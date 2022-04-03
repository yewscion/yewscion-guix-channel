(define-module (python-pygments-lexer-pseudocode-std)
  #:use-module (guix packages)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix download)
  #:use-module (guix build-system python)
  #:use-module ((guix licenses) :prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public python-pygments-lexer-pseudocode-std
  (let ((commit "607c42125b2b31cd767389cf51d521c8ea984eab")
        (revision "2"))
    (package
     (name "python-pygments-lexer-pseudocode-std")
     (version (git-version "1.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
             (commit commit)))
       (sha256
        (base32
         "10py6xghyifz6rx1qn327029mx5zm463nsia602pryazamaxcrfw"))))
  (build-system python-build-system)
  (propagated-inputs (list python-pygments))
  (home-page "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
  (synopsis "Pygments Lexer for a standard pseudocode")
  (description "A Lexer for Pygments, following what could be considered a standard pseudocode.")
  (license license:agpl3))))
python-pygments-lexer-pseudocode-std
