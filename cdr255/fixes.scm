(define-module (cdr255 fixes)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages base)
  #:use-module (gnu packages)
  #:use-module (guix build-system ant)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (gnu packages java)
  #:use-module (gnu packages groovy))

(define-public java-logback-core
  (package
    (name "java-logback-core")
    (version "1.2.3")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/qos-ch/logback/")
                    (commit (string-append "v_" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "055jbfpg3l5qw7pw2snkdag0gjkb4vcxfg9110cqqyc40k2nd17z"))
              (modules '((guix build utils)))
              (snippet
               '(delete-file-recursively "logback-access/lib"))))
    (build-system ant-build-system)
    (arguments
     `(#:jar-name "logback.jar"
       #:source-dir "src/main/java"
       #:test-dir "src/test"
       #:test-exclude
       ;; These tests fail with Unable to set MockitoNamingPolicy on cglib generator
       ;; which creates FastClasses
       (list "**/AllCoreTest.*"
             "**/AutoFlushingObjectWriterTest.*"
             "**/PackageTest.*"
             "**/ResilientOutputStreamTest.*"
             ;; And we still don't want to run abstract classes
             "**/Abstract*.*")
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'chdir
           (lambda _ (chdir "logback-core"))))))
    (inputs
     (list java-javax-mail
           java-javaee-servletapi
           java-commons-compiler
           java-janino))
    (native-inputs
     (list java-junit
           java-hamcrest-core
           java-mockito-1
           java-cglib
           java-asm
           java-objenesis
           java-joda-time))
    (home-page "https://logback.qos.ch")
    (synopsis "Logging for java")
    (description "Logback is intended as a successor to the popular log4j project.
This module lays the groundwork for the other two modules.")
    ;; Either epl1.0 or lgpl2.1
    (license (list license:epl1.0
                   license:lgpl2.1))))


(define-public java-logback-classic
  (package
    (inherit java-logback-core)
    (name "java-logback-classic")
    (arguments
     `(#:jar-name "logback-classic.jar"
       #:source-dir "src/main/java"
       #:test-dir "src/test"
       #:tests? #f; tests require more packages: h2, greenmail, hsql, subethamail, slf4j, log4j, felix
       #:jdk ,openjdk15
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'chdir
           (lambda _
             (chdir "logback-classic")
             #t))
         (replace 'build
           (lambda* (#:key inputs #:allow-other-keys)
             (mkdir-p "build/classes")
             (setenv "CLASSPATH"
                     (string-join
                       (apply append (map (lambda (input)
                                            (find-files (assoc-ref inputs input)
                                                        ".*.jar"))
                                          '("java-logback-core" "java-slf4j-api"
                                            "java-commons-compiler" "java-javaee-servletapi"
                                            "groovy")))
                       ":"))
             (apply invoke "groovyc" "-d" "build/classes" "-j"
                    (find-files "src/main/" ".*\\.(groovy|java)$"))
             (invoke "ant" "jar")
             #t)))))
    (inputs
     (modify-inputs (package-inputs java-logback-core)
                    (prepend java-logback-core java-slf4j-api)))
    (native-inputs
     (list groovy))
    (description "Logback is intended as a successor to the popular log4j project.
This module can be assimilated to a significantly improved version of log4j.
Moreover, @code{logback-classic} natively implements the slf4j API so that you
can readily switch back and forth between logback and other logging frameworks
such as log4j or @code{java.util.logging} (JUL).")))
