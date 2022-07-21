(define-module (cdr255 rust)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (gnu packages)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages glib)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:hide (zip)))

(define-public rust-cargo-husky-1
  (package
    (name "rust-cargo-husky")
    (version "1.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "cargo-husky" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1b9jx720dzw9s7rl82bywz4d089c9rb0j526c1jfzs1g4llvc0kv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rhysd/cargo-husky#readme")
    (synopsis "husky for cargo")
    (description "husky for cargo")
    (license license:expat)))
(define-public rust-tokio-macros-0.2
  (package
    (name "rust-tokio-macros")
    (version "0.2.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tokio-macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ni60vnrf32r3wfhlahmnds1phx5d1xfbmyq9j0mz8kkzh5s0kg4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://tokio.rs")
    (synopsis "Tokio's proc macros.
")
    (description "Tokio's proc macros.")
    (license license:expat)))
(define-public rust-net2-0.2
  (package
    (name "rust-net2")
    (version "0.2.37")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "net2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1bk8jp0i12gvhrlaqbfq19ancja70r1rg3sywbhjl0385g8k05ir"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-0.1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/deprecrated/net2-rs")
    (synopsis
     "Extensions to the standard library's networking types as proposed in RFC 1158.
")
    (description
     "Extensions to the standard library's networking types as proposed in RFC 1158.")
    (license (list license:expat license:asl2.0))))
(define-public rust-miow-0.2
  (package
    (name "rust-miow")
    (version "0.2.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "miow" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kcl8rnv0bhiarcdakik670w8fnxzlxhi1ys7152sck68510in7b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-kernel32-sys" ,rust-kernel32-sys-0.2)
                       ("rust-net2" ,rust-net2-0.2)
                       ("rust-winapi" ,rust-winapi-0.2)
                       ("rust-ws2-32-sys" ,rust-ws2-32-sys-0.2))))
    (home-page "https://github.com/yoshuawuyts/miow")
    (synopsis
     "A zero overhead I/O library for Windows, focusing on IOCP and Async I/O
abstractions.
")
    (description
     "This package provides a zero overhead I/O library for Windows, focusing on IOCP
and Async I/O abstractions.")
    (license (list license:expat license:asl2.0))))
(define-public rust-mio-0.6
  (package
    (name "rust-mio")
    (version "0.6.23")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "mio" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1i2c1vl8lr45apkh8xbh9k56ihfsmqff5l7s2fya7whvp7sndzaa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-0.1)
                       ("rust-fuchsia-zircon" ,rust-fuchsia-zircon-0.3)
                       ("rust-fuchsia-zircon-sys" ,rust-fuchsia-zircon-sys-0.3)
                       ("rust-iovec" ,rust-iovec-0.1)
                       ("rust-kernel32-sys" ,rust-kernel32-sys-0.2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-miow" ,rust-miow-0.2)
                       ("rust-net2" ,rust-net2-0.2)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-winapi" ,rust-winapi-0.2))))
    (home-page "https://github.com/tokio-rs/mio")
    (synopsis "Lightweight non-blocking IO")
    (description "Lightweight non-blocking IO")
    (license license:expat)))
(define-public rust-tokio-0.2
  (package
    (name "rust-tokio")
    (version "0.2.25")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tokio" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "14l0rll6y1dyzh6qcd8rma2ch3wx0dxzxq8b54di744sjirs40v7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-0.5)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-iovec" ,rust-iovec-0.1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-mio" ,rust-mio-0.6)
                       ("rust-mio-named-pipes" ,rust-mio-named-pipes-0.1)
                       ("rust-mio-uds" ,rust-mio-uds-0.6)
                       ("rust-num-cpus" ,rust-num-cpus-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.11)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.1)
                       ("rust-signal-hook-registry" ,rust-signal-hook-registry-1)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-tokio-macros" ,rust-tokio-macros-0.2)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://tokio.rs")
    (synopsis
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O
backed applications.
")
    (description
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O backed
applications.")
    (license license:expat)))
