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
  (let ((commit "d4ba4d67562d16777986e3c7dd6ee044dfa8a070")
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
         "0iw2962xxa9ya3icx5jwgb6rfp4bl0c26qzpyqc80aq8c1byyl68"))))
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
