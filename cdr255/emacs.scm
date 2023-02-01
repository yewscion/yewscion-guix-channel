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
   (license license:gpl3)))

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
   (license license:gpl3)))

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
   (license license:gpl3+)))

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
   (license license:gpl3)))

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
   (license license:gpl3)))

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
   (license license:expat)))

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
   (license license:gpl3)))

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
   (license license:gpl3)))

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
   (license license:lgpl2.1)))

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
   (license license:gpl3+)))

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
   (license license:gpl3+)))

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
   (license license:expat)))

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
   (license license:gpl3+)))

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
   (license license:gpl3)))

(define-public emacs-bnf-mode
  (package
   (name "emacs-bnf-mode")
   (version "20221205.1451")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/sergeyklay/bnf-mode.git")
                  (commit "1a7e177c282b8e07a2c33bd89232464b347dfc17")))
            (sha256
             (base32
              "1r23hrl258v7r0y785p2jrjz0y0bpd4lpl9ji91pqzrm6amvbkn4"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/sergeyklay/bnf-mode")
   (synopsis "Major mode for editing BNF grammars.")
   (description
    "BNF Mode is a GNU Emacs major mode for editing BNF grammars.  Presently it
provides basic syntax and font-locking for BNF files.  BNF notation is supported
exactly form as it was first announced in the ALGOL 60 report.")
   (license license:gpl3)))

(define-public emacs-bnfc
  (package
   (name "emacs-bnfc")
   (version "20160605.1927")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/jmitchell/bnfc-mode.git")
                  (commit "1b58df1dd0cb9b81900632fb2843a03b94f56fdb")))
            (sha256
             (base32
              "0lmqrcy80nw6vmf81kh6q39x8pwhzrj6lbk31xpl8mvwnpqaykmn"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/jmitchell/bnfc-mode")
   (synopsis "Define context-free grammars for the BNFC tool")
   (description
    "bnfc-mode simplifies editing BNFC input files in Emacs.  BNFC is a handy tool
for converting context-free grammars into parsers, syntax highlighters, and
documentation.")
   (license license:gpl2+)))

(define-public emacs-bongo
  (package
   (name "emacs-bongo")
   (version "20201002.1020")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/dbrock/bongo.git")
                  (commit "9e9629090262bba6d0003dabe5a375e47a4477f1")))
            (sha256
             (base32
              "1ayiqj8zc15kf3211asgc4hl7zv78y6n6m6rsb9svysak5srr3wy"))))
   (build-system emacs-build-system)
   (arguments
    '(#:include '("^[^/]+.el$" "^[^/]+.texi$" "^images$" "^[^/]+.rb$")
      #:exclude '()))
   (home-page "unspecified")
   (synopsis "play music with Emacs")
   (description
    "Bongo is a flexible and usable media player for GNU Emacs.  For detailed
documentation see the projects README file at https://github.com/dbrock/bongo/")
   (license license:gpl2+)))

(define-public emacs-company-c-headers
  (package
   (name "emacs-company-c-headers")
   (version "20190825.1631")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/randomphrase/company-c-headers.git")
                  (commit "9d384571b1190e99d0a789e5296176d69a3d0771")))
            (sha256
             (base32
              "149sbw2pmfwn52jrhavrnc16rkjz09g5kl9acl973k764mf215l0"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company))
   (home-page "unspecified")
   (synopsis "Company mode backend for C/C++ header files")
   (description
    "This library enables the completion of C/C++ header file names using Company.
To initialize it, just add it to `company-backends': (add-to-list
company-backends company-c-headers) When you type an #include declaration within
a supported major mode (see `company-c-headers-modes'), company-c-headers will
search for header files within predefined search paths.  company-c-headers can
search \"system\" and \"user\" paths, depending on the type of #include declaration
you type.  You will probably want to customize the `company-c-headers-path-user
and `company-c-headers-path-system variables for your specific needs.")
   (license license:gpl2+)))

(define-public emacs-company-ipa
  (package
   (name "emacs-company-ipa")
   (version "20210307.1838")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/mguzmann89/company-ipa.git")
                  (commit "8634021cac885f53f3274ef6dcce7eab19321046")))
            (sha256
             (base32
              "0629my156zxjb3h636iirdd2rr58z3vsdinhq0w0y6f3544i05hx"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company))
   (home-page "https://github.com/mguzmann/company-ipa")
   (synopsis "IPA backend for company")
   (description
    "This package adds an easy way of inserting IPA (International Phonetic Alphabet)
into a document Usage ===== To install clone this package directly and load it
(load-file \"PATH/company-ipa.el\") To activate: (add-to-list company-backends
company-ipa-symbols-unicode) To use: type ~pp and you should get completions To
change the prefix, execute: (company-ipa-set-trigger-prefix \"¬\") For best
performance you should use this with company-flx: (company-flx-mode +1)")
   (license license:gpl3)))

(define-public emacs-company-ledger
  (package
   (name "emacs-company-ledger")
   (version "20210910.250")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/debanjum/company-ledger.git")
                  (commit "c6911b7e39b29c0d5f2541392ff485b0f53fd366")))
            (sha256
             (base32
              "08g4f8w9lhfypy4m3vcfg8d8gqn7w2g8qjksl7bzcnwg2d0yqld8"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company))
   (home-page "https://github.com/debanjum/company-ledger")
   (synopsis "Fuzzy auto-completion for Ledger & friends")
   (description
    "`company-mode backend for `ledger-mode', `beancount-mode and similar plain-text
accounting modes.  Provides fuzzy completion for transactions, prices and other
date prefixed entries.  See Readme for detailed setup and usage description.
Detailed Description -------------------- - Provides auto-completion based on
words on current line - The words on the current line can be partial and in any
order - The candidate entities are reverse sorted by location in file -
Candidates are paragraphs starting with YYYY[-/]MM[-/]DD Minimal Setup
------------- (with-eval-after-load company (add-to-list company-backends
company-ledger)) Use-Package Setup ----------------- (use-package company-ledger
:ensure company :init (with-eval-after-load company (add-to-list
company-backends company-ledger)))")
   (license license:gpl3)))

(define-public emacs-company-org-block
  (package
   (name "emacs-company-org-block")
   (version "20230115.1202")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/xenodium/company-org-block.git")
                  (commit "aee601a2bfcc86d26e762eeb84e5e42573f8c5ca")))
            (sha256
             (base32
              "0zghjkny222wxkyr48njpwjkwk7gfrjm6n70drkwmjhhh88646fv"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company emacs-org))
   (home-page "https://github.com/xenodium/company-org-block")
   (synopsis "Org blocks company backend")
   (description
    "`company-complete org blocks using \"<\" as a trigger.  To enable, add
`company-org-block to `company-backends'.  Configure edit style via
`company-org-block-edit-style'.  Completion candidates are drawn from
`org-babel-load-languages'.")
   (license license:gpl3)))

(define-public emacs-company-plisp
  (package
   (name "emacs-company-plisp")
   (version "20200531.1927")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/sasanidas/company-plisp.git")
                  (commit "fc0b56d2a711340ca3e63119bfe692bb3e8620fb")))
            (sha256
             (base32
              "0xw475spfwq32nn5qz3gk22cggj1f5y245da9030vzi2jfb9vvid"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-s emacs-company emacs-dash))
   (arguments
    '(#:include '("^company-plisp.el$" "^company-plisp.l$")
      #:exclude '()))
   (home-page "https://gitlab.com/sasanidas/company-plisp")
   (synopsis "Company mode backend for PicoLisp language")
   (description
    "Backend for company mode for the PicoLisp programming language")
   (license license:gpl3)))

(define-public emacs-company-quickhelp-terminal
  (package
   (name "emacs-company-quickhelp-terminal")
   (version "20220704.647")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url
                   "https://github.com/jcs-legacy/company-quickhelp-terminal.git")
                  (commit "5c0d59d965056f3a32ee571057aeecd00678ef48")))
            (sha256
             (base32
              "1vdk55pkvmib8wr3iamrx3n7zrhmcia9hc35k25ccmbaqw2n6av1"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company-quickhelp emacs-popup))
   (home-page "https://github.com/jcs-elpa/company-quickhelp-terminal")
   (synopsis "Terminal support for `company-quickhelp'")
   (description "Terminal support for `company-quickhelp'.")
   (license license:gpl3)))

(define-public emacs-company-web
  (package
   (name "emacs-company-web")
   (version "20220115.2146")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/osv/company-web.git")
                  (commit "863fb84b81ed283474e50330cd8d27b1ca0d74f1")))
            (sha256
             (base32
              "0awl7b6p4vrxv0cy5xcxwihqzgk7kk6l7jsivyrj8s0f5jv2q71v"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company emacs-dash emacs-web-completion-data))
   (home-page "https://github.com/osv/company-web")
   (synopsis
    "Company version of ac-html, complete for web,html,emmet,jade,slim modes")
   (description
    "Same as ac-html, but for `company completion framework.  Configuration:
(add-to-list company-backends company-web-html) (add-to-list company-backends
company-web-jade) (add-to-list company-backends company-web-slim) or, for
example, setup web-mode-hook: (define-key web-mode-map (kbd \"C-'\")
company-web-html) (add-hook web-mode-hook (lambda () (set (make-local-variable
company-backends) (company-web-html company-files)) (company-mode t))) When you
use `emmet-mode (with `web-mode and `html-mode') you may autocomplete as well as
regular html complete.  P.S: You may be interested in next packages:
`ac-html-bootstrap - Twitter:Bootstrap completion data for company-web (and
ac-html as well) `ac-html-csswatcher - Watch your project CSS/Less files for
classes and ids `ac-html-angular - Angular 1.5 completion data;")
   (license license:gpl3)))

(define-public emacs-company-wordfreq
  (package
   (name "emacs-company-wordfreq")
   (version "20220405.2000")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url
                   "https://github.com/johannes-mueller/company-wordfreq.el.git")
                  (commit "83569cf346c2320ef22f6a858e3424f771c4324e")))
            (sha256
             (base32
              "1rmv8985adf1vibs070fnzzjnbxaj0qgwjyqmnd5v7v020rkpmrc"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-company))
   (home-page "https://github.com/johannes-mueller/company-wordfreq.el")
   (synopsis "Company backend for human language texts")
   (description
    "`company-wordfreq is a company backend intended for writing texts in a human
language.  The completions it proposes are words already used in the current (or
another open) buffer and matching words from a word list file.  This word list
file is supposed to be a simple list of words ordered by the frequency the words
are used in the language.  So the first completions are words already used in
the buffer followed by matching words of the language ordered by frequency.
`company-wordfreq does not come with the word list files directly, but it can
download the files for you for many languages from
<https://github.com/hermitdave/FrequencyWords>.  I made a fork of that repo just
in case the original changes all over sudden without my noticing.  The directory
where the word list files reside is determined by the variable
`company-wordfreq-path', default `~/.emacs.d/wordfreq-dicts'.  Their names must
follow the pattern `<language>.txt where language is the
`ispell-local-dictionary value of the current language.  You need =grep= in your
=$PATH= as =company-wordfreq= uses it to grep into the word list files.  Should
be the case by default on any UNIX like systems.  On windows you might have to
tweak it somehow. `company-wordfreq is supposed to be the one and only company
backend and `company-mode should not transform or sort its candidates.  This can
be achieved by setting the variables `company-backends and `company-transformers
buffer locally in `text-mode buffers by (add-hook text-mode-hook (lambda ()
(setq-local company-backends (company-wordfreq)) (setq-local
company-transformers nil))) Usually you don't need to configure the language
picked to get the word completions. `company-wordfreq uses the variable
`ispell-local-dictionary'.  It should work dynamically even if you use
`auto-dictionary-mode'.  To download a word list use M-x
company-wordfreq-download-list You are presented a list of languages to choose.
For some languages the word lists are huge, which can lead to noticeable latency
when the completions are build.  Therefore you are asked if you want to use a
word list with only the 50k most frequent words.  The file will then be
downloaded, processed and put in place.")
   (license license:gpl3)))

(define-public emacs-docstr
  (package
   (name "emacs-docstr")
   (version "20221231.1701")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/emacs-vs/docstr.git")
                  (commit "68a72e8a9abac28d8451769cab3846c342f657bc")))
            (sha256
             (base32
              "1rdl0hqif6awkyv6wsmpdk08hx7g851n19rzqchcpksdfq8dk7nr"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-s))
   (arguments
    '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                  "^dir$"
                  "^[^/]+.info$"
                  "^[^/]+.texi$"
                  "^[^/]+.texinfo$"
                  "^doc/dir$"
                  "^doc/[^/]+.info$"
                  "^doc/[^/]+.texi$"
                  "^doc/[^/]+.texinfo$"
                  "^langs/[^/]+.el$")
      #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                  "^[^/]+-tests.el$")))
   (home-page "https://github.com/emacs-vs/docstr")
   (synopsis "A document string minor mode")
   (description
    "This package provides a simple solution to insert document string into the code.")
   (license license:gpl3)))

