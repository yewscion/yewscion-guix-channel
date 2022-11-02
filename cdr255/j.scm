(define-module (cdr255 j)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config))
;(define-public %jconsole-tests )
(define jconsole
    (package
      (name "jconsole")
      (version "903-release-b")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/jsoftware/jsource.git")
                      (commit "d69825ebb2b5c4eba9b38c00497cd884f4d0058d")))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1z2p1y3qfzfpmjav4mv72vsschnriwp18r854xsij447qvz0wc9k"))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:phases #~(modify-phases
                    %standard-phases
                    ;; No Autoconf
                    (delete 'configure)
                    (replace
                     'build
                     (lambda* (#:key inputs #:allow-other-keys)
                       (chdir "make2")
                       ;; I was unable to achieve a successful build without
                       ;; explicitly specifying j64 as the architecture.
                       (system "jplatform=linux j64x=j64 ./build_all.sh")
                       (system "./cpbin.sh")))
                    (replace
                     'check
                     (lambda* (#:key tests? #:allow-other-keys)
                       (chdir "../jlibrary/bin")
                       (map (lambda (x)
                              (system (string-append
                                       "./jconsole ../../test/"
                                       x)))
                            '( "g000a.ijs" "g021.ijs" "g102p.ijs" "g128x3.ijs" "g200a.ijs" "g300b.ijs"
   "g3x12a.ijs" "g421p.ijs" "g530.ijs" "g640k.ijs" "gesc.ijs" "gldot.ijs"
   "go.ijs" "gsco.ijs" "gsp420.ijs" "gtdot4.ijs" "g000i.ijs" "g021p.ijs"
   "g102s.ijs" "g128x5.ijs" "g200i.ijs" "g300.ijs" "g3x12.ijs" "g421t.ijs"
   "g530t.ijs" "g640r.ijs" "gfft.ijs" "glocale.ijs" "goox.ijs" "gscou.ijs"
   "gsp421.ijs" "gtdot.ijs" "g000.ijs" "g021s.ijs" "g110a.ijs" "g128x6.ijs"
   "g200.ijs" "g300t.ijs" "g3x4.ijs" "g422.ijs" "g531.ijs" "g641.ijs"
   "gf.ijs" "gmbx0.ijs" "gop.ijs" "gsdot.ijs" "gsp422.ijs" "gthrow.ijs"
   "g000p.ijs" "g022a.ijs" "g110i.ijs" "g128x7.ijs" "g200m.ijs" "g301.ijs"
   "g3x5.ijs" "g422os.ijs" "g532.ijs" "g6x0.ijs" "gfor.ijs" "gmbx1.ijs"
   "gos.ijs" "gselect.ijs" "gsp431.ijs" "gt.ijs" "g000s.ijs" "g022i.ijs"
   "g110.ijs" "g128x.ijs" "g200p.ijs" "g310a.ijs" "g3x6.ijs" "g422rk.ijs"
   "g5x0.ijs" "g6x14.ijs" "gft.ijs" "gmbx2.ijs" "gparse.ijs" "gs.ijs"
   "gsp432.ijs" "gtrain.ijs" "g001.ijs" "g022.ijs" "g110p.ijs" "g130a.ijs"
   "g201.ijs" "g310.ijs" "g3x.ijs" "g422sort1.ijs" "g5x1.ijs" "g6x.ijs"
   "ggoto.ijs" "gmbx3.ijs" "gpco2.ijs" "gsp000.ijs" "gsp520.ijs" "gtry.ijs"
   "g010a.ijs" "g022p.ijs" "g110s.ijs" "g130i.ijs" "g202b.ijs"
   "g310names.ijs" "g400e.ijs" "g422sort.ijs" "g5x2.ijs" "g7x5.ijs" "gh.ijs"
   "gmbx4.ijs" "gpco.ijs" "gsp0.ijs" "gsp520sd.ijs" "gu0.ijs" "g010i.ijs"
   "g022s.ijs" "g111a.ijs" "g130.ijs" "g202.ijs" "g310r.ijs" "g400.ijs"
   "g422tao.ijs" "g5x30.ijs" "g7x6.ijs" "gi0.ijs" "gmbx5.ijs" "gpcoinv.ijs"
   "gsp100.ijs" "gsp520ss.ijs" "gu.ijs" "g010.ijs" "g030a.ijs" "g111i.ijs"
   "g130p.ijs" "g210a.ijs" "g310t.ijs" "g401.ijs" "g430a2.ijs" "g5x4.ijs"
   "g7x.ijs" "gibs.ijs" "gmbx6.ijs" "gpdd.ijs" "gsp101.ijs" "gsp521.ijs"
   "gunderai.ijs" "g010p.ijs" "g030.ijs" "g111.ijs" "g131.ijs" "g210.ijs"
   "g311.ijs" "g402.ijs" "g430avg.ijs" "g5x5.ijs" "g8x.ijs" "gibst.ijs"
   "gmbxah.ijs" "gpick.ijs" "gsp102.ijs" "gsp530i.ijs" "gwhile.ijs"
   "g010s.ijs" "g031.ijs" "g111p.ijs" "g132.ijs" "g211.ijs" "g312.ijs"
   "g410a.ijs" "g430b.ijs" "g5x6.ijs" "g9x40.ijs" "gicap2.ijs" "gmbx.ijs"
   "gpi.ijs" "gsp110.ijs" "gsp530l.ijs" "gx132.ijs" "g011a.ijs" "g032.ijs"
   "g111s.ijs" "g13x.ijs" "g212.ijs" "g320.ijs" "g410i.ijs" "g430d.ijs"
   "g5x7.ijs" "g9x.ijs" "gicap.ijs" "gmbxip.ijs" "gpoly.ijs" "gsp111.ijs"
   "gsp530n.ijs" "gxco1.ijs" "g011i.ijs" "g0a.ijs" "g112a.ijs" "g15x.ijs"
   "g220.ijs" "g320ip.ijs" "g410.ijs" "g430fin.ijs" "g5x.ijs" "ga.ijs"
   "gico.ijs" "gmbxqz.ijs" "gq101.ijs" "gsp112.ijs" "gsp531.ijs" "gxco2.ijs"
   "g011.ijs" "g0.ijs" "g112i.ijs" "g18x.ijs" "g220t.ijs" "g320ipt.ijs"
   "g410p.ijs" "g430.ijs" "g600.ijs" "gassert.ijs" "giconv.ijs"
   "gmbxx1u.ijs" "gq132.ijs" "gsp120.ijs" "gsp5x5.ijs" "gxco.ijs"
   "g011p.ijs" "g0x.ijs" "g112.ijs" "g1x0.ijs" "g221.ijs" "g321.ijs"
   "g410s.ijs" "g430inv.ijs" "g600ip.ijs" "gb.ijs" "gif.ijs" "gmbxx1w.ijs"
   "gq201.ijs" "gsp122.ijs" "gsp600a.ijs" "gx.ijs" "g011s.ijs" "g100a.ijs"
   "g112p.ijs" "g1x11.ijs" "g222a.ijs" "g321t.ijs" "g411.ijs" "g431a.ijs"
   "g601.ijs" "gbpar.ijs" "gi.ijs" "gmbxx.ijs" "gqco.ijs" "gsp130.ijs"
   "gsp600.ijs" "gxinf.ijs" "g012a.ijs" "g100i.ijs" "g112s.ijs" "g1x12.ijs"
   "g222i.ijs" "g322.ijs" "g412.ijs" "g431.ijs" "g602.ijs" "gchar.ijs"
   "gimaxmin.ijs" "gmean.ijs" "gq.ijs" "gsp1.ijs" "gsp6.ijs test.htm
   g012i.ijs" "g100.ijs" "g120a.ijs" "g1x1.ijs" "g222.ijs" "g330f.ijs"
   "g420ce.ijs" "g432.ijs" "g610.ijs" "gc.ijs" "gintdiv.ijs" "gmemo.ijs"
   "gqnonrat.ijs" "gsp221.ijs" "gspi.ijs tsu.ijs" "g012.ijs" "g100p.ijs"
   "g120i.ijs" "g1x20.ijs" "g222p.ijs" "g330.ijs" "g420fg.ijs" "g4x5.ijs"
   "g612.ijs" "gcip.ijs" "gintg.ijs" "gmmf1s.ijs" "gr1.ijs" "gsp222.ijs"
   "gsp.ijs" "g012p.ijs" "g100s.ijs" "g120.ijs" "g1x2.ijs" "g222s.ijs"
   "g330t.ijs" "g420.ijs" "g4x.ijs" "g620a.ijs" "gcompsc.ijs" "gintovfl.ijs"
   "gmmf1u.ijs" "grefcount.ijs" "gsp231.ijs" "gspj.ijs" "g012s.ijs"
   "g101a.ijs" "g120p.ijs" "g1x30.ijs" "g230a.ijs" "g331bx.ijs" "g420r2.ijs"
   "g500.ijs" "g620.ijs" "gct.ijs" "giph.ijs" "gmmf1w.ijs" "gregex.ijs"
   "gsp2.ijs" "gspo.ijs" "g020a.ijs" "g101i.ijs" "g120s.ijs" "g1x3.ijs"
   "g230i.ijs" "g331col.ijs" "g420stch.ijs" "g502.ijs" "g621.ijs"
   "gctrl.ijs" "gipht.ijs" "gmmf.ijs" "gr.ijs" "gsp320.ijs" "gspr.ijs"
   "g020i.ijs" "g101.ijs" "g121.ijs" "g1x43.ijs" "g230.ijs" "g331.ijs"
   "g420t.ijs" "g510.ijs" "g622.ijs" "gddot.ijs" "giscode.ijs" "gmnom.ijs"
   "gsco1.ijs" "gsp321.ijs" "gspx.ijs" "g020.ijs" "g101p.ijs" "g122a.ijs"
   "g1x4.ijs" "g230p.ijs" "g331ins.ijs" "g421c.ijs" "g520b.ijs" "g630.ijs"
   "gd.ijs" "git.ijs" "gnan.ijs" "gsco1u.ijs" "gsp322.ijs" "gss.ijs"
   "g020p.ijs" "g101s.ijs" "g122.ijs" "g1x55.ijs" "g230s.ijs" "g331ps.ijs"
   "g421d.ijs" "g520.ijs" "g631c.ijs" "gdll_df.ijs" "gix.ijs" "gn.ijs"
   "gsco1w.ijs" "gsp331.ijs" "gstack.ijs" "g020s.ijs" "g102a.ijs"
   "g128x10.ijs" "g1x5.ijs" "g231.ijs" "g331sp.ijs" "g421e.ijs" "g520p.ijs"
   "g631.ijs" "gdll.ijs" "gj.ijs" "gnum.ijs" "gsco2.ijs" "gsp400.ijs"
   "gtdot1.ijs" "g021a.ijs" "g102i.ijs" "g128x11a.ijs" "g1x7.ijs" "g232.ijs"
   "g332.ijs" "g421i.ijs" "g521.ijs" "g632.ijs" "gebar.ijs" "glapack.ijs"
   "gnvv.ijs" "gsco2u.ijs" "gsp410.ijs" "gtdot2.ijs" "g021i.ijs" "g102.ijs"
   "g128x11.ijs" "g1x.ijs" "g2x.ijs" "g332s.ijs" "g421.ijs" "g522.ijs"
   "g640.ijs" "ge.ijs" "glco.ijs" "goi.ijs" "gsco2w.ijs" "gsp412.ijs"
   "gtdot3.ijs")))))))
;      (native-inputs (list ))
      (synopsis "")
      (description "J is a high-level, general purpose programming language.   The J system provides: an engine for executing J; various front ends that provide user interfaces to the J engine; a library, written in J, that provides an IDE (interactive development environment), numerous tools, utililties, demos, tutorials; and online documention.  Jconsole is a command line interface to the J engine.")
      (home-page "https://www.jsoftware.com/")
      (license license:gpl3)))


