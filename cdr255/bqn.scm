(define-module (cdr255 bqn)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (gnu packages)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages java)
  #:use-module (gnu packages compression))
(define-public dbqn
  (package
    (name "dbqn")
    (version "0.2.1-1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/dzaima/BQN")
                    (commit "0bbe096fc07d278b679a8479318f1722d096a03e")))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1kxzxz2hrd1871281s4rsi569qk314aqfmng9pkqn8gv9nqhmph0"))))
    (outputs '("out"))
    (build-system gnu-build-system)
    (arguments
     ;; While there is a "test" directory, there is no
     ;; mechanism to run the tests other than to feed the files into the
     ;; binary and check for an error. This is outside the scope of a
     ;; packaging workflow, and would need to be fixed upstream
     ;; instead. Issue Reported: https://github.com/dzaima/BQN/issues/12
     ;; Maintainer says many of the tests fail, and so they will remain off
     ;; until this is sorted out.
     (list #:tests? #f 
           #:imported-modules `(,@%gnu-build-system-modules
                                (guix build syscalls)
                                (guix build ant-build-system))
           #:modules `((guix build gnu-build-system)
                       ((guix build ant-build-system) #:prefix ant:)
                       (guix build utils))
           #:phases #~(modify-phases %standard-phases
                        (delete 'configure)
                        (replace 'build
                          (lambda* _
                            (invoke "./build")))
                        (add-after 'install 'reorder-jar-content
                          (lambda* (#:key outputs #:allow-other-keys)
                            (apply (assoc-ref ant:%standard-phases
                                              'reorder-jar-content)
                                   #:outputs (list outputs))))
                        (add-after 'reorder-jar-content 'jar-indices
                          (lambda* (#:key outputs #:allow-other-keys)
                            (apply (assoc-ref ant:%standard-phases
                                              'generate-jar-indices)
                                   #:outputs (list outputs))))
                        (add-after 'jar-indices 'fix-jar-timestamps
                          (lambda* (#:key outputs #:allow-other-keys)
                            (apply (assoc-ref ant:%standard-phases
                                              'reorder-jar-content)
                                   #:outputs (list outputs))))
                        (replace 'install
                          (lambda* (#:key outputs #:allow-other-keys)
                            (let* ((out (assoc-ref outputs "out"))
                                   (dest-bin (string-append out "/bin"))
                                   (dest-jar (string-append out
                                                            "/share/java")))
                              (mkdir-p dest-bin)
                              (mkdir-p dest-jar)
                              (copy-recursively "BQN"
                                                (string-append dest-bin
                                                               "/dbqn"))
                              (chmod (string-append dest-bin "/dbqn") 493)
                              (install-file "BQN.jar" dest-jar)
                              (substitute* (string-append dest-bin "/dbqn")
                                (("BQN.jar")
                                 (string-append dest-jar "/BQN.jar")))))))))
    (native-inputs (list `(,openjdk17 "jdk")
                         coreutils
                         zip))
    (synopsis "BQN implementation based on dzaima/APL")
    (description "BQN implementation based on dzaima/APL.")
    (home-page "https://github.com/dzaima/BQN")
    (license license:expat)))
(define bqn-bytecode-sources
  (let* ((tag "0")
         (revision "1")
         (commit "e219af48401473a7bac49bdd8b89d69082cf5dd8")
         (hash "0r6pa9lscl2395g4xlvmg90vpdsjzhin4f1r0s7brymmpvmns2yc")
         (version (git-version tag revision commit)))
    (package
      (name "bqn-bytecode-sources")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/mlochbaum/BQN")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  hash))))
      (outputs '("out"))
      (build-system copy-build-system) ;This package pulls down needed source
      ;; files for CBQN's build process. They
      ;; will be compiled during that build;
      ;; none of them are prebuilt binaries.
      (arguments
       (list #:install-plan '(list (list "src/" "share/src"
                                         #:exclude '("README.txt" "doc/"))
                                   (list "test/" "share/test"
                                         #:exclude '("README.txt")))))
      (synopsis "Official BQN sources in BQN")
      (description
       "The collection of sources needed for building a
BQN-based BQN implementation.  These are included here for bootstrapping
purposes.")
      (home-page "https://github.com/mlochbaum/BQN.git")
      (license license:gpl3))))
(define cbqn-bootstrap
  (let* ((tag "0")
         (revision "1")
         (commit "88f65850fa6ac28bc50886c5942652f21d5be924")
         (hash "0bqwpvzwp2v20k2l725cwxx4fkvisniw9nls3685wd0fa3agpb47")
         (version (git-version tag revision commit)))
    (package
      (name "cbqn-bootstrap")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/dzaima/CBQN")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  hash))))
      (build-system gnu-build-system)
      (outputs '("out"))
      (arguments
       (list #:tests? #f ;Skipping Tests for Bootstrap.
             #:phases #~(modify-phases %standard-phases
                          (delete 'configure)
                          (add-before 'build 'generate-bytecode
                            (lambda* (#:key inputs #:allow-other-keys)
                              (system (string-append #$(this-package-native-input
                                                        "dbqn")
                                       "/bin/dbqn ./genRuntime "
                                       #$(this-package-input
                                          "bqn-bytecode-sources") "/share/"))))
                          (replace 'install
                            (lambda* (#:key outputs #:allow-other-keys)
                              (mkdir-p (string-append #$output "/bin"))
                              (chmod "BQN" 493)
                              (copy-recursively "BQN"
                                                (string-append #$output
                                                               "/bin/bqn")))))))
      (native-inputs (list dbqn openjdk17 clang-toolchain))
      (inputs (list bqn-bytecode-sources libffi))
      (synopsis "BQN implementation in C")
      (description
       "The expected implementation for the BQN language,
according to the official documentation of that specification.")
      (home-page "https://mlochbaum.github.io/BQN/")
      (license license:gpl3))))
(define singeli-bootstrap
  (let* ((tag "0")
         (revision "1")
         (commit "fd17b144483549dbd2bcf23e3a37a09219171a99")
         (hash "1rr4l7ijzcg25n2igi1mzya6qllh5wsrf3m5i429rlgwv1fwvfji")
         (version (git-version tag revision commit)))
    (package
      (name "singeli-bootstrap")
      (version version)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/mlochbaum/Singeli")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  hash))))
      (outputs '("out"))
      (build-system copy-build-system)
      (arguments
       (list
             ;; cbqn needs the layout of singeli to stay the same for its tests.
             #:install-plan '(list (list "./" "share/singeli"))))
      (native-inputs (list cbqn-bootstrap))
      (synopsis "High-level interface for low-level programming")
      (description
       "Singeli is a domain-specific language for building SIMD
      algorithms with flexible abstractions and control over every instruction
      emitted. It's implemented in BQN, with a frontend that emits IR and a
      backend that converts it to C. Other backends like LLVM or machine code
      are possible—it should be easy to support other CPU architectures but
      there are no plans to target GPUs.")
      (home-page "https://github.com/mlochbaum/Singeli")
      (license license:isc))))
(define-public cbqn
  (package
    (inherit cbqn-bootstrap)
    (name "cbqn")
    (outputs '("out" "lib"))
    (arguments
     (list #:make-flags '(list "shared-o3" "o3n-singeli")
           #:phases #~(modify-phases %standard-phases
                        (delete 'configure)
                        (add-before 'build 'link-singeli
                          (lambda* (#:key inputs #:allow-other-keys)
                            (symlink (string-append #$(this-package-input
                                                       "singeli-bootstrap")
                                                    "/share/singeli")
                                     "Singeli")))
                        (add-before 'build 'generate-bytecode
                          (lambda* (#:key inputs #:allow-other-keys)
                            (system (string-append #$(this-package-native-input
                                                      "dbqn")
                                                   "/bin/dbqn ./genRuntime "
                                                   #$(this-package-input
                                                      "bqn-bytecode-sources")
                                                   "/share/"))))
                        (replace 'check
                          (lambda* (#:key inputs tests? #:allow-other-keys)
                            (when tests?
                              (map (lambda (x)
                                     (system (string-append "./test/" x ".sh "
                                                            #$(this-package-input
                                                               "bqn-bytecode-sources")
                                                            "/share/")))
                                   '("mainCfgs" "x86Cfgs" "moreCfgs"))
                              (map (lambda (x)
                                     (system (string-append "./BQN ./test/" x
                                                            ".bqn")))
                                   '("cmp" "equal" "copy" "bitcpy" "random"))
                              (system "make -C test/ffi"))))
                        (replace 'install
                          (lambda* (#:key outputs #:allow-other-keys)
                            (let* ((bin (string-append (assoc-ref outputs
                                                                  "out")
                                                       "/bin"))
                                   (lib (string-append (assoc-ref outputs
                                                                  "lib")
                                                       "/lib")))
                              (mkdir-p bin)
                              (mkdir-p lib)
                              (chmod "BQN" 493)
                              (copy-recursively "BQN"
                                                (string-append bin "/bqn"))
                              (install-file "libcbqn.so" lib)))))))
    (inputs (list bqn-bytecode-sources libffi singeli-bootstrap))))
