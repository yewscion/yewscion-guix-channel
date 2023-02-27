(define-module (cdr255 agda)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system haskell)
  #:use-module (guix build-system trivial)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

;; This still needs some kind of solution for AGDA_DIR.
(define-public agda-stdlib
  (let* ((revision "1")
         (commit "b2e6385c1636897dbee0b10f7194376ff2c1753b"))
    (package
      (name "agda-stdlib")
      (version (git-version "1.7.2" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/agda/agda-stdlib")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "065hf24xjpciwdrvk4isslgcgi01q0k93ql0y1sjqqvy5ryg5xmy"))))
      (outputs '("out"))
      (build-system copy-build-system)
      (arguments
       (let ((library-directory (string-append "share/agda/agda-stdlib-"
                                               version "/")))
         (list #:install-plan #~'(("src" #$library-directory)
                                  ("standard-library.agda-lib" #$library-directory)))))
      (synopsis "The Agda Standard Library")
      (description
       "The standard library aims to contain all the tools needed to write
both programs and proofs easily.  While we always try and write efficient
code, we prioritize ease of proof over type-checking and normalization
performance.  If computational performance is important to you, then perhaps
try agda-prelude instead.")
      (home-page "https://wiki.portal.chalmers.se/agda/pmwiki.php")
      (license license:expat))))


(define-public my-agda
  (package
    (name "my-agda")
    (version "2.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (hackage-uri "Agda" version))
       (sha256
        (base32 "05k0insn1c2dbpddl1slcdn972j8vgkzzy870yxl43j75j0ckb5y"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "Agda")))
    (inputs
     (list ghc-aeson
           ghc-alex
           ghc-async
           ghc-blaze-html
           ghc-boxes
           ghc-case-insensitive
           ghc-data-hash
           ghc-edit-distance
           ghc-equivalence
           ghc-gitrev
           ghc-happy
           ghc-hashable
           ghc-hashtables
           ghc-monad-control
           ghc-murmur-hash
           ghc-parallel
           ghc-regex-tdfa
           ghc-split
           ghc-strict
           ghc-unordered-containers
           ghc-uri-encode
           ghc-vector-hashtables
           ghc-zlib))
    (arguments
     (list #:modules `((guix build haskell-build-system)
                       (guix build utils)
                       (srfi srfi-26)
                       (ice-9 match))
           #:phases
           #~(modify-phases %standard-phases
               ;; This allows us to call the 'agda' binary before installing.
               (add-after 'unpack 'set-ld-library-path
                 (lambda _
                   (setenv "LD_LIBRARY_PATH" (string-append (getcwd) "/dist/build"))))
               (add-after 'compile 'agda-compile
                 (lambda* (#:key outputs #:allow-other-keys)
                   (let ((agda-compiler (string-append #$output "/bin/agda")))
                     (for-each (cut invoke agda-compiler <>)
                               (find-files (string-append #$output "/share")
                                           "\\.agda$"))))))))
    (home-page "https://wiki.portal.chalmers.se/agda/")
    (synopsis
     "Dependently typed functional programming language and proof assistant")
    (description
     "Agda is a dependently typed functional programming language: it has
inductive families, which are similar to Haskell's GADTs, but they can be
indexed by values and not just types.  It also has parameterised modules,
mixfix operators, Unicode characters, and an interactive Emacs interface (the
type checker can assist in the development of your code).  Agda is also a
proof assistant: it is an interactive system for writing and checking proofs.
Agda is based on intuitionistic type theory, a foundational system for
constructive mathematics developed by the Swedish logician Per Martin-Löf.  It
has many similarities with other proof assistants based on dependent types,
such as Coq, Epigram and NuPRL.")
    ;; Agda is distributed under the MIT license, and a couple of
    ;; source files are BSD-3.  See LICENSE for details.
    (license (list license:expat license:bsd-3))))

(define-public ghc-vector-hashtables
  (package
    (name "ghc-vector-hashtables")
    (version "0.1.1.2")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "vector-hashtables" version))
              (sha256
               (base32
                "0hrjvy9qg1m5g3w91zxy4syqmp8jk7ajjbxbzkhy282dwfigkyd2"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "vector-hashtables")))
    (inputs (list ghc-primitive ghc-vector ghc-hashable ghc-hspec-discover))
    (native-inputs (list ghc-hspec ghc-quickcheck ghc-quickcheck-instances))
    (home-page "https://github.com/klapaucius/vector-hashtables#readme")
    (synopsis "Efficient vector-based mutable hashtables implementation.")
    (description
     "This package provides efficient vector-based hashtable implementation similar to
.NET Generic Dictionary implementation (at the time of 2015). .  See
\"Data.Vector.Hashtables\" for documentation.")
    (license license:bsd-3)))
