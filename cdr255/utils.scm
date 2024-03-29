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
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages python)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages video)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages time)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages sqlite)  
  #:use-module (gnu packages swig)  
  #:use-module (gnu packages geo)
  #:use-module (gnu packages java)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages web)
  #:use-module (gnu packages libevent)
  #:use-module (guix build-system asdf)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11))
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
(define-public libadlmidi
  (let* ((revision "1")
         (commit "84d27bc2bdbd6dd249537a7f7d2450cbd402482e"))
    (package
      (name "libadlmidi")
      (version (git-version "1.5.1-git" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/Wohlstand/libADLMIDI.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0lk61j72c1qwpq0a68vkpw7qiyv2byv7852iz4mvcivsi9gmlr6l"))))
      (outputs '("out"))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags '(list "-DlibADLMIDI_STATIC=OFF"
                                 "-DlibADLMIDI_SHARED=ON"
                                 "-DWITH_UNIT_TESTS=OFF"
                                 "-DWITH_MIDI_SEQUENCER=ON"
                                 "-DWITH_EMBEDDED_BANKS=ON"
                                 "-DWITH_HQ_RESAMPLER=ON"
                                 "-DWITH_MUS_SUPPORT=ON"
                                 "-DWITH_XMI_SUPPORT=ON"
                                 "-DUSE_DOSBOX_EMULATOR=ON"
                                 "-DUSE_NUKED_EMULATOR=ON"
                                 "-DUSE_OPAL_EMULATOR=ON"
                                 "-DUSE_JAVA_EMULATOR=ON"
                                 "-DWITH_GENADLDATA=ON"
                                 "-DWITH_GENADLDATA_COMMENTS=ON"
                                 "-DWITH_MIDIPLAY=ON"
                                 "-DWITH_ADLMIDI2=ON"
                                 "-DWITH_VLC_PLUGIN=OFF")
        #:tests? #f
        ;; #:phases #~(modify-phases
        ;;             %standard-phases
        ;;             )
        ))
      (native-inputs (list zita-resampler sdl2 pkg-config))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "A Software MIDI Synthesizer library with OPL3 (YMF262) emulator")
      (description "libADLMIDI is a free Software MIDI synthesizer library with OPL3 emulation

Original ADLMIDI code: Copyright (c) 2010-2014 Joel Yliluoma bisqwit@iki.fi

ADLMIDI Library API: Copyright (c) 2015-2022 Vitaly Novichkov admin@wohlnet.ru

Library is based on the ADLMIDI, a MIDI player for Linux and Windows with OPL3 emulation:

https://bisqwit.iki.fi/source/adlmidi.html.")
      (home-page "https://github.com/Wohlstand/libADLMIDI")
      (license (list license:gpl3+
                     license:expat
                     license:lgpl2.1+
                     license:gpl2+)))))

(define stumpwm-contrib
  (let ((commit "36daccd715e1cc6c1badab7cd87e34a8514f3b6b")
        (revision "2"))
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
          (base32 "0xad6hpp2inkksjlynb21y3jscjwjs3cpfnk1rkmgh02f9dkavd1"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       `(("stumpwm" ,stumpwm "lib")))
      (home-page "https://github.com/stumpwm/stumpwm-contrib")
      (synopsis "StumpWM interactive shell")
      (description "This package provides a StumpWM interactive shell.")
      (license (list license:gpl2+ license:gpl3+ license:bsd-2)))))
(define-public my-sbcl-stumpwm-battery-portable
  (package
    (inherit stumpwm-contrib)
    (name "my-sbcl-stumpwm-battery-portable")
    (inputs
     `(("stumpwm" ,stumpwm "lib")))
    (arguments
     '(#:asd-systems '("battery-portable")
       #:tests? #t
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
(define-public sbcl-xml-emitter
  (let* ((tag "1.1.0")
         (revision "1")
         (commit "1a93a5ab084a10f3b527db3043bd0ba5868404bf")
         (version (git-version tag revision commit)))
    (package
      (name "sbcl-xml-emitter")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/VitoVan/xml-emitter.git")
                      (commit commit)))
                (sha256
                 (base32
                  "1w9yx8gc4imimvjqkhq8yzpg3kjrp2y37rjix5c1lnz4s7bxvhk9"))))
      (outputs '("out"))
      (build-system asdf-build-system/sbcl)
      ;; (arguments
      ;;  (list
      ;;   #:phases #~(modify-phases
      ;;                  %standard-phases ; No Configure
      ;;               )
      ;;   ))
      (native-inputs (list sbcl
                           cl-1am))
      ;; (inputs (list ))
      (propagated-inputs (list 
                          cl-utilities
                          sbcl-dbus))
      (synopsis "")
      (description ".")
      (home-page "")
      (license license:gpl3))))
