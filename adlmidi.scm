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
  (let ((commit "0b87eee9df14fe24f1827a695a712ccb6c11e980")
        (revision "1"))
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
                "0f23fzapfah6hl6mz214d5xqfkm06lxafn9msfanlrr70br75pvl"))))
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
     (native-inputs `(("pkg-config" ,pkg-config)))
     (synopsis "A MIDI player that emulates OPL3")
     (description
      "A cli midi file player that emulates OPL3 chips instead of using
soundfonts.")
     (home-page "https://github.com/bisqwit/adlmidi")
     (license gpl3))))
adlmidi
