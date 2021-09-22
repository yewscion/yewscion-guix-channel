# Yewscion Guix Channel

My Own Personal Guix Channel.

## Installation

To use this Channel, follow the [documentation][b] for adding a new
channel. Add the following to `~/.config/guix/channels.scm`.

```scheme
;; Add variant packages to those Guix provides.
(cons
  (channel
    (name 'yewscion)
    (url "https://git.sr.ht/~yewscion/yewscion-guix-channel")
    (introduction
      (make-channel-introduction
        ""
        (openpgp-fingerprint
          ""))))
  %default-channels)
```

## Usage

```bash
guix pull
```

## Contributing

Pull Requests are welcome, as are bugfixes and extensions. Please open
issues as needed. If You contribute a feature, needs to be tests and
documentation.

## License

[LGPL-3.0][c]

[a]: https://common-lisp.net/project/asdf/asdf.html#Configuring-ASDF-to-find-your-systems

[b]: https://guix.gnu.org/manual/en/html_node/Specifying-Additional-Channels.html

[c]: https://choosealicense.com/licenses/lgpl-3.0/