(define-public rust-pyo3-derive-backend-0.8
  (package
    (name "rust-pyo3-derive-backend")
    (version "0.8.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pyo3-derive-backend" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0my0zj3z5wy7yrzg8mpx604gg7xb1pz05f2wq8y3giyqgwixi0j8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/pyo3/pyo3")
    (synopsis "Code generation for PyO3 package")
    (description "Code generation for PyO3 package")
    (license license:asl2.0)))
(define-public rust-pyo3cls-0.8
  (package
    (name "rust-pyo3cls")
    (version "0.8.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pyo3cls" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1npcpqvk7pprmcpqgx8kxmfny4z545nwhcw7548p8psmmg7j3wzx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-pyo3-derive-backend" ,rust-pyo3-derive-backend-0.8)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/pyo3/pyo3")
    (synopsis "Proc macros for PyO3 package")
    (description "Proc macros for PyO3 package")
    (license license:asl2.0)))
(define-public rust-pyo3-0.8
  (package
    (name "rust-pyo3")
    (version "0.8.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pyo3" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0dcz7y5dbgdrr7i47gvk10yjbm37l4a7z4bd57hzndk4b1by5gz1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indoc" ,rust-indoc-0.3)
                       ("rust-inventory" ,rust-inventory-0.1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-num-bigint" ,rust-num-bigint-0.4)
                       ("rust-num-complex" ,rust-num-complex-0.4)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-paste" ,rust-paste-0.1)
                       ("rust-pyo3cls" ,rust-pyo3cls-0.8)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-spin" ,rust-spin-0.5)
                       ("rust-unindent" ,rust-unindent-0.1)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://github.com/pyo3/pyo3")
    (synopsis "Bindings to Python interpreter")
    (description "Bindings to Python interpreter")
    (license license:asl2.0)))
(define-public rust-dbus-0.2
  (package
    (name "rust-dbus")
    (version "0.2.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "dbus" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0b85dl7y396g8xh1xh89wxnb1fvvf840dar9axavfhhhlq7c385l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/diwic/dbus-rs")
    (synopsis
     "Bindings to D-Bus, which is a bus commonly used on Linux for inter-process communication.")
    (description
     "Bindings to D-Bus, which is a bus commonly used on Linux for inter-process
communication.")
    (license (list license:asl2.0 license:expat))))
(define-public rust-secret-service-1
  (package
    (name "rust-secret-service")
    (version "1.1.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "secret-service" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12hxz35i7sw5xsdldz1c6776fmz98z4dwh5779jis98w61020xbd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aes" ,rust-aes-0.6)
                       ("rust-block-modes" ,rust-block-modes-0.7)
                       ("rust-dbus" ,rust-dbus-0.2)
                       ("rust-hkdf" ,rust-hkdf-0.10)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-num" ,rust-num-0.3)
                       ("rust-rand" ,rust-rand-0.7)
                       ("rust-sha2" ,rust-sha2-0.9))))
    (home-page "https://github.com/hwchen/secret-service-rs.git")
    (synopsis "Library to interface with Secret Service API")
    (description "Library to interface with Secret Service API")
    (license (list license:expat license:asl2.0))))
(define-public rust-keyring-0.8
  (package
    (name "rust-keyring")
    (version "0.8.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "keyring" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "078i86kb23czvxvs4law6gncx4jqrxzk65qwzf2lqzywlnm4wq3j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-secret-service" ,rust-secret-service-1)
                       ("rust-security-framework" ,rust-security-framework-0.3)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/hwchen/keyring-rs")
    (synopsis "Cross-platform library for managing passwords/credentials")
    (description "Cross-platform library for managing passwords/credentials")
    (license (list license:expat license:asl2.0))))
(define-public rust-leetcode-cli-0.3
  (package
    (name "rust-leetcode-cli")
    (version "0.3.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "leetcode-cli" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1iii7zay49cipyawwswdqcfgs2pg2iij657zvjbck32bbnh5bvnm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-clap" ,rust-clap-2)
                       ("rust-colored" ,rust-colored-1)
                       ("rust-diesel" ,rust-diesel-1)
                       ("rust-dirs" ,rust-dirs-2)
                       ("rust-env-logger" ,rust-env-logger-0.7)
                       ("rust-escaper" ,rust-escaper-0.1)
                       ("rust-keyring" ,rust-keyring-0.8)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nix" ,rust-nix-0.17)
                       ("rust-openssl" ,rust-openssl-0.10)
                       ("rust-pyo3" ,rust-pyo3-0.8)
                       ("rust-rand" ,rust-rand-0.7)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-reqwest" ,rust-reqwest-0.10)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tokio" ,rust-tokio-0.2)
                       ("rust-toml" ,rust-toml-0.5))
       #:cargo-development-inputs (("rust-cargo-husky" ,rust-cargo-husky-1))))
    (inputs (list pkg-config
                  openssl
                  dbus
                  sqlite))
    (home-page "https://github.com/clearloop/leetcode-cli")
    (synopsis "Leet your code in command-line.")
    (description "Leet your code in command-line.")
    (license license:expat)))
