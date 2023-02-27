(define-module (cdr255 agda)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages agda)
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

(define-public agda-2.6.3
  (package
    (inherit agda)
    (version "2.6.3")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "Agda" version))
              (sha256
               (base32
                "05k0insn1c2dbpddl1slcdn972j8vgkzzy870yxl43j75j0ckb5y"))))
    (inputs (modify-inputs (package-inputs agda)
              (append ghc-vector-hashtables)))))
(define-public emacs-agda2-mode-2.6.3
  (package
    (inherit agda-2.6.3)
    (name "emacs-agda2-mode")
    (build-system emacs-build-system)
    (inputs '())
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-after 'unpack 'enter-elisp-dir
                    (lambda _
                      (chdir "src/data/emacs-mode") #t)))))
    (home-page "https://agda.readthedocs.io/en/latest/tools/emacs-mode.html")
    (synopsis "Emacs mode for Agda")
    (description "This Emacs mode enables interactive development with
Agda.  It also aids the input of Unicode characters.")))
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
                                  ("_build" #$library-directory)
                                  ("standard-library.agda-lib" #$library-directory))
               #:phases #~(modify-phases %standard-phases
                            (add-before 'install 'create-interfaces
                              (lambda _
                                (map (lambda (x)
                                       (system (string-append "agda " x)))
                                     (find-files "src" ".*\\.agda"))))))))
      (native-inputs (list agda-2.6.3))
      (synopsis "The Agda Standard Library")
      (description
       "The standard library aims to contain all the tools needed to write
both programs and proofs easily.  While we always try and write efficient
code, we prioritize ease of proof over type-checking and normalization
performance.  If computational performance is important to you, then perhaps
try agda-prelude instead.")
      (home-page "https://wiki.portal.chalmers.se/agda/pmwiki.php")
      (license license:expat))))

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
