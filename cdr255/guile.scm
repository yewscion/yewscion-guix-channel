(define-module (cdr255 guile)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages texinfo)
  #:use-module (guix gexp))
(define-public guile-cdr255
  (package
   (name "guile-cdr255")
   (version "0.1.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://git.sr.ht/~yewscion/guile-cdr255")
                  (commit "c5bc0c4bce8c874bff609309dc4e722a90e7deec")))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "16fh15aj66zqx5sqx08c3b037539mmhzks84qbn1560hb6srw9bj"))))
   (build-system gnu-build-system)
   (arguments
    `(#:modules
      ((ice-9 match)
       (ice-9 ftw)
       ,@%gnu-build-system-modules)
      #:phases
      (modify-phases
       %standard-phases
       (add-after
        'install
        'hall-wrap-binaries
        (lambda* (#:key inputs outputs #:allow-other-keys)
          (let* ((compiled-dir
                  (lambda (out version)
                    (string-append
                     out
                     "/lib/guile/"
                     version
                     "/site-ccache")))
                 (uncompiled-dir
                  (lambda (out version)
                    (string-append
                     out
                     "/share/guile/site"
                     (if (string-null? version) "" "/")
                     version)))
                 (dep-path
                  (lambda (env modules path)
                    (list env
                          ":"
                          'prefix
                          (cons modules
                                (map (lambda (input)
                                       (string-append
                                        (assoc-ref inputs input)
                                        path))
                                     ,''())))))
                 (out (assoc-ref outputs "out"))
                 (bin (string-append out "/bin/"))
                 (site (uncompiled-dir out "")))
            (match (scandir site)
              (("." ".." version)
               (for-each
                (lambda (file)
                  (wrap-program
                   (string-append bin file)
                   (dep-path
                    "GUILE_LOAD_PATH"
                    (uncompiled-dir out version)
                    (uncompiled-dir "" version))
                   (dep-path
                    "GUILE_LOAD_COMPILED_PATH"
                    (compiled-dir out version)
                    (compiled-dir "" version))))
                ,''("set-gitconfig"))
               #t))))))))
   (native-inputs (list autoconf
                        automake
                        pkg-config
                        texinfo))
   (inputs (list guile-3.0))
   (synopsis "User library and utility scripts.")
   (description
    (string-append
     "Mostly a guile library, this is a personal project to make maintaining "
     "multiple systems easier and the creation of new scripts easier."))
   (home-page
    "https://sr.ht/~yewscion/guile-cdr255")
   (license license:agpl3+)))
guile-cdr255
