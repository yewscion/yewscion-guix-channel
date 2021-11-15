(define-module (owl)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp)
  #:use-module (gnu packages base))
(define-public owl
  (let ((commit "a5dbf6c1b19c163d2f137abb9172ea2d0250abef")
        (revision "1"))
    (package
     (name "owl")
     (version (git-version "0.2" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/owl-lisp/owl.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0zs9hj0rhpa0ary6cbqyq9f1dx3hc6npl4iywqn7ps3a35kv4p8v"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f
        #:make-flags
        (let ((out (assoc-ref %outputs "out")))
          (list (string-append "PREFIX=" out)))
        #:phases (modify-phases %standard-phases
                                (delete 'configure)
                                (delete 'check)
                                (delete 'delete-info-dir-file)
                                (delete 'patch-dot-desktop-files))))
     (inputs `(("which" ,which)))
     (synopsis "A functional Scheme for world domination")
     (description
      "Owl Lisp is a functional dialect of the Scheme programming language. It
     is mainly based on the applicative subset of the R7RS standard.")
     (home-page "https://github.com/bisqwit/adlmidi")
     (license bsd-3))))
owl
