(define-module (yewscion codechallenges)
 #:use-module (guix packages)
 #:use-module ((guix licenses) #:prefix license:)
 #:use-module (guix download)
 #:use-module (guix build-system gnu)
 #:use-module (guix git-download)
 #:use-module (gnu packages)
 #:use-module (gnu packages autotools)
 #:use-module (gnu packages pkg-config)
 #:use-module (gnu packages texinfo)
 #:use-module (gnu packages guile)
 #:use-module (gnu packages java)
 #:use-module (guix gexp))
(define-public codechallenge-solutions
  (let ((commit "b7b9f43aa05acbe56fa7be61a787ef67bb81e4e4")
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
                "004pfay62lkjk99axmqv59f3wx86aya7zjgp7m912pcizdq02d04"))))
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
codechallenge-solutions
