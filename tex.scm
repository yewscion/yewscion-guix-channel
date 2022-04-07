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
      (home-page "http://www.ctan.org/pkg/iftex")
      (synopsis "Determine the currently used TeX engine")
      (description "This package, which works both for Plain TeX and for
LaTeX, defines the @code{\\ifPDFTeX}, @code{\\ifXeTeX}, and @code{\\ifLuaTeX}
conditionals for testing which engine is being used for typesetting.  The
package also provides the @code{\\RequirePDFTeX}, @code{\\RequireXeTeX}, and
@code{\\RequireLuaTeX} commands which throw an error if pdfTeX, XeTeX or
LuaTeX (respectively) is not the engine in use.")
      (license license:lppl1.3+))))

(define-public texlive-latex-xpatch
  (package
    (name "texlive-latex-xpatch")
    (version (string-append
              (number->string %texlive-revision)
             "-1"))
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
texlive-generic-ifptex
texlive-latex-xpatch
