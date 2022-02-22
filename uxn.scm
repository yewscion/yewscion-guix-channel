(define-module (uxn)
  #:use-module (guix packages)
  #:use-module (gnu packages sdl)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public uxn
  (let ((commit "f87c15c8b5274546a2198c35f5a6e30094f8f004")
        (revision "5"))
    (package
     (name "uxn")
     (version (git-version "android-1.5" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~rabbits/uxn")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "00fjzjswyd88na0grylsjxq9bp7z5sk9a6xiwwm30wxflszvqm3g"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f
        #:phases (modify-phases
                  %standard-phases
                  (delete 'configure)
                  (delete 'check)
                  (delete 'patch-shebangs)
                  (delete 'validate-documentation-location)
                  (delete 'delete-info-dir-file)
                  (delete 'patch-dot-desktop-files)
                  (delete 'reset-gzip-timestamps)
                  (replace
                   'build
                   (lambda* (#:key inputs outputs #:allow-other-keys)
                     (setenv "HOME" "./")
                     (setenv "CC" "gcc")
                     (invoke "bash" "build.sh" "--install" "--no-run")
                     (invoke "./bin/uxncli"
                             "./bin/asma.rom"
                             "./projects/examples/demos/piano.tal"
                             "./bin/piano.rom")))
                  (replace
                   'install
                   (lambda* (#:key outputs #:allow-other-keys)
                     (let* ((out (assoc-ref outputs "out"))
                            (dest-bin (string-append out "/bin"))
                            (dest-lib (string-append out "/share"))
                            (dest-rom (string-append dest-lib "/rom")))
                       (mkdir-p dest-bin)
                       (mkdir-p dest-lib)
                       (install-file "./bin/uxnasm" dest-bin)
                       (install-file "./bin/uxncli" dest-bin)
                       (install-file "./bin/uxnemu" dest-bin)
                       (install-file "./bin/launcher.rom" dest-rom)
                       (install-file "./bin/asma.rom" dest-rom)
                       (install-file "./bin/piano.rom" dest-rom)
                       (copy-recursively "./projects"
                                         (string-append dest-lib "/projects/"))
                       (copy-recursively "./etc"
                                         (string-append dest-lib "/etc"))
                       (install-file "README.md"
                                     (string-append dest-lib "/doc"))
                       #t))))))
     (inputs `(("sdl2" ,sdl2)))
     (synopsis "Virtual Machine With 32 Instructions")
     (description
      "This personal computer is capable of hosting small graphical
applications, programmable in a unique assembly language.  It was designed with
an implementation-first mindset with a focus on creating portable tools and
games.")
     (home-page "https://wiki.xxiivv.com/site/uxn.html")
     (license isc))))
uxn
