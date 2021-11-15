(define-module (adlmidi)
  #:use-module (guix packages)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public adlmidi
  (let ((commit "8aa85de66d6dbf95c4d89091491257103b7d0601")
        (revision "2"))
    (package
     (name "adlmidi")
     (version (git-version "1.2.6.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/bisqwit/adlmidi")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "016vkplgq8pmznh5kzv8zbybdq6har7wyvj4qhjg3pp4lz2sc76r"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f
        #:phases (modify-phases %standard-phases
                                (delete 'configure)
                                (delete 'check)
                                (delete 'patch-shebangs)
                                (delete 'validate-documentation-location)
                                (delete 'delete-info-dir-file)
                                (delete 'patch-dot-desktop-files)
                                (delete 'reset-gzip-timestamps)
                                (delete 'compress-documentation)
                                (replace 'install
                                         (lambda* (#:key outputs #:allow-other-keys)
                                           (let* ((out (assoc-ref outputs "out"))
                                                  (dest (string-append out "/bin")))
                                             (mkdir-p dest)
                                             (install-file "adlmidi" dest)
                                             (install-file "dumpbank" dest)
                                             (install-file "dumpmiles" dest)
                                             (install-file "gen_adldata" dest)
                                             #t))))))
     (inputs `(("sdl2" ,sdl2)))
     (native-inputs `("pkg-config" ,pkg-config)))
    (synopsis "A MIDI player that emulates OPL3")
    (description
     "A cli midi file player that emulates OPL3 chips instead of using
soundfonts.")
    (home-page "https://github.com/bisqwit/adlmidi")
    (license gpl3))))
adlmidi
