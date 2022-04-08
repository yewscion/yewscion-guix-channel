(define-module (tex)
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

(define-public texlive-latex-lwarp
  (package
    (name "texlive-latex-lwarp")
    (version (string-append
              (number->string %texlive-revision)
             "-1"))
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
       #:phases (modify-phases
                 %standard-phases
                 (add-after 'unpack
                            'set-TEXINPUTS
                            (lambda _
                              (let ((cwd (getcwd)))
                                (setenv "TEXINPUTS"
                                        (string-append
                                         cwd
                                         "/source/latex/lwarp:")))))
                 (add-before 'install 'bin-script
                             (lambda* (#:key outputs #:allow-other-keys)
                               (call-with-output-file "lwarpmk"
                                 (lambda (port)
                                   (let* ((out
                                           (assoc-ref outputs "out")))
                                     (display (string-append
                                               "#!/bin/bash\n"
                                               "exec -a \"$0\" \""
                                               out
                                               "/share/texmf-dist/scripts/lwarp/lwarpmk.lua\" \"$@\"")
                                              port))))
                               (chmod "lwarpmk" #o755)))
                 (add-after 'install 'install-more
                            (lambda* (#:key outputs #:allow-other-keys)
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-bin
                                      (string-append out "/bin"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version))
                                     (dest-script
                                      (string-append out "/share/texmf-dist/scripts/lwarp/")))
                                (install-file "lwarpmk" dest-bin)
                                (install-file "scripts/lwarp/lwarpmk.lua" dest-script)
                                (install-file "doc/latex/lwarp/lwarp.pdf" dest-doc)
                                (install-file "doc/latex/lwarp/lwarp_tutorial.txt" dest-doc)
                                (install-file "doc/latex/lwarp/README.txt" dest-doc)))))))
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
etc. for the ptex engine. The ifuptex package is an alias to ifptex provided for
backward compatibility. ")
      (license license:expat))))
(define-public texlive-latex-xpatch
  (package
    (name "texlive-latex-xpatch")
    (version (string-append
              (number->string %texlive-revision)
             "-2"))
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
                 (add-after 'install 'install-more
                            (lambda* (#:key outputs #:allow-other-keys)
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version)))
                                (install-file "doc/latex/xpatch/xpatch.pdf" dest-doc)
                                (install-file "doc/latex/xpatch/README" dest-doc)))))))
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
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version)))
                                (install-file "doc/latex/catchfile/catchfile.pdf" dest-doc)
                                (install-file "doc/latex/catchfile/README.md" dest-doc)))))))
    (home-page "https://ctan.org/pkg/catchfile")
    (synopsis "Catch an external file into a macro")
    (description
     "This package catches the contents of a file and puts it in a macro. It
requires e-TeX. Both LaTeX and plain TeX are supported.")
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
user to define new, separately controlled, comment versions. All text between
\\comment ... \\endcomment or \\begin{comment} ... \\end{comment} is discarded. The
opening and closing commands should appear on a line of their own. No starting
spaces, nothing after it. This environment should work with arbitrary amounts of
comment, and the comment can be arbitrary text.

Other ‘comment’ environments are defined and selected/deselected with
\\includecomment{versiona} and \\excludecoment{versionb} These environments are
used as \\versiona … \\endversiona or \\begin{versiona} … \\end{versiona} with the
opening and closing commands again on a line of their own.")
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
      (synopsis "https://ctan.org/pkg/xstring")
      (description "The package provides macros for manipulating strings —
testing a string’s contents, extracting substrings, substitution of substrings
and providing numbers such as string length, position of, or number of
recurrences of, a substring.

The package works equally in Plain TeX and LaTeX (though e-TeX is always
required). The strings to be processed may contain (expandable) macros. ")
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
references) for APA (American Psychological Association) publications. It
implements and automates most of the guidelines in the APA 7th edition style
guide for citations and references. An example document is also given which
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
document. Package options include singlespacing, onehalfspacing, and
doublespacing. Alternatively the spacing can be changed as required with the
\\singlespacing, \\onehalfspacing, and \\doublespacing commands. Other size
spacings also available.")
      (license license:lppl1.3c))))
