(define-module (cdr255 emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:hide (zip)))

(define-public emacs-leetcode
  (let ((commit "f12421eeb9cfd5e7c223ab5190026fc6972a4cc7")
        (revision "1")
        (tag "0"))
    (package
      (name "emacs-leetcode")
      (version (git-version tag revision commit))
      (home-page "https://github.com/yewscion/leetcode-emacs.git")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/yewscion/leetcode-emacs.git")
                      (commit commit)))
                (sha256
                 (base32
                  "1hk0vs8yzxrpch7cab16kv5jrmdiq0p74j4vc8awf53j4mmqid85"))
                (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-names emacs-ctable))
      (synopsis "Solve and submit LeetCode problems from within Emacs")
      (description "This package provides an Emacs interface to LeetCode
allowing users to log in and solve problems of their choice using Emacs.")
      (license license:unlicense))))
