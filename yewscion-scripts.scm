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
  (let ((commit "fd182374e5ec43554dc27e459ad8ac9fcd8e17c6")
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
         "12w6n5068gh9pqxgibfwsfaf0fkbhxxy62r39i1libsmnxriac2i"))))
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
