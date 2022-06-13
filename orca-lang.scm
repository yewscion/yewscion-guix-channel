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
  #:use-module (gnu packages linux)
  #:use-module (guix gexp))
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
(license expat))))
orca-music
