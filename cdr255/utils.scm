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
  #:use-module (guix build-system asdf)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1))
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
  (let* ((tag "0.7.2")
         (revision "1")
         (commit "5e018ddbd8c7841254755cb87d986ecfa359932f")
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
                  "1msa1d76h851sh0karpfha87n5993b8mlzxsjf7h90li5fndzywf"))))
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
                             (("CXXFLAGS=-Wall -fPIC -I\\$\\(ROOT\\)/include -I")
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
                             (("LDFLAGS=")
                              (string-append
                               "LDFLAGS=-Wl,-rpath="
                               (assoc-ref outputs "out")
                               "/lib -L"
                               updfparser
                               "/lib -L"
                               libzip
                               "/lib -L"
                               pugixml
                               "/lib -L.. -lpugixml -lupdfparser -lzip"))
                             (("TARGETS=acsmdownloader adept_activate adept_remove adept_loan_mgt")
                              (string-append
                               "TARGETS=acsmdownloader adept_activate "
                               "adept_remove adept_loan_mgt "
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
                           (install-file "libgourou.so"
                                         dest-lib)
                           (install-file "utils/drmprocessorclientimpl.so"
                                         dest-lib)
                           (install-file "utils/utils_common.so"
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
                           (install-file "utils/adept_loan_mgt"
                                         dest-bin)))))))
      (native-inputs (list updfparser
                           macaron-base64
                           libzip
                           pugixml
                           openssl
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
(define-public knock
  (let* ((tag "1.3")
         (revision "1")
         (commit "26fe53dfd8e20fbf6147996b763b76dac3ad8a93")
         (version (git-version tag revision commit)))
    (package
      (name "knock")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/BentonEdmondson/knock.git")
                      (commit commit)))
                (sha256
                 (base32
                  "0vqvpw8kqnv3nxg80ja54d1f8bl3fgazhxdssnxw5x68x77kvvd3"))))
      
      (outputs '("out"))
      (build-system gnu-build-system)
      (arguments
       (list
        #:tests? #f
        #:phases #~(modify-phases
                       %standard-phases
                     (delete 'configure)
                     (replace 'build
                       (lambda* (#:key inputs outputs #:allow-other-keys)
                         (system (string-append
                                  "g++ -std=c++17 -o knock -D KNOCK_VERSION=1.3 -I"
                                  #$(this-package-native-input "libgourou")
                                  "/include/libgourou -I"
                                  #$(this-package-native-input "pugixml")
                                  "/include -L"
                                  #$(this-package-native-input "libgourou")
                                  "/lib -L"
                                  #$(this-package-native-input "curl")
                                  "/lib -L"
                                  #$(this-package-native-input "openssl")
                                  "/lib -L"
                                  #$(this-package-native-input "libzip")
                                  "/lib -L"
                                  #$(this-package-native-input "zlib")
                                  "/lib -l:drmprocessorclientimpl.so "
                                  "-l:utils_common.so -lgourou -lcrypto "
                                  "-lcurl -lzip -lz -Wl,-rpath="
                                  (assoc-ref outputs "out")
                                  "/lib src/knock.cpp"))))
                     (replace 'install
                       (lambda* (#:key outputs #:allow-other-keys)
                         (let* ((out (assoc-ref outputs "out"))
                                (dest-bin (string-append out "/bin")))
                           (install-file "knock" dest-bin)))))))
      (native-inputs (list libgourou
                           macaron-base64
                           libzip
                           pugixml
                           openssl
                           curl
                           zlib))
      (synopsis "Convert ACSM files to PDFs/EPUBs with one command on Linux")
      (description "Convert ACSM files to PDF/EPUBs with one command on Linux.")
      (home-page "https://github.com/BentonEdmondson/knock/")
      (license license:gpl3))))
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
