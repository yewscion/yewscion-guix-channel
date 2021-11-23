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
  (let ((commit "8b8f96e0d39708308c35e95c5e2adf160454db22")
        (revision "1"))
    (package
     (name "yewscion-scripts")
     (version (git-version "0.1.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/yewscion-scripts")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "05gbm5k98d3mdnikxx4pljhmpv760ccybp37v079q7lbcwwz5yr0"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f))
     (native-inputs `(("pkg-config" ,pkg-config)
                      ("guile" ,guile-3.0)
                      ("autoconf" ,autoconf)
                      ("automake" ,automake)))
    (synopsis "Utility Scripts from yewscion")
    (description
     "A personal collection of scripts written to aid with system administration tasks.")
    (home-page "https://git.sr.ht/~yewscion/yewscion-scripts")
    (license agpl3))))
yewscion-scripts
