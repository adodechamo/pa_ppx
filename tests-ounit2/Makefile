# Makefile,v
# Copyright (c) INRIA 2007-2017

WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile

PACKAGEPREFIX=pa_ppx_

DESTDIR=
RM=rm

LAUNCH=env TOP=$(TOP) $(TOP)/tools/LAUNCH
OCAMLFIND=$(LAUNCH) ocamlfind
NOT_OCAMLFIND=$(LAUNCH) not-ocamlfind
MKCAMLP5=$(LAUNCH) mkcamlp5
PACKAGES := $(PACKAGES),ounit2,fmt,pcre,rresult,compiler-libs.common,yojson,sexplib

PPXPACKAGES:=ppx_import
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.show
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.eq
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.ord
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.enum
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.iter
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.map
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.fold
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving.make
PPXPACKAGES:=$(PPXPACKAGES),ppx_deriving_yojson
PPXPACKAGES:=$(PPXPACKAGES),ppx_here

PAPACKAGES:=camlp5.pa_o.link
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)utils
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)dock.link
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)import
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)deriving_plugins.std
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)deriving_plugins.yojson
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)deriving_plugins.sexp
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)hashrecons
PAPACKAGES:=$(PAPACKAGES),$(PACKAGEPREFIX)testutils

ALL_PACKAGES := $(PACKAGES),$(PAPACKAGES),$(PPXPACKAGES)

CMO=papr_util.cmo hCPassthru.cmo
CMI := $(CMO:.cmo=.cmi)
CMX := $(CMO:.cmo=.cmx)

TESTS= \
	test_utils.byte \
	test_deriving_show.byte \
	test_deriving_show.ppx.byte \
	test_deriving_eq.byte \
	test_deriving_eq.ppx.byte \
	test_deriving_ord.byte \
	test_deriving_ord.ppx.byte \
	test_deriving_enum.byte \
	test_deriving_enum.ppx.byte \
	test_deriving_iter.byte \
	test_deriving_iter.ppx.byte \
	test_deriving_map.byte \
	test_deriving_map.ppx.byte \
	test_deriving_fold.byte \
	test_deriving_fold.ppx.byte \
	test_deriving_make.byte \
	test_deriving_make.ppx.byte \
	test_deriving_params.byte \
	test_here.byte \
	test_here_original.byte \
	test_here.ppx.byte \
	test_import0.byte \
	test_import_camlp5.byte \
	test_ppx_import.byte \
	test_ppx_import.ppx.byte \
	test_hashrecons.byte \
	test_passthru_hashrecons.byte \
	test_ppx_yojson.byte \
	test_ppx_yojson.ppx.byte \
	test_extensible_variants.byte \
	test_comment_lexer.byte \
	o_top_test.byte

all: $(CMO) $(TESTS)

test: $(TESTS:.byte=)

% : %.byte
	mkdir -p _build && ./$<

test_%.byte: test_%.ml
	cppo -D PAPPX $< > $<.pappx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),$(PAPACKAGES),camlp5.pr_o \
	-syntax camlp5o $<.pappx.ml > $<.pappx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PAPACKAGES) \
	-linkpkg -syntax camlp5o $<.pappx.ml -o $@

test_deriving_params.byte: test_deriving_params.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),str,pa_ppx_testutils,pa_ppx_deriving_plugins.std,pa_ppx_deriving_plugins.params,pa_ppx_params_runtime,camlp5.pr_o -ppopt -sep ";;\n" \
	-syntax camlp5r $< > $*.pappx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),str,pa_ppx_testutils,camlp5.pa_r.link,pa_ppx_base.link,pa_ppx_deriving_plugins.std,pa_ppx_deriving_plugins.params,pa_ppx_params_runtime \
	-c -syntax camlp5r $*.ml
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),str,pa_ppx_testutils,camlp5.pa_r.link,pa_ppx_base.link,pa_ppx_deriving_plugins.std,pa_ppx_deriving_plugins.params,pa_ppx_params_runtime \
	-linkpkg -syntax camlp5r $*.cmo -o $@

test_here_original.byte: test_here.ml
	cppo -D PAPPX $< > $<.pappx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)here_original,camlp5.pr_o \
	-syntax camlp5o $<.pappx.ml > $<_original.pappx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)here_original \
	-linkpkg -syntax camlp5o $<.pappx.ml -o $@

test_here.byte: test_here.ml
	cppo -D PAPPX $< > $<.pappx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)here,camlp5.pr_o \
	-syntax camlp5o $<.pappx.ml > $<.pappx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)here \
	-linkpkg -syntax camlp5o $<.pappx.ml -o $@

test_extensible_variants.byte: test_extensible_variants.ml
	cppo -D PAPPX $< > $<.pappx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),$(PAPACKAGES),camlp5.pr_o \
	-syntax camlp5o $<.pappx.ml > $<.pappx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)runtime_fat \
	-linkpkg -syntax camlp5o $<.pappx.ml -o $@

test_%.ppx.byte: test_%.ml stuff.cmo test_self_import.cmo
	cppo -U PAPPX $< > $<.ppx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),ounit2,$(PPXPACKAGES) $<.ppx.ml > $<.ppx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) -custom $(WARNERR) -package $(PACKAGES),ounit2,$(PPXPACKAGES) -linkpkg stuff.cmo test_self_import.cmo $<.ppx.ml -o $@