(define-public cl-xml-emitter
  (sbcl-package->cl-source-package sbcl-xml-emitter))
(define-public ecl-xml-emitter
  (sbcl-package->ecl-package sbcl-xml-emitter))
(define-public sbcl-stumpwm-notify
  (package
    (inherit stumpwm-contrib)
    (name "sbcl-stumpwm-notify")
    (native-inputs
     `(("sbcl-xml-emitter" ,sbcl-xml-emitter)
       ("sbcl-cl-utilities" ,sbcl-cl-utilities)
       ("sbcl-bordeaux-threads" ,sbcl-bordeaux-threads)
       ("sbcl-dbus" ,sbcl-dbus)
       ("stumpwm" ,stumpwm "lib")))
    (arguments
     '(#:asd-systems '("notify")
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'chdir
           (lambda _
             (chdir "util/notify"))))))
    (home-page
     (string-append
      "https://github.com/stumpwm/stumpwm-contrib/"
      "tree/master/modeline/battery-portable"))
    (synopsis "Notifications for StumpWM")
    (description
     "This StumpWM Module provides a notifications server for StumpWM.")
    (license license:gpl3+)))

(define-public uxn
  (let ((commit "a740105b7616c882f45c2f11611c2d2e3396f1c0")
        (revision "1"))
    (package
      (name "uxn")
      (version (git-version "git" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.sr.ht/~rabbits/uxn")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1d9p6xbiwjajanmjk62zvqzylnpiywa1zplfv7jv6af92d61ily8"))))
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
                          (define (uxn-assemble source dest)
                            (invoke "./bin/uxnasm"
                                    (string-append "./projects/" source)
                                    (string-append "./bin/" dest ".rom")))
                          (setenv "HOME" "./")
                          (setenv "CC" "gcc")
                          (invoke "bash" "build.sh" "--install" "--no-run")
                          (uxn-assemble "software/piano.tal" "piano")
                          (uxn-assemble "software/asma.tal" "asma")
                          (uxn-assemble "software/launcher.tal" "launcher")
                          (uxn-assemble "software/calc.tal" "calc")
                          (uxn-assemble "software/clock.tal" "clock")
                          (uxn-assemble "software/neralie.tal" "neralie")
                          (uxn-assemble "utils/hexdump.tal" "hexdump")))
                    (replace
                        'install
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let* ((out (assoc-ref outputs "out"))
                               (dest-bin (string-append out "/bin"))
                               (dest-lib (string-append out "/share/uxn"))
                               (dest-rom (string-append dest-lib "/rom")))

                          (mkdir-p dest-bin)
                          (mkdir-p dest-lib)
                          (install-file "./bin/uxnasm" dest-bin)
                          (install-file "./bin/uxncli" dest-bin)
                          (install-file "./bin/uxnemu" dest-bin)
                          (install-file "./bin/calc.rom" dest-rom)
                          (install-file "./bin/clock.rom" dest-rom)
                          (install-file "./bin/neralie.rom" dest-rom)
                          (install-file "./bin/hexdump.rom" dest-rom)
                          (install-file "./bin/launcher.rom" dest-rom)
                          (install-file "./bin/asma.rom" dest-rom)
                          (install-file "./bin/launcher.rom" dest-bin)
                          (install-file "./bin/asma.rom" dest-bin)
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
(define-public updfparser
  (let* ((tag "0")
         (revision "1")
         (commit "9d56c1d0b1ce81aae4c8db9d99a8b5d1f7967bcf")
         (version (git-version tag revision commit)))
    (package
      (name "updfparser")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://soutade.fr/updfparser.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1583wlw5pgrdg13gfbnx8m7yv6cnffi03bmr18wb4vclm1nf5nzm"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f
         #:phases (modify-phases %standard-phases
                    (delete 'configure)
                    (replace 'install
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let* ((out (assoc-ref outputs "out"))
                               (dest-lib (string-append out "/lib"))
                               (dest-include (string-append out "/include")))
                          (install-file "libupdfparser.so"
                                        dest-lib)
                          (install-file "include/uPDFObject.h"
                                        dest-include)
                          (install-file "include/uPDFParser_common.h"
                                        dest-include)
                          (install-file "include/uPDFParser.h"
                                        dest-include)
                          (install-file "include/uPDFTypes.h"
                                        dest-include)))))))
      (synopsis "micro PDF parser library for C++")
      (description "A very simple PDF parser.")
      (home-page "http://frotz.sourceforge.net")
      (license license:gpl3+))))
(define-public macaron-base64
  (let* ((tag "0")
         (revision "1")
         (commit "7d5a89229a525452e37504976a73c35fbaf2fe4d")
         (version (git-version tag revision commit)))
    (package
      (name "macaron-base64")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://gist.github.com/tomykaira/f0fd86b6c73063283afe550bc5d77594")
                      (commit commit)))
                (sha256
                 (base32
                  "1g5i8iq5azbqmj3frffqdgc66j2c9agmx5zd0gjpxa1b7pba5pkn"))))
      (build-system copy-build-system)
      (arguments
       `(#:install-plan '(("Base64.h" "include/base64/"))))
      (synopsis "single header base64 library")
      (description "A single-header C++ library for base64 encoding/decoding.")
      (home-page "https://gist.github.com/tomykaira/f0fd86b6c73063283afe550bc5d77594")
      (license license:expat))))
(define-public libgourou
  (let* ((tag "0.8.1")
         (revision "1")
         (commit "46afe771c788a32eb7a96234a4cea0810293942d")
         (version (git-version tag revision commit)))
    (package
      (name "libgourou")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://soutade.fr/libgourou.git")
                      (commit commit)))
                (sha256
                 (base32
                  "00cg8lfjnryszvldy949xgpir6nz674kfrwwys8av4vy7piqm7jz"))))
      (outputs '("out" "bin"))
      (build-system gnu-build-system)
      (arguments
       (list
        #:tests? #f
        #:phases #~(modify-phases
                       %standard-phases
                     (delete 'configure)
                     (add-before
                         'build 'patch-makefiles
                       (lambda* (#:key inputs outputs #:allow-other-keys)
                         (let* ((out (assoc-ref outputs "out"))
                                (dest (string-append out "/lib"))
                                (updfparser #$(this-package-native-input
                                               "updfparser"))
                                (macaron-base64 #$(this-package-native-input
                                                   "macaron-base64"))
                                (libzip #$(this-package-native-input
                                           "libzip"))
                                (openssl #$(this-package-native-input
                                            "openssl"))
                                (curl #$(this-package-native-input
                                         "curl"))
                                (zlib #$(this-package-native-input
                                         "zlib"))
                                (pugixml #$(this-package-native-input
                                            "pugixml")))
                           (system "rm src/pugixml.cpp")
                           (substitute*
                               "Makefile"
                             (("./lib -I./lib/pugixml/src/ -I./lib/updfparser/include")
                              "")
                             (("CXXFLAGS=-Wall -fPIC -I./include -I")
                              (string-append
                               "CXXFLAGS=-Wall -fPIC -I./include -I"
                               updfparser
                               "/include -I"
                               macaron-base64
                               "/include -I"
                               pugixml
                               "/include"
                               ))
                             (("\\./scripts/setup.sh")
                              "")
                             (("src/pugixml.cpp")
                              "")
                             (("LDFLAGS = \\$\\(UPDFPARSERLIB\\)")
                              (string-append
                               "LDFLAGS = -L"
                               updfparser
                               "/lib -L"
                               pugixml
                               "/lib -lpugixml -lupdfparser"
                               ))
                             (("\\$\\(UPDFPARSERLIB\\)")
                              ""))
                           (substitute*
                               "utils/Makefile"
                             (("\\$\\(ROOT\\)/lib/pugixml/src/")
                              "")
                             (("CXXFLAGS=-Wall -fPIC -I\\$\\(ROOT\\)/include")
                              (string-append
                               "CXXFLAGS=-Wall -fPIC "
                               "-I$(ROOT)/source/include -I"
                               updfparser
                               "/include -I"
                               macaron-base64
                               "/include -I"
                               pugixml
                               "/include -I"
                               openssl
                               "/include -I"
                               curl
                               "/include -I"
                               zlib
                               "/include -I"
                               libzip
                               "/include"))
                             (("LDFLAGS \\+= -L\\$\\(ROOT\\) -lcrypto -lzip -lz -lcurl")
                              (string-append
                               "LDFLAGS += -Wl,-rpath="
                               (assoc-ref outputs "out")
                               "/lib -L"
                               updfparser
                               "/lib -L"
                               libzip
                               "/lib -L"
                               pugixml
                               "/lib -L.. -lpugixml -lupdfparser -lzip -lz "
                               "-lcrypto -lcurl"))
                             (("TARGETS=acsmdownloader adept_activate adept_remove adept_loan_mgt launcher")
                              (string-append
                               "TARGETS=acsmdownloader adept_activate "
                               "adept_remove adept_loan_mgt launcher "
                               "drmprocessorclientimpl.so "
                               "utils_common.so"))
                             (("^clean:")
                              (string-append
                               "drmprocessorclientimpl.so: drmprocessorclientimpl.o\n"
                               "\tgcc -shared -o drmprocessorclientimpl.so drmprocessorclientimpl.o\n"
                               "utils_common.so: utils_common.o\n"
                               "\tgcc -shared -o utils_common.so utils_common.o\n"
                               "\nclean:"))))
                         (system "cat utils/Makefile")))
                     (replace 'install
                       (lambda* (#:key outputs #:allow-other-keys)
                         (let* ((out (assoc-ref outputs "out"))
                                (bin (assoc-ref outputs "bin"))
                                (dest-lib (string-append out "/lib"))
                                (dest-include (string-append
                                               out
                                               "/include/libgourou"))
                                (dest-bin (string-append bin "/bin")))
                           (system "ls")
                           (system "ls utils")
                           (install-file (string-append
                                          "libgourou.so."
                                          #$tag)
                                         dest-lib)
                           (install-file "libgourou.so"
                                         dest-lib)
                           (copy-recursively "include"
                                             dest-include)
                           (install-file "utils/drmprocessorclientimpl.h"
                                         dest-include)
                           (install-file "utils/utils_common.h"
                                         dest-include)
                           (install-file "utils/acsmdownloader"
                                         dest-bin)
                           (install-file "utils/adept_activate"
                                         dest-bin)
                           (install-file "utils/adept_remove"
                                         dest-bin)
                           (install-file "utils/launcher"
                                         dest-bin)
                           (install-file "utils/adept_loan_mgt"
                                         dest-bin)))))))
      (native-inputs (list updfparser
                           macaron-base64
                           libzip
                           pugixml
                           openssl-3.0
                           curl
                           zlib))
      (synopsis "a Free ADEPT protocol implementation")
      (description "A Free and Open Source implementation of ADEPT protocol.
It supports:

    Account signIn
    Device activation
    ePub download from ACSM request file")
      (home-page "http://blog.soutade.fr/post/2021/07/libgourou-a-free-adept-protocol-implementation.html")
      (license license:lgpl3))))
