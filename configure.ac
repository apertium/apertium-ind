AC_PREREQ(2.52)

AC_INIT([Apertium Indonesian], [0.4.0], [nlhowell@gmail.com], [apertium-ind], [https://wiki.apertium.org/wiki/Apertium-ind])
AM_INIT_AUTOMAKE
AC_PROG_AWK
AC_SUBST([FOMA])

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.7.0)
PKG_CHECK_MODULES(HFST, hfst >= 3.15.1)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.1)
AC_PATH_PROG([FOMA], [foma])

PKG_CHECK_MODULES(HFSTOSPELL, hfstospell >= 0.2, [], [
      AC_MSG_NOTICE([You will need hfst-ospell installed to use the compiled speller])
])

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.0.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

AP_MKINCLUDE

AC_OUTPUT([Makefile apertium-ind.pc])
