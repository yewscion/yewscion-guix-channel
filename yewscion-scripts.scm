(define-module (yewscion-scripts)
  #:use-module (guix packages)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public yewscion-scripts
  (let ((commit "3dd16b408c9f0d62ff4251a540abd7ac90b05650")
        (revision "1"))
    (package
     (name "yewscion-scripts")
     (version (git-version "0.0.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/yewscion-scripts")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "19hkxnrv7prigwa4inyxxfrpdwxn0jq2dxpinffly349md162cln"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f))
     (inputs `(("autoconf" ,autoconf)
               ("automake" ,automake)))
     (native-inputs `(("pkg-config" ,pkg-config)
                      ("guile" ,guile-3.0)))
    (synopsis "A Collection of Utility Scripts")
    (description
     "A personal collection of scripts written to aid with system administration tasks.")
    (home-page "https://git.sr.ht/~yewscion/yewscion-scripts")
    (license gpl3))))
yewscion-scripts
