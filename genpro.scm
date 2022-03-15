(define-module (genpro)
  #:use-module (guix packages)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public genpro
  (let ((commit "13f3434c9cb7fe4e6aed165491f5ffca314c321c")
        (revision "1"))
    (package
     (name "genpro")
     (version (git-version "0.0.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/genpro")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0sjgf2lfybji2xaggdfz9lv6nqmwv9yylyx5dj1432x8v8s68nkf"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs `(("pkg-config" ,pkg-config)
                      ("guile" ,guile-3.0)
                      ("autoconf" ,autoconf)
                      ("automake" ,automake)
                      ("texlive" ,texlive)
                      ("biber" ,biber)
                      ("python-pygments" ,python-pygments)))
    (synopsis "Generate and Publish LaTeX files.")
    (description
     (string-append
      "Tool to consistently create and work with LaTeX projects."))
    (home-page "https://git.sr.ht/~yewscion/genpro")
    (license agpl3))))
genpro
