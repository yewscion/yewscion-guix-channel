(define-module (cdr255 tex)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system perl)
  #:use-module (guix build-system python)
  #:use-module (guix build-system qt)
  #:use-module (guix build-system trivial)
  #:use-module (guix build-system texlive)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (guix git-download)
  #:use-module (guix svn-download)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gd)
  #:use-module (gnu packages ghostscript)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages tex)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:hide (zip)))

(define (find-all-files-with-suffix directory suffix)
  (scandir directory
           (lambda (x)
             (pattern-in-suffix? x suffix (+ 1 (string-length suffix))))))
(define (pattern-in-suffix? item pattern suffix)
  (if (and (>= (string-length item) (string-length pattern))
           (>= (string-length item) suffix))
      (string-contains item pattern (- (string-length item) suffix))
      #f))

(define-syntax copy-sty
  (syntax-rules ()
    ((copy-sty package-name prefix-name package-version)
     (begin
       `(let*
           ((out
             (assoc-ref outputs
                        "out"))
            (dest-script
             (string-append out
                            "/share/texmf-dist/scripts/"
                            package-name
                            "/"))
            (dest-sty
             (string-append out
                            "/share/texmf-dist/tex/"
                            prefix-name
                            "/"
                            package-name
                            "/"))
            (source-sty (find-files "./build/" ".*\\.sty")))
         (mkdir-p dest-sty)
         (for-each (lambda (x)
                     (install-file x
                                   dest-sty))
                   source-sty))))))

(define* (simple-texlive-package name locations hash
                                 #:key trivial?)
  "Return a template for a simple TeX Live package with the given NAME,
downloading from a list of LOCATIONS in the TeX Live repository, and expecting
the provided output HASH.  If TRIVIAL? is provided, all files will simply be
copied to their outputs; otherwise the TEXLIVE-BUILD-SYSTEM is used."
  (define with-documentation?
    (and trivial?
         (any (lambda (location)
                (string-prefix? "/doc" location))
              locations)))
  (package
   (name name)
   (version (number->string %texlive-revision))
   (source (texlive-origin name version
                           locations hash))
   (outputs (if with-documentation?
                '("out" "doc")
                '("out")))
   (build-system (if trivial?
                     gnu-build-system
                     texlive-build-system))
   (arguments
    (let ((copy-files
           `(lambda* (#:key outputs inputs #:allow-other-keys)
              (let (,@(if with-documentation?
                          `((doc (string-append (assoc-ref outputs "doc")
                                                "/share/texmf-dist/")))
                          '())
                    (out (string-append (assoc-ref outputs "out")
                                        "/share/texmf-dist/")))
                ,@(if with-documentation?
                      '((mkdir-p doc)
                        (copy-recursively
                         (string-append (assoc-ref inputs "source") "/doc")
                         (string-append doc "/doc")))
                      '())
                (mkdir-p out)
                (copy-recursively "." out)
                ,@(if with-documentation?
                      '((delete-file-recursively (string-append out "/doc")))
                      '())
                #t))))
      (if trivial?
          `(#:tests? #f
            #:phases
            (modify-phases %standard-phases
                           (delete 'configure)
                           (replace 'build (const #t))
                           (replace 'install ,copy-files)))
          `(#:phases
            (modify-phases %standard-phases
                           (add-after 'install 'copy-files ,copy-files))))))
   (home-page #f)
   (synopsis #f)
   (description #f)
   (license #f)))
;;; Start
(use-modules (gnu packages lisp)
             (gnu packages lisp-xyz))
(define-public texlive-latex-lwarp
  (package
   (name "texlive-latex-lwarp")
   (version (string-append
             (number->string %texlive-revision)
             "-1"))
   (outputs '("out" "doc"))
   (source
    (texlive-origin
     name
     (number->string %texlive-revision)
     (list "doc/latex/lwarp/"
           "scripts/lwarp/"
           "source/latex/lwarp/")
     (base32 "079hwbsj3a27j4a0yrcvnlq33hijmk0l0szyfssj9ns6habnrygk")))
   (build-system texlive-build-system)
   (arguments
    `(#:build-targets '("lwarp.ins")
      #:link-scripts '("lwarpmk")
      #:phases
      (modify-phases
       %standard-phases
       (add-before 'install
                   'prep-install
                   (lambda* (#:key outputs #:allow-other-keys)
                     (invoke "ls")
                     (display (getcwd))
                     (rename-file (string-append (getcwd)
                                                 "/scripts/lwarp/lwarpmk.lua")
                                  (string-append (getcwd)
                                                 "/scripts/lwarp/lwarpmk"))))
       (add-after 'install
                  'install-more
                  (lambda* (#:key outputs #:allow-other-keys)
                    ,(copy-sty "lwarp" "latex" (version)))))))
   (propagated-inputs (list lua
                            perl
                            poppler
                            xindy
                            texlive-scheme-basic))
   (home-page "https://ctan.org/pkg/lwarp")
   (synopsis "Converts LaTeX to HTML")
   (description
    "This package converts LaTeX to HTML by using LaTeX to process the user's
document and generate HTML tags.  External utility programs are only used for
the final conversion of text and images.  Math may be represented by SVG files
or MathJax.  Hundreds of LaTeX packages are supported, and their load order is
automatically verified.  Documents may be produced by LaTeX, LuaLaTeX, XeLaTeX,
and by several CJK engines, classes, and packages.  A texlua script automates
compilation, index, glossary, and batch image processing, and also supports
latexmk.  Configuration is semi-automatic at the first manual compile.  Support
files are self-generated.  Print and HTML versions of each document may coexist.
Assistance is provided for HTML import into EPUB conversion software and word
processors.  Requirements include the commonly-available Poppler utilities, and
Perl.  Detailed installation instructions are included for each of the major
operating systems and TeX distributions.  A quick-start tutorial is provided.")
   (license license:lppl1.3c+)))
(define-public texlive-generic-ifptex
  (let ((template (simple-texlive-package
                   "texlive-generic-ifptex"
                   (list "/doc/generic/ifptex/"
                         "/tex/generic/ifptex/")
                   (base32
                    "0l5mclz9cwj756ah0nqbiai0b5m9368dz4ykb0ih5irm6cmswdfm")
                   #:trivial? #t)))
    (package
     (inherit template)
     (home-page "https://ctan.org/pkg/ifptex")
     (synopsis "Check if the engine is pTeX or one of its derivatives")
     (description "The ifptex package is a counterpart of ifxetex, ifluatex,
etc. for the ptex engine.  The ifuptex package is an alias to ifptex provided
for backward compatibility.")
     (license license:expat))))
(define-public texlive-latex-xpatch
  (package
   (name "texlive-latex-xpatch")
   (version (string-append
             (number->string %texlive-revision)
             "-1"))
   (outputs '("out" "doc"))
   (source
    (texlive-origin
     name
     (number->string %texlive-revision)
     (list "doc/latex/xpatch/"
           "source/latex/xpatch/")
     (base32 "1q5v8h52kmvwzsdqbr1blqln1mragynsbwk3bcp2icnldzclrj6z")))
   (build-system texlive-build-system)
   (arguments
    `(#:build-targets '("xpatch.ins")
                      #:phases (modify-phases
                                %standard-phases
                                (add-after 'unpack
                                           'set-TEXINPUTS
                                           (lambda _
                                             (let ((cwd (getcwd)))
                                               (setenv "TEXINPUTS"
                                                       (string-append
                                                        cwd
                                                        "/source/latex/xpatch:")))))
                                (add-after 'install
                                           'install-more
                                  (lambda* (#:key outputs #:allow-other-keys)
                                             ,(copy-sty "xpatch" "latex" (version)))))))
   (home-page "https://ctan.org/pkg/xpatch")
   (synopsis "Extending etoolbox patching commands")
   (description
    "The package generalises the macro patching commands provided by
Philipp Lehmann’s etoolbox.")
   (license license:lppl1.3)))
(define-public texlive-latex-catchfile
  (package
   (name "texlive-latex-catchfile")
   (version (string-append
             (number->string %texlive-revision)
             "-1"))
   (outputs '("out" "doc"))
   (source
    (texlive-origin
     name
     (number->string %texlive-revision)
     (list "doc/latex/catchfile/"
           "source/latex/catchfile/")
     (base32 "1sbjp8k5vxhrniwqjb61d2562vzi5bz6vrn1hml9rj5p9wi8js4c")))
   (build-system texlive-build-system)
   (arguments
    `(#:build-targets '("catchfile.dtx")
                      #:phases (modify-phases
                                %standard-phases
                                (add-after 'unpack
                                           'set-TEXINPUTS
                                           (lambda _
                                             (let ((cwd (getcwd)))
                                               (setenv "TEXINPUTS"
                                                       (string-append
                                                        cwd
                                                        "/source/latex/catchfile:")))))
                                (add-after 'install 'install-more
                                           (lambda* (#:key outputs #:allow-other-keys)
                                             ,(copy-sty "catchfile" "latex" (version)))))))
   (home-page "https://ctan.org/pkg/catchfile")
   (synopsis "Catch an external file into a macro")
   (description
    "This package catches the contents of a file and puts it in a macro.  It
requires e-TeX.  Both LaTeX and plain TeX are supported.")
   (license license:lppl1.3)))
(define-public texlive-latex-comment
  (let ((template (simple-texlive-package
                   "texlive-latex-comment"
                   (list "/doc/latex/comment/"
                         "/tex/latex/comment/")
                   (base32
                    "1c1mqziwxyf1bqzpw6ji65n7ypygm3lyknblxmf0c70w0ivw76pa")
                   #:trivial? #t)))
    (package
     (inherit template)
     (home-page "https://ctan.org/pkg/comment")
     (synopsis "Selectively include/exclude portions of text")
     (description "Selectively include/exclude pieces of text, allowing the
user to define new, separately controlled, comment versions.  All text between
\\comment ...  \\endcomment or \\begin{comment} ...  \\end{comment} is
discarded.  The opening and closing commands should appear on a line of their
own.  No starting spaces, nothing after it.  This environment should work with
arbitrary amounts of comment, and the comment can be arbitrary text.

Other ‘comment’ environments are defined and selected/deselected with
\\includecomment{versiona} and \\excludecoment{versionb} These environments are
used as \\versiona … \\endversiona or \\begin{versiona} … \\end{versiona} with
the opening and closing commands again on a line of their own.")
     (license license:gpl2))))
(define-public texlive-latex-setspace
  (let ((template (simple-texlive-package
                   "texlive-latex-setspace"
                   (list "/tex/latex/setspace/"
                         "/doc/latex/setspace/")
                   (base32
                    "0bvspbka1jhpysyhh3sd1vkkm6xjj2ahj0mzv2inzqbrrbydr9gr")
                   #:trivial? #t)))
    (package
     (inherit template)
     (home-page "https://ctan.org/pkg/setspace")
     (synopsis "Set space between lines")
     (description "Provides support for setting the spacing between lines in a
document.  Package options include singlespacing, onehalfspacing, and
doublespacing.  Alternatively the spacing can be changed as required with the
\\singlespacing, \\onehalfspacing, and \\doublespacing commands.  Other size
spacings also available.")
     (license license:lppl1.3c))))
(define-public texlive-latex-endfloat
  (package
   (name "texlive-latex-endfloat")
   (version (string-append
             (number->string %texlive-revision)
             "-1"))
   (outputs '("out" "doc"))
   (source
    (texlive-origin
     name
     (number->string %texlive-revision)
     (list "doc/latex/endfloat/"
           "source/latex/endfloat/")
     (base32 "0q1k8qbm704xbgrnaj5dv1rbkfyyzd65m8ybrip334gsmn4223ni")))
   (build-system texlive-build-system)
   (arguments
    `(#:build-targets '("endfloat.ins")
                      #:phases (modify-phases
                                %standard-phases
                                (add-after 'unpack
                                           'set-TEXINPUTS
                                           (lambda _
                                             (let ((cwd (getcwd)))
                                               (setenv "TEXINPUTS"
                                                       (string-append
                                                        cwd
                                                        "/source/latex/endfloat:")))
                                             (delete-file-recursively
                                              "source/latex/endfloat/endfloat.drv")))
                                (add-after 'install 'install-more
                                           (lambda* (#:key outputs #:allow-other-keys)
                                             ,(copy-sty "endfloat" "latex" (version)))))))
   (home-page "https://ctan.org/pkg/endfloat")
   (synopsis "Move floats to the end, leaving markers where they belong")
   (description
    "Place all floats on pages by themselves at the end of the document,
optionally leaving markers like “[Figure 3 about here]” in the text near to
where the figure (or table) would normally have occurred.  Float types figure
and table are recognised by the package, unmodified.  Since several packages
define other types of float, it is possible to register these float types with
endfloat.")
   (license license:gpl3)))
(define-public texlive-latex-minted
  (package
   (name "texlive-latex-minted")
   (version (string-append
             (number->string %texlive-revision)
             "-1"))
   (outputs '("out" "doc"))
   (source
    (texlive-origin
     name
     (number->string %texlive-revision)
     (list "doc/latex/minted/"
           "source/latex/minted/")
     (base32 "14b6xdp8yzmams9gxqk3bmwna6d2c3h90wgkl4sgf302m67fqh74")))
   (build-system texlive-build-system)
   (arguments
    `(#:build-targets
      '("minted.ins")
      #:phases
      (modify-phases
       %standard-phases
       (add-after 'unpack
                  'set-TEXINPUTS
                  (lambda _
                    (let ((cwd (getcwd)))
                      (setenv "TEXINPUTS"
                              (string-append
                               cwd
                               "/source/latex/minted:")))))
       (add-after 'install 'install-more
                  (lambda* (#:key outputs #:allow-other-keys)
                    ,(copy-sty "minted" "latex" (version))
                    )))))
    (home-page "https://ctan.org/pkg/minted")
    (synopsis "Highlighted source code for LaTeX")
    (description
     "The package that facilitates expressive syntax highlighting in LaTeX using
the powerful Pygments library.  The package also provides options to customize
the highlighted source code output using fancyvrb.")
    (license license:lppl1.3)))
  (define-public texlive-latex-fvextra
    (package
     (name "texlive-latex-fvextra")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/fvextra/"
             "source/latex/fvextra/")
       (base32 "0jmhrh43lxjiy0p6308bmqpgfxf7b3rl0n9hkph3dzii9z7czw2h")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("fvextra.ins")
                        #:phases (modify-phases
                                  %standard-phases
                                  (add-after 'unpack
                                             'set-TEXINPUTS
                                             (lambda _
                                               (let ((cwd (getcwd)))
                                                 (setenv "TEXINPUTS"
                                                         (string-append
                                                          cwd
                                                          "/source/latex/fvextra:")))))
                                  (add-after 'install 'install-more
                  (lambda* (#:key outputs #:allow-other-keys)
                    ,(copy-sty "minted" "latex" (version)))))))
     (home-page "https://ctan.org/pkg/fvextra")
     (synopsis "Extensions and patches for fancyvrb")
     (description
      "fvextra provides several extensions to fancyvrb, including automatic line
breaking and improved math mode.  It also patches some fancyvrb internals.
Parts of fvextra were originally developed as part of pythontex and minted.")
     (license license:lppl1.3)))
  (define-public texlive-latex-lineno
    (let ((template (simple-texlive-package
                     "texlive-latex-lineno"
                     (list "/tex/latex/lineno/"
                           "/doc/latex/lineno/")
                     (base32
                      "1naqdd62gld0hx6ss0d7sllnbqslzxjcgzj7cnycs303lb03h738")
                     #:trivial? #t)))
      (package
       (inherit template)
       (home-page "https://ctan.org/pkg/lineno")
       (synopsis "Line numbers on paragraphs")
       (description "Adds line numbers to selected paragraphs with reference
possible through the LaTeX \\ref and \\pageref cross reference mechanism.

Line numbering may be extended to footnote lines, using the fnlineno package.")
       (license license:lppl1.3a+))))
  (define-public texlive-latex-datetime2
    (package
     (name "texlive-latex-datetime2")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/datetime2/"
             "source/latex/datetime2/")
       (base32 "068l3zj9d5h6j078xsxqmzvfbj599xfcnkd7v4an31d1v21x2qc7")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("datetime2.ins")
        #:phases (modify-phases
                  %standard-phases
                  (add-after 'unpack
                             'set-TEXINPUTS
                             (lambda _
                               (let ((cwd (getcwd)))
                                 (setenv "TEXINPUTS"
                                         (string-append
                                          cwd
                                          "/source/latex/datetime2:")))))
                  (add-after 'install 'install-more
                    (lambda* (#:key outputs #:allow-other-keys)
                      ,(copy-sty "datetime2" "latex" (version)))))))
     (home-page "https://ctan.org/pkg/datetime2")
     (synopsis "Formats for dates, times and time zones")
     (description
      "This package provides commands for formatting dates, times and time zones
and redefines \\today to use the same formatting style.  In addition to \\today,
you can also use \\DTMcurrenttime (current time) or \\DTMnow (current date and
time).  Dates and times can be saved for later use.

The accompanying datetime2-calc package can be used to convert date-times to
UTC+00:00.

Language and regional support is provided by independently maintained and
installed modules.

The datetime2-calc package uses the pgfcalendar package (part of the PGF/TikZ
bundle).

This package replaces datetime.sty which is now obsolete.")
     (license license:lppl1.3)))
(define-public texlive-latex-datetime2-english
    (package
     (name "texlive-latex-datetime2-english")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/datetime2-english/"
             "source/latex/datetime2-english/")
       (base32 "1nh1lmbgaf4axkvcqkf70gsyr51m3wpjmqc6gvsqv8i3461s0gik")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("datetime2-english.ins")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/latex/datetime2-english:")))))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       (let*
                           ((out
                             (assoc-ref outputs
                                        "out"))
                            (dest-ldf
                             (string-append
                              out
                              "/share/texmf-dist/"
                              "tex/latex/datetime2-contrib/datetime2-english/"))
                            (source-ldf (find-files "./build/" ".*\\.ldf")))
                         (mkdir-p dest-ldf)
                         (for-each (lambda (x)
                                     (install-file x
                                                   dest-ldf))
                                   source-ldf)))))))
     (home-page "https://ctan.org/pkg/datetime2-english")
     (synopsis "English language module for the datetime2 package")
     (description
      "This module provides the following styles that can be set using
\\DTMsetstyle provided by datetime2.sty.  The region not only determines the
date/time format but also the time zone abbreviations if the zone mapping
setting is on.

- english (English – no region)
- en-GB (English – United Kingdom of Great Britain and Northern Ireland)
- en-US (English – United States of America)
- en-CA (English – Canada) en-AU (English – Commonwealth of Australia)
- en-NZ (English – New Zealand) en-GG (English – Bailiwick of Guernsey)
- en-JE (English – Bailiwick of Jersey) en-IM (English – Isle of Man)
- en-MT (English – Republic of Malta) en-IE (English – Republic of Ireland)")
     (license license:lppl1.3)))
  (define-public xindy
    (let ((revision "1")
          (package-version "2.5.1"))
      (package
       (name "xindy")
       (version  (string-append package-version "-"
                                revision "-"
                                (number->string %texlive-revision)))
       (source (origin
                (method svn-fetch)
                (uri (svn-reference
                      (url "svn://www.tug.org/texlive/tags/texlive-2023.0/Build/source/utils/xindy/xindy-src/")
                      (revision %texlive-revision)))
                (sha256
                 (base32
                  "1g93sg56xlj96jd7ry65z874n757kfbgldv8w9k81gjv0300zpay"))))
       (build-system gnu-build-system)
       (arguments
        '(#:phases
          (modify-phases
           %standard-phases
           (add-before 'configure 'autoreconf
                       (lambda* _
                         (system "autoreconf -fiv")))
           )))
       (native-inputs (list pkg-config
                            autoconf
                            automake
                            clisp
                            sed
                            perl
                            texlive-ec
                            texlive-scheme-basic
                            libiconv
                            texlive-inputenx
                            texlive-cm-super
                            texlive-cyrillic
                            texlive-latex-bin))
       (home-page "https://ctan.org/pkg/xindy")
       (description
        "Xindy was developed after an impasse had been encountered in the attempt
to complete internationalisation of makeindex.

Xindy can be used to process indexes for documents marked up using (La)TeX,
Nroff family and SGML-based languages.  Xindy is highly configurable, both in
markup terms and in terms of the collating order of the text being processed.")
       (synopsis "General-purpose index processor.")
       (license license:gpl3))))
  (define-public texlive-latex-everyhook
    (let ((template (simple-texlive-package
                     "texlive-latex-everyhook"
                     (list "/tex/latex/everyhook/"
                           "/doc/latex/everyhook/")
                     (base32
                      "0kpx1shj9qjzdh5qqnmlz6vn0c2lji8068sw3cmzdyvidk03n5g3")
                     #:trivial? #t)))
      (package
       (inherit template)
       (home-page "https://ctan.org/pkg/everyhook")
       (synopsis "Hooks for standard TeX token lists")
       (description "The package takes control of the six TeX token registers
\\everypar, \\everymath, \\everydisplay, \\everyhbox, \\everyvbox and
\\everycr.  Real hooks for each of the registers may be installed using a stack
like interface.  For backwards compatibility, each of the \\everyX token lists
can be set without interfering with the hooks.")
       (license license:lppl1.3))))
  (define-public texlive-latex-printlen
    (let ((template (simple-texlive-package
                     "texlive-latex-printlen"
                     (list "/tex/latex/printlen/"
                           "/doc/latex/printlen/")
                     (base32
                      "0pha10m0zgsp4zs100kjlf1zgdj2dsb1i1a6ng3wamhbq8l0508l")
                     #:trivial? #t)))
      (package
       (inherit template)
       (home-page "https://ctan.org/pkg/latex-printlen")
       (description
        "Macros to Print LaTeX values in standard units.  \\printlength{length}
prints the value of a LaTeX length in the units specified by
\\uselengthunit{unit} (‘unit’ may be any TeX length unit except for scaled
point, viz., any of: pt, pc, in, mm, cm, bp, dd or cc).  When the unit is pt,
the printed length value will include any stretch or shrink; otherwise these are
not printed.  The ‘unit’ argument may also be PT, in which case length values
will be printed in point units but without any stretch or shrink values.")
       (synopsis "Print lengths using specified units.")
       (license license:lppl))))
  (define-public texlive-latex-cleveref
    (package
     (name "texlive-latex-cleveref")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/cleveref/"
             "source/latex/cleveref/")
       (base32 "1sycqkdvpv3aha6dh6syghh3lh3zzlld610r2ypd50dpdvj0vl7z")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("cleveref.ins")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/latex/cleveref:")))))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       ,(copy-sty "cleveref" "latex" (version)))))))
     (home-page "https://ctan.org/pkg/cleveref")
     (synopsis "intelligent cross-referencing")
     (description
      "This package enhances LaTeX’s cross-referencing features, allowing the
format of references to be determined automatically according to the type of
reference.  The formats used may be customised in the preamble of a document;
babel support is available (though the choice of languages remains limited:
currently Danish, Dutch, English, French, German, Italian, Norwegian, Russian,
Spanish, and Ukranian).

This package also offers a means of referencing a list of references, each
formatted according to its type.  In such lists, it can collapse sequences of
numerically-consecutive labels to a reference range.")
     (license license:lppl1.2)))
  (define-public texlive-latex-readablecv
    (let ((template (simple-texlive-package
                     "texlive-latex-readablecv"
                     (list "/tex/latex/readablecv/"
                           "/doc/latex/readablecv/")
                     (base32
                      "12gjcwmli04pj2cgsj2g0xw2m0vczqs7kq9zirqakbkk7nb7w4g2")
                     #:trivial? #t)))
      (package
       (inherit template)
       (propagated-inputs (list texlive-latex-memoir))
       (home-page "https://ctan.org/pkg/readablecv")
       (synopsis "A highly readable and good looking CV and letter class")
       (description "This class provides an extremely attractive and highly readable CV structure for LaTeX.")
       (license license:lppl1.3))))
  (define-public texlive-latex-memoir
    (package
     (name "texlive-latex-memoir")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/memoir/"
             "source/latex/memoir/")
       (base32 "1y4m5z5z8ffvd26fg09vim629qp0rh5jw7bg9ik88gwcy550lg8f")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("memoir.ins" "mempatch.ins")
        #:phases (modify-phases
                     %standard-phases
                                  (add-after 'unpack
                                             'set-TEXINPUTS
                                             (lambda _
                                               (let ((cwd (getcwd)))
                                                 (setenv "TEXINPUTS"
                                                         (string-append
                                                          cwd
                                                          "/source/latex/memoir:")))))
                                  (add-after 'install 'install-more
                                    (lambda* (#:key outputs #:allow-other-keys)                                      
                                      ,(copy-sty "memoir" "latex" (version))

                                      (let*
                                          ((out
                                            (assoc-ref outputs
                                                       "out"))
                                           (dest
                                            (string-append out
                                                           "/share/texmf-dist/tex/"
                                                           "latex/memoir/"))
                                           (source-clo (find-files "./build/" ".*\\.clo"))
                                           (source-cls (find-files "./build/" ".*\\.cls"))
                                           (source-gst (find-files "./build/" ".*\\.gst"))
                                           (sources (append source-clo
                                                            source-cls
                                                            source-gst)))
                                        (mkdir-p dest)
                                        (for-each (lambda (x)
                                                    (install-file x
                                                                  dest))
                                                  sources)))))))
     (home-page "https://ctan.org/pkg/memoir")
     (synopsis "Typeset fiction, non-fiction and mathematical books")
     (description
      "The memoir class is for typesetting poetry, fiction, non-fiction, and mathematical works.

Permissible document ‘base’ font sizes range from 9 to 60pt. There is a range of
page-styles and well over a dozen chapter-styles to choose from, as well as
methods for specifying your own layouts and designs. The class also provides the
functionality of over thirty of the more popular packages, thus simplifying
document sources.

Users who wish to use the hyperref package, in a document written with the
memoir class, should also use the memhfixc package (part of this bundle). Note,
however, that any current version of hyperref actually loads the package
automatically if it detects that it is running under memoir. ")
     (license license:lppl1.3)))
  (define-public texlive-latex-lipsum
    (package
     (name "texlive-latex-lipsum")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/lipsum/"
             "source/latex/lipsum/")
       (base32 "13fqw9l139c18w4bj89ln1fzchfwqp5fgx57hc49r5ihdas8rd3h")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("lipsum.ins")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/latex/lipsum:")))))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       ,(copy-sty "lipsum" "latex" (version)))))))
     (home-page "https://ctan.org/pkg/lipsum")
     (synopsis "Easy access to the Lorem Ipsum and other dummy texts")
     (description
      "This package gives you easy access to 150 paragraphs of the Lorem Ipsum dummy text provided by https://lipsum.com, plus a growing list of other dummy texts in different languages.")
     (license license:lppl1.3)))
  (define-public texlive-latex-venndiagram
    (package
     (name "texlive-latex-venndiagram")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out" "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "doc/latex/venndiagram/"
             "source/latex/venndiagram/")
       (base32 "0isdki5qsiy8dskzhnx86sf6z1aln6f2y2zvpizy36qk5jwcji2x")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("venndiagram.ins")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/latex/venndiagram:")))))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       ,(copy-sty "venndiagram" "latex" (version)))))))
     (home-page "https://ctan.org/pkg/venndiagram")
     (synopsis "Creating Venn diagrams with TikZ")
     (description
      "The package assists generation of simple two- and three-set Venn diagrams for lectures or assignment sheets.")
     (license license:lppl)))
(define-public texlive-luatex-luamplib
  (package
    (name "texlive-luatex-luamplib")
    (version (string-append
               (number->string %texlive-revision)
               "-1"))
    (outputs '("out"
               "doc"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "source/luatex/luamplib/")
       (base32 "140ghg5l9vndgx62zfhs7cx93ibph6hjghy4267f6h4d45bizk2n")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("luamplib.dtx")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/luatex/luamplib:")))))
                   (add-after 'build 'build-docs
                     (lambda _
                       ;; From Makefile
                       (system "cd source/luatex/luamplib/ && latexmk -lualatex -recorder- luamplib.dtx")))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       (let*
                           ((dest
                              (string-append
                               (assoc-ref outputs
                                          "out")
                               "/share/texmf-dist/tex/"
                               "luatex/luamplib/"))
                            (dest-doc
                             (string-append
                              (assoc-ref outputs
                                         "doc")
                              "/texmf-dist/doc/luatex/luamplib/"))
                             (source-sty (find-files "./build/" ".*\\.sty"))
                             (source-lua (find-files "./build/" ".*\\.lua"))
                             (sources (append source-sty
                                              source-lua)))
                         (mkdir-p dest)
                         (mkdir-p dest-doc)
                         (install-file "./source/luatex/luamplib/luamplib.pdf"
                                       dest-doc)
                         (for-each (lambda (x)
                                     (install-file x
                                                   dest))
                                   sources)))))))
     (inputs (list texlive-libertine
                   texlive-latexmk
                   texlive-pdftexcmds
                   texlive-infwarerr
                   texlive-kvoptions
                   texlive-fontspec
                   texlive-hologo
                   texlive-hypdoc
                   texlive-epstopdf-pkg
                   texlive-metalogo
                   texlive-mdwtools
                   texlive-inconsolata
                   texlive-iwona
                   texlive-grfext
                   texlive-hologo
                   texlive-tools
                   texlive-fancyvrb
                   texlive-xcolor
                   texlive-hyperref
                   texlive-stringenc
                   texlive-lm
                   texlive-luaotfload))
     (home-page "https://ctan.org/pkg/luamplib")
     (synopsis "Use LuaTeX’s built-in METAPOST interpreter")
     (description
      "The package enables the user to specify METAPOST diagrams (which may include colour specifications from the color or xcolor packages) into a document, using LuaTeX’s built-in METAPOST library.

The facility is only available in PDF mode. ")
     (license license:gpl2)))
  (define-public texlive-hologo
    (package
     (name "texlive-hologo")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "source/generic/hologo/")
       (base32 "04d83z1pw6scg4cd1616ix291zi9dz5nnvw9xc8hd4lfxf15nx1c")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("hologo.dtx")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/latex/hologo:")))))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       ,(copy-sty "hologo" "latex" (version))))
                   )))
     (home-page "https://ctan.org/pkg/hologo")
     (synopsis "A collection of logos with bookmark support")
     (description
      "The package defines a single command \\hologo, whose argument is the usual case-confused ASCII version of the logo. The command is bookmark-enabled, so that every logo becomes available in bookmarks without further work.")
     (license license:lppl1.3c)))
  (define-public texlive-fonttable
    (package
     (name "texlive-fonttable")
     (version (string-append
               (number->string %texlive-revision)
               "-1"))
     (outputs '("out"))
     (source
      (texlive-origin
       name
       (number->string %texlive-revision)
       (list "source/latex/fonttable/")
       (base32 "1qjilvy77072jpbdc4p4qfy5d4n2ww2wcm5drwvai6p2aclqf29x")))
     (build-system texlive-build-system)
     (arguments
      `(#:build-targets '("fonttable.ins")
        #:phases (modify-phases
                     %standard-phases
                   (add-after 'unpack
                       'set-TEXINPUTS
                     (lambda _
                       (let ((cwd (getcwd)))
                         (setenv "TEXINPUTS"
                                 (string-append
                                  cwd
                                  "/source/latex/fonttable:")))))
                   ;;(add-after 'build 'build-docs
                   ;;(lambda _
                   ;; From Makefile
                   ;; Not Working 2023-08-11
                   ;;(system "cd source/latex/fonttable/ && pdflatex fonttable.dtx && pdflatex fonttable.dtx")))
                   (add-after 'install 'install-more
                     (lambda* (#:key outputs #:allow-other-keys)
                       ,(copy-sty "fonttable" "latex" (version))))
                   )))
     (inputs (list texlive-libertine
                   texlive-metalogo
                   texlive-amsfonts
                   texlive-bin
                   texlive-cm
                   texlive-pdftexcmds
                   texlive-infwarerr
                   texlive-kvoptions
                   texlive-fontspec
                   texlive-hypdoc
                   texlive-mdwtools
                   texlive-inconsolata
                   texlive-iwona
                   texlive-grfext
                   texlive-hologo
                   texlive-tools
                   texlive-fancyvrb
                   texlive-xcolor
                   texlive-hyperref
                   texlive-stringenc
                   texlive-lm
                   texlive-luaotfload))
     (home-page "https://ctan.org/pkg/fonttable")
     (synopsis "Print font tables from a LaTeX document")
     (description
      " This is a package version of nfssfont.tex (part of the LaTeX distribution); it enables you to print a table of the characters of a font and/or some text (for demonstration or testing purposes), from within a document. (Packages such as testfont and nfssfont.tex provide these facilities, but they run as interactive programs: the user is expected to type details of what is needed.)

Note that the package mftinc also has a \\fonttable function; the documentation explains how avoid a clash with that package.")
     (license license:lppl1.3c)))
