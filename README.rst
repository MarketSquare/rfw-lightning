RFW Lightning
=============
This is a reference implementation exploring ways to make Robot Framework more human understandable. Kick-started with a sponsorship and excellent ideas from `RoboCorp <https://robocorp.com/>`_.

Major syntax changes:

- Simple variables. From `${ var iable }` to `$var_iable`. 
- Robot Framework like IF syntax - not going to Python eval.
- For loop with iterating over first thing - not over argument expansion.

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
 
