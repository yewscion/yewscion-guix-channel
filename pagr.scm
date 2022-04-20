(define-module (pagr)
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
(define-public pagr
  (let ((commit "920945e18202937af0e265c43c1b28cc6b3a75c0")
        (revision "1"))
    (package
     (name "pagr")
     (version (git-version "0.0.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/pagr")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0iicnfiqx62d3rp2zh3xf6xv19awlccx0zzc31in8jx85a68lhmp"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs (list pkg-config
                          guile-3.0
                          guile-git
                          autoconf
                          automake))
    (synopsis "Push all git repos")
    (description
     (string-append
      "A convenience script for handling many git repos with similar "
      "remotes."))
    (home-page "https://git.sr.ht/~yewscion/pagr")
    (license agpl3))))
pagr
