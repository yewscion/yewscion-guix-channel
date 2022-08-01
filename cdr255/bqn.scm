(define-module (cdr255 bqn)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system font)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (gnu packages)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages java)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages fontutils)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:hide (zip)))

(define dbqn
  (let* ((tag "0.2.1")
         (revision "1")
         (commit "0bbe096fc07d278b679a8479318f1722d096a03e")
         (version (git-version tag revision commit)))
    (package
     (name "dbqn")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dzaima/BQN.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1kxzxz2hrd1871281s4rsi569qk314aqfmng9pkqn8gv9nqhmph0"))))
     (outputs '("out"))
     (build-system gnu-build-system)
     (arguments
      (list
       #:tests? #f
       #:phases
       #~(modify-phases
          %standard-phases
          (delete 'configure)
          (replace 'build
                   (lambda* _
                     (invoke "./build")))
          (add-after 'install 'subjars
                     (lambda* (#:key outputs #:allow-other-keys)
                       (let* ((out (assoc-ref outputs "out"))
                              (dest-bin (string-append out "/bin"))
                              (dest-jar (string-append out "/share/java")))
                         (substitute*
                          (string-append dest-bin
                                         "/dbqn")
                          (("/usr/share/java/BQN.jar")
                           (string-append dest-jar
                                          "/BQN.jar"))))))
          (replace 'install
                   (lambda* (#:key outputs #:allow-other-keys)
                     (let* ((out (assoc-ref outputs "out"))
                            (dest-bin (string-append out "/bin"))
                            (dest-jar (string-append out "/share/java")))
                       (mkdir-p dest-bin)
                       (mkdir-p dest-jar)
                       (copy-recursively #$(plain-file "dbqn"
                                                       "#!/bin/bash
                                 
                                 java -jar /usr/share/java/BQN.jar -f \"$@\"")
                                         (string-append dest-bin
                                                        "/dbqn"))
                       (chmod (string-append dest-bin "/dbqn") #o755)
                       (install-file "BQN.jar"
                                     dest-jar)
                       #t))))))
     (native-inputs `(("openjdk17" ,openjdk17 "jdk")
                      ("coreutils" ,coreutils) ))
     ;; (inputs (list ))
     ;; (propagated-inputs (list ))
     (synopsis "A BQN implementation based on dzaima/APL")
     (description "A BQN implementation based on dzaima/APL.")
     (home-page "https://github.com/dzaima/BQN")
     (license license:expat))))
(define bqn-bytecode-sources
  (let* ((tag "0")
         (revision "1")
         (commit "e219af48401473a7bac49bdd8b89d69082cf5dd8")
         (version (git-version tag revision commit)))
    (package
     (name "bqn-bytecode-sources")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mlochbaum/BQN.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0r6pa9lscl2395g4xlvmg90vpdsjzhin4f1r0s7brymmpvmns2yc"))))
     (outputs '("out"))
     (build-system copy-build-system)
     (arguments
      (list
       #:install-plan (quote (list (list "src/" "share/src" #:exclude
                                         '("README.txt"
                                           "doc/"))))
       ))
     (native-inputs (list ))
     ;; (inputs (list ))
     ;; (propagated-inputs (list ))
     (synopsis "")
     (description ".")
     (home-page "")
     (license license:gpl3))))
(define-public cbqn
  (let* ((tag "0")
         (revision "1")
         (commit "88f65850fa6ac28bc50886c5942652f21d5be924")
         (version (git-version tag revision commit)))
    (package
     (name "cbqn")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dzaima/CBQN.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0bqwpvzwp2v20k2l725cwxx4fkvisniw9nls3685wd0fa3agpb47"))))
     (outputs '("out"))
     (build-system gnu-build-system)
     (arguments
      (list
       #:tests? #f
       #:make-flags (quote (list "CC=gcc"))
       #:phases #~(modify-phases
                   %standard-phases
                   (delete 'configure)
                   (add-before 'build 'generate-bytecode
                               (lambda* (#:key inputs #:allow-other-keys)
                                 (system (string-append
                                          #$(this-package-native-input "dbqn")
                                          "/bin/dbqn ./genRuntime "
                                          #$(this-package-input
                                             "bqn-bytecode-sources")
                                          "/share/"))))
                   (replace 'install
                            (lambda* (#:key outputs #:allow-other-keys)
                              (let* ((out (assoc-ref outputs "out"))
                                     (dest-bin (string-append out "/bin")))
                                (mkdir-p dest-bin)
                                (copy-recursively "BQN"
                                                  (string-append dest-bin
                                                                 "/bqn"))
                                (chmod (string-append dest-bin "/bqn") #o755)
                                ))))))
     (native-inputs (list dbqn
                          openjdk17))
     (inputs (list bqn-bytecode-sources
                   libffi))
     (synopsis "A BQN implementation in C")
     (description "The expected implementation for the BQN language,
according to the official documentation of that specification.")
     (home-page "https://mlochbaum.github.io/BQN/")
     (license license:gpl3))))
(define-public emacs-bqn-mode
  (let* ((tag "0")
         (revision "1")
         (commit "86ef8b4d32d272b2765cd4a6e6e0b70a4f3e99a2")
         (version (git-version tag revision commit)))
    (package
     (name "emacs-bqn-mode")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/museoa/bqn-mode.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1m54pa9b8kp3qr9lysfznv3d830w4zxqg0qgxxxrdkkk4gz1aa7b"))))
     (outputs '("out"))
     (build-system emacs-build-system)
     (synopsis "Major Mode for BQN")
     (description "The official major mode for the BQN language in Emacs.
Derived from gnu-apl-mode.")
     (home-page "https://mlochbaum.github.io/BQN/editors/index.html")
     (license license:gpl3))))
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
(define-public font-bqn386
  (let* ((tag "0")
         (revision "1")
         (commit "81e18d1eb8cb6b66df9e311b3b63ec086d910d18")
         (version (git-version tag revision commit)))
    (package
     (name "font-bqn386")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dzaima/BQN386.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0gg06rkcf71jr239pa22n46wbl5xq5756dfyl6m264k42ypinhvz"))))
     (outputs '("out"))
     (build-system font-build-system)
     (synopsis "An Official BQN/APL Unicode Font")
     (description "An APL and BQN font extending on APL386 by Adám Brudzewsky, which is based on APL385 by Adrian Smith. This font keeps regular APL characters mostly intact (with an exception being making ○-based charcters larger)")
     (home-page "https://github.com/dzaima/BQN386")
     (license license:unlicense))))
(define-public font-3270
  (let* ((tag "0")
         (revision "3.0.1")
         (commit "9aec667cb514472d37bf5fa202259c29fa587dc5")
         (version (git-version tag revision commit)))
    (package
     (name "font-3270")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rbanffy/3270font.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1l19djfq50qqswwagf01cnraqb1cwcbxlghmjxqdn75fpdlhlgva"))))
     (outputs '("out"))
     (build-system gnu-build-system)
     (arguments
      (list
       #:tests? #f
       #:make-flags (quote (list "font"))
       #:phases #~(modify-phases
                   %standard-phases
                   (delete 'configure)
                   (replace 'install
                               (lambda* (#:key outputs #:allow-other-keys)
                                 (let* ((out (assoc-ref outputs "out"))
                                        (out-ttf (string-append out
                                                                "/share/fonts/truetype"))
                                        (out-otf (string-append out
                                                                "/share/fonts/opentype"))
                                        (out-woff (string-append out
                                                                 "/share/fonts/webfonts")))
                                   (chdir "build")
                                   (mkdir-p out)
                                   (mkdir-p out-ttf)
                                   (mkdir-p out-otf)
                                   (mkdir-p out-woff)
                                   (install-file "3270SemiCondensed-Regular.ttf"
                                                 out-ttf)
                                   (install-file "3270-Regular.ttf"
                                                 out-ttf)
                                   (install-file "3270Condensed-Regular.ttf"
                                                 out-ttf)
                                   (install-file "3270SemiCondensed-Regular.otf"
                                                 out-otf)
                                   (install-file "3270-Regular.otf"
                                                 out-otf)
                                   (install-file "3270Condensed-Regular.otf"
                                                 out-otf)
                                   (install-file "3270SemiCondensed-Regular.woff"
                                                 out-woff)
                                   (install-file "3270-Regular.woff"
                                                 out-woff)
                                   (install-file "3270Condensed-Regular.woff"
                                                 out-woff)
                                   (chdir "..")))))))
      (native-inputs (list fontforge))
      (synopsis "A font for the nostalgic")
      (description "A 3270 font in a modern format, built using fontforge.")
      (home-page "https://github.com/rbanffy/3270font")
      (license license:bsd-3))))
(define-public font-open-relay
  (let* ((tag "0")
         (revision "1")
         (commit "38ecb6007388f91f0f41a95aa75c059a2d43ae71")
         (version (git-version tag revision commit)))
    (package
     (name "font-open-relay")
     (version version)
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kreativekorp/open-relay.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1rai98rp2b99kzp6r6xm20y0zda1nbs16z6az485clxi8gw32i6p"))))
     (outputs '("out"))
     (build-system font-build-system)
     (arguments
      (list
       #:phases #~(modify-phases %standard-phases
                    (add-before 'install
                        'rename-licenses
                      (lambda* _
                        (map
                         (lambda (x)
                           (copy-recursively (string-append
                                              x
                                              "/OFL.txt")
                                             (string-append
                                              "LICENSE-"
                                              x
                                              ".txt")))
                         (list "AlcoSans"
                               "Constructium"
                               "Fairfax"
                               "FairfaxHD"
                               "KreativeSquare")))))))
     (synopsis "Free and open source fonts from Kreative Software")
     (description "Free and open source fonts from Kreative Software:

        Constructium is a fork of SIL Gentium designed specifically to
support constructed scripts as encoded in the Under-ConScript Unicode
Registry. It is ideal for mixed Latin, Greek, Cyrillic, IPA, and conlang text
in web sites and documents.

        Fairfax is a 6x12 bitmap font for terminals, text editors, IDEs,
etc. It supports many scripts and a large number of Unicode blocks as well as
constructed scripts as encoded in the Under-ConScript Unicode Registry,
pseudographics and semigraphics, and tons of private use characters. It has
been superceded by Fairfax HD but is still maintained.

        Fairfax HD is a halfwidth scalable monospace font for terminals, text
editors, IDEs, etc. It supports many scripts and a large number of Unicode
blocks as well as constructed scripts as encoded in the Under-ConScript
Unicode Registry, pseudographics and semigraphics, and tons of private use
characters.

        Kreative Square is a fullwidth scalable monospace font designed
specifically to support pseudographics, semigraphics, and private use
characters.")
     (home-page "http://www.kreativekorp.com/software/fonts/index.shtml")
     (license license:silofl1.1))))
