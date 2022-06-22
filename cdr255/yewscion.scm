(define-module (cdr255 yewscion)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (cdr255 tex)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (gnu packages java))
(define-public genpro
  (let ((commit "f928b01a5ce4f5d5534442a5d29186b088fa787b")
        (revision "1"))
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
         "0yb7d0k48dx2x7as2jqwg5pmblp8bqaxhxwpf8hkdz8jdymvr7k2"))))
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
     (license license:agpl3))))
(define-public pagr
  (let ((commit "920945e18202937af0e265c43c1b28cc6b3a75c0")
        (revision "1"))
    (package
     (name "pagr")
     (version (git-version "0.0.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/pagr")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0iicnfiqx62d3rp2zh3xf6xv19awlccx0zzc31in8jx85a68lhmp"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs (list pkg-config
                          guile-3.0
                          guile-git
                          autoconf
                          automake))
    (synopsis "Push all git repos")
    (description
     (string-append
      "A convenience script for handling many git repos with similar "
      "remotes."))
    (home-page "https://git.sr.ht/~yewscion/pagr")
    (license license:agpl3))))
(define-public guile-cdr255
  (package
   (name "guile-cdr255")
   (version "0.1.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://git.sr.ht/~yewscion/guile-cdr255")
                  (commit "c5bc0c4bce8c874bff609309dc4e722a90e7deec")))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "16fh15aj66zqx5sqx08c3b037539mmhzks84qbn1560hb6srw9bj"))))
   (build-system gnu-build-system)
   (arguments
    `(#:modules
      ((ice-9 match)
       (ice-9 ftw)
       ,@%gnu-build-system-modules)
      #:phases
      (modify-phases
       %standard-phases
       (add-after
        'install
        'hall-wrap-binaries
        (lambda* (#:key inputs outputs #:allow-other-keys)
          (let* ((compiled-dir
                  (lambda (out version)
                    (string-append
                     out
                     "/lib/guile/"
                     version
                     "/site-ccache")))
                 (uncompiled-dir
                  (lambda (out version)
                    (string-append
                     out
                     "/share/guile/site"
                     (if (string-null? version) "" "/")
                     version)))
                 (dep-path
                  (lambda (env modules path)
                    (list env
                          ":"
                          'prefix
                          (cons modules
                                (map (lambda (input)
                                       (string-append
                                        (assoc-ref inputs input)
                                        path))
                                     ,''())))))
                 (out (assoc-ref outputs "out"))
                 (bin (string-append out "/bin/"))
                 (site (uncompiled-dir out "")))
            (match (scandir site)
              (("." ".." version)
               (for-each
                (lambda (file)
                  (wrap-program
                   (string-append bin file)
                   (dep-path
                    "GUILE_LOAD_PATH"
                    (uncompiled-dir out version)
                    (uncompiled-dir "" version))
                   (dep-path
                    "GUILE_LOAD_COMPILED_PATH"
                    (compiled-dir out version)
                    (compiled-dir "" version))))
                ,''("set-gitconfig"))
               #t))))))))
   (native-inputs (list autoconf
                        automake
                        pkg-config
                        texinfo))
   (inputs (list guile-3.0))
   (synopsis "User library and utility scripts.")
   (description
    (string-append
     "Mostly a guile library, this is a personal project to make maintaining "
     "multiple systems easier and the creation of new scripts easier."))
   (home-page
    "https://sr.ht/~yewscion/guile-cdr255")
   (license license:agpl3+)))
(define-public yewscion-scripts
  (let ((commit "6b74d81401204997ebd31ecda46043ad6be8198c")
        (revision "1"))
    (package
     (name "yewscion-scripts")
     (version (git-version "0.1.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/yewscion-scripts")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0pn04h2725z2sgwr9a837yrqwr1a0439ih09z1f1hrrh6y2ynhld"))))
     (build-system gnu-build-system)

     (arguments
      `(#:tests? #f))
     (native-inputs `(("pkg-config" ,pkg-config)
                      ("guile" ,guile-3.0)
                      ("autoconf" ,autoconf)
                      ("automake" ,automake)))
    (synopsis "Utility Scripts from yewscion")
    (description
     (string-append
      "A personal collection of scripts written to aid with system "
      "administration tasks."))
    (home-page "https://git.sr.ht/~yewscion/yewscion-scripts")
    (license license:agpl3))))
(define-public python-pygments-lexer-pseudocode-std
  (let ((commit "607c42125b2b31cd767389cf51d521c8ea984eab")
        (revision "2"))
    (package
     (name "python-pygments-lexer-pseudocode-std")
     (version (git-version "1.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
             (commit commit)))
       (sha256
        (base32
         "10py6xghyifz6rx1qn327029mx5zm463nsia602pryazamaxcrfw"))))
  (build-system python-build-system)
  (propagated-inputs (list python-pygments))
  (home-page "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
  (synopsis "Pygments Lexer for a standard pseudocode")
  (description "A Lexer for Pygments, following what could be considered a standard pseudocode.")
  (license license:agpl3))))
(define-public codechallenge-solutions
  (let ((commit "5b0f6af9240d93006e12660c45c95e0d310a6c2f")
        (revision "1"))
    (package
     (name "codechallenge-solutions")
     (version "0.0.1")
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/yewscion/codechallenge-solutions.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0kgrvsmbda0c8pza0jqkm5s9zv7jmw64zq3hds03z9vi4qzrn5h0"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f))
     (native-inputs (list autoconf automake pkg-config texinfo `(,openjdk17 "jdk") ))
     (inputs (list guile-3.0-latest))
     (synopsis "Toy Repository for Code Challenge Solutions.")
     (description
      (string-append
       "Mostly just a repository of my solutions to various coding challenges, "
       "but also any tools I make along the way."))
     (home-page
      "https://github.com/yewscion/codechallenge-solutions")
     (license license:agpl3+))))
