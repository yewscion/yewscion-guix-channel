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

(define-public emacs-abc-mode
  (package
   (name "emacs-abc-mode")
   (version "20220713.1359")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/mkjunker/abc-mode.git")
                  (commit "45193b67508861cf77da7e76b71711855c002caa")))
            (sha256
             (base32
              "10i8wkzwngflfzbwmqv5gv6jzh5v5j7yh1364xdygg4xpnf7qdnv"))))
   (build-system emacs-build-system)
   (home-page "unspecified")
   (synopsis "Major mode for editing abc music files")
   (description
    "This package provides a major mode for editing abc music files.  Includes some
abc2midi features.  Written for Emacs version 21.  May or may not work with
previous versions.  See the Common Customizations section below.  Or run
`abc-customize'.  This package is stored at
https://github.com/mkjunker/abc-mode.")
   (license #f)))

(define-public emacs-i-ching
  (package
   (name "emacs-i-ching")
   (version "20220619.817")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/zzkt/i-ching.git")
                  (commit "54f19e2dcb1d16735b94fc7e06a2aa8b1b6f165a")))
            (sha256
             (base32
              "1y6jabsnkn1fa0czxbh6rz6fcm7557dg4w8nsp30makc2bly02cr"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-request))
   (home-page "https://github.com/zzkt/i-ching")
   (synopsis "The Book of Changes")
   (description
    "The I Ching or Book of Changes can be used as a divination method, pattern
generator or fixed point for millennia of commentary & exegesis.  This package
provides methods for casting and describing hexagrams, querying the oracle, and
finding patterns in randomness.  The descriptions of hexagrams and their
classification have been drawn from public domain sources, tradition and
antiquity.  Further details of usage along with reading & study material can be
found in the README file.")
   (license #f)))

(define-public emacs-ob-browser
  (package
   (name "emacs-ob-browser")
   (version "20170720.1918")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/krisajenkins/ob-browser.git")
                  (commit "a347d9df1c87b7eb660be8723982c7ad2563631a")))
            (sha256
             (base32
              "0q2amf2kh2gkn65132q9nvn87pws5mmnr3wm1ajk23c01kcjf29c"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-org))
   (arguments
    '(#:include '("^[^/]+.js$" "^[^/]+.el$")
      #:exclude '()))
   (home-page "https://github.com/krisajenkins/ob-browser")
   (synopsis "Render HTML in org-mode blocks.")
   (description "Render HTML in org-mode blocks.")
   (license #f)))

(define-public emacs-ob-elixir
  (package
   (name "emacs-ob-elixir")
   (version "20170725.1419")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/zweifisch/ob-elixir.git")
                  (commit "8990a8178b2f7bd93504a9ab136622aab6e82e32")))
            (sha256
             (base32
              "19awvfbjsnd5la14ad8cfd20pdwwlf3d2wxmz7kz6x6rf48x38za"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-org))
   (home-page "http://github.com/zweifisch/ob-elixir")
   (synopsis "org-babel functions for elixir evaluation")
   (description "org-babel functions for elixir evaluation")
   (license #f)))

(define-public emacs-ob-elm
  (package
   (name "emacs-ob-elm")
   (version "20200528.1857")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/BonfaceKilz/ob-elm.git")
                  (commit "d3a9fbc2f56416894c9aed65ea9a20cc1d98f15d")))
            (sha256
             (base32
              "1wdlr0cbsb2drdmcn2bnivjkj1f2v52l6yizwsnjgi4xq3w6k56h"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-org))
   (home-page "https://www.bonfacemunyoki.com")
   (synopsis "Org-babel functions for elm evaluation")
   (description
    "Org-Babel support for evaluating Elm code ; System Requirements: All you need is
Elm >= 0.19 installed on your system")
   (license #f)))

(define-public emacs-ob-elvish
  (package
   (name "emacs-ob-elvish")
   (version "20180427.1900")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/zzamboni/ob-elvish.git")
                  (commit "369181ceae1190bf971c71aebf9fc6133bd98c39")))
            (sha256
             (base32
              "170bw9qryhzjzmyi84qc1jkzy1y7i8sjz6vmvyfc264ia4j51m9w"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/zzamboni/ob-elvish")
   (synopsis "org-babel functions for Elvish shell")
   (description
    "Execute Elvish code inside org-mode src blocks. ; Requirements: - The Elvish
shell: https://elvish.io/ - The elvish-mode Emacs major mode:
https://github.com/ALSchwalm/elvish-mode")
   (license #f)))

(define-public emacs-ob-http
  (package
   (name "emacs-ob-http")
   (version "20180707.1448")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/zweifisch/ob-http.git")
                  (commit "b1428ea2a63bcb510e7382a1bf5fe82b19c104a7")))
            (sha256
             (base32
              "11fx9c94xxhl09nj9z5b5v6sm0xwkqawgjnnm7bg56vvj495n6h7"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-s))
   (home-page "http://github.com/zweifisch/ob-http")
   (synopsis "http request in org-mode babel")
   (description "http request in org-mode babel")
   (license #f)))

(define-public emacs-ob-lfe
  (package
   (name "emacs-ob-lfe")
   (version "20170725.1420")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/zweifisch/ob-lfe.git")
                  (commit "f7780f58e650b4d29dfd834c662b1d354b620a8e")))
            (sha256
             (base32
              "1ricvb2wxsmsd4jr0301pk30mswx41msy07fjgwhsq8dimxzmngp"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-org))
   (home-page "http://github.com/zweifisch/ob-lfe")
   (synopsis "org-babel functions for lfe evaluation")
   (description "org-babel functions for lfe evaluation")
   (license #f)))

(define-public emacs-ob-nim 
  (package
   (name "emacs-ob-nim")
   (version "20210601.1807")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/Lompik/ob-nim.git")
                  (commit "6fd060a3ecd38be37e4ec2261cd65760a3c35a91")))
            (sha256
             (base32
              "12sinii7i917v1f3czvmc0rrwk3ksr1ls7wv4yvv9f8jdkzr0msm"))))
   (build-system emacs-build-system)
   (home-page "unspecified")
   (synopsis "Babel Functions for nim")
   (description
    "Org-Babel support for evaluating nim code (based on ob-C).  very limited
implementation: - currently only support :results output - not much in the way
of error feedback")
   (license #f)))

(define-public emacs-ob-prolog 
  (package
   (name "emacs-ob-prolog")
   (version "20190410.2130")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/ljos/ob-prolog.git")
                  (commit "331899cfe345c934026c70b78352d320f7d8e239")))
            (sha256
             (base32
              "1k34cl2whc32ysd7anvz8ii66ljfrmkvx3cgb6i42jcx74kavlfr"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/ljos/ob-prolog")
   (synopsis "org-babel functions for prolog evaluation.")
   (description
    "Org-babel support for prolog.  To activate ob-prolog add the following to your
init.el file: (add-to-list load-path \"/path/to/ob-prolog-dir\")
(org-babel-do-load-languages org-babel-load-languages ((prolog .  t))) It is
unnecessary to add the directory to the load path if you install using the
package manager.  In addition to the normal header arguments ob-prolog also
supports the :goal argument. :goal is the goal that prolog will run when
executing the source block.  Prolog needs a goal to know what it is going to
execute.")
   (license #f)))

(define-public emacs-ob-rust 
  (package
   (name "emacs-ob-rust")
   (version "20220824.1923")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/micanzhang/ob-rust.git")
                  (commit "be059d231fafeb24a658db212a55ccdc55c0c500")))
            (sha256
             (base32
              "0r6ckhnyr824s4isz8z6hbd7ix9fyg9pha115km9pvafhcw05xdn"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/micanzhang/ob-rust")
   (synopsis "Org-babel functions for Rust")
   (description
    "Org-Babel support for evaluating rust code.  Much of this is modeled after
`ob-C'.  Just like the `ob-C', you can specify :flags headers when compiling
with the \"rust run\" command.  Unlike `ob-C', you can also specify :args which
can be a list of arguments to pass to the binary.  If you quote the value passed
into the list, it will use `ob-ref to find the reference data.  If you do not
include a main function or a package name, `ob-rust will provide it for you and
it's the only way to properly use very limited implementation: - currently only
support :results output. ; Requirements: - You must have rust and cargo
installed and the rust and cargo should be in your `exec-path rust command. -
rust-script - `rust-mode is also recommended for syntax highlighting and
formatting.  Not this particularly needs it, it just assumes you have it.")
   (license #f)))

(define-public emacs-org-chef 
  (package
   (name "emacs-org-chef")
   (version "20220422.300")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/Chobbes/org-chef.git")
                  (commit "6a786e77e67a715b3cd4f5128b59d501614928af")))
            (sha256
             (base32
              "0ik5akhsh9aji6n477i1jnk0wnljj7n1d0ybp8szgj2nr5258mhk"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-org))
   (home-page "https://github.com/Chobbes/org-chef")
   (synopsis "Cookbook and recipe management with org-mode.")
   (description
    "org-chef is a package for managing recipes in org-mode.  One of the main
features is that it can automatically extract recipes from websites like
allrecipes.com")
   (license #f)))

(define-public emacs-ox-gfm
  (package
   (name "emacs-ox-gfm")
   (version "20220910.1321")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/larstvei/ox-gfm.git")
                  (commit "46faa67dbb3fb0cd7a76c3fe518f16e4195c22c7")))
            (sha256
             (base32
              "0xiqxahxwaicxdi6apmdsrhvlyg63i9zr57l050f339p8x7id367"))))
   (build-system emacs-build-system)
   (home-page "unspecified")
   (synopsis "Github Flavored Markdown Back-End for Org Export Engine")
   (description
    "This library implements a Markdown back-end (github flavor) for Org exporter,
based on the `md back-end.")
   (license #f)))
(define-public emacs-zetteldeft
  (package
   (name "emacs-zetteldeft")
   (version "20221006.9f0927")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/EFLS/zetteldeft.git")
                  (commit "63be6478751376f04d36c6ea52fe65acd69f0927")))
            (sha256
             (base32
              "0sjzszdlw2mplfh0c9qgsc1hi95hwr420vwaz6gh5vbxcmfy4qzm"))))
   (build-system emacs-build-system)
   (home-page "https://www.eliasstorms.net/zetteldeft/")
   (propagated-inputs (list emacs-ace-window
                            emacs-deft))
   (synopsis "Zettelkasten for Emacs")
   (description
    "Zetteldeft is an extension of the Deft package for Emacs. Building on Deft’s
search functionality, Zetteldeft provides a way to create and manage links
between short notes.")
   (license license:gpl3)))

(define-public emacs-v-mode
  (package
  (name "emacs-v-mode")
  (version "20221007.635")
  (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/damon-kwok/v-mode.git")
                  (commit "84f26ab0f0f5b23133292674da9fa4558207c33d")))
            (sha256
             (base32
              "10kr5ga8l3061nj4y6qciy0v4mkfvv9mav3i5cl1sz6b6h8kdp66"))))
  (build-system emacs-build-system)
  (propagated-inputs (list emacs-dash emacs-hydra))
  (home-page "https://github.com/damon-kwok/v-mode")
  (synopsis "A major mode for the V programming language")
  (description
   "Description: This is a major mode for the V programming language For more
details, see the project page at https://github.com/damon-kwok/v-mode
Installation: The simple way is to use package.el: M-x package-install v-mode
Or, copy v-mode.el to some location in your Emacs load path.  Then add \"(require
v-mode)\" to your Emacs initialization (.emacs, init.el, or something).  Example
config: (require v-mode)")
  (license license:gpl3)))

(define-public emacs-elisp-autofmt
  (package
   (name "emacs-elisp-autofmt")
   (version "20230131.1219")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://melpa.org/packages/elisp-autofmt-"
                                version ".tar"))
            (sha256
             (base32
              "0mg8cdp31w6p19b6ahc9nv8nhd29b3r0sjwayvim2hb7aiyfm54h"))))
   (build-system emacs-build-system)
   (home-page "https://codeberg.org/ideasman42/emacs-elisp-autofmt")
   (synopsis "Emacs lisp auto-format")
   (description
    "Auto format emacs-lisp code on save. ; Usage (elisp-autofmt-buffer) ;
Auto-format the current buffer.  You may also use the minor mode
`elisp-autofmt-mode which enables formatting the buffer on save.")
   (license #f)))
