######
#
# A simple Makefile
#
######

include \
$(PATSHOME)/share/atsmake-pre.mk

######
#
CFLAGS+=\
-I$(PATSHOME)/npm-utils/contrib/atscntrb
#
CFLAGS+=$(shell pkg-config gtk+-3.0 --cflags)
#
######

LDFLAGS += -lgc
LDFLAGS += $(shell pkg-config gtk+-3.0 --libs)

######

include \
$(PATSHOME)/share/atsmake-post.mk

######
#
PATSCC2=$(PATSCC) $(INCLUDE)
INCLUDE+=-IIATS $(PATSCONTRIB)/contrib
#
######
#
all:: \
permutation_anim
#
permutation_anim: \
  permutation_anim.dats ; \
  $(PATSCC2) -D_GNU_SOURCE -DATS_MEMALLOC_GCBDW -O2 -o $@ $(CFLAGS) $< $(LDFLAGS)
#
regress:: \
permutation_anim; ./$<
cleanall:: ; $(RMF) permutation_anim
#
######

testall:: all
testall:: regress
testall:: cleanall

######

cleanats:: ; $(RMF) *_?ats.c

###### end of [Makefile] ######
