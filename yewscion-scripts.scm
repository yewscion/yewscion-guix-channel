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
  (let ((commit "73c0bb887ad8ae3c775e20f7d2a4f9372bc5dcea")
        (revision "1"))
    (package
     (name "yewscion-scripts")
     (version (git-version "0.1.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/yewscion-scripts")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1py1hwhsava6ayz4zs05ackhm3rlhczybf1jz5ib02rlnxppxkbw"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs `(("pkg-config" ,pkg-config)
                      ("guile" ,guile-3.0)
                      ("autoconf" ,autoconf)
                      ("automake" ,automake)))
    (synopsis "Utility Scripts from yewscion")
    (description
     (string-append
      "A personal collection of scripts written to aid with system "
      "administration tasks."))
    (home-page "https://git.sr.ht/~yewscion/yewscion-scripts")
    (license gpl3))))
yewscion-scripts