;; (define-public knock
;;   (let* ((tag "1.3.1")
;;          (revision "1")
;;          (commit "488fcabd69ca6f9e306a3ca30ccef600209115b1")
;;          (version (git-version tag revision commit)))
;;     (package
;;       (name "knock")
;;       (version version)
;;       (source (origin
;;                 (method git-fetch)
;;                 (uri (git-reference
;;                       (url "https://github.com/BentonEdmondson/knock.git")
;;                       (commit commit)))
;;                 (sha256
;;                  (base32
;;                   "1fp33wdx0rijv0v06ggc0d9yb4k5lhc4f48543pbaf2fql5npj4c"))))
;;       (outputs '("out"))
;;       (build-system gnu-build-system)
;;       (arguments
;;        (list
;;         #:tests? #f
;;         #:phases #~(modify-phases
;;                        %standard-phases
;;                      (delete 'configure)
;;                      (replace 'build
;;                        (lambda* (#:key inputs outputs #:allow-other-keys)
;;                          (system (string-append
;;                                   "g++ -std=c++17 -o knock -D KNOCK_VERSION=1.3 -I"
;;                                   #$(this-package-native-input "libgourou")
;;                                   "/include/libgourou -I"
;;                                   #$(this-package-native-input "pugixml")
;;                                   "/include -L"
;;                                   #$(this-package-native-input "libgourou")
;;                                   "/lib -L"
;;                                   #$(this-package-native-input "curl")
;;                                   "/lib -L"
;;                                   #$(this-package-native-input "openssl")
;;                                   "/lib -L"
;;                                   #$(this-package-native-input "libzip")
;;                                   "/lib -L"
;;                                   #$(this-package-native-input "zlib")
;;                                   "/lib -l:drmprocessorclientimpl.so "
;;                                   "-l:utils_common.so -lgourou -lcrypto "
;;                                   "-lcurl -lzip -lz -Wl,-rpath="
;;                                   (assoc-ref outputs "out")
;;                                   "/lib src/knock.cpp"))))
;;                      (replace 'install
;;                        (lambda* (#:key outputs #:allow-other-keys)
;;                          (let* ((out (assoc-ref outputs "out"))
;;                                 (dest-bin (string-append out "/bin")))
;;                            (install-file "knock" dest-bin)))))))
;;       (native-inputs (list libgourou
;;                            macaron-base64
;;                            libzip
;;                            pugixml
;;                            openssl-3.0
;;                            curl
;;                            zlib))
;;       (synopsis "Convert ACSM files to PDFs/EPUBs with one command on Linux")
;;       (description "Convert ACSM files to PDF/EPUBs with one command on Linux.")
;;       (home-page "https://github.com/BentonEdmondson/knock/")
;;       (license license:gpl3))))
(define-public mikmod
  (let* ((tag "3.3.11.1-git")
         (revision "1")
         (commit "187e55986a5888a8ead767a38fc29a8fc0ec5bbe")
         (version (git-version tag revision commit)))
    (package
      (name "mikmod")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.code.sf.net/p/mikmod/mikmod")
                      (commit commit)))
                (sha256
                 (base32
                  "1im3k2185ddgw7sxwxbklak6navh0m016v61cphms2v1h4j9ddrz"))))
      (outputs '("out"))
      (build-system cmake-build-system)
      (arguments
       (list
        #:tests? #f
        #:phases #~(modify-phases
                     %standard-phases
                     (add-before 'configure 'chdir
                                 (lambda _
                                   (chdir "mikmod"))))
        ))
       (native-inputs (list libmikmod-with-drivers
                            autoconf
                            automake
                            ncurses))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "Mikmod Sound System Player")
      (description "Mikmod is a module player and library supporting many formats, including mod, s3m, it, and xm. Originally a player for MS-DOS, MikMod has been ported to other platforms, such as Unix, Macintosh, BeOS, and Java.")
      (home-page "http://mikmod.sourceforge.net/")
      (license license:gpl2))))
