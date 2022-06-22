(define-module (cdr255 utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages lisp-check)
  #:use-module (gnu packages lisp-xyz)
  #:use-module (gnu packages music)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages base)
  #:use-module (gnu packages perl)
  #:use-module (guix build-system asdf)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils))
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
     (inputs (list sdl2))
     (native-inputs (list pkg-config))
     (synopsis "A MIDI player that emulates OPL3")
     (description
      "A cli midi file player that emulates OPL3 chips instead of using
soundfonts.")
     (home-page "https://github.com/bisqwit/adlmidi")
     (license license:gpl3))))
(define stumpwm-contrib
  (let ((commit "a7dc1c663d04e6c73a4772c8a6ad56a34381096a")
        (revision "1"))
    (package
      (name "stumpwm-contrib")
      (version (git-version "0.0.1" revision commit)) ;no upstream release
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/stumpwm/stumpwm-contrib")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "09akdaaya7lga5lzbq1aj1filsyjwvflghkidpmr0nk0jz5xx1g7"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("stumpwm" ,stumpwm "lib")))
      (home-page "https://github.com/stumpwm/stumpwm-contrib")
      (synopsis "StumpWM interactive shell")
      (description "This package provides a StumpWM interactive shell.")
      (license (list license:gpl2+ license:gpl3+ license:bsd-2)))))
(define-public sbcl-stumpwm-battery-portable
  (package
    (inherit stumpwm-contrib)
    (name "sbcl-stumpwm-battery-portable")
    (inputs
     `(("stumpwm" ,stumpwm "lib")))
    (arguments
     '(#:asd-systems '("battery-portable")
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chdir
           (lambda _
             (chdir "modeline/battery-portable"))))))
    (home-page
     (string-append
      "https://github.com/stumpwm/stumpwm-contrib/"
      "tree/master/modeline/battery-portable"))
    (synopsis "Battery Indicator for StumpWM")
    (description
     "This StumpWM Module provides modeline support for a battery indicator.")
    (license license:gpl3+)))
(define-public orca-music
  (let ((commit "e55b8fdc3606341345938d5b24b2d9d9326afdb5") (revision "1"))
    (package
(name "orca-music")
;; No upstream version numbers; Using commit instead.
(version (git-version "0" revision commit))
(source (origin
          (method git-fetch)
          (uri (git-reference
                (url "https://git.sr.ht/~rabbits/orca")
                (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32
            "0xf5i9vd2wyrhvfp68j5gvd40iqm9rf6g1p74jan7d875g6kpppq"))))
(build-system gnu-build-system)
(arguments
 `(#:tests? #f
   #:phases (modify-phases %standard-phases
              (delete 'configure) ;; No autoconf
              (replace 'build
                (lambda* (#:key inputs outputs #:allow-other-keys)
                  (setenv "CC"
                          ,(cc-for-target))
                  (invoke "make" "release")))
              (add-after 'build 'rename-orca
                (lambda* _
                  (invoke "mv" "-v" "./build/orca" "./build/orca-music")))
              (replace 'install
                (lambda* (#:key outputs #:allow-other-keys)
                  (let* ((out (assoc-ref outputs "out")) (dest-bin (string-append
                                                                    out
                                                                    "/bin"))
                         (share (string-append out "/share"))
                         (dest-examples (string-append share "/examples"))
                         (dest-doc (string-append share "/doc")))
                    (install-file "./build/orca-music" dest-bin)
                    (copy-recursively "./examples" dest-examples)
                    (install-file "./README.md" dest-doc)))))))
(inputs (list ncurses portmidi alsa-plugins `(,alsa-plugins "pulseaudio")))
(native-inputs (list pkg-config))
(native-search-paths (list
                       (search-path-specification
                        (variable "TERMINFO_DIRS")
                        (files '("share/terminfo")))))
(synopsis "Musical live-coding environment")
(description
 "This is the C implementation of the ORCΛ language and terminal
livecoding environment. It's designed to be power efficient. It can handle
large files, even if your terminal is small.

Orca is not a synthesizer, but a flexible livecoding environment capable of
sending MIDI, OSC, and UDP to your audio/visual interfaces like Ableton,
Renoise, VCV Rack, or SuperCollider.")
(home-page "https://100r.co/site/orca.html")
(license license:expat))))
(define-public uxn
  (let ((commit "f87c15c8b5274546a2198c35f5a6e30094f8f004")
        (revision "1"))
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
     (inputs (list sdl2))
     (synopsis "Virtual Machine With 32 Instructions")
     (description
      "This personal computer is capable of hosting small graphical
applications, programmable in a unique assembly language.  It was designed with
an implementation-first mindset with a focus on creating portable tools and
games.")
     (home-page "https://wiki.xxiivv.com/site/uxn.html")
     (license license:isc))))
(define-public my-frotz
  (package
    (name "my-frotz")
    (version "2.54")
    (source (origin
              (method url-fetch)
              (uri (list (string-append
                          "http://www.ifarchive.org/if-archive/infocom/interpreters/"
                          "frotz/frotz-" version ".tar.gz")
                         (string-append
                          "ftp://ftp.ifarchive.org/if-archive/infocom/interpreters/"
                          "frotz/frotz-" version ".tar.gz")))
              (sha256
               (base32
                "1vsfq9ryyb4nvzxpnnn40k423k9pdy8k67i8390qz5h0vmxw0fds"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; there are no tests
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'build
           (lambda* _
             ;; Compile.
             (invoke "make" "frotz")))
         (add-before 'build 'patch-makefile
           (lambda* _
             (let ((makefiles (list
                               "Makefile"
                               "src/common/Makefile"
                               "src/curses/Makefile"
                               "src/x11/Makefile"
                               "src/sdl/Makefile"
                               "src/dumb/Makefile"
                               "src/blorb/Makefile")))
               (map (lambda (x)
                      (substitute* x
                        (("\\$\\(CC\\)") "gcc")))
                    makefiles))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (man (string-append out "/share/man/man6")))
               (install-file "frotz" bin)
               (mkdir-p man)
               (install-file "doc/frotz.6" man)))))))
    (inputs (list ao libmodplug libsamplerate libsndfile libvorbis ncurses which perl pkg-config))
    (synopsis "Portable Z-machine interpreter (ncurses version) for text adventure games")
    (description "Frotz is an interpreter for Infocom games and other Z-machine
games in the text adventure/interactive fiction genre.  This version of Frotz
complies with standard 1.0 of Graham Nelson's specification.  It plays all
Z-code games V1-V8, including V6, with sound support through libao, and uses
ncurses for text display.")
    (home-page "http://frotz.sourceforge.net")
    (license license:gpl2+)))
my-frotz
