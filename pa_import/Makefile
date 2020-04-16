# Makefile,v
# Copyright (c) INRIA 2007-2017

WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile

DESTDIR=
RM=rm

LAUNCH=$(TOP)/tools/LAUNCH
OCAMLFIND=$(LAUNCH) ocamlfind
MKCAMLP5=$(LAUNCH) mkcamlp5
PACKAGES := $(PACKAGES),pa_ppx_base,fmt,bos,compiler-libs.common,findlib

TARGET=pa_import.cma
CMO=pa_import.cmo harness.cmo
CMI=$(CMO:.cmo=.cmi)

all: $(TARGET) $(TARGET:.cma=.cmxa) camlp5.pa_ppx_pa_import local-install

camlp5.pa_ppx_pa_import:
	$(MKCAMLP5) -verbose -package $(PACKAGES) $(TARGET) -o $@

META: META.pl
	./META.pl > META

install::
	./META.pl $(DESTDIR)/lib > META
	$(OCAMLFIND) remove -destdir $(DESTDIR)/lib pa_ppx_pa_import || true
	mkdir -p $(DESTDIR)/lib
	$(OCAMLFIND) install pa_ppx_pa_import -destdir $(DESTDIR)/lib META $(TARGET) $(TARGET:.cma=.cmxa) $(CMI)
	$(RM) -f META

local-install::
	$(MAKE) DESTDIR=$(WD)/$(TOP)/local-install/ install

clean::
	rm -rf META camlp5.pa_ppx_pa_import

$(TARGET): $(CMO)
	$(OCAMLFIND) ocamlc $(DEBUG) $(CMO) -a -o $(TARGET)

$(TARGET:.cma=.cmxa): $(CMO:.cmo=.cmx)
	$(OCAMLFIND) ocamlopt $(DEBUG) $(CMO:.cmo=.cmx) -a -o $(TARGET:.cma=.cmxa)

$(TARGET): $(CMO)
$(TARGET:.cma=.cmxa): $(CMO:.cmo=.cmx)

harness.cmo: pa_import.cmo
harness.cmx: pa_import.cmx