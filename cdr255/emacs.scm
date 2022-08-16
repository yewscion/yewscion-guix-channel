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
  #:use-module (gnu packages emacs-xyz))

(define-public emacs-leetcode
  (let* ((tag "0")
         (revision "1")
         (commit "f12421eeb9cfd5e7c223ab5190026fc6972a4cc7")
         (hash "1hk0vs8yzxrpch7cab16kv5jrmdiq0p74j4vc8awf53j4mmqid85")
         (version (git-version tag revision commit)))
    (package
      (name "emacs-leetcode")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/yewscion/leetcode-emacs.git")
                      (commit commit)))
                (sha256 (base32 hash))
                (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-names emacs-ctable))
      (synopsis "Solve and submit LeetCode problems from within Emacs")
      (description "This package provides an Emacs interface to LeetCode
allowing users to log in and solve problems of their choice using Emacs.")
      (home-page "https://github.com/yewscion/leetcode-emacs.git")
      (license license:unlicense))))
(define-public emacs-bqn-mode
  (let* ((tag "0")
         (revision "1")
         (commit "035f7731e0ca6c11bc3e7552809424e9773368ef"))
    (package
      (name "emacs-bqn-mode")
      (version (git-version tag revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/yewscion/bqn-mode.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256 (base32 "1lzizakf6rami85lvxkk3csl1qawv9g4lvmq1dd540nrppj72i2l"))))
      (outputs '("out"))
      (build-system emacs-build-system)
      (synopsis "Major Mode for BQN")
      (description "The official major mode for the BQN language in Emacs.
Derived from gnu-apl-mode.")
      (home-page "https://mlochbaum.github.io/BQN/editors/index.html")
      (license license:gpl3))))
