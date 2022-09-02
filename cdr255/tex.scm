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
       (base32 "19aj3wq990yw1px0g9wlwmmir9wrm9pr0fsra5j15ykllx3h215h")))
    (build-system texlive-build-system)
    (arguments
     `(#:tex-directory "latex/lwarp"
       #:build-targets '("lwarp.ins")
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
                                "/source/latex/lwarp:")))))
        (add-before 'install
                    'bin-script
                    (lambda* (#:key outputs #:allow-other-keys)
                      (call-with-output-file "lwarpmk"
                        (lambda (port)
                          (let* ((out
                                  (string-append
                                   (assoc-ref outputs "out")
                                   "/share/texmf-dist/scripts")))
                            (display
                             (string-append
                              "#!/bin/bash\n"
                              "exec -a \"$0\" \""
                              out
                              "/lwarp/lwarpmk.lua\" \"$@\"")
                                              port))))
                      (chmod "lwarpmk" #o755)))
        (add-after 'install
                   'install-more
                   (lambda* (#:key outputs #:allow-other-keys)
                     (let*
                         ((out
                           (assoc-ref outputs
                                      "out"))
                          (dest-bin
                           (string-append out
                                          "/bin"))
                          (dest-script
                           (string-append out
                                          "/share/texmf-dist/scripts/lwarp/"))
                          (dest-doc
                           (string-append (assoc-ref outputs "doc")
                                          "/share/doc/" ,name "-" ,version))
                          (source-doc "doc/latex/lwarp/"))
                       (install-file "lwarpmk"
                                     dest-bin)
                       (install-file "scripts/lwarp/lwarpmk.lua"
                                     dest-script)
                       (install-file (string-append source-doc
                                                    "lwarp.pdf")
                                                    dest-doc)
                       (install-file (string-append source-doc
                                                    "lwarp_tutorial.txt")
                                                    dest-doc)
                       (install-file (string-append source-doc
                                                    "/README.txt")
                                                    dest-doc)))))))
    (propagated-inputs (list lua
                             perl
                             poppler
                             xindy
                             texlive-base))
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
                    "1ig52bijh6jm7pdg91nqx3l5wq0fdajg2zr4v450gnyzzc8d3gky")
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
     `(#:tex-directory "latex/xpatch"
       #:build-targets '("xpatch.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/xpatch/"))
                                (install-file (string-append source-doc
                                                             "xpatch.pdf")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "README")
                                                             dest-doc)))))))
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
     `(#:tex-directory "latex/catchfile"
       #:build-targets '("catchfile.dtx")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/catchfile/"))
                                (install-file (string-append source-doc
                                                             "catchfile.pdf")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "README.md")
                                                             dest-doc)))))))
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
(define-public texlive-generic-xstring
  (let ((template (simple-texlive-package
                   "texlive-generic-xstring"
                   (list "/doc/generic/xstring/"
                         "/tex/generic/xstring/")
                   (base32
                    "1azpq855kq1l4686bjp8haxim5c8wycz1b6lcg5q7x8kb4g9sppn")
                   #:trivial? #t)))
    (package
      (inherit template)
      (home-page "https://ctan.org/pkg/xstring")
      (synopsis "String manipulation for (La)TeX.")
      (description "The package provides macros for manipulating strings —
testing a string’s contents, extracting substrings, substitution of substrings
and providing numbers such as string length, position of, or number of
recurrences of, a substring.

The package works equally in Plain TeX and LaTeX (though e-TeX is always
required).  The strings to be processed may contain (expandable) macros.")
      (license license:lppl1.3c))))
(define-public texlive-biblatex-apa
  (let ((template (simple-texlive-package
                   "texlive-biblatex-apa"
                   (list "/tex/latex/biblatex-apa/"
                         "/doc/latex/biblatex-apa/")
                   (base32
                    "0ivf7xbzj4xd57sqfbi87hbr73rraqifkzvx06yxgq0gmzz0x6wl")
                   #:trivial? #t)))
    (package
      (inherit template)
      (home-page "https://ctan.org/pkg/biblatex-apa")
      (synopsis "BibLaTeX citation and reference style for APA")
      (description "This is a fairly complete BibLaTeX style (citations and
references) for APA (American Psychological Association) publications.  It
implements and automates most of the guidelines in the APA 7th edition style
guide for citations and references.  An example document is also given which
typesets every citation and reference example in the APA 7th edition style
guide.

This version of the package requires use of csquotes ≥4.3, BibLaTeX ≥3.4, and
the biber backend for BibLaTeX ≥2.5.")
      (license license:lppl1.3c))))
(define-public texlive-latex-setspace
  (let ((template (simple-texlive-package
                   "texlive-latex-setspace"
                   (list "/tex/latex/setspace/"
                         "/doc/latex/setspace/")
                   (base32
                    "00ik8qgkw3ivh3z827zjf7gbwkbsmdcmv22c6ap543mpgaqqjcfm")
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
     `(#:tex-directory "latex/endfloat"
       #:build-targets '("endfloat.ins")
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
                              (let* ((out (string-append
                                           (assoc-ref outputs "out")
                                           "/share/texmf-dist/tex/latex/"))
                                     (dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/endfloat/"))
                                (install-file (string-append source-doc
                                                             "README")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "COPYING")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "efxmpl.cfg")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "endfloat.pdf")
                                                             dest-doc)
                                (delete-file-recursively
                                 (string-append out
                                                "endfloat/efxmpl.cfg"))))))))
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
       (base32 "15l5lk5fkw6f88rmm784j6k4f0ansrksdc3jnywij90pm57qx2g0")))
    (build-system texlive-build-system)
    (arguments
     `(#:tex-directory "latex/minted"
       #:build-targets '("minted.ins")
       #:phases (modify-phases
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
                              (let* ( (dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/minted/"))
                                (install-file (string-append source-doc
                                                             "README")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "Makefile")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "minted.pdf")
                                                             dest-doc)))))))
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
       (base32 "00p0m643ah7d82k1ilz1nkmnbb733vqcz1paxk5n6y1k6awm1gks")))
    (build-system texlive-build-system)
    (arguments
     `(#:tex-directory "latex/fvextra"
       #:build-targets '("fvextra.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/fvextra/"))
                                (install-file (string-append source-doc
                                                             "README")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "fvextra.pdf")
                                                             dest-doc)))))))
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
                    "061c618kgw4vz9jh8f9vx591n733srafkbrq2qxsjx9szkvzbbki")
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
     `(#:tex-directory "latex/datetime2"
       #:build-targets '("datetime2.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/datetime2/"))
                                (install-file (string-append source-doc
                                                             "README")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "CHANGES")
                                                             dest-doc)
                                (mkdir-p (string-append dest-doc "/samples/"))
                                (copy-recursively (string-append source-doc
                                                                 "samples")
                                                  (string-append dest-doc
                                                                 "/samples/"))
                                (install-file (string-append source-doc
                                                             "datetime2.pdf")
                                                             dest-doc)))))))
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
;; In Guix Proper now.
;;
;; (define-public texlive-tracklang
;;   (let ((template (simple-texlive-package
;;                    "texlive-tracklang"
;;                    (list "/tex/latex/tracklang/"
;;                          "/tex/generic/tracklang/"
;;                          "/doc/generic/tracklang/")
;;                    (base32
;;                     "075q6yd7lq2qzaaim2zv9h27lcfmbxkrpilfrnzygfvkbhzqmi0i")
;;                    #:trivial? #t)))
;;     (package
;;       (inherit template)
;;       (home-page "https://ctan.org/pkg/tracklang")
;;       (synopsis "Language and dialect tracker")
;;       (description "The tracklang package is provided for package developers who
;; want a simple interface to find out which languages the user has requested
;; through packages such as babel or polyglossia.

;; This package does not provide any translations!  Its purpose is simply to track
;; which languages have been requested by the user.

;; Generic TeX code is in tracklang.tex for non-LaTeX users.")
;;       (license license:lppl1.3))))
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
     `(#:tex-directory "latex/datetime2-english"
       #:build-targets '("datetime2-english.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/datetime2-english/"))
                                (install-file (string-append source-doc
                                                             "README")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "CHANGES")
                                              dest-doc)
                                (install-file (string-append
                                               source-doc
                                               "datetime2-english-sample.pdf")
                                              (string-append
                                               dest-doc
                                               "/samples/"))
                                (install-file (string-append
                                               source-doc
                                               "datetime2-english-sample.tex")
                                              (string-append
                                               dest-doc
                                               "/samples/"))
                                (install-file (string-append
                                               source-doc
                                               "datetime2-english.pdf")
                                              dest-doc)))))))
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
     (version  (string-append package-version "-" revision))
     (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://mirrors.ctan.org/indexing/xindy/base/xindy-"
                    package-version ".tar.gz"))
              (sha256
               (base32
                "0hxsx4zw19kmixkmrln17sxgg1ln4pfp4lpfn5v5fyr1nwfyk3ic"))))
     (build-system gnu-build-system)
     (native-inputs (list pkg-config
                          clisp
                          sed
                          perl
                          texlive-fonts-ec
                          texlive-base
                          libiconv
                          texlive-inputenx
                          texlive-cm-super
                          texlive-latex-base))
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
(define-public texlive-svn-prov
  (let ((template (simple-texlive-package
                   "texlive-svn-prov"
                   (list "/tex/latex/svn-prov/"
                         "/doc/latex/svn-prov/")
                   (base32
                    "19vgp4bzj3i33yw35a6sg4pkbsv0ynxpg65ffm69gd4kqhqm934v")
                   #:trivial? #t)))
    (package
      (inherit template)
     (home-page "https://ctan.org/pkg/svn-prov")
     (description
      "The package introduces Subversion variants of the standard LaTeX macros
\\ProvidesPackage, \\ProvidesClass, and \\ProvidesFile where the file name and
date is extracted from Subversion Id keywords.  The file name may also be given
explicitly as an optional argument.")
     (synopsis "Subversion variants of \\Provides… macros")
     (license license:lppl))))
(define-public texlive-latex-newfloat
  (package
    (name "texlive-latex-newfloat")
    (version (string-append
              (number->string %texlive-revision)
             "-1"))
    (outputs '("out" "doc"))
    (source
     (texlive-origin
      name
      (number->string %texlive-revision)
      (list "doc/latex/newfloat/"
            "source/latex/newfloat/")
       (base32 "1j6h4q8lf6ksfdygm6d13j5zkmlq7f9xmly0vhyjmd3bsfqmidmi")))
    (build-system texlive-build-system)
    (arguments
     `(#:tex-directory "latex/newfloat"
       #:build-targets '("newfloat.ins")
       #:phases (modify-phases
                 %standard-phases
                 (add-after 'unpack
                            'set-TEXINPUTS
                            (lambda _
                              (let ((cwd (getcwd)))
                                (setenv "TEXINPUTS"
                                        (string-append
                                         cwd
                                         "/source/latex/newfloat:")))))
                 (add-after 'install 'install-more
                            (lambda* (#:key outputs #:allow-other-keys)
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/newfloat/"))
                                (install-file (string-append source-doc
                                                             "README")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "CHANGELOG")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "SUMMARY")
                                                             dest-doc)
                                (install-file (string-append source-doc
                                                             "newfloat.pdf")
                                                             dest-doc)))))))
    (home-page "https://ctan.org/pkg/newfloat")
    (synopsis "Define new floating environments")
    (description
     "The package offers the command \\DeclareFloatingEnvironment, which the
user may use to define new floating environments which behave like the LaTeX
standard foating environments figure and table.")
    (license license:lppl1.3)))
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
     `(#:tex-directory "latex/cleveref"
       #:build-targets '("cleveref.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/cleveref/"))
                                (install-file (string-append source-doc
                                                             "README")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "cleveref.pdf")
                                              dest-doc)))))))
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
       (base32 "0k95814kvyirlpgy63c3n1pv1b8zsp4fr0568fcaa002cryfgnar")))
    (build-system texlive-build-system)
    (arguments
     `(#:tex-directory "latex/memoir"
       #:build-targets '("memoir.ins" "mempatch.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/memoir/"))
                                (install-file (string-append source-doc
                                                             "README")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "setpage-example.pdf")
                                              dest-doc)))))))
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
       (base32 "0qlfvx5684dbcwbsmhk487ppryj7fkr8w2zhqllmhrzhqsqq43w5")))
    (build-system texlive-build-system)
    (arguments
     `(#:tex-directory "latex/lipsum"
       #:build-targets '("lipsum.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/lipsum/"))
                                (install-file (string-append source-doc
                                                             "README.txt")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "lipsum.pdf")
                                              dest-doc)))))))
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
     `(#:tex-directory "latex/venndiagram"
       #:build-targets '("venndiagram.ins")
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
                              (let* ((dest-doc
                                      (string-append (assoc-ref outputs "doc")
                                                     "/share/doc/"
                                                     ,name "-"
                                                     ,version))
                                     (source-doc
                                      "doc/latex/venndiagram/"))
                                (install-file (string-append source-doc
                                                             "README")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "CHANGES")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "samples/venn-sample.pdf")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "samples/venn-sample.tex")
                                              dest-doc)
                                (install-file (string-append source-doc
                                                             "venndiagram.pdf")
                                              dest-doc)))))))
    (home-page "https://ctan.org/pkg/lipsum")
    (synopsis "Creating Venn diagrams with TikZ")
    (description
     "The package assists generation of simple two- and three-set Venn diagrams for lectures or assignment sheets.")
    (license license:lppl)))
(define-public texlive-babel-russian
  (let ((template (simple-texlive-package
                   "texlive-babel-russian"
                   (list "/source/generic/babel-russian/")
                   (base32
                    "12ik2dwkih2g0gqpbg83j0kcfwsb5grccx27grgi0wjazk0nicq6"))))
    (package
      (inherit template)
      (arguments
       (substitute-keyword-arguments (package-arguments template)
         ((#:tex-directory _ '())
          "generic/babel-russian")
         ((#:build-targets _ '())
          ''("russianb.ins")) ; TODO: use dtx and build documentation
         ((#:phases phases) `(modify-phases ,phases
                               (add-after 'unpack 'chdir
                                 (lambda _
                                   (chdir "source/generic/babel-russian")))))))
      (home-page "https://www.ctan.org/pkg/babel-russian")
      (synopsis "Babel support for Russian")
      (description
       "This package provides the language definition file for support of Russian
in @code{babel}.  It provides all the necessary macros, definitions and
settings to typeset Russian documents.")
      (license license:lppl1.3c+))))
