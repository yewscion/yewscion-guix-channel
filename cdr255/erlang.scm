(define-module (cdr255 erlang)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system rebar)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config))

(define-public erlang-t--
  (package
   (name "erlang-t--")
   (version "0.1.0")
   (source (origin
            (method url-fetch)
            (uri (hexpm-uri "t__" version))
            (sha256
             (base32
              "13fwh57xmwcspz8zi23430ap7rqg0w07avzh31l3g25zsqf1lml2"))))
   (build-system rebar-build-system)
   (synopsis "Erlang gettext application")
   (description "Erlang gettext application")
   (home-page "https://hexdocs.pm/t__/")
   (license license:expat)))

(define-public erlang-geminic
  (package
   (name "erlang-geminic")
   (version "0.1.0")
   (source (origin
            (method url-fetch)
            (uri (hexpm-uri "geminic" version))
            (sha256
             (base32
              "18i2cpsp9s8q1qx9qqyrvdismh8mnfvmdfqs7kzv0r36s4q792rv"))))
   (build-system rebar-build-system)
   (synopsis "An OTP Gemini protocol client application")
   (description "An OTP Gemini protocol client application")
   (home-page "https://hexdocs.pm/geminic/")
   (license license:expat)))

