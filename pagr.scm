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
  (let ((commit "2b90c2d27c5397555b04f30db31cb4b008636ecb")
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
         "1p4dsmwds2zf20fiar6bjwd8cw8mpzr9z584gas7xxm5f40wxz63"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs `(("pkg-config" ,pkg-config)
                      ("guile" ,guile-3.0)
                      ("autoconf" ,autoconf)
                      ("automake" ,automake)))
    (synopsis "Push all git repos")
    (description
     (string-append
      "A convenience script for handling many git repos with similar "
      "remotes."))
    (home-page "https://git.sr.ht/~yewscion/pagr")
    (license agpl3))))
pagr
