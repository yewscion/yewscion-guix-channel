(define-module (cdr255 forth)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config))

(define-public retroforth
  (let* ((revision "1")
         (commit "d5c8102d61ba6e6fd7260e1e370641e5f6340124"))
    (package
      (name "retroforth")
      (version (git-version "2022.8" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.sr.ht/~crc_/retroforth/")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "191xpva228ssmfi655avsw6z20i71df6sx1n8pbdxqwmqiaiwq8v"))))
      (outputs '("out"))
      (build-system gnu-build-system)
      (arguments
       (list #:make-flags #~(list "CC=gcc"
                                  (string-append "PREFIX="
                                                 #$output))
             #:tests? #f
             #:phases #~(modify-phases %standard-phases
                          (delete 'configure))))
      (synopsis "Modern, pragmatic set of Forths")
      (description
       "Retro is a modern, pragmatic set of Forths drawing influence from
many sources.  It clean, elegant, tiny, easy to grasp, and adaptable to many
tasks.

It's not a traditional Forth.  Drawing influence from colorForth, it uses
prefixes to guide the compiler.  From Joy and Factor, it uses
quotations (anonymous, nestable functions) and combinators (functions that
operate on functions) for much of the stack and flow control.  It also adds
vocabularies for working with strings, arrays, and other data types.  Source
files are written in Unu, allowing for simple, literate sources.")
      (home-page "http://retroforth.org/")
      (license license:isc))))
