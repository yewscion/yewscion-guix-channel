(define-module (leiningen)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages java)
  #:use-module (gnu packages clojure)
  #:use-module (gnu packages perl)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public leiningen
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
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f
        #:phases (modify-phases %standard-phases
                                (delete 'configure)
                                (replace 'build (lambda* (#:key outputs #:allow-other-keys)
                                                  (chmod "./bin/lein-pkg" 777)
                                                  (system "sh ./bin/lein-pkg"))))))
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
leiningen-ng
