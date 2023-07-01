(define-module (cdr255 yewscion)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (cdr255 programming)
  #:use-module (cdr255 tex)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages agda)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages base)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages check)
  #:use-module (gnu packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix build-system emacs)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (gnu packages java))
(define-public genpro
  (let ((commit "7dd2329a9279bb3147750ae9027ad47211a272f4")
        (revision "1"))
    (package
     (name "genpro")
     (version (git-version "0.6.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/genpro")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "11nr1xcpq278i92260lwx628zh199ahijq83vj83p375lmpwr9hd"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f))
     (propagated-inputs (list
                         biber
                         zip
                         unzip
                         texlive-bin
                         lynx
                         sed
                         grep))
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
                     texlive-etexcmds
                     texlive-gettitlestring
                     texlive-generic-ifptex
                     texlive-iftex
                     texlive-xstring
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
                     texlive-fancyhdr
                     texlive-fancyvrb
                     texlive-latex-float
                     texlive-latex-framed
                     texlive-latex-fvextra
                     texlive-latex-geometry
                     texlive-latex-ifplatform
                     texlive-kvoptions
                     texlive-letltxmacro
                     texlive-latex-lineno
                     texlive-latex-lwarp
                     texlive-latex-minted
                     texlive-latex-newfloat
                     texlive-latex-newunicodechar
                     texlive-pdftexcmds
                     texlive-latex-printlen
                     texlive-refcount
                     texlive-latex-setspace
                     texlive-titlesec
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
  (let ((commit "8a68e53e5d4fe6d232155583440e8fb968017905")
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
         "1dccdnff5skzlm7krgjb42v2avbhw9ja8w68bqf0gdl38lrigiz7"))))
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
  (let ((commit "93fbfb0b57dcb402a1b06604f12953df815fccb1")
        (revision "1"))
    (package
     (name "guile-cdr255")
     (version (git-version "0.2.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/guile-cdr255")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0pnfsn6jxbakds0yb6wzjiziagxyzpqi036d67dcgg6kr8ks5whk"))))
     (build-system gnu-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; Java and Guile programs don't need to be stripped.
         (delete 'strip))))
     (native-inputs (list autoconf automake pkg-config texinfo))
     (inputs (list guile-3.0-latest))
     (synopsis "Yewscion's Guile Library")
     (description
      (string-append
       "A grab-bag collection of procedures I use in my projects."))
     (home-page
      "https://sr.ht/~yewscion/guile-cdr255")
     (license license:agpl3+))))
(define-public yewscion-scripts
  (let ((commit "60cb8912e1b718856e61812ef666f795ca1aab02")
        (revision "1"))
    (package
     (name "yewscion-scripts")
     (version (git-version "0.2.1" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~yewscion/yewscion-scripts")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1b45b7fnr33a1hpw9z87fpwlglqglnvcgnkyzqxv1n2xkphd1f6s"))))
     (build-system gnu-build-system)
     (arguments
      `(#:make-flags '("GUILE_AUTO_COMPILE=0")
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
     (native-inputs (list pkg-config
                          guile-3.0-latest
                          autoconf
                          automake
                          texinfo
                          guile-cdr255))
     (synopsis "Utility Scripts from yewscion")
     (description
      (string-append
       "A personal collection of scripts written to aid with system "
       "administration tasks."))
     (home-page "https://git.sr.ht/~yewscion/yewscion-scripts")
     (license license:agpl3))))
(define-public python-pygments-pseudotaxus
  (let ((commit "74f8837e00501cb5137c0ac5342a33682c61f732")
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
         "1da9qajfa39sf9y69292d6r6v8f381clgxw262da20dqbqkcf30r"))))
     (build-system python-build-system)
     (propagated-inputs (list python-pygments))
     (home-page "https://git.sr.ht/~yewscion/pygments-lexer-pseudocode-std")
     (synopsis "Pygments Lexer for Pseudotaxus Pseudocode")
     (description "A Lexer for Pygments, following what could be a
standardized pseudocode.")
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
  (let ((commit "cf94750d4dbf1e5bc40161a119cc9d24a7888435")
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
                "1m9yrrbkbnjnv5na7ls4n128jgkl0jymywkqpi72zhxdx5kqai9p"))))
     (build-system gnu-build-system)
     (arguments
      `(#:out-of-source? #f))
     (native-inputs (list autoconf automake pkg-config texinfo))
     (inputs (list ghc ghc-bnfc ghc-alex ghc-happy agda texlive-bin))
     (synopsis "Somewhat-standardized pseudocode syntax")
     (description "Pseudotaxus is a collection of standard symbols (words and
      punctuation) that lend some consistent form to the definition of an
      algorithm in pseudocode.  It's meant to provide pseudocode with an
      interpretable form, syntax-highlighting, and most importantly a limit on
      which words carry predefined meaning in a listing.")
     (home-page "https://cdr255.com/projects/pseudotaxus")
     (license license:agpl3+))))
(define-public pseudotaxus-grove
  (let* ((revision "1")
         (commit "4cc9a64bfa48ad3630965623cb6910a114a52ed2"))
    (package
     (name "pseudotaxus-grove")
     (version (git-version "0.0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/pseudotaxus-grove")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0m2a8lc98j9fn6q1jyzbvmsbpd3zgmhiy39cvgxp2vc0i4l08wp1"))))
     (outputs '("out"))
     (build-system gnu-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; This allows the paths for guile and java to be embedded in the
         ;; scripts in bin/
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
     (native-inputs (list autoconf automake pkg-config texinfo pseudotaxus))
     (inputs (list guile-3.0-latest))
     (synopsis "The Pseudotaxus Core Library")
     (description
      (string-append
       "A collection of algorithms implemented within the syntax of the "
       "Pseudotaxus variant of Pseudocode."))
     (home-page
      "https://cdr255.com/projects/pseudotaxus-grove/")
     (license license:agpl3+))))
(define-public pseudotaxus-emacs
  (let* ((revision "1")
         (commit "fe4d77a2137131d53727582d2f0dd1c0b5b387f9"))
    (package
     (name "pseudotaxus-emacs")
     (version (git-version "0.0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/pseudotaxus-emacs")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "00n8cv02526ajgysrhqxxcvdy79kspdf3dyv3ibzp09fcx5ndxgf"))))
     (build-system gnu-build-system)
     (native-inputs (list autoconf automake pkg-config texinfo
                          emacs-minimal guile-3.0-latest))
     (synopsis "A major mode for editing Pseudotaxus files")
     (description
      (string-append
       "This is a major mode for GNU Emacs, to allow for easy and robust "
       "editing of Pseudotaxus pseudocode files."))
     (home-page
      "https://cdr255.com/projects/pseudotaxus/")
     (license license:agpl3+))))
(define-public emacs-compost-mode
  (let ((revision "1")
        (commit "c546f13bb9518e360b087433b290f7c6a99af218"))
    (package
     (name "emacs-compost-mode")
     (version (git-version "0.1.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/emacs-compost-mode")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0vdkf52cxyv3wj29wm015c10plqmsb08r4g421j596jb4jiczyrr"))))
     (build-system emacs-build-system)
     (native-inputs (list texinfo))
     (propagated-inputs (list emacs-deadgrep emacs-pdf-tools emacs-ebib
                              emacs-f emacs-org))
     (arguments
      (list #:phases #~(modify-phases %standard-phases
                                      (add-before 'install 'make-info
                                                  (lambda* (#:key inputs #:allow-other-keys)
                                                    (let ((makeinfo (search-input-file inputs
                                                                                       "/bin/makeinfo")))
                                                      (system (string-append makeinfo " "
                                                                             "doc/emacs-compost-mode.texi")))))
                                      (add-before 'install 'set-home
                                                  (lambda _
                                                    (setenv "HOME" "/tmp"))))))
     (synopsis "Notetaking Mode for GNU Emacs")
     (description
      "An implementation of a variation on the Zettelkasten method of notetaking
in GNU Emacs, leveraging org-mode, plain-text, and pdf-tools to create a
directory of notes.")
     (home-page "https://cdr255.com/projects/compost-mode")
     (license license:agpl3+))))

(define-public c-cdr255
  (let ((commit "d5646d62933c38732116be70d3651c8abca72b13")
        (revision "1"))
    (package
     (name "c-cdr255")
     (version "0.0.1")
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/c-cdr255")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1ra9ycxp18wkv3375b9l5j4jdd53vb32jvvn5175wjlj5hajxy5f"))))
     (build-system gnu-build-system)
     (native-inputs (list autoconf automake pkg-config texinfo check libtool))
     (inputs (list guile-3.0))
     (synopsis "Yewscion's C Library")
     (description
      (string-append
       "A grab-bag collection of procedures I use in my projects."))
     (home-page
      "https://cdr255.com/projects/c-cdr255")
     (license license:agpl3+))))

(define-public emacs-cdr255
  (let ((commit "845b27d3098120290ca60ca87dc158dccdab35a6")
        (revision "1"))
    (package
     (name "emacs-cdr255")
     (version "0.0.1")
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.sr.ht/~yewscion/emacs-cdr255")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1s91by7pnzih2xf7algbqv3chjjnjd1cqbgi50vgbpwzal8b8xgx"))))
     (build-system gnu-build-system)
     (arguments
      '(#:tests? #f))
     (native-inputs (list autoconf automake pkg-config texinfo emacs-minimal emacs-f))
     (synopsis "Yewscion's Emacs Lisp Library")
     (description
      (string-append
       "A grab-bag collection of procedures I use in my projects."))
     (home-page
      "https://cdr255.com/projects/emacs-cdr255")
     (license license:agpl3+))))