(define-public libmikmod-with-drivers
  (package
    (name "libmikmod-with-drivers")
    (version "3.3.11.1")
    (source (origin
             (method url-fetch)
             (uri (list
                   (string-append "mirror://sourceforge/mikmod/libmikmod/"
                                  version "/libmikmod-" version ".tar.gz")
                   ;; Older versions are sometimes moved to:
                   (string-append "mirror://sourceforge/mikmod/"
                                  "outdated_versions/libmikmod/"
                                  version "/libmikmod-" version ".tar.gz")))
             (sha256
              (base32
               "06bdnhb0l81srdzg6gn2v2ydhhaazza7rshrcj3q8dpqr3gn97dd"))))
    (build-system gnu-build-system)
    (arguments
     ;; By default, libmikmod tries to dlopen libasound etc., which won't work
     ;; unless the right libalsa happens to be in $LD_LIBRARY_PATH.  Pass
     ;; '--disable-dl' to avoid that.
     '(#:configure-flags '("--disable-dl"
                           "--enable-pulseaudio"
                           "--enable-openal"
                           "--enable-alsa")))
    (native-inputs (list pulseaudio
                         sdl2
                         openal
                         alsa-lib
                         perl))
    (synopsis "Library for module sound formats")
    (description
     "MikMod is able to play a wide range of module formats, as well as
digital sound files.  It can take advantage of particular features of your
system, such as sound redirection over the network.")
    (license license:lgpl2.1)
    (home-page "http://mikmod.sourceforge.net/")))
