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
