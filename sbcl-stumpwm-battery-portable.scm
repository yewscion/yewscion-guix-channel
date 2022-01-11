(define-module (sbcl-stumpwm-battery-portable)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (gnu packages wm)
  #:use-module (guix build-system asdf)
  #:use-module (gnu packages lisp-check)
  #:use-module (gnu packages lisp-xyz))

(define stumpwm-contrib
  (let ((commit "a7dc1c663d04e6c73a4772c8a6ad56a34381096a")
        (revision "3"))
    (package
      (name "stumpwm-contrib")
      (version (git-version "0.0.1" revision commit)) ;no upstream release
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/stumpwm/stumpwm-contrib")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "09akdaaya7lga5lzbq1aj1filsyjwvflghkidpmr0nk0jz5xx1g7"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("stumpwm" ,stumpwm "lib")))
      (home-page "https://github.com/stumpwm/stumpwm-contrib")
      (synopsis "StumpWM interactive shell")
      (description "This package provides a StumpWM interactive shell.")
      (license (list gpl2+ gpl3+ bsd-2)))))

(define-public sbcl-stumpwm-battery-portable
  (package
    (inherit stumpwm-contrib)
    (name "sbcl-stumpwm-battery-portable")
    (inputs
     `(("stumpwm" ,stumpwm "lib")))
    (arguments
     '(#:asd-systems '("battery-portable")
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chdir
           (lambda _
             (chdir "modeline/battery-portable"))))))
    (home-page
     "https://github.com/stumpwm/stumpwm-contrib/tree/master/modeline/battery-portable")
    (synopsis "Battery Indicator for StumpWM")
    (description "This StumpWM Module provides modeline support for a battery indicator.")
    (license gpl3+)))
sbcl-stumpwm-battery-portable
