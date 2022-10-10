(define-module (cdr255 yewscion)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (cdr255 programming)
  #:use-module (cdr255 tex)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages base)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages compression)
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
  (let ((commit "445c025c915a90bd35d0c649d2b8dd448d4bbaa0")
        (revision "1"))
    (package
      (name "genpro")
      (version (git-version "0.5.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://git.sr.ht/~yewscion/genpro")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0z9kpp8magqphggqnlw8751d382zhr840bpnn4vwgrwf9wvqiizy"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f))
      (propagated-inputs (list
                          biber
                          zip
                          unzip
                          texlive-bin))
      (native-inputs (list
                      guile-cdr255
                      pkg-config
                      guile-3.0
                      autoconf
                      automake
                      python-pygments
                      texinfo
                      texlive-base
                      texlive-biblatex
                      texlive-biblatex-apa
                      texlive-booktabs
                      texlive-capt-of
                      texlive-context
                      texlive-csquotes
                      texlive-dvips
                      texlive-etoolbox
                      texlive-fontspec
                      texlive-generic-etexcmds
                      texlive-generic-gettitlestring
                      texlive-generic-ifptex
                      texlive-generic-iftex
                      texlive-generic-xstring
                      texlive-hyperref
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
                      texlive-metapost
                      texlive-pgf
                      texlive-svn-prov
                      texlive-tex-gyre
                      texlive-tracklang
                      texlive-varwidth
                      texlive-xcolor
                      texlive-xifthen))
      (synopsis "Generate and Publish Academic Projects")
      (description
       (string-append
        "Genpro is a tool written in Guile Scheme to easily and consistently create and iterate on papers in an academic setting.

It's meant to provide me with an easy way to set up and compile LaTeX projects in the formats my professors want them in, as well as allow them to be hosted online after completion."))
      (home-page "https://cdr255.com/projects/genpro/")
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
                    (commit "8271404a84f20e7f358b71db2146372c61db3599")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1nqs03y30mp5z4ybya83s5ybpb3mz2qp6fiabgs6xq74hby35zzh"))))
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
  (let ((commit "7476b31b19ac3cece4906fecb00f589f6b8e739f")
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
           "0d8758g8vvjphvbw0m0dka0qv2g42b0srji14iln7mmnr170m836"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f))
      (native-inputs (list pkg-config
                           guile-3.0
                           autoconf
                           automake
                           guile-cdr255))
      (synopsis "Utility Scripts from yewscion")
      (description
       (string-append
        "A personal collection of scripts written to aid with system "
        "administration tasks."))
      (home-page "https://git.sr.ht/~yewscion/yewscion-scripts")
      (license license:agpl3))))
(define-public python-pygments-pseudotaxus
  (let ((commit "fde115d019a7c3644f98275e7c2f3523629088b8")
        (revision "1"))
    (package
      (name "python-pygments-pseudotaxus")
      (version (git-version "1.1.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "17h0gynzp5azd5y4cxg4imnjx787pk7y7ifmfbpb9i1kjakdjnnh"))))
      (build-system python-build-system)
      (propagated-inputs (list python-pygments))
      (home-page "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
      (synopsis "Pygments Lexer for Pseudotaxus Pseudocode")
      (description "A Lexer for Pygments, following what could be a standardized pseudocode.")
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
(define-public patchelf-wrapper
  (let* ((tag "0.0.1")
         (revision "2")
         (commit "d25559c5078123e020411c75f636aefcde481149")
         (hash "19vxyar9n2y3d2pp7y2cmq1f01qbsxqkf94bv006idkwjyrjcw5g")
         (version (git-version tag revision commit)))
    (package
      (name "patchelf-wrapper")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.sr.ht/~yewscion/patchelf-wrapper")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  hash))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f
         #:phases
         (modify-phases
             %standard-phases
           ;; This allows the paths for guile and java to be embedded in the scripts
           ;; in bin/
           (add-before
               'patch-usr-bin-file 'remove-script-env-flags
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute*
                   (find-files "./bin")
                 (("#!/usr/bin/env -S guile \\\\\\\\")
                  "#!/usr/bin/env guile \\")
                 (("\"java")
                  (string-append "\"" (search-input-file inputs "/bin/java"))))))
           ;; Java and Guile programs don't need to be stripped.
           (delete 'strip))))
      (propagated-inputs (list grep patchelf))
      (native-inputs (list autoconf automake pkg-config texinfo))
      (inputs (list guile-3.0-latest))
      (synopsis "A tool to use patchelf with GNU/Guix")
      (description
       (string-append
        "A script and library based around the idea of making it easier to patch "
        "precompiled binaries to work with GNU/Guix."))
      (home-page
       "https://github.com/yewscion/patchelf-wrapper")
      (license license:agpl3+))))
(define-public pseudotaxus
  (let ((commit "5a03e3183f921b6328e2b6bc58fb7e1c7628f617")
        (revision "1"))
    (package
      (name "pseudotaxus")
      (version (git-version "0.0.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.sr.ht/~yewscion/pseudotaxus")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0k0vp34nx13d16i17fvvy8cjgdbibf0p6sq47jf88mwvxmh2bhlh"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f))
      (native-inputs (list autoconf automake pkg-config texinfo))
      (inputs (list ghc ghc-bnfc ghc-alex ghc-happy))
      (synopsis "Somewhat-standardized pseudocode syntax")
      (description
       "Pseudotaxus is a collection of standard symbols (words and punctuation) that
lend some consistent form to the definition of an algorithm in pseudocode.
It's meant to provide pseudocode with an interpretable form,
syntax-highlighting, and most importantly a limit on which words carry
predefined meaning in a listing.")
      (home-page "https://cdr255.com/projects/pseudotaxus")
      (license license:agpl3+))))
