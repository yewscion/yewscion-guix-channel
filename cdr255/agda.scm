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

