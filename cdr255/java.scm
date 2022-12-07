(define-module (cdr255 java)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system ant)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages java))
(define-public java-bigdecimal-math
  (let* ((revision "1"))
    (package
      (name "java-bigdecimal-math")
      (version "3.0.0")
      (source (origin
                (method url-fetch)
                (uri "https://arxiv.org/src/0908.3030v3")
                (file-name (string-append name "-" version ".tar.gz"))
                (sha256
                 (base32
                  "144jg3ch9lqx2gz5zzwxdyyirlcrwilxjqgsckbbf574dv2gc7ys"))))
      (outputs '("out"))
      (build-system ant-build-system)
      (arguments
       (list
        #:jar-name "BigDecimalMath.jar"
        #:source-dir "."
        #:tests? #f
        ))
      ;; (native-inputs (list ))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "A Java Implementation of Core Mathematical Functions")
      (description "The mathematical functions log(x), exp(x), root[n]x, sin(x), cos(x), tan(x), arcsin(x), arctan(x), x^y, sinh(x), cosh(x), tanh(x) and Gamma(x) have been implemented for arguments x in the real domain in a native Java library on top of the multi-precision BigDecimal representation of floating point numbers. This supports scientific applications where more than the double precision accuracy of the library of the Standard Edition is desired. This is the source code accompanying DOI https://doi.org/10.48550/arXiv.0908.3030.")
      (home-page "https://doi.org/10.48550/arXiv.0908.3030")
      (license license:lgpl3))))

(define-public java-wigner3jgui
  (package
   (inherit java-bigdecimal-math)
   (name "java-wigner3jgui")
   (arguments
    (list
     #:jar-name "Wigner3jGUI.jar"
     #:source-dir "."
     #:tests? #f
     #:main-class "org/nevec/rjm/Wigner3jGUI"
     ))
   (synopsis "Online Calculator Using BigDecimalMath")
   (description "The mathematical functions log(x), exp(x), root[n]x, sin(x), cos(x), tan(x), arcsin(x), arctan(x), x^y, sinh(x), cosh(x), tanh(x) and Gamma(x) have been implemented for arguments x in the real domain in a native Java library on top of the multi-precision BigDecimal representation of floating point numbers. This supports scientific applications where more than the double precision accuracy of the library of the Standard Edition is desired. This is the source code accompanying DOI https://doi.org/10.48550/arXiv.0908.3030 for the Online Calculator.")
      (home-page "https://doi.org/10.48550/arXiv.0908.3030")
      (license license:lgpl3)))

