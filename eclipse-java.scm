;;;; eclipse.scm -- Mthl's eclipse package definition
;;; Copyright © 2018 Mathieu Lirzin <address@hidden>
;;;
;;; This program is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define-module (mthl packages eclipse-java)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages java)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages bash)
  #:use-module (guix download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))

(define-public eclipse-java
  ;; XXX: This package is not built from source.
  (package
   (name "eclipse-java")
   (version "oxygen")
   ;; TODO: Handle i686 alternate origin and augment 'supported-systems'.
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://www.eclipse.org/downloads/download.php?";
                  "r=1&nf=1&file=/technology/epp/downloads/release/"
                  version "/3a/" name "-"
                  version "-3a-linux-gtk-x86_64.tar.gz"))
            (sha256
             (base32
              "0m7y7jfm059w01x9j5b5qkinjjmhkyygpjabhjf19fg2smxmwcim"))))
   (build-system trivial-build-system)
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
        (use-modules (guix build utils))
        (let* ((source  (assoc-ref %build-inputs "source"))
               (out     (assoc-ref %outputs "out"))
               (eclipse (string-append out "/eclipse/eclipse")))
          (mkdir-p (string-append out "/bin"))
          (set-path-environment-variable "PATH" '("bin")
                                         (map cdr %build-inputs))
          (and
           (invoke "tar" "xvf" source "-C" out)
           (let ((ld-so (string-append (assoc-ref %build-inputs "libc")
                                       "/lib/ld-linux-x86-64.so.2")))
             (invoke "patchelf" "--set-interpreter" ld-so eclipse))
           (let ((jdk (assoc-ref %build-inputs "jdk")))
             (define (libdir input)
               (string-append (assoc-ref %build-inputs input) "/lib"))

             (wrap-program eclipse
                           `("PATH" prefix (,(string-append jdk "/bin")))
                           `("LD_LIBRARY_PATH" prefix ,(map libdir
                                                            '("gtk+" "libxtst" "glib"))))
             (symlink eclipse (string-append out "/bin/eclipse"))
             #t))))))
   (native-inputs
    `(("tar" ,tar)
      ("gzip" ,gzip)
      ("patchelf" ,patchelf)))
   (inputs
    `(("bash" ,bash)
      ("glib" ,glib)
      ("gtk+" ,gtk+)
      ("jdk" ,icedtea-8)
      ("libc" ,glibc)
      ("libxtst" ,libxtst)))
   (supported-systems '("x86_64-linux"))
   (synopsis "Java Integrated Development Environment")
   (description
    "Eclipse is an integrated development environment (IDE) used in computer
programming, in particular for Java development.  It contains a base workspace
and an extensible plug-in system for customizing the environment.")
   (home-page "https://www.eclipse.org/")
   (license license:mpl2.0)))
eclipse-java
