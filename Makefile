PACKAGE = lilypond.sile

SHELL := zsh
.SHELLFLAGS := +o nomatch -e -c

.ONESHELL:
.SECONDEXPANSION:
.DELETE_ON_ERROR:
.SUFFIXES:

VERSION != git describe --tags --always --abbrev=7 | sed 's/-/-r/'
SEMVER != git describe --tags | sed 's/^v//;s/-.*//'
ROCKREV = 1
TAG ?= v$(SEMVER)

DEV_SPEC = $(PACKAGE)-dev-$(ROCKREV).rockspec
DEV_ROCK = $(PACKAGE)-dev-$(ROCKREV).src.rock
REL_SPEC = rockspecs/$(PACKAGE)-$(SEMVER)-$(ROCKREV).rockspec
REL_ROCK = $(PACKAGE)-$(SEMVER)-$(ROCKREV).src.rock

.PHONY: all
all: rockspecs dist

.PHONY: rockspecs
rockspecs: $(DEV_SPEC) $(REL_SPEC)

.PHONY: dist
dist: $(DEV_ROCK) $(REL_ROCK)

define rockpec_template =
	sed -e "s/@SEMVER@/$(SEMVER)/g" \
		-e "s/@ROCKREV@/$(ROCKREV)/g" \
		-e "s/@TAG@/$(TAG)/g" \
		$< > $@
endef

$(PACKAGE)-dev-%.rockspec: SEMVER = dev
$(PACKAGE)-dev-%.rockspec: TAG = master
$(PACKAGE)-dev-%.rockspec: $(PACKAGE).rockspec.in
	$(rockpec_template)
	sed -i \
		"1i -- DO NOT EDIT! Modify template $< and rebuild with \`make $@\`" \
		$@

rockspecs/$(PACKAGE)-%.rockspec: SEMVER = $*
rockspecs/$(PACKAGE)-%.rockspec: TAG = v$*
rockspecs/$(PACKAGE)-%.rockspec: $(PACKAGE).rockspec.in
	$(rockpec_template)
	sed -i \
		-e '/rockspec_format/s/3.0/1.0/' \
		-e '/url = "git/a\   dir = "$(PACKAGE)",' \
		-e '/issues_url/d' \
		-e '/maintainer/d' \
		-e '/labels/d' \
		$@

$(PACKAGE)-%.src.rock: $(DEV_SPEC)
	luarocks pack $<

$(PACKAGE)-%.src.rock: rockspecs/$(PACKAGE)-%.rockspec
	luarocks pack $<

$(MAKEFILE_LIST):;
