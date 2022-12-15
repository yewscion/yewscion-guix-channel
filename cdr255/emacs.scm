(define-module (cdr255 emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz))

(define-public emacs-leetcode
  (let* ((tag "0")
         (revision "1")
         (commit "f12421eeb9cfd5e7c223ab5190026fc6972a4cc7")
         (hash "1hk0vs8yzxrpch7cab16kv5jrmdiq0p74j4vc8awf53j4mmqid85")
         (version (git-version tag revision commit)))
    (package
      (name "emacs-leetcode")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/yewscion/leetcode-emacs.git")
                      (commit commit)))
                (sha256 (base32 hash))
                (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-names emacs-ctable))
      (synopsis "Solve and submit LeetCode problems from within Emacs")
      (description "This package provides an Emacs interface to LeetCode
allowing users to log in and solve problems of their choice using Emacs.")
      (home-page "https://github.com/yewscion/leetcode-emacs.git")
      (license license:unlicense))))
(define-public emacs-bqn-mode
  (let* ((tag "0")
         (revision "1")
         (commit "035f7731e0ca6c11bc3e7552809424e9773368ef"))
    (package
      (name "emacs-bqn-mode")
      (version (git-version tag revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/yewscion/bqn-mode.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256 (base32 "1lzizakf6rami85lvxkk3csl1qawv9g4lvmq1dd540nrppj72i2l"))))
      (outputs '("out"))
      (build-system emacs-build-system)
      (synopsis "Major Mode for BQN")
      (description "The official major mode for the BQN language in Emacs.
Derived from gnu-apl-mode.")
      (home-page "https://mlochbaum.github.io/BQN/editors/index.html")
      (license license:gpl3))))
(define-public emacs-gnu-apl-mode
  (package
    (name "emacs-gnu-apl-mode")
    (version "20220404.341")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/lokedhs/gnu-apl-mode.git")
                    (commit "c8695b0d55b5167263a843252ffd21a589018427")))
              (sha256
               (base32
                "03hwnzzxn5d1wdw93dgznflsx9m9hb133gv54pbrij2454pkvm4g"))))
    (build-system emacs-build-system)
    (home-page "http://www.gnu.org/software/apl/")
    (synopsis "Integrate GNU APL with Emacs")
    (description
     "Emacs mode for GNU APL

This mode provides both normal editing facilities for APL code as well as an
interactive mode.  The interactive mode is started using the command ‘gnu-apl’.

The mode provides two different ways to input APL symbols.  The first method is
enabled by default, and simply binds keys with the \"super\" modifier.  The
problem with this method is that the \"super\" modifier has to be enabled, and any
shortcuts added by the operating system that uses this key has to be changed.

The other method is a bit more cumbersome to use, but it's pretty much
guaranteed to work everywhere.  Simply enable the input mode using C-\\
(‘toggle-input-method’) and choose APL-Z.  Once this mode is enabled, press \".\"
(period) followed by a letter to generate the corresponding symbol.")
    (license license:gpl3)))
(define-public emacs-ogham-input
  (let ((commit "d57671872a2c221723c7f9346d809976ff914351")
        (revision "1"))
    (package
     (name "emacs-ogham-input")
     (version (git-version "0.0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/emacs-ogham-input")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0krj9fncvisa8ywxsc5mr707ac24lx55g33jybpj71dp7q9c8acm"))))
     (build-system emacs-build-system)
     (synopsis "Emacs input method for Ogham")
     (description
      (string-append
       "A quail-based input method for the Ogham script (beith-luis-nion)."))
     (home-page
      "https://git.sr.ht/~yewscion/emacs-ogham-input")
     (license license:agpl3+))))

(define-public emacs-persistent-scratch
  (package
    (name "emacs-persistent-scratch")
    (version "20220620.408")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Fanael/persistent-scratch.git")
                    (commit "92f540e7d310ec2e0b636eff1033cf78f0d9eb40")))
              (sha256
               (base32
                "1hl4xac1zsvpbibahp54phf1b1srhnm2nh30vzmh96aynnf38vqd"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/Fanael/persistent-scratch")
    (synopsis "Preserve the scratch buffer across Emacs sessions")
    (description
     "Preserve the state of scratch buffers across Emacs sessions by saving the state
to and restoring it from a file, with autosaving and backups.  Save scratch
buffers: `persistent-scratch-save and `persistent-scratch-save-to-file'.
Restore saved state: `persistent-scratch-restore and
`persistent-scratch-restore-from-file'.  To control where the state is saved,
set `persistent-scratch-save-file'.  What exactly is saved is determined by
`persistent-scratch-what-to-save'.  What buffers are considered scratch buffers
is determined by `persistent-scratch-scratch-buffer-p-function'.  By default,
only the `*scratch* buffer is a scratch buffer.  Autosave can be enabled by
turning `persistent-scratch-autosave-mode on.  Backups of old saved states are
off by default, set `persistent-scratch-backup-directory to a directory to
enable them.  To both enable autosave and restore the last saved state on Emacs
start, add (persistent-scratch-setup-default) to the init file.  This will NOT
error when the save file doesn't exist.  To just restore on Emacs start, it's a
good idea to call `persistent-scratch-restore inside an `ignore-errors or
`with-demoted-errors block.")
    (license license:bsd-2)))