test_ppx_yojson.byte: test_ppx_yojson.ml
	cppo -D PAPPX test_ppx_yojson.ml > test_ppx_yojson.pappx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)deriving_plugins.sexp,camlp5.pr_o  -syntax camlp5o  test_ppx_yojson.pappx.ml > test_ppx_yojson.pappx.ml.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PAPACKAGES),$(PACKAGEPREFIX)deriving_plugins.sexp \
	-linkpkg -syntax camlp5o test_ppx_yojson.pappx.ml -o $@

test_ppx_yojson.ppx.byte: test_ppx_yojson.ml stuff.cmo test_self_import.cmo
	cppo test_ppx_yojson.ml > test_ppx_yojson.ppx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),ounit2,$(PPXPACKAGES),ppx_sexp_conv test_ppx_yojson.ppx.ml >  test_ppx_yojson.ppx.ml.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) -custom $(WARNERR) -package $(PACKAGES),ounit2,$(PPXPACKAGES),ppx_sexp_conv -linkpkg stuff.cmo test_self_import.cmo test_ppx_yojson.ppx.ml -o $@

test_passthru_hashrecons.byte: test_passthru_hashrecons.ml hCPassthru.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),camlp5.pa_o.link,camlp5.pr_o.link,$(PACKAGEPREFIX)base.link,$(PACKAGEPREFIX)hashrecons,$(PACKAGEPREFIX)testutils \
	-linkpkg -syntax camlp5o hCPassthru.cmo $< -o $@

hCPassthru.cmo: hCPassthru.ml
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PACKAGEPREFIX)base,$(PACKAGEPREFIX)hashrecons -syntax camlp5r -c $<

test_import0.byte: test_import0.ml stuff.cmo test_self_import.cmi
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PACKAGEPREFIX)deriving_plugins.show,$(PACKAGEPREFIX)import,camlp5.pr_o,$(PACKAGEPREFIX)testutils \
	-ppopt -pa_import-package -ppopt $(PACKAGES) \
	-ppopt -pa_import-I -ppopt . \
	-linkpkg -syntax camlp5o $< -o $@

test_import_camlp5.byte: test_import_camlp5.ml stuff.cmo test_self_import.cmi
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PACKAGEPREFIX)import,$(PACKAGEPREFIX)deriving_plugins.show,$(PACKAGEPREFIX)testutils \
	-ppopt -pa_import-package -ppopt $(PACKAGES) \
	-ppopt -pa_import-I -ppopt . \
	-linkpkg -syntax camlp5o $< -o $@

test_self_import.cmo: test_self_import.ml test_self_import.cmi
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PACKAGEPREFIX)import,$(PACKAGEPREFIX)testutils \
	-ppopt -pa_import-package -ppopt $(PACKAGES) \
	-ppopt -pa_import-I -ppopt . \
	-syntax camlp5o -c $< -o $@

test_self_import.cmi: test_self_import.mli
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES) \
	-syntax camlp5o -c $< -o $@

test_ppx_import.byte: test_ppx_import.ml stuff.cmo test_self_import.cmo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PACKAGEPREFIX)import,$(PACKAGEPREFIX)deriving_plugins.show,$(PACKAGEPREFIX)testutils \
	-ppopt -pa_import-package -ppopt $(PACKAGES) \
	-ppopt -pa_import-I -ppopt . \
	-linkpkg -syntax camlp5o stuff.cmo test_self_import.cmo $< -o $@

o_top_test:: o_top_test.byte
	mkdir -p _build && ./o_top_test.byte

o_top_test.byte: o_top_test.ml
	$(OCAMLFIND) ocamlc $(DEBUG) -package camlp5,ounit2,fmt,compiler-libs.toplevel,camlp5.pa_op.link,camlp5.pr_official.link,camlp5.toploop.link,pa_ppx_base.link,pa_ppx_here.link,$(PACKAGEPREFIX)testutils -syntax camlp5r -linkpkg -impl o_top_test.ml -o o_top_test.byte

testutil2.cmo: testutil2.ml
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES) -syntax camlp5o -c $<

stuff.cmo: stuff.ml
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES) -syntax camlp5o -c $<

clean::
	rm -f *.corrected *.pappx.ml *.ppx.ml *.ppo.ml

EXTERNAL := $(shell $(OCAMLFIND) query -predicates byte -format '%m' $(ALL_PACKAGES) | grep local-install)
$(CMO) $(TESTS): $(EXTERNAL)

depend::
	echo "$(CMO) $(TESTS): $(EXTERNAL)" > .depend.NEW
	$(OCAMLFIND) ocamldep $(DEBUG) $(WARNERR) -package $(PACKAGES) -syntax camlp5o \
	testutil2.ml stuff.ml \
	test_*.ppx.ml \
	test_*.pappx.ml \
	>> .depend.NEW
	$(OCAMLFIND) ocamldep $(DEBUG) $(WARNERR) -package $(PACKAGES) -syntax camlp5r \
	testutil.ml hCPassthru.ml \
	>> .depend.NEW
	mv .depend.NEW .depend

-include .depend
