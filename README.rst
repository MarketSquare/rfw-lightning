RFW Lightning
=============

*PRE-RELEASE* There is still work to be done!

This is a reference implementation exploring ways to make Robot Framework more human understandable.
Kick-started with a sponsorship and excellent ideas from `RoboCorp <https://robocorp.com/>`_.

There have been key difficulties in getting office workers started with Robot Framework use. These have been detected at RoboCorp.

Syntax changes:

- ✨ Simple variables. From ``${ var iable }`` to ``$var_iable```.
  
  - ✨ FEATURE: Direct argument
  - ✨ TODO: Remove ``Set Variable``
  - ✨ TODO: ``Text templates with {$variable}``
  - ✨ TODO: named argument setting with ``$name=value`` instead of ``name=value``

- ✨ Robot Framework like IF syntax. No Python eval.

  - Supporting '==', 'is', 'in', '!=', '>', '<', >=', '<=' and 'not in'

- ✨ For loop with iterating over the First thing. Not over argument expansion.

.. code:: robotframework

   *** Variables ***
   $SIMPLEVAR   1
   $SIMPLELIST=Create List   1  2  3
   $SIMPLEDICT=Create Dictionary    a=123  b=456

   *** Test Cases ***
   Testing
       Should Be Equal   $SIMPLEVAR   1
       IF  $SIMPLEVAR   ==   1
          Log   $SIMPLEVAR
       END
       IF  $SIMPLEVAR   is   $TRUE
          Fail
       END
       IF  5  not in  $SIMPLELIST
          No Operation
       END
       IF  2  in  $SIMPLELIST
          Log   All is fine
       END
       FOR  $SIMPLE  IN   $SIMPLELIST
          Log   $SIMPLE
       END
 

Roadmap
=======

1. Implement all the cool 😎 things in the list above ⬅️
2. Invent a new extension because *.robot is taken by the classic Robot Framework syntax
3. Invent a new runner name for this extension
4. Carve out Robot Framework to get an extension that depends on the real Robot Framework
5. Publish the extension

How you can get started
=======================

If you want to help there is much to do.

.. code:: bash

   git clone git@github.com:MarketSquare/rfw-lightning.git
   cd rfw-lightning
   python -m venv .venv
   source .venv/bin/activate
   pip install -U pip
   pip install -r requirements-dev.txt
   pip install -r utest/requirements.txt
   pip install -r atest/requirements.txt
   pip install -r atest/requirements.txt
   pip install -r atest/requirements-run.txt
   # TO RUN THE EXAMPLES OF NEW SYNTAX
   ./rundevel.py example
   # TO RUN UNIT TESTS (CURRENTLY MANY FAILING BECAUSE OF THE SYNTAX CHANGES)
   utest/run.py
   # TO RUN RF ON RF TESTS (CURRENTLY MANY FAILING BECAUSE OF THE SYNTAX CHANGES)
   atest/run.py atest/robot/