(define-public texlive-latex-endfloat
  (package
    (name "texlive-latex-endfloat")
    (version (string-append
              (number->string %texlive-revision)
             "-1"))
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
                              (delete-file-recursively "source/latex/endfloat/endfloat.drv")))
                 (add-after 'install 'install-more
                            (lambda* (#:key outputs #:allow-other-keys)
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version)))
                                (install-file "doc/latex/endfloat/README" dest-doc)
                                (install-file "doc/latex/endfloat/COPYING" dest-doc)
                                (install-file "doc/latex/endfloat/efxmpl.cfg" dest-doc)
                                (install-file "doc/latex/endfloat/endfloat.pdf" dest-doc)
                                (delete-file-recursively (string-append out "/share/texmf-dist/"
                                                                        "tex/"
                                                                        "latex/"
                                                                        "endfloat/"
                                                                        "efxmpl.cfg"))))))))
    (home-page "https://ctan.org/pkg/endfloat")
    (synopsis "Move floats to the end, leaving markers where they belong")
    (description
     "Place all floats on pages by themselves at the end of the document,
optionally leaving markers like “[Figure 3 about here]” in the text near to
where the figure (or table) would normally have occurred. Float types figure and
table are recognised by the package, unmodified. Since several packages define
other types of float, it is possible to register these float types with
endfloat.")
    (license license:gpl3)))
(define-public texlive-latex-minted
  (package
    (name "texlive-latex-minted")
    (version (string-append
              (number->string %texlive-revision)
             "-1"))
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
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version)))
                                (install-file "doc/latex/minted/README" dest-doc)
                                (install-file "doc/latex/minted/Makefile" dest-doc)
                                (install-file "doc/latex/minted/minted.pdf" dest-doc)))))))
    (home-page "https://ctan.org/pkg/minted")
    (synopsis "Highlighted source code for LaTeX")
    (description
     "The package that facilitates expressive syntax highlighting in LaTeX using
the powerful Pygments library. The package also provides options to customize
the highlighted source code output using fancyvrb.")
    (license license:lppl1.3)))
(define-public texlive-latex-fvextra
  (package
    (name "texlive-latex-fvextra")
    (version (string-append
              (number->string %texlive-revision)
             "-1"))
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
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version)))
                                (install-file "doc/latex/fvextra/README" dest-doc)
                                (install-file "doc/latex/fvextra/fvextra.pdf" dest-doc)))))))
    (home-page "https://ctan.org/pkg/fvextra")
    (synopsis "Extensions and patches for fancyvrb")
    (description
     "fvextra provides several extensions to fancyvrb, including automatic line
breaking and improved math mode. It also patches some fancyvrb internals. Parts
of fvextra were originally developed as part of pythontex and minted.")
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
                              (let* ((out
                                      (assoc-ref outputs "out"))
                                     (dest-doc
                                      (string-append out "/share/doc/" ,name ,version)))
                                (install-file "doc/latex/datetime2/README" dest-doc)
                                (install-file "doc/latex/datetime2/CHANGES" dest-doc)
                                (mkdir-p (string-append dest-doc "/samples/"))
                                (copy-recursively "doc/latex/datetime2/samples" (string-append dest-doc "/samples/"))
                                (install-file "doc/latex/datetime2/datetime2.pdf" dest-doc)))))))
    (home-page "https://ctan.org/pkg/datetime2")
    (synopsis "Formats for dates, times and time zones")
    (description
     "This package provides commands for formatting dates, times and time zones
and redefines \\today to use the same formatting style. In addition to \\today,
you can also use \\DTMcurrenttime (current time) or \\DTMnow (current date and
time). Dates and times can be saved for later use.

The accompanying datetime2-calc package can be used to convert date-times to
UTC+00:00.

Language and regional support is provided by independently maintained and
installed modules.

The datetime2-calc package uses the pgfcalendar package (part of the PGF/TikZ
bundle).

This package replaces datetime.sty which is now obsolete. ")
    (license license:lppl1.3)))
(define-public texlive-tracklang
  (let ((template (simple-texlive-package
                   "texlive-tracklang"
                   (list "/tex/latex/tracklang/"
                         "/tex/generic/tracklang/"
                         "/doc/generic/tracklang/")
                   (base32
                    "075q6yd7lq2qzaaim2zv9h27lcfmbxkrpilfrnzygfvkbhzqmi0i")
                   #:trivial? #t)))
    (package
      (inherit template)
      (home-page "https://ctan.org/pkg/tracklang")
      (synopsis "Language and dialect tracker")
      (description "The tracklang package is provided for package developers who
want a simple interface to find out which languages the user has requested
through packages such as babel or polyglossia.

This package does not provide any translations! Its purpose is simply to track
which languages have been requested by the user.

Generic TeX code is in tracklang.tex for non-LaTeX users.")
      (license license:lppl1.3))))

texlive-latex-lwarp
texlive-generic-ifptex
texlive-latex-xpatch
texlive-latex-catchfile
texlive-latex-comment
texlive-generic-xstring
texlive-biblatex-apa
texlive-latex-setspace
texlive-latex-endfloat
texlive-latex-minted
texlive-latex-fvextra
texlive-latex-lineno
texlive-latex-datetime2
texlive-tracklang
