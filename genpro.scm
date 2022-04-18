(define-module (genpro)
  #:use-module (guix packages)
  #:use-module (tex)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public genpro
  (let ((commit "bb9f44fafee0c82633a633cbc1d8b28e7fea3a60")
        (revision "2"))
    (package
     (name "genpro")
     (version (git-version "0.0.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/genpro")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1f3k70a4q8mydza3h4wbw1iv2pgf4i87x86x2k4b5q1qpam44g3m"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs (list pkg-config
                          guile-3.0
                          autoconf
                          automake
                          biber
                          python-pygments
                          texlive-biblatex
                          texlive-biblatex-apa
                          texlive-capt-of
                          texlive-csquotes
                          texlive-etoolbox
                          texlive-fontspec
                          texlive-generic-etexcmds
                          texlive-generic-gettitlestring
                          texlive-generic-ifptex
                          texlive-generic-iftex
                          texlive-generic-xstring
                          texlive-ifmtarg
                          texlive-kpathsea
                          texlive-latex-catchfile
                          texlive-latex-cleveref
                          texlive-latex-comment
                          texlive-latex-datetime2
                          texlive-latex-datetime2-english
                          texlive-latex-endfloat
                          texlive-latex-environ
                          texlive-latex-everyhook
                          texlive-latex-fancyhdr
                          texlive-latex-fancyvrb
                          texlive-latex-float
                          texlive-latex-framed
                          texlive-latex-fvextra
                          texlive-latex-geometry
                          texlive-latex-ifplatform
                          texlive-latex-kvoptions
                          texlive-latex-letltxmacro
                          texlive-latex-lineno
                          texlive-latex-lwarp
                          texlive-latex-minted
                          texlive-latex-newfloat
                          texlive-latex-newunicodechar
                          texlive-latex-pdftexcmds
                          texlive-latex-printlen
                          texlive-latex-refcount
                          texlive-latex-setspace
                          texlive-latex-titlesec
                          texlive-latex-trimspaces
                          texlive-latex-upquote
                          texlive-latex-xkeyval
                          texlive-latex-xpatch
                          texlive-libkpathsea
                          texlive-listings
                          texlive-lm
                          texlive-luaotfload
                          texlive-svn-prov
                          texlive-tex-gyre
                          texlive-tracklang
                          texlive-varwidth
                          texlive-xcolor
                          texlive-xifthen))
     (synopsis "Generate and Publish LaTeX files.")
     (description
      (string-append
       "Tool to consistently create and work with LaTeX projects."))
     (home-page "https://git.sr.ht/~yewscion/genpro")
     (license agpl3))))
genpro
