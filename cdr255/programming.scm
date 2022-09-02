(define-module (cdr255 programming)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages clojure)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages java)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages sqlite)
  #:use-module (guix build-system clojure)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system haskell)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils))
(define-public newlisp
  (let ((source-version "10.7.5")
        (revision "1"))
    (package
     (name "newlisp")
     (version (string-append source-version "-" revision))
     (source
      (origin
       (method url-fetch)
       (uri (string-append
             "https://sourceforge.net/projects/newlisp/files/newlisp-"
             source-version
             ".tgz/download"))
       (file-name (string-append
                   "newlisp-"
                   source-version
                   ".tgz"))
       (sha256
        (base32 "1v1607lv2q7vfnp21p5d3rpgp9jik2jqpbzk9ay7bcn2a7v0ybfw"))))
     (build-system gnu-build-system)
     (arguments
      `(#:make-flags
        (list (string-append "prefix=" (assoc-ref %outputs "out"))
              "CC=gcc")))
     (inputs (list libffi which readline))
     (home-page "http://www.newlisp.org/")
     (synopsis
      "A LISP like, general purpose scripting language")
     (description
      (string-append
       "newLISP is a scripting language for developing web applications "
       "and programs in general and in the domains of artificial "
       "intelligence (AI) and statistics."))
     (license license:gpl3))))
(define-public owl-lisp
  (let ((commit "a5dbf6c1b19c163d2f137abb9172ea2d0250abef")
        (revision "1"))
    (package
     (name "owl-lisp")
     (version (git-version "0.2" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/owl-lisp/owl.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0zs9hj0rhpa0ary6cbqyq9f1dx3hc6npl4iywqn7ps3a35kv4p8v"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f
        #:make-flags
        (let ((out (assoc-ref %outputs "out")))
          (list (string-append "PREFIX=" out)))
        #:phases (modify-phases %standard-phases
                                (delete 'configure)
                                (delete 'check)
                                (delete 'delete-info-dir-file)
                                (delete 'patch-dot-desktop-files))))
     (inputs (list which))
     (synopsis "A functional Scheme for world domination")
     (description
      (string-append
       "Owl Lisp is a functional dialect of the Scheme programming language. It"
       "is mainly based on the applicative subset of the R7RS standard."))
     (home-page "https://gitlab.com/owl-lisp/owl")
     (license license:bsd-3))))
; Modified version of GNU Guix "apl" package for quick fixes when needed.
(define-public gnu-apl
  (package
    (name "gnu-apl")
    (version "1.8")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/apl/apl-" version ".tar.gz"))
      (sha256
       (base32
        "1jxvv2h3y1am1fw6r5sn3say1n0dj8shmscbybl0qhqdia2lqkql"))))
    (build-system gnu-build-system)
    (home-page "https://www.gnu.org/software/apl/")
    (inputs (list gettext-minimal lapack pcre2 sqlite readline))
    (arguments
     `(#:configure-flags (list "CXX_WERROR=no"
                               (string-append                                
                                "--with-sqlite3="
                                (assoc-ref %build-inputs "sqlite")))))
    (synopsis "APL interpreter")
    (description
     "GNU APL is a free interpreter for the programming language APL.  It is
an implementation of the ISO standard 13751.")
    (license license:gpl3+)))
(define-public carp
  (let ((commit "e32ec43a26c51ebd136776566909f19476df6ed9")
        (revision "3"))
    (package
     (name "carp")
     (version (git-version "0.5.5" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/carp-lang/Carp.git")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14jdnv0ljqvpr9ych1plfw7hp5q57a8j1bv8h3v345x06z783d07"))))
     (build-system haskell-build-system)
     (arguments
       `(#:phases
       (modify-phases
        %standard-phases
        (add-after 'install 'install-core
                   (lambda _
                     (let* ((share-dir (string-append %output
                                                      "/share/"
                                                      ,name)))
                       (copy-recursively "core" (string-append
                                                 share-dir
                                                 "/core"))
                       (copy-recursively "bench" (string-append
                                                  share-dir
                                                  "/bench"))
                       (copy-recursively "examples" (string-append
                                                     share-dir
                                                     "/examples"))))))))
     (inputs (list
              ghc-hunit
              ghc-ansi-terminal
              ghc-blaze-markup
              ghc-blaze-html
              ghc-cmark
              ghc-edit-distance
              ghc-hashable
              ghc-optparse-applicative
              ghc-split
              ghc-open-browser
              python))
     (home-page "https://github.com/carp-lang/Carp")
     (synopsis
      "A statically typed lisp, without a GC, for real-time applications")
     (description
      "Carp is a programming language designed to work well for interactive and
performance sensitive use cases like games, sound synthesis and visualizations.

The key features of Carp are the following:

@begin itemize
@item Automatic and deterministic memory management (no garbage collector or VM)
@item Inferred static types for great speed and reliability
@item Ownership tracking enables a functional programming style while still
      using mutation of cache-friendly data structures under the hood
@item No hidden performance penalties – allocation and copying are explicit
@item Straightforward integration with existing C code
@item Lisp macros, compile time scripting and a helpful REPL
@end itemize")
     (license license:asl2.0))))
(define-public ghc-open-browser
  (package
   (name "ghc-open-browser")
   (version "0.2.1.0")
   (source (origin
            (method url-fetch)
            (uri (hackage-uri "open-browser" version))
            (sha256
             (base32
              "0rna8ir2cfp8gk0rd2q60an51jxc08lx4gl0liw8wwqgh1ijxv8b"))))
  (build-system haskell-build-system)
  (home-page "https://github.com/rightfold/open-browser")
  (synopsis "Open a web browser from Haskell.")
  (description
   "Open a web browser from Haskell.  Currently BSD, Linux, OS X and Windows are
supported.")
  (license license:bsd-3)))
(define leiningen
  (let ((commit "ef5ab97f058e8cb01e9c6a5a1cb6aa45c3b01d27")
        (revision "1"))
    (package
     (name "leiningen")
     (version (git-version "2.9.8" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/technomancy/leiningen.git")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1i6pn8vzzhgnm9hmlb92z65l79nxcxa5zdsrgg5svq7vmbixgnhl"))))
     (build-system clojure-build-system)
     (arguments
      `(#:tests? #f))
        ;; #:phases (modify-phases ))
        ;;           %standard-phases ))
        ;;           (delete 'configure) ))
        ;;           (replace ))
        ;;            'build ))
        ;;            (lambda* (#:key inputs outputs #:allow-other-keys) ))
        ;;              (setenv "CLASSPATH" ))
        ;;                      (string-append ))
        ;;                       (search-input-directory inputs "share/java")))))
        ;;              (system "echo $CLASSPATH") ))
        ;;              (chmod "./bin/lein-pkg" 777) ))
        ;;              (system "sh ./bin/lein-pkg"))))))))) ))
     (inputs (list `(,icedtea "jdk")
                   clojure
                   perl-digest-sha))
     (synopsis "Generate and Publish LaTeX files.")
     (description
      (string-append
       "Tool to consistently create and work with LaTeX projects."))
     (home-page "https://git.sr.ht/~yewscion/genpro")
     (license license:epl1.0))))
;;; Left the above at 'Error: unable to find or locate main class clojure.main'

;;; Pulled the below from nonguix, as I decided I don't know the tool well
;;; enough to package it yet.

;; This is a hidden package, as it does not really serve a purpose on its own.
(define leiningen-jar
  (package
    (name "leiningen-jar")
    (version "2.9.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/technomancy/leiningen/releases/download/"
                                  version "/leiningen-" version "-standalone.jar"))
              (file-name "leiningen-standalone.jar")
              (sha256
               (base32
                "13f4n15i0gsk9jq52gxivnsk32qjahmxgrddm54cf8ynw0a923ia"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (jar-dir (string-append %output "/share/")))
                     (mkdir-p jar-dir)
                     (copy-file source
                                (string-append jar-dir "leiningen-standalone.jar"))))))
    (home-page "https://leiningen.org")
    (synopsis "Automate Clojure projects without setting your hair on fire")
    (description "Leiningen is a Clojure tool with a focus on project
automation and declarative configuration.  It gets out of your way and
lets you focus on your code.")
    (license license:epl1.0)))
(define-public leiningen-ng
  (package
    (inherit leiningen-jar)
    (name "leiningen-ng")
    (version "2.9.8")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/technomancy/leiningen.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1i6pn8vzzhgnm9hmlb92z65l79nxcxa5zdsrgg5svq7vmbixgnhl"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (delete 'build)
                  (replace 'install
                    (lambda _
                      (let* ((lein-pkg (string-append (assoc-ref %build-inputs "source") "/bin/lein-pkg"))
                             (lein-jar (string-append (assoc-ref  %build-inputs "leiningen-jar")
                                                      "/share/leiningen-standalone.jar"))
                             (bin-dir (string-append %output "/bin"))
                             (lein (string-append bin-dir "/lein")))
                        (mkdir-p bin-dir)
                        (copy-file lein-pkg lein)
                        (patch-shebang lein)
                        (chmod lein #o555)
                        (substitute* lein
                          (("LEIN_JAR=.*") (string-append "LEIN_JAR=" lein-jar)))
                        #t))))))
    (inputs
     `(("leiningen-jar" ,leiningen-jar)))))
;;; End part pulled from nonguix.
