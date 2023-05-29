(define-module (cdr255 k)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages pkg-config))

(define-public kona
  (let* ((revision "1")
         (commit "ff7e51e5685c552ec755447de84c9ca687809d8f"))
    (package
      (name "kona")
      (version (git-version "211225" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/kevinlawler/kona.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1ybij0q1lmvdqshdmvgy5br32ybgq361p0143lmdsa7ji5rbsxlv"))))
      (outputs '("out"))
      (build-system gnu-build-system)
      (arguments
       (list #:make-flags #~(list "CC=gcc"
                                  (string-append "PREFIX="
                                                 #$output))
             #:tests? #f ;No upstream make check.
             #:phases #~(modify-phases %standard-phases
                          (delete 'configure)
                          (add-before 'install 'create-dir
                            (lambda _
                              (mkdir #$output)
                              (mkdir (string-append #$output "/bin")))))))
      (native-inputs (list gcc-toolchain))
      (synopsis "Open Source k3 Implementation")
      (description
       "Kona is the open-source implementation of the k3 programming language. k is a synthesis of APL and LISP. Although many of the capabilities come from APL, the fundamental data construct is quite different.  In APL the construct is a multi-dimensional matrix-like array, where the dimension of the array can range from 0 to some maximum (often 9). In k, like LISP, the fundamental data construct is a list.  Also, like LISP, the k language is ASCII-based, so you don't need a special keyboard.")
      (home-page "https://github.com/kevinlawler/kona/")
      (license license:isc))))

