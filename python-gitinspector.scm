(define-module (python-gitinspector)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system python)
  #:use-module (guix licenses)
  #:use-module (guix utils)
  #:use-module (guix store)
  #:use-module (guix gexp))
(define-public python-gitinspector
  (let ((commit "cc8302edf08fa7e266f3ca23220af3d4cb15dc46")
        (revision "1"))
    (package
     (name "python-gitinspector")
     (version (git-version "0.4.4" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ejwa/gitinspector.git")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1pfsw6xldm6jigs3nhysvqaxk8a0zf8zczgfkrp920as9sya3c7m"))))
     (build-system python-build-system)
     (arguments
      `(#:python ,python-2.7))
     (inputs `(("python2-unittest2" ,python2-unittest2)))
;     (native-inputs `(("python2" ,python-2.7)))
     (home-page "http://gitinspector.googlecode.com")
     (synopsis "A statistical analysis tool for git repositories.")
     (description
      "This package provides a statistical analysis tool for git repositories.")
     (license gpl3))))
python-gitinspector
