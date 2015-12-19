CFLAGS=--std=gnu99 -Wall -O3
CXXFLAGS=--std=gnu++11 -Wall -O3
LDFLAGS=-ltcmalloc

blt_test: blt_test.c blt.c

blt_bm: blt_bm.c blt.c bm.c
	$(CC) $(CFLAGS) -o $@ $^

cbt_bm: cbt_bm.c cbt.c bm.c
	$(CC) $(CFLAGS) -o $@ $^

map_bm: map_bm.cc
	$(CXX) $(CXXFLAGS) -o $@ $^

umap_bm: umap_bm.cc
	$(CXX) $(CXXFLAGS) -o $@ $^

critbit.h: critbit/critbit.h
	sed 's/\s*extern.*//;s/\s*};//' $^ >$@

critbit_bm: critbit_bm.c critbit/critbit.c critbit.h bm.c
	$(CC) $(CFLAGS) -o $@ critbit_bm.c critbit/critbit.c bm.c

mfcb_bm: mfcb_bm.c pcb/mfcb/mfcb.c pcb/mfcb/mfcb.h bm.c
	$(CC) $(CFLAGS) -I pcb/mfcb -o $@ mfcb_bm.c pcb/mfcb/mfcb.c bm.c

benchmark: blt_bm cbt_bm map_bm umap_bm critbit_bm mfcb_bm
	./benchmark

clean:
	rm -f critbit.h *_bm *.csv

.PHONY: benchmark