(define-public emacs-easy-kill
  (package
   (name "emacs-easy-kill")
   (version "20220511.557")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/leoliu/easy-kill.git")
                  (commit "de7d66c3c864a4722a973ee9bc228a14be49ba0c")))
            (sha256
             (base32
              "0zr836c9c5bhf0cslwk6jqf1xn9w6wfjn4faisq5v8ydyxn78925"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/leoliu/easy-kill")
   (synopsis "kill & mark things easily")
   (description
    "`easy-kill aims to be a drop-in replacement for `kill-ring-save'.  To use:
(global-set-key [remap kill-ring-save] #'easy-kill) `easy-mark is similar to
`easy-kill but marks the region immediately.  It can be a handy replacement for
`mark-sexp allowing `+'/`- to do list-wise expanding/shrinking.  To use:
(global-set-key [remap mark-sexp] #'easy-mark) Please send bug reports or
feature requests to: https://github.com/leoliu/easy-kill/issues")
   (license license:gpl3)))

(define-public emacs-easy-kill-extras
  (package
   (name "emacs-easy-kill-extras")
   (version "20210529.945")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/knu/easy-kill-extras.el.git")
                  (commit "74e9d0fcafc38d5f24e6209671a552bc1ba5a867")))
            (sha256
             (base32
              "0yxfsp4zzzw9v4swgslsr4v35hs04sczskfyfdvw8wk0aahxcwrx"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-easy-kill))
   (home-page "https://github.com/knu/easy-kill-extras.el")
   (synopsis "Extra functions for easy-kill.")
   (description
    "This package contains extra functions for easy-kill/easy-mark: * easy-mark-word
* easy-mark-sexp * easy-mark-to-char * easy-mark-up-to-char These are shorthand
commands for easy-marking an aimed string at point. * easy-kill-er-expand *
easy-kill-er-unexpand These work like `er/expand-region and
`er/contract-region', respectively, using the functionality of the
`expand-region package.  It also provides the following easy-kill/easy-mark
targets: * `buffer This selects the whole buffer. * `buffer-before-point *
`buffer-after-point These work like vi's gg/G commands, respectively. *
`backward-line-edge * `forward-line-edge The former is like vi's ^/0 commands,
and the latter is just like that in the opposite direction. *
`string-to-char-forward * `string-to-char-backward * `string-up-to-char-forward
* `string-up-to-char-backward These work like vi's f/F/t/T commands,
respectively.  Experimental ace-jump integration into easy-kill is enabled by
default. `ace-jump-*-mode can be invoked for selection when in
easy-kill/easy-mark mode.  You can disable this feature via a customize variable
`easy-kill-ace-jump-enable-p'.  Experimental multiple-cursors-mode support for
easy-kill is enabled by default. `easy-kill and `easy-mark will mostly work in
`multiple-cursors-mode'.  Suggested settings are as follows: ;; Upgrade
`mark-word and `mark-sexp with easy-mark ;; equivalents. (global-set-key (kbd
\"M-@@\") easy-mark-word) (global-set-key (kbd \"C-M-@@\") easy-mark-sexp) ;;
`easy-mark-to-char or `easy-mark-up-to-char could be a good ;; replacement for
`zap-to-char'. (global-set-key [remap zap-to-char] easy-mark-to-char) ;;
Integrate `expand-region functionality with easy-kill (define-key
easy-kill-base-map (kbd \"o\") easy-kill-er-expand) (define-key easy-kill-base-map
(kbd \"i\") easy-kill-er-unexpand) ;; Add the following tuples to
`easy-kill-alist', preferrably by ;; using `customize-variable'. (add-to-list
easy-kill-alist (?^ backward-line-edge \"\")) (add-to-list easy-kill-alist (?$
forward-line-edge \"\")) (add-to-list easy-kill-alist (?b buffer \"\")) (add-to-list
easy-kill-alist (?< buffer-before-point \"\")) (add-to-list easy-kill-alist (?>
buffer-after-point \"\")) (add-to-list easy-kill-alist (?f string-to-char-forward
\"\")) (add-to-list easy-kill-alist (?F string-up-to-char-forward \"\"))
(add-to-list easy-kill-alist (?t string-to-char-backward \"\")) (add-to-list
easy-kill-alist (?T string-up-to-char-backward \"\"))")
   (license license:bsd-2)))

(define-public emacs-elixir-mode
  (package
    (name "emacs-elixir-mode")
    (version "20221017.2044")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/elixir-editors/emacs-elixir.git")
                    (commit "4974ff9a83daf50f2f03dc0d6d00871296e088b0")))
              (sha256
               (base32
                "1cc8qmfiz6azm7ly22cjhv7mmf5crmnfk3gx6315h0lz6rqh2885"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/elixir-editors/emacs-elixir")
    (synopsis "Major mode for editing Elixir files")
    (description
     "This package provides font-locking, indentation and navigation support for the
Elixir programming language.")
    (license license:gpl3)))

(define-public emacs-emojify-logos
  (package
    (name "emacs-emojify-logos")
    (version "20180814.917")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mxgoldstein/emojify-logos.git")
                    (commit "a3e78bcbdf863092d4c9b026ac08bf7d1c7c0e8b")))
              (sha256
               (base32
                "1fhxf3nky9wlcn54q60f9254iawcccsrxw370q7cgpsrl1gj3dgp"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-emojify))
    (arguments
     '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                   "^dir$"
                   "^[^/]+.info$"
                   "^[^/]+.texi$"
                   "^[^/]+.texinfo$"
                   "^doc/dir$"
                   "^doc/[^/]+.info$"
                   "^doc/[^/]+.texi$"
                   "^doc/[^/]+.texinfo$"
                   "^logos$")
       #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                   "^[^/]+-tests.el$")))
    (home-page "https://github.com/mxgoldstein/emojify-logos")
    (synopsis "Add logos to emojify")
    (description
     "This package adds logo icons for various programming languages and tools to
emojify.el All icons are the property of their respective owners and may be
trademarked and/or restricted in the way they may be used.  See COPYRIGHT.MD for
more details. ; TODO Add more logos for languages / modes etc.  Replace
low-quality C icon Find a (somewhat) free icon for java")
    (license (list license:gpl3
                   license:expat
                   license:cc0
                   license:cc-by3.0
                   license:gpl3+
                   license:public-domain
                   license:gpl2+
                   license:perl-license
                   ;; PHP, Python, and C++ all have custom licenses that do
                   ;; not prohibit use, but may need to be removed for FSDG
                   ;; purposes.
                   license:cc-by-sa3.0))))

(define-public emacs-eterm-256color
  (package
    (name "emacs-eterm-256color")
    (version "20210224.2241")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dieggsy/eterm-256color.git")
                    (commit "c9cfccef03e730f7ab2b407aada3df15ace1fe32")))
              (sha256
               (base32
                "1ip1mcry2mryr3gzina16c7m2pw71klx1ldbfv8w7rv8fsx2dsma"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-xterm-color emacs-f))
    (arguments
     '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                   "^dir$"
                   "^[^/]+.info$"
                   "^[^/]+.texi$"
                   "^[^/]+.texinfo$"
                   "^doc/dir$"
                   "^doc/[^/]+.info$"
                   "^doc/[^/]+.texi$"
                   "^doc/[^/]+.texinfo$"
                   "^eterm-256color.ti$")
       #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                   "^[^/]+-tests.el$")))
    (home-page "http://github.com/dieggsy/eterm-256color")
    (synopsis "Customizable 256 colors for term.")
    (description
     "Adds 256 color handling to term/ansi-term by adding 247 customizable faces to
ansi-term-color-vector and overriding term-handle-colors-array to handle
additional escape sequences.")
    (license license:gpl3)))

(define-public emacs-free-keys
  (package
    (name "emacs-free-keys")
    (version "20211116.1501")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Fuco1/free-keys.git")
                    (commit "7348ce68192871b8a69b687ec124d9f816d493ca")))
              (sha256
               (base32
                "0f99vykxvvcsdqs03ig5kyd3vdrclk8mcryn7b310ysg840ksrw8"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/Fuco1/free-keys")
    (synopsis "Show free keybindings for modkeys or prefixes")
    (description
     "Show free keybindings for modkeys or prefixes.  Based on code located here:
https://gist.github.com/bjorne/3796607 For complete description see
https://github.com/Fuco1/free-keys")
    (license license:gpl3)))

(define-public emacs-gameoflife
  (package
    (name "emacs-gameoflife")
    (version "20200614.1814")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Lindydancer/gameoflife.git")
                    (commit "2483f3d98dbcf7f1633f551cc3691f5659b4b942")))
              (sha256
               (base32
                "1a57fc8ylrdlqlywp81b71jd93hiwkxy6gxpi8358d6d4czslvq7"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/Lindydancer/gameoflife")
    (synopsis "Screensaver running Conway's Game of Life")
    (description
     "Run Conway's Game of Life, in all windows, using the original window content as
seed.  In addition, when performing the animation, the original characters and
the colors they have, are retained, resulting is a much more living result than
when simply using, say, stars.  By \"seed\", it means that the original content of
the windows are seen as dots in the plane.  All non-blank characters are seen as
live dots.  The Game of Life animation can be started as a screensaver, so that
it starts automatically when Emacs has been idle for a while.  By default, it
stops after 1000 generations.  Screenshot: ![See doc/GameOfLifeDemo.gif for
screenshot](doc/GameOfLifeDemo.gif) Usage: `gameoflife-animate -- Start the Game
of Life animation. `gameoflife-screensaver-mode -- Run as a screensaver.  The
animation is started when Emacs has been idle for a while.  About Conway's Game
of Life: Conway's Game of Life is a simple simulation, originally developed in
1970, taking place in a two-dimentional grid -- think of it as an infinite chess
board.  A square can either be dead or alive.  In each step in the simulation,
the following rule applies: - A live square stays alive only if it has two or
three neighbours. - A dead square is resurrected if it has exactly three
neighburs.  Personal reflection: I have noticed that sparse programming
languages with a lot of highlighting, like C and C++, produde the most beautiful
animations.  More dense programming languages, like elisp, tend to \"kill\" many
squares in the first generation, making them less suited for Game of Life seeds.")
    (license license:gpl3)))

(define-public emacs-gemini-mode
  (package
    (name "emacs-gemini-mode")
    (version "20221127.1619")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.carcosa.net/jmcbray/gemini.el.git")
                    (commit "a7dd7c6ea4e036d0d5ecc4a5d284874c400f10ba")))
              (sha256
               (base32
                "1pvlk56mhh4xh4gwzqldfk79jsjbcpivv5scd9811pv3afc30gsx"))))
    (build-system emacs-build-system)
    (home-page "https://git.carcosa.net/jmcbray/gemini.el")
    (synopsis "A simple highlighting package for text/gemini")
    (description
     "This package provides a major mode for editing text/gemini files.  Currently, it
only provides syntax-highlighting support.  This file is not part of GNU Emacs.
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.  This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
for more details.  You should have received a copy of the GNU Affero General
Public License along with this program.  If not, see
<https://www.gnu.org/licenses/>.")
    (license license:gpl3)))

(define-public emacs-gnuplot-mode
  (package
    (name "emacs-gnuplot-mode")
    (version "20171013.1616")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mkmcc/gnuplot-mode.git")
                    (commit "601f6392986f0cba332c87678d31ae0d0a496ce7")))
              (sha256
               (base32
                "14f0yh1rjqc3337j4sbqzfb7pjim2c8a7wk1a73xkrdkmjn82vgb"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/mkmcc/gnuplot-mode")
    (synopsis "Major mode for editing gnuplot scripts")
    (description
     "Defines a major mode for editing gnuplot scripts.  I wanted to keep it simpler
than other modes -- just syntax highlighting, indentation, and a command to plot
the file.  Some of this code is adapted from a more full-featured version by
Bruce Ravel (available here https://github.com/bruceravel/gnuplot-mode; GPLv2).
Thanks to everyone, including Christopher Gilbreth and Ralph Möritz, for sending
suggestions, improvements, and fixes. ; Installation: Use package.el.  You'll
need to add MELPA to your archives: (require package) (add-to-list
package-archives (\"melpa\" . \"https://melpa.org/packages/\") t) Alternatively, you
can just save this file and do the standard (add-to-list load-path
\"/path/to/gnuplot-mode.el\") ; Configuration: If you installed this via
`package.el', you should take advantage of autoloading.  You can customize
features using `defvar and `eval-after-load', as illustrated below: ;; specify
the gnuplot executable (if other than \"gnuplot\") (defvar gnuplot-program
\"/sw/bin/gnuplot\") ;; set gnuplot arguments (if other than \"-persist\") (defvar
gnuplot-flags \"-persist -pointsize 2\") ;; if you want, add a mode hook.  e.g.,
the following turns on ;; spell-checking for strings and comments and
automatically cleans ;; up whitespace on save. (eval-after-load gnuplot-mode
(add-hook gnuplot-mode-hook (lambda () (flyspell-prog-mode) (add-hook
before-save-hook whitespace-cleanup nil t)))) If you installed this file
manually, you probably don't want to muck around with autoload commands.
Instead, add something like the following to your .emacs: (require gnuplot-mode)
;; specify the gnuplot executable (if other than \"gnuplot\") (setq
gnuplot-program \"/sw/bin/gnuplot\") ;; set gnuplot arguments (if other than
\"-persist\") (setq gnuplot-flags \"-persist -pointsize 2\") ;; if you want, add a
mode hook.  e.g., the following turns on ;; spell-checking for strings and
comments and automatically cleans ;; up whitespace on save. (add-hook
gnuplot-mode-hook (lambda () (flyspell-prog-mode) (add-hook before-save-hook
whitespace-cleanup nil t)))")
    (license license:gpl3)))

(define-public emacs-guix
  (package
    (name "emacs-guix")
    (version "20221011.1244")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.savannah.gnu.org/git/guix/emacs-guix.git")
                    (commit "cf5b7a402ea503c3dcda85a86b9a6c6dd01896e0")))
              (sha256
               (base32
                "0wxiipgv91rlk9bhspx370rykywi52rxg5m1f7680vzs3ckc7nyd"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-dash emacs-geiser emacs-bui emacs-magit-popup
                             emacs-edit-indirect))
    (arguments
     '(#:include '("^elisp/[^/]+.el$" "^doc/[^/]+.texi$")
       #:exclude '("^scheme/Makefile.am$")))
    (home-page "https://emacs-guix.gitlab.io/website/")
    (synopsis "Interface for GNU Guix")
    (description
     "Emacs-Guix (aka \"guix.el\") provides featureful visual interface for the GNU Guix
package manager.  It allows you: - to search for packages and to look at their
code (package recipes); - to manage your Guix profile(s) by installing/removing
packages; - to look at, compare and remove profile generations; - to look at
system services and generations (if you use Guix System); - to do many other
things.  Run \"M-x guix-help\" to look at the summary of available commands.")
    (license license:gpl3)))

(define-public emacs-guru-mode
  (package
    (name "emacs-guru-mode")
    (version "20211025.1157")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/bbatsov/guru-mode.git")
                    (commit "a3370e547eab260d24774cd50ccbe865373c8631")))
              (sha256
               (base32
                "0h7d41l7rybljpb49hvkh14kc7bnh56rfrqzldpdry1qk3mr9bhj"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/bbatsov/guru-mode")
    (synopsis "Become an Emacs guru")
    (description
     "Guru mode teaches you how to use Emacs effectively.  In particular it promotes
the use of idiomatic keybindings for essential editing commands.  It can be
configured to either disallow the alternative keybindings completely or to warn
when they are being used.")
    (license license:gpl3)))

(define-public emacs-haskell-mode
  (package
    (name "emacs-haskell-mode")
    (version "20221113.1425")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/haskell/haskell-mode.git")
                    (commit "a34ccdc54be15043ff0d253c3c20087524255491")))
              (sha256
               (base32
                "1z2jcgdm5bc13zwl4y7fn5rxqqzs3i54qw32wb2hwpa42izwq159"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                   "^dir$"
                   "^[^/]+.info$"
                   "^[^/]+.texi$"
                   "^[^/]+.texinfo$"
                   "^doc/dir$"
                   "^doc/[^/]+.info$"
                   "^doc/[^/]+.texi$"
                   "^doc/[^/]+.texinfo$"
                   "^NEWS$"
                   "^logo.svg$")
       #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                   "^[^/]+-tests.el$")))
    (home-page "https://github.com/haskell/haskell-mode")
    (synopsis "A Haskell editing mode")
    (description
     "This package provides a major mode for editing Haskell (the functional
programming language, see URL `http://www.haskell.org') in Emacs.  Some of its
major features include: - syntax highlighting (font lock), - automatic
indentation, - on-the-fly documentation, - interaction with inferior GHCi/Hugs
instance, - scans declarations and places them in a menu.  See URL
`https://github.com/haskell/haskell-mode and/or Info node
`(haskell-mode)Introduction for more information.  Use `M-x
haskell-mode-view-news` (after Haskell Mode is installed) to show information on
recent changes in Haskell Mode.")
    (license license:gpl3)))

(define-public emacs-impatient-mode
  (package
    (name "emacs-impatient-mode")
    (version "20200723.2117")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/skeeto/impatient-mode.git")
                    (commit "479a2412596ff1dbdddeb7bdbba45482ce5b230c")))
              (sha256
               (base32
                "09ns4csq36x4jnja8ayla6j29c5pyw9psf534rd56d7l33sbgyvl"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-simple-httpd emacs-htmlize))
    (arguments
     '(#:include '("^[^/]+.html$" "^[^/]+.js$" "^impatient-mode.el$")
       #:exclude '()))
    (home-page "https://github.com/netguy204/imp.el")
    (synopsis "Serve buffers live over HTTP")
    (description
     "impatient-mode is a minor mode that publishes the live buffer through the local
simple-httpd server under /imp/live/<buffer-name>/.  To unpublish a buffer,
toggle impatient-mode off.  Start the simple-httpd server (`httpd-start') and
visit /imp/ on the local server.  There will be a listing of all the buffers
that currently have impatient-mode enabled.  This is likely to be found here:
http://localhost:8080/imp/ Except for html-mode buffers, buffers will be
prettied up with htmlize before being sent to clients.  This can be toggled at
any time with `imp-toggle-htmlize'.  Because html-mode buffers are sent raw, you
can use impatient-mode see your edits to an HTML document live! This is perhaps
the primary motivation of this mode.  To receive updates the browser issues a
long poll on the client waiting for the buffer to change -- server push.  The
response happens in an `after-change-functions hook.  Buffers that do not run
these hooks will not be displayed live to clients.")
    (license license:public-domain)))

(define-public emacs-inf-elixir
  (package
    (name "emacs-inf-elixir")
    (version "20221120.2028")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/J3RN/inf-elixir.git")
                    (commit "6fbb0867b586ad1bf8adc09cc55f33dfa72db833")))
              (sha256
               (base32
                "0gwg2hjz0s6gkyifvni3mghrp7174prwrl46sbxx5pi9s435djpm"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/J3RN/inf-elixir")
    (synopsis "Run an interactive Elixir shell")
    (description
     "This package provides access to an IEx shell buffer, optionally running a
specific command (e.g. iex -S mix, iex -S mix phx.server, etc)")
    (license license:gpl3)))

(define-public emacs-inform7
  (package
    (name "emacs-inform7")
    (version "20200430.1539")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GuiltyDolphin/inform7-mode.git")
                    (commit "a409bbc6f04264f7f00616a995fa6ecf59d33d0d")))
              (sha256
               (base32
                "1sai118i5ry58jjc3777kn2ca2nhaxszhl0va6gyy7j2cdpg8gpy"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s))
    (home-page "https://github.com/GuiltyDolphin/inform7-mode")
    (synopsis "Major mode for working with Inform 7 files")
    (description
     "inform7-mode provides a major mode for interacting with files written in Inform
7 syntax.  For more information see the README.")
    (license license:gpl3)))

(define-public emacs-ipcalc
  (package
    (name "emacs-ipcalc")
    (version "20210903.958")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dotemacs/ipcalc.el.git")
                    (commit "8d5af5b8e075f204c1e265174c96587886831996")))
              (sha256
               (base32
                "0a7rw26ibhmlnf9jjs6kf610k566mqzjvbd9rlmpwpi8awlfflky"))))
    (build-system emacs-build-system)
    (home-page "http://github.com/dotemacs/ipcalc.el")
    (synopsis "IP subnet calculator")
    (description "Usage: evaluate (ipcalc \"192.168.0.23/21\")")
    (license license:bsd-2)))

(define-public emacs-j-mode
  (package
    (name "emacs-j-mode")
    (version "20171224.1856")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zellio/j-mode.git")
                    (commit "e8725ac8af95498faabb2ca3ab3bd809a8f148e6")))
              (sha256
               (base32
                "0icrwny3cif0iwgyf9i25sj9i5gy056cn9ic2wwwbzqjqb4xg6dd"))))
    (build-system emacs-build-system)
    (home-page "http://github.com/zellio/j-mode")
    (synopsis "Major mode for editing J programs")
    (description
     "This package provides font-lock and basic REPL integration for the [J
programming language](http://www.jsoftware.com) ; Installation The only method
of installation is to check out the project, add it to the load path, and load
normally.  This may change one day.  Put this in your emacs config (add-to-list
load-path \"/path/to/j-mode/\") (load \"j-mode\") Add for detection of j source
files if the auto-load fails (add-to-list auto-mode-alist (\"\\\\.ij[rstp]$\" .
j-mode)))")
    (license license:gpl3)))

(define-public emacs-julia-mode
  (package
    (name "emacs-julia-mode")
    (version "20230119.1840")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/JuliaEditorSupport/julia-emacs.git")
                    (commit "7aafa8e77df64a47fa4729a0c1ea572b5bc8e30e")))
              (sha256
               (base32
                "1agk2jf76ardqxm28nw341jb92sl6ylkr8yfibsp5vaid9dlq6bp"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/JuliaEditorSupport/julia-emacs")
    (synopsis "Major mode for editing Julia source code")
    (description "This is the official Emacs mode for editing Julia programs.")
    (license license:expat)))

(define-public emacs-julia-repl
  (package
    (name "emacs-julia-repl")
    (version "20230112.1929")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tpapp/julia-repl.git")
                    (commit "57a15dfafed680ad7d81f779d414e8cb6717417c")))
              (sha256
               (base32
                "1bpp7216j1a3agwfsidikf65mmym0xyhq2yn6s9ipsk25n6vac1s"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s))
    (home-page "https://github.com/tpapp/julia-repl")
    (synopsis "A minor mode for a Julia REPL")
    (description
     "Run a julia REPL inside a terminal in Emacs.  In contrast to ESS, use the Julia
REPL facilities for interactive features, such readline, help, debugging.")
    (license license:expat)))

(define-public emacs-ledger-mode
  (package
    (name "emacs-ledger-mode")
    (version "20230106.1610")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ledger/ledger-mode.git")
                    (commit "4b32f701736b37f99048be79583b0bde7cc14c85")))
              (sha256
               (base32
                "17653pz69nmzg7452zq7pcj31dk86vssj94i9al28lgfv02h07l2"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^ledger[^/]+.el$")
       #:exclude '()))
    (home-page "unspecified")
    (synopsis "Helper code for use with the \"ledger\" command-line tool")
    (description "Most of the general ledger-mode code is here.")
    (license license:gpl2)))

(define-public emacs-lfe-mode
  (package
    (name "emacs-lfe-mode")
    (version "20220822.911")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rvirding/lfe.git")
                    (commit "9a75089f00f2433fad8e32974a34b50763039c84")))
              (sha256
               (base32
                "111b8spkkalhys55j5a2yz67a1ykb51jdqm1vgij1b52j7qrxssf"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^emacs/inferior-lfe.el$" "^emacs/lfe-mode.el$"
                   "^emacs/lfe-indent.el$")
       #:exclude '()))
    (home-page "unspecified")
    (synopsis "Lisp Flavoured Erlang mode")
    (description "Copied from `lisp-mode and modified for LFE.")
    (license license:asl2.0)))

(define-public emacs-lice
  (package
    (name "emacs-lice")
    (version "20220312.2215")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/buzztaiki/lice-el.git")
                    (commit "0b69ba54057146f1473e85c0760029e584e3eb13")))
              (sha256
               (base32
                "06plnrxj6kgnl9mjcbc48mgagpa60yyyyribwicmcgg9pgrs0wad"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^[^/]+.el$" "^template$")
       #:exclude '()))
    (home-page "https://github.com/buzztaiki/lice-el")
    (synopsis "License And Header Template")
    (description
     "Overview -------- `lice.el` provides following features: - License template
management. - File header insertion.  Usage ----- Usage is very easy, put
`lice.el` in your Emacs system, and open a new file, and run: M-x lice Then,
`lice.el` tell to use which license (default is gpl-3.0).  You can select
license on minibuffer completion.  When you select license, and enter the `RET`,
license and copyright is putted into a text.  More Information ----------------
See the `README.md` file for more information.")
    (license license:gpl3)))

(define-public emacs-lua-mode
  (package
    (name "emacs-lua-mode")
    (version "20221218.605")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/immerrr/lua-mode.git")
                    (commit "ad639c62e38a110d8d822c4f914af3e20b40ccc4")))
              (sha256
               (base32
                "1hwczx31bd2wjky45mqqr85x9l58833g69s0n9pa1lwwfx0c6z62"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                   "^dir$"
                   "^[^/]+.info$"
                   "^[^/]+.texi$"
                   "^[^/]+.texinfo$"
                   "^doc/dir$"
                   "^doc/[^/]+.info$"
                   "^doc/[^/]+.texi$"
                   "^doc/[^/]+.texinfo$")
       #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                   "^[^/]+-tests.el$" "^init-tryout.el$")))
    (home-page "https://immerrr.github.io/lua-mode")
    (synopsis "a major-mode for editing Lua scripts")
    (description
     "lua-mode provides support for editing Lua, including automatic indentation,
syntactical font-locking, running interactive shell, Flymake checks with
luacheck, interacting with `hs-minor-mode and online documentation lookup.  The
following variables are available for customization (see more via `M-x
customize-group lua`): - Var `lua-indent-level': indentation offset in spaces -
Var `lua-indent-string-contents': set to `t` if you like to have contents of
multiline strings to be indented like comments - Var
`lua-indent-nested-block-content-align': set to `nil to stop aligning the
content of nested blocks with the open parenthesis - Var
`lua-indent-close-paren-align': set to `t to align close parenthesis with the
open parenthesis, rather than with the beginning of the line - Var
`lua-mode-hook': list of functions to execute when lua-mode is initialized - Var
`lua-documentation-url': base URL for documentation lookup - Var
`lua-documentation-function': function used to show documentation (`eww` is a
viable alternative for Emacs 25) These are variables/commands that operate on
the Lua process: - Var `lua-default-application': command to start the Lua
process (REPL) - Var `lua-default-command-switches': arguments to pass to the
Lua process on startup (make sure `-i` is there if you expect working with Lua
shell interactively) - Cmd `lua-start-process': start new REPL process, usually
happens automatically - Cmd `lua-kill-process': kill current REPL process These
are variables/commands for interaction with the Lua process: - Cmd
`lua-show-process-buffer': switch to REPL buffer - Cmd
`lua-hide-process-buffer': hide window showing REPL buffer - Var
`lua-always-show': show REPL buffer after sending something - Cmd
`lua-send-buffer': send whole buffer - Cmd `lua-send-current-line': send current
line - Cmd `lua-send-defun': send current top-level function - Cmd
`lua-send-region': send active region - Cmd `lua-restart-with-whole-file':
restart REPL and send whole buffer To enable on-the-fly linting, make sure you
have the luacheck program installed (available from luarocks) and activate
`flymake-mode'.  See \"M-x apropos-command ^lua-\" for a list of commands.  See
\"M-x customize-group lua\" for a list of customizable variables.")
    (license license:gpl3)))

(define-public emacs-markdown-changelog
  (package
    (name "emacs-markdown-changelog")
    (version "20200120.2253")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/plandes/markdown-changelog.git")
                    (commit "1a2c3a4c3e4196f2b5dbb145b01b4bc435a93a96")))
              (sha256
               (base32
                "0dw9bz1iq8v816n0z4v9zc6nsrx4qzl99q2pj04f37s7x9vgmc4x"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-dash))
    (home-page "https://github.com/plandes/markdown-changelog")
    (synopsis "Maintain changelog entries")
    (description
     "Create and maintain Keep a Changelog based entries.  See
https://keepachangelog.com/ for this specific change log format.  A nascent
changelog is created with `markdown-changelog-new and
`markdown-changelog-add-release is used to add a new entry.  For more
information and motivation for markdown changelogs see
https://github.com/plandes/markdown-changelog#motivation")
    (license license:gpl2)))

(define-public emacs-markdown-toc
  (package
    (name "emacs-markdown-toc")
    (version "20210905.738")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ardumont/markdown-toc.git")
                    (commit "3d724e518a897343b5ede0b976d6fb46c46bcc01")))
              (sha256
               (base32
                "01l48njg0x7gkssvw9nv3yq97866r945izbggx9y3z5ckr1w4hlc"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s emacs-dash emacs-markdown-mode))
    (home-page "http://github.com/ardumont/markdown-toc")
    (synopsis "A simple TOC generator for markdown file")
    (description
     "Generate a TOC from a markdown file: M-x markdown-toc-generate-toc This will
compute the TOC at insert it at current position.  Update existing TOC: C-u M-x
markdown-toc-generate-toc Here is a possible output: <!-- markdown-toc start -
Don't edit this section.  Run M-x markdown-toc-refresh-toc --> **Table of
Contents** - [some markdown page title](#some-markdown-page-title) - [main
title](#main-title) - [Sources](#sources) - [Marmalade
(recommended)](#marmalade-recommended) - [Melpa-stable](#melpa-stable) - [Melpa
(~snapshot)](#melpa-~snapshot) - [Install](#install) - [Load
org-trello](#load-org-trello) - [Alternative](#alternative) - [Git](#git) -
[Tar](#tar) - [another title](#another-title) - [with](#with) - [some](#some) -
[heading](#heading) <!-- markdown-toc end --> Install - M-x package-install RET
markdown-toc RET")
    (license license:gpl3)))

(define-public emacs-metronome
  (package
    (name "emacs-metronome")
    (version "20220210.147")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/jagrg/metronome.git")
                    (commit "1e1bd5234f3ecfb608041d423be7412c461ad3c2")))
              (sha256
               (base32
                "1igx3ajzgrrhc1bxzj24bf1r9ipm3pd4haq82wqdqskf60gidkac"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                   "^dir$"
                   "^[^/]+.info$"
                   "^[^/]+.texi$"
                   "^[^/]+.texinfo$"
                   "^doc/dir$"
                   "^doc/[^/]+.info$"
                   "^doc/[^/]+.texi$"
                   "^doc/[^/]+.texinfo$"
                   "^sounds$")
       #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                   "^[^/]+-tests.el$")))
    (home-page "https://gitlab.com/jagrg/metronome")
    (synopsis "A simple metronome")
    (description
     "This is a very simple metronome for GNU Emacs.  To install it from source, add
metronome.el to your load path and require it.  Then M-x metronome to
play/pause, and C-u M-x metronome to set a new tempo. (require metronome)
(global-set-key (kbd \"C-c C-m\") metronome)")
    (license license:gpl3)))

(define-public emacs-noflet
  (package
    (name "emacs-noflet")
    (version "20141102.1454")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/nicferrier/emacs-noflet.git")
                    (commit "7ae84dc3257637af7334101456dafe1759c6b68a")))
              (sha256
               (base32
                "0g70gnmfi8n24jzfci9nrj0n9bn1qig7b8f9f325rin8h7x32ypf"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/nicferrier/emacs-noflet")
    (synopsis "locally override functions")
    (description
     "This let's you locally override functions, in the manner of `flet', but with
access to the original function through the symbol: `this-fn'.")
    (license license:gpl3)))

(define-public emacs-esxml
  (package
    (name "emacs-esxml")
    (version "20220506.759")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tali713/esxml.git")
                    (commit "7ac1fec0e45f12836b301fd9b8e7297434db2f70")))
              (sha256
               (base32
                "040a9i202pxjxj34c6f49fj6rg70xha2ns6047vj3gcsa72ylm4n"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-kv))
    (arguments
     '(#:include '("^esxml.el$" "^esxml-query.el$")
       #:exclude '()))
    (home-page "https://github.com/tali713/esxml")
    (synopsis "Library for working with xml via esxml and sxml")
    (description
     "This is XML/XHTML done with S-Expressions in EmacsLisp.  Simply, this is the
easiest way to write HTML or XML in Lisp.  This library uses the native form of
XML representation as used by many libraries already included within emacs.
This representation will be referred to as \"esxml\" throughout this library.  See
`esxml-to-xml for a concise description of the format.  This library is not
intended to be used directly by a user, though it certainly could be.  It could
be used to generate static html, or use a library like `elnode to serve dynamic
pages.  Or even to extract a form from a site to produce an API. TODO: Better
documentation, more convenience.  NOTICE: Code base will be transitioning to
using pcase instead of destructuring bind wherever possible.  If this leads to
hard to debug code, please let me know, and I will do whatever I can to resolve
these issues.")
    (license license:gpl3)))

(define-public emacs-nov
  (package
    (name "emacs-nov")
    (version "20170901.1312")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://depp.brause.cc/nov.el.git")
                    (commit "cb5f45cbcfbcf263cdeb2d263eb15edefc8b07cb")))
              (sha256
               (base32
                "1fm65d39505kcgqaxnr5nkdilan45gpb1148m15d7gc5806n0sdz"))))
    (build-system emacs-build-system)
    (home-page "https://depp.brause.cc/nov.el/")
    (synopsis "Major mode for reading EPUBs in Emacs")
    (description
     "nov.el provides a major mode for reading EPUB documents. Features: Basic
navigation (jump to TOC, previous/next chapter); Remembering and restoring
the last read position; Jump to next chapter when scrolling beyond end;
Storing and following Org links to EPUB files; Renders EPUB2 (.ncx) and
EPUB3 (<nav>) TOCs; Hyperlinks to internal and external targets; Supports
textual and image documents; Info-style history navigation; View source of
document files; Metadata display; Image rescaling.")
    (license license:gpl3)))

(define-public emacs-number
  (package
    (name "emacs-number")
    (version "20170901.1312")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/chrisdone/number.git")
                    (commit "bbc278d34dbcca83e70e3be855ec98b23debfb99")))
              (sha256
               (base32
                "0a1r352zs58mdwkq58561qxrz3m5rwk3xqcaaqhkxc0h9jqs4a9r"))))
    (build-system emacs-build-system)
    (home-page "unspecified")
    (synopsis "Working with numbers at point.")
    (description
     "Do trivial arithmetic on the numbers at point.  Attempts to preserve padding
when it can.  Examples: M-x number/add 1 RET 1 -> 2 05 -> 06 6.30 -> 7.30 07.30
-> 08.30 -08.30 -> -07.30 M-x number/pad 2 RET 5 -> 05 M-x number/pad 2 RET 6
RET 3.141 -> 03.141000 The \"guessing\" where the number is isn't yet quite
awesome, e.g. it doesn't know that the 05 in \"2014-05-01\" is a month and not,
e.g. the number -05.  But you can use the region to explicitly denote the start
and end of the number.  The following keybindings might be nice to use:
(global-set-key (kbd \"C-c C-+\") number/add) (global-set-key (kbd \"C-c C--\")
number/sub) (global-set-key (kbd \"C-c C-*\") number/multiply) (global-set-key
(kbd \"C-c C-/\") number/divide) (global-set-key (kbd \"C-c C-0\") number/pad)
(global-set-key (kbd \"C-c C-=\") number/eval)")
    (license license:gpl3)))

(define-public emacs-ob-kotlin
  (package
    (name "emacs-ob-kotlin")
    (version "20180823.1321")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/zweifisch/ob-kotlin.git")
                    (commit "96e420cbd2e9ea8a77043e5dcaebdfc6da17492a")))
              (sha256
               (base32
                "0ganip7077rsi681kdsrmvpjhinhgsrla34mll0daiqid7flnk4g"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org))
    (home-page "http://github.com/zweifisch/ob-kotlin")
    (synopsis "org-babel functions for kotlin evaluation")
    (description "org-babel functions for kotlin evaluation")
    (license license:gpl3)))

(define-public emacs-ob-mermaid
  (package
    (name "emacs-ob-mermaid")
    (version "20200320.1504")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/arnm/ob-mermaid.git")
                    (commit "b4ce25699e3ebff054f523375d1cf5a17bd0dbaf")))
              (sha256
               (base32
                "0fhj3241gpj6qj2sawr8pgyn5b7320vjfb7idsy23kh4jvmj2wb8"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/arnm/ob-mermaid")
    (synopsis "org-babel support for mermaid evaluation")
    (description
     "Org-Babel support for evaluating mermaid diagrams. ; Requirements: mermaid.cli |
https://github.com/mermaidjs/mermaid.cli")
    (license license:gpl3)))

(define-public emacs-ob-translate
  (package
    (name "emacs-ob-translate")
    (version "20170720.1919")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/krisajenkins/ob-translate.git")
                    (commit "9d9054a51bafd5a29a8135964069b4fa3a80b169")))
              (sha256
               (base32
                "143dq3wp3h1zzk8ihj8yjw9ydqnf48q7y8yxxa0ly7f2v1li84bc"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-google-translate emacs-org))
    (home-page "https://github.com/krisajenkins/ob-translate")
    (synopsis "Translation of text blocks in org-mode.")
    (description "Supports translation of text blocks in org-mode.")
    (license license:gpl3+)))

(define-public emacs-octo-mode
  (package
    (name "emacs-octo-mode")
    (version "20161008.1229")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/cryon/octo-mode.git")
                    (commit "bd4db7e5e3275b24c74e6a23c11d04f54e9feca5")))
              (sha256
               (base32
                "1blr664h8bq8bs1wr82nhhb9y7ggrlxp6x203i5bv542zm4a5rba"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/cryon/octo-mode")
    (synopsis "Major mode for Octo assembly language")
    (description
     "Major mode for editing Octo source code.  A high level assembly language for the
Chip8 virtual machine.  See: https://github.com/JohnEarnest/Octo The mode could
most likely have benefited from deriving asm-mode as Octo is an assembly
language.  However part of the reasoning behind creating this mode was learning
more about Emacs internals.  The language is simple enough to allow the mode to
be quite compact anyways.  Much inspiration was taken from yaml-mode so there
might be similarities in the source structure and naming choices. ;
Installation: The easiest way to install octo-mode is from melpa.  Assuming
MELPA is added to your archive list you can list the available packages by
typing M-x list-packages, look for octo-mode, mark it for installation by typing
i and then execute (install) by typing x'.  Or install it directly with M-x
package-install RET octo-mode.  If you want to install it manually, just drop
this file anywhere in your `load-path'.  Be default octo-mode associates itself
with the *.8o file ending.  You can enable the mode manually by M-x octo-mode
RET.")
    (license license:expat)))

(define-public emacs-offlineimap
  (package
    (name "emacs-offlineimap")
    (version "20150916.1158")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jd/offlineimap.el.git")
                    (commit "cc3e067e6237a1eb7b21c575a41683b1febb47f1")))
              (sha256
               (base32
                "1bjrgj8klg7ly63vx90jpaih9virn02bhqi16p6z0mw36q1q7ysq"))))
    (build-system emacs-build-system)
    (home-page "http://julien.danjou.info/offlineimap-el.html")
    (synopsis "Run OfflineIMAP from Emacs")
    (description "M-x offlineimap We need comint for `comint-truncate-buffer")
    (license license:gpl3)))

(define-public emacs-org-analyzer
  (package
    (name "emacs-org-analyzer")
    (version "20191001.1717")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rksm/clj-org-analyzer.git")
                    (commit "19da62aa4dcf1090be8f574f6f2d4c7e116163a8")))
              (sha256
               (base32
                "1zfc93z6w5zvbqiypqvbnyv8ims1wgpcp61z1s152d0nq2y4pf50"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^org-analyzer-el/[^/]+.jar$" "^org-analyzer-el/[^/]+.el$")
       #:exclude '()))
    (home-page "https://github.com/rksm/clj-org-analyzer")
    (synopsis
     "org-analyzer is a tool that extracts time tracking data from org files.")
    (description
     "org-analyzer is a tool that extracts time tracking data from org files (time
data recording with `org-clock-in', those lines that start with \"CLOCK:\").  It
then creates an interactive visualization of that data — outside of Emacs(!).
In order to run the visualizer / parser you need to have java installed.  This
Emacs package provides a simple way to start the visualizer via
`org-analyzer-start and feed it the default org files.  See
https://github.com/rksm/clj-org-analyzer for more information.")
    (license license:gpl3)))

(define-public emacs-org-board
  (package
    (name "emacs-org-board")
    (version "20200619.1016")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/charlesroelli/org-board.git")
                    (commit "1393bd46d11a81328ed4fb8471831415a3efe224")))
              (sha256
               (base32
                "1kryrg988c3sbxyp1sdgc6xdv2iz6kiflpzn2rw4z3l4grzab53b"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/scallywag/org-board")
    (synopsis "bookmarking and web archival system for Org mode.")
    (description
     "org-board uses `org-attach and `wget to provide a bookmarking and web archival
system directly from an Org file.  Any `wget switch can be used in `org-board',
and presets (like user agents) can be set for easier control.  Every snapshot is
logged and saved to an automatically generated folder, and snapshots for the
same link can be compared using the `ztree package (optional dependency; `ediff
used if `zdiff is not available).  Arbitrary functions can also be run after an
archive, allowing for extensive user customization.")
    (license license:gpl3)))

(define-public emacs-org-brain
  (package
    (name "emacs-org-brain")
    (version "20210706.1519")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Kungsgeten/org-brain.git")
                    (commit "46ca9f766322cff31279ecdf02251ff24a0e9431")))
              (sha256
               (base32
                "0bj08f5mg9v0xm2awbv1fxv98jj9scvqss6fmw0lzix6s3112z25"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org))
    (home-page "http://github.com/Kungsgeten/org-brain")
    (synopsis "Org-mode concept mapping")
    (description
     "org-brain implements a variant of concept mapping with org-mode, it is inspired
by The Brain software (http://thebrain.com).  An org-brain is a network of
org-mode entries, where each entry is a file or a headline, and you can get a
visual overview of the relationships between the entries: parents, children,
siblings and friends.  This visual overview can also be used to browse your
entries.  You can think of entries as nodes in a mind map, or pages in a wiki.
All org files put into your `org-brain-path directory will be considered entries
in your org-brain.  Headlines with an ID property in your entry file(s) are also
considered as entries.  Use `org-brain-visualize to see the relationships
between entries, quickly add parents/children/friends/pins to an entry, and open
them for editing.")
    (license license:expat)))

(define-public emacs-org-cliplink
  (package
    (name "emacs-org-cliplink")
    (version "20201126.1020")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rexim/org-cliplink.git")
                    (commit "13e0940b65d22bec34e2de4bc8cba1412a7abfbc")))
              (sha256
               (base32
                "1avyiw8vlv4n1r7zqvc6wjlsz7jl2pqaprzpm782gzp0c999pssl"))))
    (build-system emacs-build-system)
    (home-page "http://github.com/rexim/org-cliplink")
    (synopsis "insert org-mode links from the clipboard")
    (description
     "This package provides a simple command that takes a URL from the clipboard and
inserts an org-mode link with a title of a page found by the URL into the
current buffer This code was a part of my Emacs config almost a year.  I decided
to publish it as a separate package in case someone needs this feature too.")
    (license license:bsd-3)))

(define-public emacs-org-clock-today
  (package
    (name "emacs-org-clock-today")
    (version "20220918.514")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mallt/org-clock-today-mode.git")
                    (commit "b73cca120eb64538ab0666892a8b97b6d65b4d6b")))
              (sha256
               (base32
                "147q7x6q9fi0damvyxlmh6f0asv0gkra9a86138m25133syv3w2g"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/mallt/org-clock-today-mode")
    (synopsis "Show total clocked time of the current day in the mode line")
    (description
     "Show the total clocked time of the current day in the mode line")
    (license license:gpl3+)))

(define-public emacs-org-d20
  (package
    (name "emacs-org-d20")
    (version "20210212.142")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.spwhitton.name/org-d20")
                    (commit "e6149dcfbb6302d10109dd792fd0ffae7bfe2595")))
              (sha256
               (base32
                "129zdnz97h6px0yz0f0if4gw96zxmsg24xc8vg51crsazqqz8l3b"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s emacs-seq emacs-dash))
    (home-page "https://spwhitton.name/tech/code/org-d20/")
    (synopsis "minor mode for d20 tabletop roleplaying games")
    (description
     "; A minor mode intended for use in an Org-mode file in which you are ; keeping
your GM notes for a tabletop roleplaying game that uses a ; d20. ; Example file
footer: ; ; # Local Variables: ; # eval: (org-d20-mode 1) ; # org-d20-party:
((\"Zahrat\" .  2) (\"Ennon\" .  4) (\"Artemis\" .  5))")
    (license license:gpl3)))

(define-public emacs-org-kanban
  (package
    (name "emacs-org-kanban")
    (version "20220723.1216")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/gizmomogwai/org-kanban.git")
                    (commit "e78deb03880ae89d6bceae6563ef1383526233a1")))
              (sha256
               (base32
                "006y8glnd3h5nmcb0fdq650xnknhi5n74v7adk1maf26r8rpc6vy"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s emacs-dash emacs-org))
    (home-page "http://github.com/gizmomogwai/org-kanban")
    (synopsis "kanban dynamic block for org-mode.")
    (description
     "To create a kanban table for an org file, simply put the dynamic block `
#+BEGIN: kanban #+END:  somewhere and run `C-c C-c on it.  You can use
`org-kanban/initialize to get this generated.")
    (license license:expat)))

(define-public emacs-org-page
  (package
    (name "emacs-org-page")
    (version "20170807.224")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/emacsorphanage/org-page.git")
                    (commit "b25c3ef41da233306c157634c1f0b019d8b6adc0")))
              (sha256
               (base32
                "06hh1g3rxadscjjn1ym358m2c8qn3s2x7ik0msadvm1zgx7ng4v5"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-ht
                             emacs-simple-httpd
                             emacs-mustache
                             emacs-htmlize
                             emacs-org
                             emacs-dash
                             emacs-git))
    (arguments
     '(#:include '("^[^/]+.el$" "^doc$" "^themes$")
       #:exclude '()))
    (home-page "https://github.com/kelvinh/org-page")
    (synopsis "a static site generator based on org mode")
    (description
     "See documentation at https://github.com/kelvinh/org-page Org-page is a static
site generator based on org mode.  Org-page provides following features: 1) org
sources and html files managed by git 2) incremental publication (according to
=git diff= command) 3) category support 4) tags support (auto generated) 5) RSS
support (auto generated) 6) search engine support (auto generated) 7) a
beautiful theme 8) theme customization support 9) commenting (implemented using
disqus) 10) site visiting tracking (implemented using google analytics) 11)
index/about page support (auto generated if no default provided) 12) site
preview 13) highly customizable")
    (license license:gpl3)))

(define-public emacs-org-pdftools
  (package
    (name "emacs-org-pdftools")
    (version "20220320.301")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/fuxialexander/org-pdftools.git")
                    (commit "967f48fb5038bba32915ee9da8dc4e8b10ba3376")))
              (sha256
               (base32
                "0f47ww8r00b7lb1msybnmnqdhm9i2vwz5lrz9m9bn6gbh97mzhn8"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org emacs-pdf-tools emacs-org-noter))
    (arguments
     '(#:include '("^org-pdftools.el$")
       #:exclude '()))
    (home-page "https://github.com/fuxialexander/org-pdftools")
    (synopsis "Support for links to documents in pdfview mode")
    (description
     "Add support for org links from pdftools buffers with more precise location
control.  https://github.com/fuxialexander/org-pdftools/")
    (license license:gpl3)))

(define-public emacs-org-scrum
  (package
    (name "emacs-org-scrum")
    (version "20200131.1129")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ianxm/emacs-scrum.git")
                    (commit "f7a46bc4bc85305f0c2b72565170ea0e007c42fd")))
              (sha256
               (base32
                "1x37jcfbdmyba3301fbrvmps93ibwcgn6dcqzv39qfsbpr5j0iik"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org emacs-seq))
    (home-page "https://github.com/ianxm/emacs-scrum")
    (synopsis "org mode extensions for scrum planning and reporting")
    (description
     "This package provides functions that extend org-mode which allow it to generate
reports used in the scrum software development process, such as a scrum board
and burndown chart.")
    (license license:gpl3)))

(define-public emacs-org-special-block-extras
  (package
    (name "emacs-org-special-block-extras")
    (version "20220326.1432")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url
                     "https://github.com/alhassy/org-special-block-extras.git")
                    (commit "0a0a199b5962af59ffd5c2a25af20ad7c9c22dc8")))
              (sha256
               (base32
                "0887qswhrrzhsspdclb186s7l5768w4xx2j0j5k64qd95kpxgrqr"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s
                             emacs-dash
                             emacs-org
                             emacs-lf
                             emacs-dad-joke
                             emacs-seq
                             emacs-lolcat))
    (home-page "https://alhassy.github.io/org-special-block-extras")
    (synopsis "30 new custom blocks & 34 link types for Org-mode")
    (description
     "This library provides common desirable features using the Org interface for
blocks and links: 0.  A unified interface, the ‘defblock’ macro, for making new
block and link types.  1.  Colours: Regions of text and inline text can be
coloured using 19 colours; easily extendable; below is an example. #+begin_red
org /This/ *text* _is_ red! #+end_red 2.  Multiple columns: Regions of text are
exported into multiple side-by-side columns 3.  Remarks: First-class visible
editor comments 4.  Details: Regions of text can be folded away in HTML 5.
Badges: SVG badges have the pleasant syntax badge:key|value|colour|url|logo;
only the first two are necessary.  6.  Tooltips: Full access to Lisp
documentation as tooltips, or any other documentation-backend, including
user-defined entries; e.g., doc:thread-first retrives the documentation for
thread-first and attachs it as a tooltip to the text in the HTML export and as a
glossary entry in the LaTeX export 7.  Various other blocks: Solution, org-demo,
spoiler (“fill in the blanks”).  This file has been tangled from a literate,
org-mode, file; and so contains further examples demonstrating the special
blocks it introduces.  Full documentation can be found at
https://alhassy.github.io/org-special-block-extras")
    (license license:gpl3)))

(define-public emacs-orgtbl-aggregate
  (package
    (name "emacs-orgtbl-aggregate")
    (version "20230124.1042")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tbanel/orgaggregate.git")
                    (commit "50e36e201ff331443a31d12defc2dfea60fa9523")))
              (sha256
               (base32
                "1pnhqqn4rf260d993iafd6mbhwhc813m5c3dpys1n1xjdwh8ya0i"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/tbanel/orgaggregate/blob/master/README.org")
    (synopsis "Create an aggregated Org table from another one")
    (description
     "This package provides a new org-mode table is automatically updated, based on
another table acting as a data source and user-given specifications for how to
perform aggregation.  Example: Starting from a source table of activities and
quantities (whatever they are) over several days, #+TBLNAME: original | Day |
Color | Level | Quantity | |-----------+-------+-------+----------| | Monday |
Red | 30 | 11 | | Monday | Blue | 25 | 3 | | Tuesday | Red | 51 | 12 | | Tuesday
| Red | 45 | 15 | | Tuesday | Blue | 33 | 18 | | Wednesday | Red | 27 | 23 | |
Wednesday | Blue | 12 | 16 | | Wednesday | Blue | 15 | 15 | | Thursday | Red |
39 | 24 | | Thursday | Red | 41 | 29 | | Thursday | Red | 49 | 30 | | Friday |
Blue | 7 | 5 | | Friday | Blue | 6 | 8 | | Friday | Blue | 11 | 9 | an
aggregation is built for each day (because several rows exist for each day),
typing C-c C-c #+BEGIN: aggregate :table original :cols \"Day mean(Level)
sum(Quantity)\" | Day | mean(Level) | sum(Quantity) |
|-----------+-------------+---------------| | Monday | 27.5 | 14 | | Tuesday |
43 | 45 | | Wednesday | 18 | 54 | | Thursday | 43 | 83 | | Friday | 8 | 22 |
#+END A wizard can be used: M-x orgtbl-aggregate-insert-dblock-aggregate Full
documentation here:
https://github.com/tbanel/orgaggregate/blob/master/README.org")
    (license license:gpl3)))

(define-public emacs-ox-json
  (package
    (name "emacs-ox-json")
    (version "20210928.347")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jlumpe/ox-json.git")
                    (commit "fc6b2594706c44d266d0863c323b1b58ab9d18ba")))
              (sha256
               (base32
                "01kydlzrc2qi4hrklzqc89fk9wpkc52slsslbv42ifsimlj2bnkq"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org emacs-s))
    (home-page "https://github.com/jlumpe/ox-json")
    (synopsis "JSON export backend for Org mode")
    (description
     "Org mode export backend for exporting the document syntax tree to JSON. The main
entry points are `ox-json-export-as-json and `ox-json-export-to-json'.  It can
also be used through the built-in export dispatcher through
`org-export-dispatch'.  Export options: :json-data-type-property (string) - This
the name of a property added to all JSON objects in export to differentiate
between structured data and ordinary key-value mappings.  Its default value is
\"$$data_type\".  Setting to nil prevents the property being added altogether.
:json-exporters - plist containing exporter functions for different data types.
The keys appear in :json-property-types and can also be used with
`ox-json-encode-with-type'.  Functions are called with the value to be exported
and the export info plist.  Default values stored in
`ox-json-default-type-exporters'. :json-property-types (plist) - Sets the types
of properties of specific elements/objects.  Nested set of plists - the top
level is keyed by element type (see `org-element-type') and the second level by
property name (used with `org-element-property').  Values in 2nd level are keys
in the :json-exporters plist and are used to pick the function that will export
the property value.  Properties with a type of t will be encoded using
`ox-json-encode-auto', but this sometimes can produce undesirable results.  The
\"all\" key contains the default property types for all element types.  This
option overrides the defaults set in `ox-json-default-property-types'.
:json-strict (bool) - If true an error will be signaled when problems are
encountered in exporting a data structure.  If nil the data structure will be
exported as an object containing an error message.  Defaults to nil.
:json-include-extra-properties (bool) - Whether to export node properties not
listed in the :json-property-types option.  If true these properties will be
exported using `ox-json-encode-auto'.")
    (license license:expat)))

(define-public emacs-ox-mediawiki
  (package
    (name "emacs-ox-mediawiki")
    (version "20180105.2154")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tomalexander/orgmode-mediawiki.git")
                    (commit "a9327150293e370e500ba55bddfe5fc435c6bf9b")))
              (sha256
               (base32
                "0dsq86hli24imdkgsf45asx23kriw9di3d0cf5z8axfpkcbkn770"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s))
    (home-page "https://github.com/tomalexander/orgmode-mediawiki")
    (synopsis "Mediawiki Back-End for Org Export Engine")
    (description
     "This library implements a Mediawiki back-end for Org exporter, based on `html
back-end.  It provides two commands for export, depending on the desired output:
`org-mw-export-as-mediawiki (temporary buffer) and `org-mw-export-to-mediawiki
(\"mw\" file).")
    (license license:gpl3+)))

(define-public emacs-ox-minutes
  (package
    (name "emacs-ox-minutes")
    (version "20180202.1734")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kaushalmodi/ox-minutes.git")
                    (commit "27c29f3fdb9181322ae56f8bace8d95e621230e5")))
              (sha256
               (base32
                "10rw12gmg3d6fvkqijmjnk5bdpigvm8fy34435mwg7raw0gmlq75"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/kaushalmodi/ox-minutes")
    (synopsis "Plain text backend for Org for Meeting Minutes")
    (description
     "The aim of this exporter to generate meeting minutes plain text that is
convenient to send via email. - Unnecessary blank lines are removed from the
final exported plain text. - Header decoration and section numbers done in the
default ASCII exports is prevented. - Also TOC and author name are not exported.
 This is an ox-ascii derived backed for org exports.  This backend effectively
sets the `org-export-headline-levels to 0 and,
`org-export-with-section-numbers', `org-export-with-author and
`org-export-with-toc to nil time being for the exports.  That is equivalent to
manually putting the below in the org file: #+options: H:0 num:nil author:nil
toc:nil This package has been tested to work with the latest version of org
built from the master branch ( http://orgmode.org/cgit.cgi/org-mode.git ) as of
Aug 10 2016.  EXAMPLE ORG FILE: #+title: My notes * Heading 1 ** Sub heading ***
More nesting - List item 1 - List item 2 - List item 3 * Heading 2 ** Sub
heading - List item 1 - List item 2 - List item 3 *** More nesting MINUTES
EXPORT: __________ MY NOTES __________ * Heading 1 + Sub heading - More nesting
- List item 1 - List item 2 - List item 3 * Heading 2 + Sub heading - List item
1 - List item 2 - List item 3 - More nesting REQUIREMENTS: - Emacs 24 is
required at minimum for lexical binding support. - Emacs 24.4 is required as
ox-ascii got added to org-mode in that Emacs release.")
    (license license:gpl3+)))

(define-public emacs-ox-report
  (package
    (name "emacs-ox-report")
    (version "20220910.951")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/DarkBuffalo/ox-report.git")
                    (commit "0c2357cd09841dfe180210443cae435b49826d75")))
              (sha256
               (base32
                "0w2vkpy7ycg08sv0qpavaq1pvhxsrc4q487w7dq4gj7a9h8c2qkd"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org-msg))
    (home-page "https://github.com/DarkBuffalo/ox-report")
    (synopsis "Export your org file to minutes report PDF file")
    (description
     "This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.  This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.  This is a another exporter for org-mode that translates Org-mode file
to beautiful PDF file EXAMPLE ORG FILE HEADER: #+title:Readme ox-notes #+author:
Matthias David #+options: toc:nil #+ou:Zoom #+quand: 20/2/2021 #+projet:
ox-minutes #+absent: C. Robert,T. tartanpion #+present: K. Soulet,I. Payet
#+excuse:Sophie Fonsec,Karine Soulet #+logo: logo.png")
    (license license:gpl3)))

(define-public emacs-ox-slack
  (package
    (name "emacs-ox-slack")
    (version "20200108.1546")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/titaniumbones/ox-slack.git")
                    (commit "bd797dcc58851d5051dc3516c317706967a44721")))
              (sha256
               (base32
                "1kh2v08fqmsmfj44ik8pljs3fz47fg9zf6q4mr99c0m5ccj5ck7w"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org emacs-ox-gfm))
    (home-page "https://github.com/titaniumbones/ox-slack")
    (synopsis "Slack Exporter for org-mode")
    (description
     "This library implements a Slack backend for the Org exporter, based on the `md
and `gfm back-ends.")
    (license license:gpl3+)))

(define-public emacs-ox-timeline
  (package
    (name "emacs-ox-timeline")
    (version "20220321.2115")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jjuliano/org-simple-timeline.git")
                    (commit "b28bd4ccd5fa114c0f51b9766f0b9be7fe05fdd8")))
              (sha256
               (base32
                "0l71bhbgs2g0gbfl8lf6p2hnnyma26qk67q59x935hkgjbb4vx1z"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/jjuliano/org-simple-timeline")
    (synopsis "HTML Timeline Back-End for Org Export Engine")
    (description
     "This library implements the Org-mode back-end generic exporter for HTML
Timeline.  Installation ------------ Download the timeline scripts from
https://squarechip.github.io/timeline/ Then copy the files relative to your html
file.n The default (`org-timeline-source-url') is set to
\"modules/timeline/dist\".  Usage ----- To test it, run: M-x
org-timeline-export-as-html in an Org mode buffer.  See ox.el and ox-html.el for
more details on how this exporter works.")
    (license license:gpl3+)))

(define-public emacs-pikchr-mode
  (package
    (name "emacs-pikchr-mode")
    (version "20210324.2125")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kljohann/pikchr-mode.git")
                    (commit "5d424c5c97ac854cc44c369e654e4f906fcae3c8")))
              (sha256
               (base32
                "07qjz0mzl6cqgavv5sc9n1v7zq5q6f8is6nn126v0zk6rskp366q"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/kljohann/pikchr-mode")
    (synopsis "A major mode for the pikchr diagram markup language")
    (description
     "This package provides a major mode for the pikchr (https://pikchr.org/) diagram
markup language.")
    (license license:gpl3)))

(define-public emacs-podcaster
  (package
    (name "emacs-podcaster")
    (version "20200607.1054")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/lujun9972/podcaster.git")
                    (commit "7a21173da0c57e6aa41dbdc33383047386b35eb5")))
              (sha256
               (base32
                "1b2bhwipsyyydrqdxjsipzy170xdkfamd4mw5pwzjcgdjqz9wvxa"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/lujun9972/podcaster")
    (synopsis "Podcast client")
    (description
     "podcaster.el is an podcast client which is derived from syohex's emacs-rebuildfm
podcaster.el provides showing podscasts list.  Its actions are - Play podcast
mp3(requires `avplay or `ffplay or `itunes')")
    (license license:gpl3+)))

(define-public emacs-raku-mode
  (package
    (name "emacs-raku-mode")
    (version "20210927.1227")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Raku/raku-mode.git")
                    (commit "977b14a7c1295ebf2aad2f807d3f8e7c27aeb47f")))
              (sha256
               (base32
                "14r1m1iw123y623dxcbjmzn8dpmixc3l7s5svxxs0msxnh5b4fcy"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^[^/]+.el$" "^[^/]+.el.in$"
                   "^dir$"
                   "^[^/]+.info$"
                   "^[^/]+.texi$"
                   "^[^/]+.texinfo$"
                   "^doc/dir$"
                   "^doc/[^/]+.info$"
                   "^doc/[^/]+.texi$"
                   "^doc/[^/]+.texinfo$")
       #:exclude '("^.dir-locals.el$" "^test.el$" "^tests.el$" "^[^/]+-test.el$"
                   "^[^/]+-tests.el$" "^nqp-mode.el$")))
    (home-page "https://github.com/hinrik/perl6-mode")
    (synopsis "Major mode for editing Raku code")
    (description
     "GNU Emacs 24 major mode for editing Raku code.  Currently only provides very
basic syntax highlighting.")
    (license license:gpl3)))

(define-public emacs-rego-mode
  (package
    (name "emacs-rego-mode")
    (version "20201102.1420")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/psibi/rego-mode.git")
                    (commit "be110e6cef5d34eef0529a8739c68e619cf15310")))
              (sha256
               (base32
                "1lm53zg30n96bq8z5g836dhk0y02njdyp8c6vjgsrcii4ff42jp5"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-reformatter))
    (home-page "https://github.com/psibi/rego-mode")
    (synopsis "A major mode for rego language")
    (description
     "This package provides a major mode for editing Rego file (See
https://www.openpolicyagent.org/docs/latest/policy-language/ to learn more) in
Emacs.  Some of its major features include: - syntax highlighting (font lock), -
Basic indentation, raw and normal string support - Automatic formatting on save
(configurable) - REPL support")
    (license license:gpl3)))

(define-public emacs-restart-emacs
  (package
    (name "emacs-restart-emacs")
    (version "20201127.1425")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/iqbalansari/restart-emacs.git")
                    (commit "1607da2bc657fe05ae01f7fdf26f716eafead02c")))
              (sha256
               (base32
                "0afy3icvlj9j6dl3jj6i286mwdhjl7kgvykv1wnbjx2c6gbwfpxa"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/iqbalansari/restart-emacs")
    (synopsis "Restart emacs from within emacs")
    (description
     "This package provides a simple command to restart Emacs from within Emacs")
    (license license:gpl3)))

(define-public emacs-sass-mode
  (package
    (name "emacs-sass-mode")
    (version "20190502.53")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/nex3/sass-mode.git")
                    (commit "247a0d4b509f10b28e4687cd8763492bca03599b")))
              (sha256
               (base32
                "1nhk12lhvkwdk8s8fx33p6rssi0gcfx2zkanq23rz6k28v5zi5yp"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-haml-mode))
    (home-page "http://github.com/nex3/haml/tree/master")
    (synopsis "Major mode for editing Sass files")
    (description
     "Because Sass's indentation schema is similar to that of YAML and Python, many
indentation-related functions are similar to those in yaml-mode and python-mode.
 To install, save this on your load path and add the following to your .emacs
file: (require sass-mode) sass-mode requires haml-mode, which can be found at
http://github.com/nex3/haml-mode.")
    (license license:expat)))

(define-public emacs-sbt-mode
  (package
    (name "emacs-sbt-mode")
    (version "20211203.1148")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/hvesalai/emacs-sbt-mode.git")
                    (commit "9fe1e8807c22cc1dc56a6233e000969518907f4d")))
              (sha256
               (base32
                "1mii46nr4ykkwnbpvsdp46j6n7k38h0jbm49vbm0w7n1az09yg1a"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/hvesalai/emacs-sbt-mode")
    (synopsis "Interactive support for sbt projects")
    (description "")
    (license license:gpl3)))

(define-public emacs-scala-mode
  (package
    (name "emacs-scala-mode")
    (version "20221025.1502")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/hvesalai/emacs-scala-mode.git")
                    (commit "5d7cf21c37e345c49f921fe5111a49fd54efd1e0")))
              (sha256
               (base32
                "1dygncmjizlg33g2yghihmkf5hjwhrd8b63qvl4dndxwbq995n6r"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/hvesalai/emacs-scala-mode")
    (synopsis "Major mode for editing Scala")
    (description "")
    (license license:gpl3)))

(define-public emacs-shen-elisp
  (package
    (name "emacs-shen-elisp")
    (version "20221211.1313")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/deech/shen-elisp.git")
                    (commit "957ab44654fc7a7cc1b78181d244fa25166f9b09")))
              (sha256
               (base32
                "0xfs48fryqjaiy9w7rwxsi9g950gbjq6haacah1lf8h59pa9ff2w"))))
    (build-system emacs-build-system)
    (arguments
     '(#:include '("^shen[^/]+.el$")
       #:exclude '()))
    (home-page "https://github.com/deech/shen-elisp")
    (synopsis "Shen implementation in Elisp")
    (description
     "This is an implemenatation of the Shen programming language in Elisp.  The end
goal is to provide: 1.  An easy way to play with Shen with no other installation
hassle (assuming you use Emacs).  2.  A first-class development experience when
writing Shen.  The idea is that an editor that understands the code can be much
more helpful than one that does not.  To this end the roadmap involves a full
gamut of source code introspection and debugging tools.")
    (license license:bsd-3)))

(define-public emacs-skeletor
  (package
    (name "emacs-skeletor")
    (version "20210129.239")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/chrisbarrett/skeletor.el.git")
                    (commit "f6e560a0bfe459e0b8a268047920ce1148f2ebf6")))
              (sha256
               (base32
                "0xal5m59z8whrsr6id52gb6f22jy6dp349xvs6xxjdfamj1083r7"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-s emacs-f emacs-dash emacs-let-alist))
    (arguments
     '(#:include '("^[^/]+.el$" "^doc/[^/]+.texi$" "^licenses$"
                   "^project-skeletons$")
       #:exclude '()))
    (home-page "unspecified")
    (synopsis "Provides project skeletons for Emacs")
    (description
     "Skeletor provides project templates for Emacs.  It also automates the mundane
parts of setting up a new project like version control, licenses and tooling.
Skeletor comes with a number of predefined templates and allows you to easily
create your own.  To create a new project interactively, run M-x
skeletor-create-project'.  To define a new project, create a project template
inside `skeletor-user-directory', then configure the template with the
`skeletor-define-template macro.  See the info manual for all the details.")
    (license license:gpl3)))

(define-public emacs-snow
  (package
    (name "emacs-snow")
    (version "20221226.2238")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/alphapapa/snow.el.git")
                    (commit "be17977677fa29709a726715a1a1cba1bd299f68")))
              (sha256
               (base32
                "0fh1hmwpszm9frvnqr2b8rlfx33dy9jm5r82hldgxdbhlv8dq4d0"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/alphapapa/snow.el")
    (synopsis "Let it snow in Emacs!")
    (description
     "Let it snow in Emacs! Command `snow displays a buffer in which it snows.  The
storm varies in intensity, a gentle breeze blows at times, and snow accumulates
on the terrain in the scene.")
    (license license:gpl3)))

(define-public emacs-spdx
  (package
    (name "emacs-spdx")
    (version "20230127.116")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/condy0919/spdx.el.git")
                    (commit "0b4a7d8b761c553c4380e9a881e69276213172fc")))
              (sha256
               (base32
                "0b2q9xkir41aisvaks8xsdzh6g0mkl0ws6qnq4in2v7g1j9yvp4v"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/condy0919/spdx.el")
    (synopsis "Insert SPDX license and copyright headers")
    (description
     "# spdx.el `spdx.el` provides SPDX license header and copyright insertion. ##
Installation Put `spdx.el` in your Emacs system.  Add the following to your
`.emacs`: ```elisp (require spdx) (define-key prog-mode-map (kbd \"C-c i l\")
#'spdx-insert-spdx) ``` Or Use
[use-package](https://github.com/jwiegley/use-package) with
[straight.el](https://github.com/raxod502/straight.el) ``` emacs-lisp
(use-package spdx :ensure t :straight (:host github :repo \"condy0919/spdx.el\")
:bind (:map prog-mode-map (\"C-c i l\" .  spdx-insert-spdx)) :custom
(spdx-copyright-holder auto) (spdx-project-detection auto)) ``` Then you can
press `C-c i l` to trigger `spdx-insert-spdx` Or manually run: M-x
spdx-insert-spdx Then, `spdx.el` will ask you to select a license.  It's done by
`completing-read'.  After that, the license header will be written.  An example
follows. `;; SPDX-License-Identifier: AGPL-1.0-only` ## Customization -
`spdx-copyright-holder - `spdx-copyright-sign - `spdx-project-detection -
`spdx-ignore-deprecated")
    (license license:gpl3)))

(define-public emacs-threes
  (package
    (name "emacs-threes")
    (version "20160820.1242")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/xuchunyang/threes.el.git")
                    (commit "6981acb30b856c77cba6aba63fefbf102cbdfbb2")))
              (sha256
               (base32
                "1a7zqq6kmqxgzbsg8yczlvipzv65n10c8j26mc507p4m47nlikgv"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-seq))
    (home-page "https://github.com/xuchunyang/threes.el")
    (synopsis "A clone of Threes (a tiny puzzle game)")
    (description "To play, type M-x threes, then use the arrow keys to move.")
    (license license:gpl3+)))

(define-public emacs-titlecase
  (package
    (name "emacs-titlecase")
    (version "20220728.2253")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://melpa.org/packages/titlecase-"
                                  version ".tar"))
              (sha256
               (base32
                "139bq2g6mlxwpm39rshrkmcgjfy4w40dkihj56bwhf4raxzg5x42"))))
    (build-system emacs-build-system)
    (home-page "https://codeberg.org/acdw/titlecase.el")
    (synopsis "Title-case phrases")
    (description
     "This library strives to be the most accurate possible with title-casing
sentences, lines, and regions of text in English prose according to a number of
styles guides capitalization rules.  It is necessarily a best-effort; due to the
vaguaries of written English it's impossible to completely correctly capitalize
aribtrary titles.  So be sure to proofread and copy-edit your titles before
sending them off to be published, and never trust a computer.  INSTALLATION and
USE: Make sure both titlecase.el and titlecase-data.el are in your `load-path',
and `require titlecase.  You should then be able to call the interactive
functions defined in this file. ; CUSTOMIZATION: Only two customization options
are probably going to be of any interest: `titlecase-style (the style to use for
capitalizing titles), and `titlecase-dwim-non-region-function', which determines
what to do when `titlecase-dwim isn't acting on a region.  If you want to use
your own title-casing code, or a third party, you can customize
`titlecase-command to something other than its default.  One possibility is
titlecase.pl, written John Gruber and Aristotle Pagaltzis:
https://github.com/ap/titlecase.")
    (license license:gpl3)))

(define-public emacs-tldr
  (package
    (name "emacs-tldr")
    (version "20221109.1501")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kuanyui/tldr.el.git")
                    (commit "2b5d53571bd30b75d4f5a642aa129055803a6bfb")))
              (sha256
               (base32
                "0i58abjzxi6qkfclwhphp7ljdc4sx80cj7izcq76glkpkif6sysn"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/kuanyui/tldr.el")
    (synopsis "tldr client for Emacs")
    (description
     "This is a tldr client for Emacs.  https://github.com/tldr-pages/tldr Just M-x
tldr Notice that the first time using it will automatically download the latest
tldr docs.  You can use =M-x tldr-update-docs= to update docs.")
    (license license:wtfpl2)))

(define-public emacs-typo
  (package
    (name "emacs-typo")
    (version "20200706.1714")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/jorgenschaefer/typoel.git")
                    (commit "173ebe4fc7ac38f344b16e6eaf41f79e38f20d57")))
              (sha256
               (base32
                "09835zlfzxby5lpz9njl705nqc2n2h2f7a4vpcyx89f5rb9qhy68"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/jorgenschaefer/typoel")
    (synopsis "Minor mode for typographic editing")
    (description
     "typo.el includes two modes, `typo-mode` and `typo-global-mode`. `typo-mode` is a
buffer-specific minor mode that will change a number of normal keys to make them
insert typographically useful unicode characters.  Some of those keys can be
used repeatedly to cycle through variations.  This includes in particular
quotation marks and dashes. `typo-global-mode` introduces a global minor mode
which adds the `C-c 8` prefix to complement Emacs’ default `C-x 8` prefix map.
See the documentation of `typo-mode` and `typo-global-mode` for further details.
## Quotation Marks > “He said, ‘leave me alone,’ and closed the door.” All
quotation marks in this sentence were added by hitting the \" key exactly once
each.  typo.el guessed the correct glyphs to use from context.  If it gets it
wrong, you can just repeat hitting the \" key until you get the quotation mark
you wanted. `M-x typo-change-language` lets you change which quotation marks to
use.  This is also configurable, in case you want to add your own. ## Dashes and
Dots The hyphen key will insert a default hyphen-minus glyph.  On repeated use,
though, it will cycle through the en-dash, em-dash, and a number of other
dash-like glyphs available in Unicode.  This means that typing two dashes
inserts an en-dash and typing three dashes inserts an em-dash, as would be
expected.  The name of the currently inserted dash is shown in the minibuffer.
The full stop key will self-insert as usual.  When three dots are inserted in a
row, though, they are replaced by a horizontal ellipsis glyph. ## Other Keys
Tick and backtick keys insert the appropriate quotation mark as well.  The
less-than and greater-than signs cycle insert the default glyphs on first use,
but cycle through double and single guillemets on repeated use. ## Prefix Map In
addition to the above, typo-global-mode also provides a globally-accessible key
map under the `C-c 8` prefix (akin to Emacs’ default `C-x 8` prefix map) to
insert various Unicode characters.  In particular, `C-c 8 SPC` will insert a
no-break space.  Continued use of SPC after this will cycle through half a dozen
different space types available in Unicode.  Check the mode’s documentation for
more details.")
    (license license:gpl3+)))

(define-public emacs-unicode-fonts
  (package
    (name "emacs-unicode-fonts")
    (version "20220713.1837")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rolandwalker/unicode-fonts.git")
                    (commit "44d0a22420c39709d1e1fa659a3f135facf3c986")))
              (sha256
               (base32
                "00qdwkphwpc5kddn3k3ck1isykbhlvqmfb45877a65274am79pd7"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-font-utils emacs-ucs-utils emacs-list-utils
                             emacs-persistent-soft emacs-pcache))
    (home-page "http://github.com/rolandwalker/unicode-fonts")
    (synopsis "Configure Unicode fonts")
    (description
     "Quickstart: Configure an extended Latin font for your default face, such as
Monaco, Consolas, or DejaVu Sans Mono.  Install these fonts
https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/Symbola.zip
http://www.quivira-font.com/files/Quivira.ttf ; or Quivira.otf
http://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2
https://github.com/googlei18n/noto-fonts/raw/master/hinted/NotoSans-Regular.ttf
https://github.com/googlei18n/noto-fonts/raw/master/unhinted/NotoSansSymbols-Regular.ttf
Remove Unifont from your system. (require unicode-fonts) (unicode-fonts-setup)
Testing: C-h h ; M-x view-hello-file M-x list-charset-chars RET unicode-bmp RET
; search for 210x M-x list-charset-chars RET unicode-smp RET ; if your backend
supports astral chars M-x unicode-fonts-debug-insert-block RET
Mathematical_Operators RET Explanation: Emacs maintains font mappings on a
per-glyph basis, meaning that multiple fonts are used at the same time
(transparently) to display any character for which you have a font.
Furthermore, Emacs does this out of the box.  However, font mappings via
fontsets are a bit difficult to configure.  In addition, the default setup does
not always pick the most legible fonts.  As the manual warns, the choice of font
actually displayed for a non-ASCII character is \"somewhat random\".  The Unicode
standard provides a way to organize font mappings: it divides character ranges
into logical groups called \"blocks\".  This library configures Emacs in a
Unicode-friendly way by providing mappings from each Unicode block ---to---> a
font with good coverage and makes the settings available via the customization
interface.  This library provides font mappings for 233 of the 255 blocks in the
Unicode 8.0 standard which are public and have displayable characters.  It
assumes that 6 Latin blocks are covered by the default font.  16/255 blocks are
not mapped to any known font.  To use unicode-fonts, place the unicode-fonts.el
file somewhere Emacs can find it, and add the following to your ~/.emacs file:
(require unicode-fonts) (unicode-fonts-setup) See important notes about startup
speed below.  To gain any benefit from the library, you must have fonts with
good Unicode support installed on your system.  If you are running a recent
version of OS X or Microsoft Windows, you already own some good multi-lingual
fonts, though you would do very well to download and install the four items
below: From https://dejavu-fonts.github.io/ DejaVu Sans, DejaVu Sans Mono From
http://www.quivira-font.com/downloads.php Quivira From
https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/Symbola.zip Symbola Many
non-free fonts are referenced by the default settings.  However, free
alternatives are also given wherever possible, and patches are of course
accepted to improve every case.  On the assumption that an extended Latin font
such as Monaco, Consolas, or DejaVu Sans Mono is already being used for the
default face, no separate mappings are provided for the following Unicode
blocks: Basic Latin Latin Extended Additional Latin Extended-A Latin Extended-B
Latin-1 Supplement Spacing Modifier Letters though some of these remain
configurable via `customize'.  It is also recommended to remove GNU Unifont from
your system.  Unifont is very useful for debugging, but not useful for reading.
The default options favor correctness and completeness over speed, and can add
many seconds to initial startup time in GUI mode.  However, when possible a font
cache is kept between sessions.  If you have persistent-soft.el installed, when
you start Emacs the second time, the startup cost should be negligible.  The
disk cache will be rebuilt during Emacs startup whenever a font is added or
removed, or any relevant configuration variables are changed.  To increase the
speed of occasionally building the disk cache, you may use the customization
interface to remove fonts from `unicode-fonts-block-font-mapping which are not
present on your system.  If you are using a language written in Chinese or
Arabic script, try customizing `unicode-fonts-skip-font-groups to control which
script you see, and send a friendly bug report.  Color Emoji are enabled by
default when using the Native Mac port on OS X. This can be disabled by
customizing each relevant mapping, or by turning off all multicolor glyphs here:
M-x customize-variable RET unicode-fonts-skip-font-groups RET See Also M-x
customize-group RET unicode-fonts RET M-x customize-variable RET
unicode-fonts-block-font-mapping RET Notes Free fonts recognized by this package
may be downloaded from the following locations.  For any language, it is
increasingly likely that Noto Sans provides coverage: From
http://www.google.com/get/noto/ Noto Sans and friends ; 181 Unicode blocks and
counting; sole ; source for these blocks: ; ; Bamum / Bamum Supplement / Kaithi
; Mandaic / Meetei Mayek Extensions ; Sundanese Supplement ; ; Also a good
source for recently-added ; glyphs such as \"Turkish Lira Sign\".  From
http://scripts.sil.org/cms/scripts/page.php?item_id=CharisSIL_download or
http://scripts.sil.org/cms/scripts/page.php?item_id=DoulosSIL_download Charis
SIL or Doulos SIL ; Extended European and diacritics From
http://scripts.sil.org/cms/scripts/page.php?item_id=Gentium_download Gentium
Plus ; Greek From http://users.teilar.gr/~g1951d/ Aegean, Aegyptus, Akkadian ;
Ancient languages Analecta ; Ancient languages, Deseret Anatolian ; Ancient
languages Musica ; Musical Symbols Nilus ; Ancient languages From
http://www.wazu.jp/gallery/views/View_MPH2BDamase.html MPH 2B Damase ; Arabic,
Armenian, Buginese, Cherokee, Georgian, ; Glagolitic, Hanunoo, Kharoshthi,
Limbu, Osmanya, ; Shavian, Syloti Nagri, Tai Le, Thaana From
http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=NamdhinggoSIL
Namdhinggo SIL ; Limbu From http://wenq.org/wqy2/index.cgi?FontGuide WenQuanYi
Zen Hei ; CJK (Simplified Chinese) From http://babelstone.co.uk/Fonts/
BabelStone Han ; CJK (Simplified Chinese) BabelStone Phags-pa Book ; Phags-pa
BabelStone Modern ; Tags / Specials / Selectors From
http://vietunicode.sourceforge.net/fonts/fonts_hannom.html HAN NOM A, HAN NOM B
; CJK (Nôm Chinese) From http://kldp.net/projects/unfonts/ Un Batang ; CJK
(Hangul) From http://sourceforge.jp/projects/hanazono-font/releases/ Hana Min A,
Hana Min B ; CJK (Japanese) From
http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=SILYi_home Nuosu SIL
; CJK (Yi) From http://www.daicing.com/manchu/index.php?page=fonts-downloads
Daicing Xiaokai ; Mongolian From http://www.library.gov.bt/IT/fonts.html
Jomolhari ; Tibetan From
http://www.thlib.org/tools/scripts/wiki/tibetan%20machine%20uni.html Tibetan
Machine Uni ; Tibetan From
http://scripts.sil.org/cms/scripts/page.php?item_id=Padauk Padauk ; Myanmar From
https://code.google.com/p/myanmar3source/downloads/list Myanmar3 ; Myanmar From
http://www.yunghkio.com/unicode/ Yunghkio ; Myanmar From
https://code.google.com/p/tharlon-font/downloads/list TharLon ; Myanmar From
http://sourceforge.net/projects/prahita/files/Myanmar%20Unicode%20Fonts/MasterpieceUniSans/
Masterpiece Uni Sans ; Myanmar From http://sarovar.org/projects/samyak/ Samyak ;
Gujarati, Malayalam, Oriya, Tamil From
http://software.sil.org/annapurna/download/ Annapurna SIL ; Devanagari From
http://guca.sourceforge.net/typography/fonts/anmoluni/ AnmolUni ; Gurmukhi From
http://brahmi.sourceforge.net/downloads2.html Kedage ; Kannada From
http://www.omicronlab.com/bangla-fonts.html Mukti Narrow ; Bengali From
http://www.kamban.com.au/downloads.html Akshar Unicode ; Sinhala From
http://tabish.freeshell.org/eeyek/download.html Eeyek Unicode ; Meetei Mayek
From http://scripts.sil.org/CMS/scripts/page.php?&item_id=Mondulkiri Khmer
Mondulkiri ; Khmer From http://www.laoscript.net/downloads/ Saysettha MX ; Lao
From http://www.geocities.jp/simsheart_alif/taithamunicode.html Lanna Alif ; Tai
Tham From
http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=DaiBannaSIL Dai
Banna SIL ; New Tai Lue From
http://scripts.sil.org/cms/scripts/page.php?item_id=TaiHeritage Tai Heritage Pro
; Tai Viet From http://sabilulungan.org/aksara/ Sundanese Unicode ; Sundanese
From http://www.amirifont.org/ Amiri ; Arabic (Naskh) From
http://scripts.sil.org/cms/scripts/page.php?item_id=Scheherazade Scheherazade ;
Arabic (Naskh) From http://www.farsiweb.ir/wiki/Persian_fonts Koodak ; Arabic
(Farsi) From http://openfontlibrary.org/font/ahuramazda/ Ahuramzda ; Avestan
From http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=AbyssinicaSIL
Abyssinica SIL ; Ethiopic From
http://www.bethmardutho.org/index.php/resources/fonts.html Estrangelo Nisibin ;
Syriac From http://www.evertype.com/fonts/nko/ Conakry ; N'ko From
http://uni.hilledu.com/download-ribenguni Ribeng ; Chakma From
http://www.virtualvinodh.com/downloads Adinatha Tamil Brahmi ; Brahmi From
http://ftp.gnu.org/gnu/freefont/ FreeMono, etc (FreeFont) ; Kayah Li (and
others) From http://ulikozok.com/aksara-batak/batak-font/ Batak-Unicode ; Batak
From http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=Mingzat Mingzat
; Lepcha From http://phjamr.github.io/lisu.html#install
http://phjamr.github.io/miao.html#install
http://phjamr.github.io/mro.html#install Miao Unicode ; Miao Lisu Unicode ; Lisu
Mro Unicode ; Mro From http://scholarsfonts.net/cardofnt.html Cardo ; Historical
Languages From http://sourceforge.net/projects/junicode/files/junicode/ Junicode
; Historical Languages From http://www.evertype.com/fonts/vai/ Dukor ; Vai From
http://sourceforge.net/projects/zhmono/ ZH Mono ; Inscriptional Pahlavi /
Parthian From http://culmus.sourceforge.net/ancient/index.html Aramaic Imperial
Yeb ; Imperial Aramaic From http://www.languagegeek.com/font/fontdownload.html
Aboriginal Sans ; Aboriginal Languages Aboriginal Serif From
http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=EzraSIL_Home Ezra
SIL ; Hebrew From http://www.evertype.com/fonts/coptic/ Antinoou ; Coptic /
General Punctuation From http://apagreekkeys.org/NAUdownload.html New Athena
Unicode ; Ancient Languages / Symbols From
http://markmail.org/thread/g57mk4sbdycblxds KhojkiUnicodeOT ; Khojki From
https://github.com/andjc/ahom-unicode/tree/master/font AhomUnicode ; Ahom From
https://github.com/MihailJP/oldsindhi/releases OldSindhi ; Khudawadi From
https://github.com/MihailJP/Muktamsiddham/releases MuktamsiddhamG ; Siddham
(note trailing \"G\" on font name) From
https://github.com/MihailJP/MarathiCursive/releases MarathiCursiveG ; Modi (note
trailing \"G\" on font name) From
https://github.com/OldHungarian/old-hungarian-font/releases OldHungarian ; Old
Hungarian From http://tutohtml.perso.sfr.fr/unicode.html Albanian ; Elbasan /
Takri / Sharada From
https://github.com/enabling-languages/cham-unicode/tree/master/fonts/ttf Cham
OI_Tangin ; Cham From https://ctan.org/tex-archive/fonts/Asana-Math?lang=en
Asana Math ; Mathematical Symbols Compatibility and Requirements GNU Emacs
version 23.3 and higher : yes GNU Emacs version 22.3 and lower : no Requires
font-utils.el, ucs-utils.el Bugs The default choice of font for each code block
balances coverage versus appearance.  This is necessarily subjective.  Unicode
also defines the notion of a \"script\" as a higher-level abstraction which is
independent of \"blocks\".  Modern fonts can report their script coverage, and
Emacs may also access that information.  However, this library ignores scripts
in favor of blocks and glyphs.  Checking for font availability is slow.  This
library can add anywhere between 0.1 - 10 secs to startup time.  It is slowest
under X11.  Some per-architecture limitations are documented in font-utils.el
Calling `set-fontset-font can easily crash Emacs.  There is a workaround, but it
may not be sufficient on all platforms.  Tested on Cocoa Emacs, Native Mac
Emacs, X11/XQuartz, MS Windows XP. Glyph-by-glyph fallthrough happens
differently depending on the font backend.  On Cocoa Emacs, glyph-by-glyph
fallthrough does not occur, and manual per-glyph overrides are required to
maximize coverage.  Fallthrough works on MS Windows, but not perfectly.
X11/FreeType behaves most predictably.  The following ranges cannot be
overridden within the \"fontset-default\" fontset: Latin Extended Additional Latin
Extended-B Spacing Modifier Letters `unicode-fonts-overrides-mapping shows some
order-dependence, which must indicate a bug in this code.  A number of the
entries in `unicode-fonts-overrides-mapping are workarounds for the font Monaco,
and therefore specific to OS X. Widths of alternate fonts do not act as expected
on MS Windows.  For example, DejaVu Sans Mono box-drawing characters may use a
different width than the default font.  TODO provide additional interfaces -
dump set-fontset-font instructions - immediately set font for
character/current-character/range - recommend font for current character -
alternatives to customize, which can be called before unicode-fonts-setup - eg
\"prefer this font for this block\" - also character/range ie overrides scripts vs
blocks - further doc note - provide alternative interface via scripts reorganize
font list by language? - break down into living/dead/invented support MUFI for
PUA support ConScript for PUA Aramaic as a style of Hebrew
(set-language-environment \"UTF-8\") ? Include all Windows 8 fonts Include all
Windows 10 fonts Remove very old Microsoft entries (eg Monotype.com which was
renamed Andale) Recognize the default font and make smarter choices when it is
one of the provided mappings. (On Cocoa, the default font is returned when
font-info fails, which is not a good thing overall.) For every font, list font
version and unicode blocks which are complete.  Note all decorative fonts Adobe
international fonts which are supplied with Reader Apple fonts which could not
be mapped Wawati TC Weibei TC Weibei SC Wawati SC ; License Simplified BSD
License: Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 1.
Redistributions of source code must retain the above copyright notice, this list
of conditions and the following disclaimer.  2.  Redistributions in binary form
must reproduce the above copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other materials provided with
the distribution.  This software is provided by Roland Walker \"AS IS\" and any
express or implied warranties, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose are
disclaimed.  In no event shall Roland Walker or contributors be liable for any
direct, indirect, incidental, special, exemplary, or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) however caused and on
any theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.  The views and
conclusions contained in the software and documentation are those of the authors
and should not be interpreted as representing official policies, either
expressed or implied, of Roland Walker.  No rights are claimed over data created
by the Unicode Consortium, which are included here under the terms of the
Unicode Terms of Use.")
    (license license:bsd-2)))

(define-public emacs-uuidgen
  (package
    (name "emacs-uuidgen")
    (version "20220405.1345")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kanru/uuidgen-el.git")
                    (commit "7b728c1d92e196c3acf87a004949335cfc18eab3")))
              (sha256
               (base32
                "1z7x4p1qgyginn74xapd1iq0k53m9qbfk57dzc8srg7fcn5ip1js"))))
    (build-system emacs-build-system)
    (home-page "unspecified")
    (synopsis "Provides various UUID generating functions")
    (description
     "This is a naive implementation of RFC4122 Universally Unique IDentifier
generation in elisp.  Currently implemented are UUID v1 v3, v4 and v5
generation.  The resolution of the time based UUID is microseconds, which is 10
times of the suggested 100-nanosecond resolution, but should be enough for
general usage.  Get development version from git: git clone
git://github.com/kanru/uuidgen-el.git")
    (license license:gpl3)))

(define-public emacs-verb
  (package
    (name "emacs-verb")
    (version "20221113.2327")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/federicotdn/verb.git")
                    (commit "cb07a35bac5e2e3400d8f9e764177b9a9457deb1")))
              (sha256
               (base32
                "1psah3k956hkl3qw3hjzfw89lcvcjp3zh6ap9ln0p9d8q696zmba"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/federicotdn/verb")
    (synopsis "Organize and send HTTP requests")
    (description
     "Verb is a package that allows you to organize and send HTTP requests from Emacs.
 See the project's README.md file for more details.")
    (license license:gpl3)))
