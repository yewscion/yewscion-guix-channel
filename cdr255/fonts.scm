(define-module (cdr255 fonts)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (gnu packages)
  #:use-module (gnu packages fontutils))

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
      (description "An APL and BQN font extending on APL386 by Adám Brudzewsky,
      which is based on APL385 by Adrian Smith. This font keeps regular APL
      characters mostly intact (with an exception being making ○-based
      charcters larger)")
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
