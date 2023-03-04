#  Copyright 2008-2015 Nokia Networks
#  Copyright 2016-     Robot Framework Foundation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

import re
import string

from robot.errors import VariableError
from robot.utils import is_string


def search_variable(characters, identifiers='$@&%*', ignore_errors=False):
    if not is_string(characters):
        return VariableMatch(characters)
    return _search_variable(characters, identifiers, ignore_errors)


def contains_variable(characters, identifiers='$@&'):
    match = search_variable(characters, identifiers, ignore_errors=True)
    return bool(match)


def is_variable(characters, identifiers='$@&'):
    match = search_variable(characters, identifiers, ignore_errors=True)
    return match.is_variable()


def is_scalar_variable(characters):
    return is_variable(characters, '$')


def is_assign(characters, identifiers='$@&', allow_assign_mark=False):
    match = search_variable(characters, identifiers, ignore_errors=True)
    return match.is_assign(allow_assign_mark)


def is_assign_keyword_call(characters):
    if '=' not in characters:
        return False
    head, tail = characters.split('=', 1)
    return is_variable(head.rstrip()) and len(tail.lstrip()) > 0


def is_scalar_assign(characters, allow_assign_mark=False):
    return is_assign(characters, '$', allow_assign_mark)


def is_list_assign(characters, allow_assign_mark=False):
    return is_assign(characters, '@', allow_assign_mark)


def is_dict_assign(characters, allow_assign_mark=False):
    return is_assign(characters, '&', allow_assign_mark)


class VariableMatch:

    def __init__(self, string, identifier=None, base=None, items=(), start=-1, end=-1):
        self.string = string
        self.identifier = identifier
        self.base = base
        self.items = items
        self.start = start
        self.end = end

    def resolve_base(self, variables, ignore_errors=False):
        if self.identifier:
            internal = search_variable(self.base)
            self.base = variables.replace_string(
                internal,
                custom_unescaper=unescape_variable_syntax,
                ignore_errors=ignore_errors,
            )

    @property
    def name(self):
        return '%s%s' % (self.identifier, self.base) if self else None

    @property
    def before(self):
        return self.string[:self.start] if self.identifier else self.string

    @property
    def match(self):
        return self.string[self.start:self.end] if self.identifier else None

    @property
    def after(self):
        return self.string[self.end:] if self.identifier else None

    def is_variable(self):
        return bool(self.identifier
                    and self.base
                    and self.start == 0
                    and self.end == len(self.string))

    def is_scalar_variable(self):
        return self.identifier == '$' and self.is_variable()

    def is_assign(self, allow_assign_mark=False):
        if allow_assign_mark and self.string.endswith('='):
            match = search_variable(self.string.rstrip(), ignore_errors=True)
            return match.is_assign()
        return (self.is_variable()
                and self.identifier in '$@&'
                and not self.items
                and not search_variable(self.base))

    def is_scalar_assign(self, allow_assign_mark=False):
        return self.identifier == '$' and self.is_assign(allow_assign_mark)

    def is_list_assign(self, allow_assign_mark=False):
        return self.identifier == '@' and self.is_assign(allow_assign_mark)

    def is_dict_assign(self, allow_assign_mark=False):
        return self.identifier == '&' and self.is_assign(allow_assign_mark)

    def __bool__(self):
        return self.identifier is not None

    def __str__(self):
        if not self:
            return '<no match>'
        items = ''.join('[%s]' % i for i in self.items) if self.items else ''
        return '%s%s%s' % (self.identifier, self.base, items)


def _search_variable(characters: str, identifiers: str, ignore_errors=False) -> VariableMatch:
    start = _find_variable_start(characters, identifiers)
    if start < 0:
        return VariableMatch(characters)

    match = VariableMatch(characters, identifier=characters[start], start=start)
    not_allowed_char = False
    indices_and_chars = enumerate(characters[start+1:], start=start+1)
    items = []
    next_item = ''
    parsing_items = False

    for index, char in indices_and_chars:
        if char == '[':
            parsing_items = True
            start=index
            continue
        if parsing_items:
            if char == ']':
                match.end = index+1
                items.append(characters[start+1:index])
                match.items = tuple(items)
                parsing_items = False
            continue
        if char in (' ', '}', '='):
            break
        if char not in string.ascii_letters + string.digits + '_':
            not_allowed_char = True
        match.base = characters[start+1:index+1]
        match.end = index+1
    
    if not_allowed_char and characters[match.start:] in ['$/', '$:', '$\\n']:
        not_allowed_char = False
    if not_allowed_char or parsing_items:
        if ignore_errors:
            return VariableMatch(characters)
        incomplete = characters[match.start:]
        if not_allowed_char:
            raise VariableError(f"Variable '{incomplete}' has not allowed character.")
        raise VariableError(f"Variable item '{incomplete}' was not closed properly.")

    return match if match else VariableMatch(match)


def _find_variable_start(characters, identifiers):
    index = 0
    while True:
        index = characters.find('$', index)
        if index < 0:
            return -1
        if characters[index] in identifiers and _not_escaped(characters, index):
            return index
        index += 1


def _not_escaped(characters, index):
    escaped = False
    while index > 0 and characters[index-1] == '\\':
        index -= 1
        escaped = not escaped
    return not escaped


def unescape_variable_syntax(item):

    def handle_escapes(match):
        escapes, text = match.groups()
        if len(escapes) % 2 == 1 and starts_with_variable_or_curly(text):
            return escapes[1:]
        return escapes

    def starts_with_variable_or_curly(text):
        if text[0] in '{}':
            return True
        match = search_variable(text, ignore_errors=True)
        return match and match.start == 0

    return re.sub(r'(\\+)(?=(.+))', handle_escapes, item)


class VariableIterator:

    def __init__(self, string, identifiers='$@&%', ignore_errors=False):
        self.string = string
        self.identifiers = identifiers
        self.ignore_errors = ignore_errors

    def __iter__(self):
        remaining = self.string
        while True:
            match = search_variable(remaining, self.identifiers, self.ignore_errors)
            if not match:
                break
            remaining = match.after
            yield match.before, match.match, remaining

    def __len__(self):
        return sum(1 for _ in self)

    def __bool__(self):
        try:
            next(iter(self))
        except StopIteration:
            return False
        else:
            return True
