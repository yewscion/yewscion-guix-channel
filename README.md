# Yewscion Guix Channel

My Own Personal Guix Channel.

## Installation

To use this Channel, follow the [documentation][b] for adding a new channel. Add
the following to `~/.config/guix/channels.scm`.

```scheme
;; Add yewscion's variant packages to those Guix provides.
(cons* (channel
   (name 'yewscion)
   (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
   (branch "trunk")
   ;; Enable signature verification:
   (introduction
     (make-channel-introduction
       "2dce8bfec5f2886f7642007bbead3f2fbee26312"
       (openpgp-fingerprint
         "6E3D E92C 3D0A 0A4D 1CDD  33EC 8EF2 971E D0D0 35B8"))))
  %default-channels)
```

## Usage

```bash
guix pull
```

## Contributing

Pull Requests are welcome, as are bugfixes and extensions. Please open issues as
needed. If You contribute a feature, needs to be tests and documentation.

## License

[AGPL-3.0][c]

[a]: https://common-lisp.net/project/asdf/asdf.html#Configuring-ASDF-to-find-your-systems

[b]: https://guix.gnu.org/manual/en/html_node/Specifying-Additional-Channels.html

[c]: https://choosealicense.com/licenses/agpl-3.0/
