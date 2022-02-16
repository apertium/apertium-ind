###############################################################################
## Makefile for apertium-ind
###############################################################################

LANG1=ind
BASENAME=apertium-$(LANG1)

TARGETS_COMMON =			\
	$(LANG1).automorf.hfst		\
	$(LANG1).autogen.hfst		\
	$(LANG1).zhfst

# This include defines goals for install-modes, .deps/.d, autobil.prefixes and .mode files:
@ap_include@


LEXCFLAGS=-v --Werror

###############################################################################
## Indonesian transducer
###############################################################################

.deps/$(LANG1).%.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	grep -v 'Dir/$*' $< > $@

.deps/$(LANG1).%.foma: $(BASENAME).$(LANG1).foma
	sed 's@$(BASENAME).$(LANG1).\(lexc\|foma\.bin\.gz\)@.deps/$(LANG1).$*.\1@g' $< > $@

.deps/%.foma.bin.gz: .deps/%.foma .deps/%.lexc apertium-ind.morphophonemic.xfst apertium-ind.hyphenrule.xfst
	$(FOMA) < $<

.deps/%.foma.bin: .deps/%.foma.bin.gz
	gunzip $<

.deps/%.hfst: .deps/%.foma.bin
	hfst-fst2fst -S $< -o $@

$(LANG1).autogen.hfst: .deps/$(LANG1).RL.hfst
	hfst-fst2fst -O $< -o $@

$(LANG1).automorf.hfst: .deps/$(LANG1).LR.hfst
	hfst-invert $< | hfst-fst2fst -O -o $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx
	cg-comp $< $@

###############################################################################
## Spell checker
###############################################################################

$(LANG1).zhfst: .deps/acceptor.default.hfst .deps/errmodel.default.hfst speller/index.xml
	rm -f $@
	zip -j $@ $^

.deps/editdist.default.att: speller/editdist.default.txt .deps/acceptor.default.hfst
	apertium-editdist -v -s -d 1 -e '@0@' -i $(srcdir)/speller/editdist.default.txt -a .deps/acceptor.default.hfst > $@

.deps/editdist.default.hfst: .deps/editdist.default.att
	hfst-txt2fst -e '@0@' $< -o $@

.deps/editstrings.default.hfst: .deps/strings.default.hfst .deps/editdist.default.hfst
	hfst-disjunct $^ | hfst-minimise | hfst-repeat -f 1 -t 2 -o $@

.deps/errmodel.default.hfst: .deps/words.default.hfst .deps/editstrings.default.hfst
	hfst-disjunct $^ | hfst-fst2fst -f olw -o $@

.deps/words.default.hfst: speller/words.default.txt
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j -o $@

.deps/strings.default.hfst: speller/strings.default.txt .deps/anystar.hfst
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j | hfst-concatenate .deps/anystar.hfst - |\
	hfst-concatenate - .deps/anystar.hfst -o $@

.deps/anystar.hfst:
	echo "?*;" | hfst-regexp2fst -S -o $@

.deps/acceptor.default.hfst: $(LANG1).autogen.hfst
	cat $< | hfst-fst2fst -t | hfst-project --project=lower | hfst-minimise | hfst-fst2fst  -f olw -o $@


###############################################################################
## Unigram tagger
###############################################################################

#$(LANG1).prob: corpus/$(LANG1).tagged
#	apertium-tagger -s 0 -u 2 $@ $<

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST= \
		$(BASENAME).$(LANG1).foma	\
		$(BASENAME).$(LANG1).lexc	\
		$(BASENAME).morphophonemic.xfst	\
		$(BASENAME).hyphenrule.xfst	\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_ind_dir: This is where the compiled binaries go
#   apertium_ind_srcdir: This is where the source files go

apertium_inddir=$(prefix)/share/apertium/$(BASENAME)/
apertium_ind_srcdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_ind_DATA=$(TARGETS_COMMON) \
	$(BASENAME).$(LANG1).foma	\
	$(BASENAME).$(LANG1).lexc	\
	$(BASENAME).morphophonemic.xfst	\
	$(BASENAME).hyphenrule.xfst

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
uninstall-local: uninstall-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	apertium-regtest test
