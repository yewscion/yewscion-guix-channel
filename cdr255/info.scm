(define-module (cdr255 info)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages base)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils))

(define-public scheme-primer
  (let ((commit "c00e16d43aaa274277d7808767c2506ea4738111")
        (sha "1m6bdzbfiic9xznj7v5v6b445bmhr7a2145glcf3rzspl36ajz7q")
        (revision "1")
        (tag "0"))
    (package
     (name "scheme-primer")
     (version (git-version tag revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.com/spritely/scheme-primer.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32 sha))))
     (build-system copy-build-system)
     (arguments
      `(#:phases (modify-phases %standard-phases
                   (add-after 'unpack 'compile
                     (lambda* (#:key inputs outputs #:allow-other-keys)
                       (system "emacs --batch --eval '(load \"ox-texinfo.el\")' --visit=scheme-primer.org --funcall org-texinfo-export-to-info"))))
        #:install-plan '(("scheme-primer.info" "share/info/"))))
     (native-inputs (list emacs-no-x
                          emacs-org
                          texinfo))
     (home-page "https://spritely.institute/news/the-spritely-institute-publishes-a-scheme-primer.html")
     (synopsis "A Primer for Scheme")
     (description
      "An Info Manual of the Primer for Scheme by the Spritely Institute.")
     (license license:asl2.0))))
scheme-primer



