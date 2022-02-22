(define-module (orca-lang)
  #:use-module (guix packages)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages music)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public orca-lang
  (let ((commit "5ba56ca67baae3db140f8b7a2b2fc46bbac5602f")
        (revision "3"))
    (package
     (name "orca-lang")
     (version (git-version "git" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~rabbits/orca")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1mnhk68slc6g5y5348vj86pmnz90a385jxvm3463fic79k90gckd"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests?
        #f
        #:phases
        (modify-phases
         %standard-phases
         (delete 'configure)
         (delete 'check)
         (delete 'patch-shebangs)
         (delete 'validate-documentation-location)
         (delete 'delete-info-dir-file)
         (delete 'patch-dot-desktop-files)
         (delete 'reset-gzip-timestamps)
         (replace 'build
                  (lambda* (#:key inputs outputs #:allow-other-keys)
                           (setenv "CC" "gcc")
                           (invoke "make" "release")))
         (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                           (let* ((out
                                   (assoc-ref outputs "out"))
                                  (dest-bin
                                   (string-append out "/bin"))
                                  (dest-lib
                                   (string-append out "/share"))
                                  (dest-exa
                                   (string-append dest-lib "/examples"))
                                  (dest-doc
                                   (string-append dest-lib "/doc")))
                             (install-file "./build/orca" dest-bin)
                             (copy-recursively "./examples" dest-exa)
                             (install-file "./README.md" dest-doc)
                             #t))))))
     (inputs `(("ncurses" ,ncurses)
               ("portmidi" ,portmidi)))
     (native-inputs `(("pkg-config" ,pkg-config)))
     (synopsis "Musical Esoteric Programming Language")
     (description
      "Orca is an esoteric programming language and live editor designed to
quickly create procedural sequencers.  Every letter of the alphabet is an
operation, lowercase letters execute on *bang*, and uppercase letters execute
each frame.")
     (home-page "https://wiki.xxiivv.com/site/uxn.html")
     (license agpl3))))
orca-lang
