(define-module (hledger-ui)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system haskell)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages finance))
(define-public hledger-ui
  (package
   (name "hledger-ui")
   (version "1.21")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://hackage.haskell.org/package/hledger-ui/hledger-ui-"
           version
           ".tar.gz"))
     (sha256
      (base32 "1h9d686z0y8cvq6780g6r8fdrs76y9649js0c350b6xnhzggbx0l"))))
   (build-system haskell-build-system)
   (inputs
    `(("ghc-ansi-terminal" ,ghc-ansi-terminal)
      ("ghc-async" ,ghc-async)
      ("ghc-base-compat-batteries" ,ghc-base-compat-batteries)
      ("ghc-brick" ,ghc-brick)
      ("ghc-cmdargs" ,ghc-cmdargs)
      ("ghc-data-default" ,ghc-data-default)
      ("ghc-extra" ,ghc-extra)
      ("ghc-fsnotify" ,ghc-fsnotify)
      ("hledger" ,hledger)
      ("ghc-hledger-lib" ,ghc-hledger-lib)
      ("ghc-megaparsec" ,ghc-megaparsec)
      ("ghc-microlens" ,ghc-microlens)
      ("ghc-microlens-platform" ,ghc-microlens-platform)
      ("ghc-safe" ,ghc-safe)
      ("ghc-split" ,ghc-split)
      ("ghc-text-zipper" ,ghc-text-zipper)
      ("ghc-vector" ,ghc-vector)
      ("ghc-vty" ,ghc-vty)))
   (home-page "http://hledger.org")
   (synopsis
    "Curses-style terminal interface for the hledger accounting system")
   (description
    "A simple curses-style terminal user interface for the hledger accounting system. It can be a more convenient way to browse your accounts than the CLI. This package currently does not support Microsoft Windows, except in WSL. . hledger is a robust, cross-platform set of tools for tracking money, time, or any other commodity, using double-entry accounting and a simple, editable file format, with command-line, terminal and web interfaces. It is a Haskell rewrite of Ledger, and one of the leading implementations of Plain Text Accounting. Read more at: <https://hledger.org>")
   (license gpl3)))
(define-public ghc-brick
  (package
   (name "ghc-brick")
   (version "0.64.2")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://hackage.haskell.org/package/brick/brick-"
           version
           ".tar.gz"))
     (sha256
      (base32 "058kpghx5s559z5l9hav44s8vb5lizn8j7v7l4lmvpqx3a6cisn7"))))
   (build-system haskell-build-system)
   (inputs
    `(("ghc-vty" ,ghc-vty)
      ("ghc-data-clist" ,ghc-data-clist)
      ("ghc-dlist" ,ghc-dlist)
      ("ghc-microlens" ,ghc-microlens)
      ("ghc-microlens-th" ,ghc-microlens-th)
      ("ghc-microlens-mtl" ,ghc-microlens-mtl)
      ("ghc-config-ini" ,ghc-config-ini)
      ("ghc-vector" ,ghc-vector)
      ("ghc-contravariant" ,ghc-contravariant)
      ("ghc-text-zipper" ,ghc-text-zipper)
      ("ghc-word-wrap" ,ghc-word-wrap)
      ("ghc-random" ,ghc-random)))
   (native-inputs `(("ghc-quickcheck" ,ghc-quickcheck)))
   (home-page "https://github.com/jtdaugherty/brick/")
   (synopsis "A declarative terminal user interface library")
   (description
    "Write terminal user interfaces (TUIs) painlessly with 'brick'! You write an event handler and a drawing function and the library does the rest. . . > module Main where > > import Brick > > ui :: Widget () > ui = str \"Hello, world!\" > > main :: IO () > main = simpleMain ui . . To get started, see: . * <https://github.com/jtdaugherty/brick/blob/master/README.md The README> . * The <https://github.com/jtdaugherty/brick/blob/master/docs/guide.rst Brick user guide> . * The demonstration programs in the 'programs' directory . . This package deprecates <http://hackage.haskell.org/package/vty-ui vty-ui>.")
   (license bsd-3)))
(define-public ghc-vty
  (package
   (name "ghc-vty")
   (version "5.33")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://hackage.haskell.org/package/vty/vty-"
           version
           ".tar.gz"))
     (sha256
      (base32 "0qsx4lwlkp6mwyr7rm1r9dg5ic1lc1awqgyag0nj1qgj2gnv6nc9"))))
   (build-system haskell-build-system)
   (inputs
    `(("ghc-blaze-builder" ,ghc-blaze-builder)
      ("ghc-microlens" ,ghc-microlens)
      ("ghc-microlens-mtl" ,ghc-microlens-mtl)
      ("ghc-microlens-th" ,ghc-microlens-th)
      ("ghc-hashable" ,ghc-hashable)
      ("ghc-parallel" ,ghc-parallel)
      ("ghc-utf8-string" ,ghc-utf8-string)
      ("ghc-vector" ,ghc-vector)
      ("ghc-ansi-terminal" ,ghc-ansi-terminal)))
   (native-inputs
    `(("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-smallcheck" ,ghc-smallcheck)
      ("ghc-quickcheck-assertions" ,ghc-quickcheck-assertions)
      ("ghc-test-framework" ,ghc-test-framework)
      ("ghc-test-framework-smallcheck" ,ghc-test-framework-smallcheck)
      ("ghc-random" ,ghc-random)
      ("ghc-hunit" ,ghc-hunit)
      ("ghc-quickcheck" ,ghc-quickcheck)
      ("ghc-smallcheck" ,ghc-smallcheck)
      ("ghc-quickcheck-assertions" ,ghc-quickcheck-assertions)
      ("ghc-test-framework" ,ghc-test-framework)
      ("ghc-test-framework-smallcheck" ,ghc-test-framework-smallcheck)
      ("ghc-test-framework-hunit" ,ghc-test-framework-hunit)
      ("ghc-random" ,ghc-random)
      ("ghc-string-qq" ,ghc-string-qq)))
   (arguments
    `(#:cabal-revision
      ("1" "1in66nd2xkb6mxxzazny900pz1xj83iqsql42c0rwk72chnnb8cd")))
   (home-page "https://github.com/jtdaugherty/vty")
   (synopsis "A simple terminal UI library")
   (description
    "vty is terminal GUI library in the niche of ncurses. It is intended to be easy to use, have no confusing corner cases, and good support for common terminal types. . See the @vty-examples@ package as well as the program @test/interactive_terminal_test.hs@ included in the @vty@ package for examples on how to use the library. . Import the \"Graphics.Vty\" convenience module to get access to the core parts of the library. . &#169; 2006-2007 Stefan O'Rear; BSD3 license. . &#169; Corey O'Connor; BSD3 license. . &#169; Jonathan Daugherty; BSD3 license.")
   (license bsd-3)))
hledger-ui
