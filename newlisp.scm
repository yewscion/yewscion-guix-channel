(define-module (newlisp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp)
  #:use-module (gnu packages base)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages readline))
(define-public newlisp
  (let ((source-version "10.7.5")
        (revision "2"))
    (package
     (name "newlisp")
     (version (string-append source-version "-" revision))
     (source
      (origin
       (method url-fetch)
       (uri (string-append
             "https://sourceforge.net/projects/newlisp/files/newlisp-"
             source-version
             ".tgz/download"))
       (file-name (string-append
                   "newlisp-"
                   source-version
                   ".tgz"))
       (sha256
        (base32 "1v1607lv2q7vfnp21p5d3rpgp9jik2jqpbzk9ay7bcn2a7v0ybfw"))))
     (build-system gnu-build-system)
     (arguments
      `(#:make-flags
        (list (string-append "prefix=" (assoc-ref %outputs "out"))
              "CC=gcc")))
     (inputs `(("libffi" ,libffi)
               ("which" ,which)
               ("readline" ,readline)))
     (home-page "http://www.newlisp.org/")
     (synopsis
      "A LISP like, general purpose scripting language")
     (description
      "newLISP is a scripting language for developing web applications and programs in general and in the domains of artificial intelligence (AI) and statistics.")
     (license gpl3))))
newlisp
