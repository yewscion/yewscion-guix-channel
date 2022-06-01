(define-module (carp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system haskell)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages python)
  #:use-module (guix gexp))
(define-public carp
  (let ((commit "e32ec43a26c51ebd136776566909f19476df6ed9")
        (revision "1")
        (version "10.7.5"))
    (package
     (name "carp")
     (version version)
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/carp-lang/Carp.git")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14jdnv0ljqvpr9ych1plfw7hp5q57a8j1bv8h3v345x06z783d07"))))
     (build-system haskell-build-system)
     (inputs (list
              ghc-hunit
              ghc-ansi-terminal
              ghc-blaze-markup
              ghc-blaze-html
              ghc-cmark
              ghc-edit-distance
              ghc-hashable
              ghc-optparse-applicative
              ghc-split
              ghc-open-browser
              python))
     (home-page "https://github.com/carp-lang/Carp")
     (synopsis
      "A statically typed lisp, without a GC, for real-time applications")
     (description
      "Carp is a programming language designed to work well for interactive and performance sensitive use cases like games, sound synthesis and visualizations.

The key features of Carp are the following:

@begin itemize
@item Automatic and deterministic memory management (no garbage collector or VM)
@item Inferred static types for great speed and reliability
@item Ownership tracking enables a functional programming style while still using mutation of cache-friendly data structures under the hood
@item No hidden performance penalties – allocation and copying are explicit
@item Straightforward integration with existing C code
@item Lisp macros, compile time scripting and a helpful REPL
@end itemize")
     (license license:asl2.0))))
(define-public ghc-open-browser
  (package
   (name "ghc-open-browser")
   (version "0.2.1.0")
   (source (origin
            (method url-fetch)
            (uri (hackage-uri "open-browser" version))
            (sha256
             (base32
              "0rna8ir2cfp8gk0rd2q60an51jxc08lx4gl0liw8wwqgh1ijxv8b"))))
  (build-system haskell-build-system)
  (home-page "https://github.com/rightfold/open-browser")
  (synopsis "Open a web browser from Haskell.")
  (description
   "Open a web browser from Haskell.  Currently BSD, Linux, OS X and Windows are
supported.")
  (license license:bsd-3)))
carp