;;; Bumped version from Guix.
(define-public xkeyboard-config
  (package
    (name "xkeyboard-config")
    (version "2.36")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "ftp://ftp.freedesktop.org/pub/xorg/individual/data/xkeyboard-config/xkeyboard-config-"
             version
             ".tar.xz"))
       (sha256
        (base32
         "158m7r6ga7w12ry35q6d0z6hilbpj9h7ilw56h55478n58lv26qz"))))
    (build-system meson-build-system)
    (inputs
     (list libx11 xkbcomp-intermediate))
    (native-inputs
     `(("gettext" ,gettext-minimal)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("python" ,python)))
    (home-page "https://www.x.org/wiki/")
    (synopsis "Xorg XKB configuration files")
    (description
     "xkeyboard-config provides a database for X Keyboard (XKB) Extension.
There are five components that define a complete keyboard mapping:
symbols, geometry, keycodes, compat, and types; these five components
can be combined together using the @code{rules} component of this database.")
    (license license:x11)))
(define-public python-ssdpy
  (package
    (name "python-ssdpy")
    (version "0.4.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "ssdpy" version))
              (sha256
               (base32
                "09bl73i7nk4gq1g0z2v5cgxw71wi5lzmkjdyrmz18zzp22hccwa9"))))
    (build-system python-build-system)
    (home-page "https://github.com/MoshiBin/ssdpy")
    (synopsis "Python SSDP library")
    (description "Python SSDP library")
    (license license:expat)))

(define-public python-twtxt
  (package
   (name "python-twtxt")
   (version "1.3.1")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "twtxt" version))
            (sha256
             (base32
              "1zvi3dsqv1zjn62cvfpa0zn8v7lvjcml0j20n94181qnh07mhppi"))))
   (build-system python-build-system)
   (arguments
    (list
     #:tests? #f ));; "WARNING: Testing via this command is deprecated and
                   ;; will be removed in a future version. Users looking for
                   ;; a generic test entry point independent of test runner
                   ;; are encouraged to use tox."
   (propagated-inputs (list python-aiohttp python-click python-dateutil
                            python-humanize-3.8.0))
   (native-inputs (list python-pytest python-pytest-cov python-tox))
   (home-page "https://github.com/buckket/twtxt")
   (synopsis "Decentralised, minimalist microblogging service for hackers.")
   (description
    "Decentralised, minimalist microblogging service for hackers.")
   (license license:expat)))

(define-public python-humanize-3.8.0
  (package
   (name "python-humanize")
   (version "3.8.0")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "humanize" version))
            (sha256
             (base32
              "04qnipdc0x2bycmlx7a85nfh81cyy15rxy4m4s4fs1ya2fiqlvmx"))))
   (build-system python-build-system)
   (arguments
    (list
     #:phases
     `(modify-phases %standard-phases
                  (add-before 'build 'explicit-version
                              ;; The version string is usually derived via setuptools-scm, but
                              ;; without the git metadata available, the version string is set to
                              ;; '0.0.0'.
                              (lambda _
                                (substitute* "setup.py"
                                             (("setup\\(\\)") ,(string-append
                                                                "setup(name='humanize',
version='"
                                                            version
                                                            "',)")))
                                )))))
   (propagated-inputs (list python-importlib-metadata))
   (native-inputs (list python-freezegun python-pytest python-pytest-cov))
   (home-page "")
   (synopsis "Python humanize utilities")
   (description "Python humanize utilities")
   (license license:expat)))

