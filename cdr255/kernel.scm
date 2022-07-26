(define-module (cdr255 kernel)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix utils)
  #:use-module (guix deprecation)
  #:use-module (guix git-download)
  #:use-module (guix svn-download)
  #:use-module (gnu packages base)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module ((srfi srfi-1) #:hide (zip)))

(define %jory-config-options
  '(
    ;; https://logs.guix.gnu.org/guix/2022-07-26.log#205936
    ("CONFIG_ATH9K_HWRNG" . #f)))

(define %jory-config
  (append %jory-config-options
          (@@ (gnu packages linux) %default-extra-linux-options)))

(define-public linux-libre-jory
  ((@@ (gnu packages linux) make-linux-libre*)
   (@@ (gnu packages linux) linux-libre-version)
   (@@ (gnu packages linux) linux-libre-gnu-revision)
   (@@ (gnu packages linux) linux-libre-source)
   '("x86_64-linux")
   #:configuration-file (@@ (gnu packages linux) kernel-config)
   #:extra-version "jory"
   #:extra-options %jory-config))
