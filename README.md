This library implements most of the functionality in the Strings
dictionary of the Common Lisp standard.  It has an extrinsic and an
intrinsic version.

The extrinsic version can be loaded into an existing Common Lisp
implementation without clobbering the existing functionality in that
implementation.  The extrinsic version is also used for the test
suite.

The intrinsic version is meant to provide the functionality of the
Strings dictionary for a Common Lisp implementation that does not have
its own implementation of this functionality.

We provide compiler macros for functions with keyword parameters so
that keyword argument parsing can be avoided in many cases.  And we
provide extensive documentation strings for the functions we define.

We use the ANSI test suite to test this library.  It is best to run
this test suite from the command line of the operating system.  If
SBCL is used to test the system, the provided shell script
`ansi-test-sbcl` can be used.

All provided operators are tested in the test suite, with the
exception of `string`, because it would require shadowing the name of
the system class and the ansi-test suite will not work then.