(define python-hatch-0.23.0
  (let ((commit "704cdcd1a0cd3a621235ac9f5b2b90e7524e3cd3")
        (revision "1"))
    (package
     (name "python-hatch-0.23.0")
     (version (git-version "0.23.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pypa/hatch.git")
                    (commit commit)))
              (sha256
               (base32
                "1y41xgp4q8ghzmzxfhw68rmdx9j0f6pxgq326sml23qjyfh6f9n9"))))
     (build-system python-build-system)
     (arguments
      (list
       #:tests? #f))
     (propagated-inputs (list python-wheel
                              python-atomicwrites
                              python-appdirs
                              python-virtualenv
                              python-twine
                              python-semver
                              python-pytest
                              python-pexpect
                              python-coverage
                              python-colorama
                              python-click
                              python-parse))
     (home-page "")
     (synopsis "Modern, extensible Python build backend")
     (description "Modern, extensible Python build backend")
     (license #f))))

(define python-hatch-1.0.0
  (let ((commit "eef7d0cc6a4d9c4459a4332ebce4b91ff22fbb08"))
    (package
     (name "python-hatch")
     (version "1.0.0")
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pypa/hatch.git")
                    (commit commit)))
              (sha256
               (base32
                "1y41xgp4q8ghzmzxfhw68rmdx9j0f6pxgq326sml23qjyfh6f9n9"))))
     (build-system pyproject-build-system)
     (arguments
      (list
       #:tests? #f))
     (propagated-inputs (list python-wheel
                              python-atomicwrites
                              python-appdirs
                              python-virtualenv
                              python-twine
                              python-semver
                              python-pytest
                              python-pexpect
                              python-coverage
                              python-colorama
                              python-click
                              python-parse
                              python-hatch-0.23.0))
     (home-page "")
     (synopsis "Modern, extensible Python build backend")
     (description "Modern, extensible Python build backend")
     (license #f))))

(define-public gerbil-0.17
  (package
   (inherit gerbil)
   (name "gerbil")
   (version "0.17")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/vyzo/gerbil")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0xzi9mhrmzcajhlz5qcnz4yjlljvbkbm9426iifgjn47ac0965zw"))))))


(define-public mysql-workbench-community
  (let* ((revision "1")
         (commit "4e1ee2964e2104c4054a398ba6093cf7f7937e36"))
    (package
     (name "mysql-workbench-community")
     (version (git-version "8.0.33" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mysql/mysql-workbench.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0bdrsjvxiizn3rd77s0afp2rk29zbyjh2ibp3ixbg15drb716qmq"))))
     (outputs '("out"))
     (build-system cmake-build-system)
     (arguments
      (list
       #:configure-flags #~(list
                            "-DCMAKE_CXX_STANDARD=11"
                              (string-append
                               "-DWITH_ANTLR_JAR="
                               #$(this-package-native-input
                                  "antlr4")
                               "/share/java/antlr4.jar")
                              
                              (string-append
                               "-DMySQL_INCLUDE_DIRS="
                               #$(this-package-native-input
                                  "mysql")
                               "/include/mysql")
                              
                              (string-append
                               "-DMySQL_LIBRARIES="
                               #$(this-package-native-input
                                  "mysql")
                               "/lib")
                              
                              (string-append
                               "-DMySQLCppConn_INCLUDE_DIRS="
                               #$(this-package-native-input
                                  "mysql-connector-cpp")
                               "/include")
                              
                              (string-append
                               "-DMySQLCppConn_LIBRARIES="
                               #$(this-package-native-input
                                  "mysql-connector-cpp")
                               "/lib")
                              (string-append
                               "-DUNIXODBC_INCLUDE_PATH="
                               #$(this-package-native-input
                                  "unixodbc")
                               "/include")
                              (string-append
                               "-DUNIXODBC_INCLUDE_DIRS="
                               #$(this-package-native-input
                                  "unixodbc")
                               "/include")
                              (string-append
                               "-DUNIXODBC_LIBRARIES="
                               #$(this-package-native-input
                                  "unixodbc")
                               "/lib")
                               )
        ;; #:tests? #f
        ;; #:phases #~(modify-phases
        ;;             %standard-phases
        ;;             )
        ))
     (native-inputs (list
                     antlr4
                     java-antlr4-runtime-cpp
                     autoconf
                     automake
                     pkg-config
                     libtool
                     libzip
                     libxml2
                     libsigc++
                     libglade
                     mesa
                     mysql
                     pixman
                     pcre
                     pango
                     cairo
                     python
                     sqlite
                     swig
                     gdal
                     gtk+
                     gtk
                     gtkmm-3
                     openssl
                     libsecret
                     proj
                     mysql-connector-cpp
                     vsqlite++
                     boost
                     libssh
                     rapidjson
                     unixodbc-2311
                     icedtea-7
                           ))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "")
      (description ".")
      (home-page "")
      (license license:gpl3))))

