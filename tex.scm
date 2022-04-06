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
    (home-page "https://ctan.org/macros/latex/contrib/lwarp")
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
 texlive-latex-lwarp