(define-public mysql-connector-cpp
  (let* ((revision "1")
         (commit "9f64d3245d21ed1718211d70eb2a09394ff19c7f"))
    (package
      (name "mysql-connector-cpp")
      (version (git-version "1.1.8" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/mysql/mysql-connector-cpp.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1rv8imvs8imxkn4y9agl9802lz40w7zn36x3fvypz5m0dy2p9mc3"))))
      (outputs '("out"))
      (build-system cmake-build-system)
      (arguments
      (list
       #:configure-flags #~(list
                            "-DCMAKE_ENABLE_C++11=true"
                              (string-append
                               "-DMySQL_INCLUDE_DIRS="
                               #$(this-package-native-input
                                  "mysql")
                               "/include/mysql")
                              (string-append
                               "-DMySQL_LIBRARIES="
                               #$(this-package-native-input
                                  "mysql")
                               "/share/mysql")
                               )
        #:tests? #f
        ;; #:phases #~(modify-phases
        ;;             %standard-phases
        ;;             )
        ))
      (native-inputs (list boost
                           openssl
                           mysql
                           zlib))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "")
      (description ".")
      (home-page "")
      (license license:gpl3))))

(define-public vsqlite++
  (let* ((revision "1")
         (commit "1bc5a9851195b9c67fd48cc82a4ccba378e63534"))
    (package
      (name "vsqlite++")
      (version (git-version "0.3.13" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/vinzenz/vsqlite--.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1b0s14axvqg3maqv28br5c72sbid4ilxi5j8vcxj10klr2fvyag1"))))
      (outputs '("out"))
      (build-system gnu-build-system)
      (arguments
       (list
        ;; #:tests? #f
        ;; #:phases #~(modify-phases
        ;;             %standard-phases
        ;;             )
        ))
      (native-inputs (list boost
                           sqlite
                           autoconf
                           automake
                           libtool))
      ;; (inputs (list ))
      ;; (propagated-inputs (list ))
      (synopsis "")
      (description ".")
      (home-page "")
      (license license:gpl3))))

(define-public unixodbc-2311
  (package
   (inherit unixodbc)
   (name "unixodbc")
   (version "2.3.11")
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-"
              version ".tar.gz"))
            (sha256
             (base32 "0p1vqxkw58k22mn7az7vj2s1c5dddn2khwy8cqy7wd0qf675rrfr"))))
))

;; (define-public tic-80
;;   (let* ((revision "1")
;;          (commit "b09c50c61f2e8f66959ee9539e5a05feaeaf8ae1"))
;;     (package
;;       (name "tic-80")
;;       (version (git-version "1.0.2164" revision commit))
;;       (source (origin
;;                 (method git-fetch)
;;                 (uri (git-reference
;;                       (url "https://github.com/nesbox/tic-80.git")
;;                       (commit commit)))
;;                 (file-name (git-file-name name version))
;;                 (sha256
;;                  (base32
;;                   "11bzkn0a0n59w0a2qc8zr7imnqgddnqv37bs26jraar526hsdijx"))))
;;       (outputs '("out"))
;;       (build-system cmake-build-system)
;;       (arguments
;;        (list
;;         #:configure-flags '(list "-dbuild_pro=on")
;;         ;; #:tests? #f
;;          #:phases #~(modify-phases
;;                      %standard-phases
;;                      (add-before 'configure 'graft-sources
;;                        (lambda* (#:key inputs #:allow-other-keys)
;;                          (begin
;;                            (display inputs)
;;                            ()
;;                      )))
;;         ))
;;       (native-inputs (list sdl2
;;                            libzip
;;                            libuv))
;;       ;; (inputs (list ))
;;       ;; (propagated-inputs (list ))
;;       (synopsis "the tiny computer")
;;       (description "tic-80 is a free and open source fantasy computer for making, playing and sharing tiny games.  with tic-80 you get built-in tools for development: code, sprites, maps, sound editors and the command line, which is enough to create a mini retro game.  games are packaged into a cartridge file, which can be easily distributed. tic-80 works on all popular platforms. this means your cartridge can be played in any device.  to make a retro styled game, the whole process of creation and execution takes place under some technical limitations: 240x136 pixel display, 16 color palette, 256 8x8 color sprites, 4 channel sound.")
;;       (home-page "https://tic80.com/")
;;       (license license:expat))))
