// Benchmark CBT. For example:
//
//   $ cbt_bm < /usr/share/dict/words

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "bm.h"
#include "mfcb.h"

#define REP(i,n) for(int i=0;i<n;i++)

void f(char **key, int m) {
  mfcb_t cbt = { 0 };
  int count = 0;
  bm_init();
  REP(i, m) mfcb_add(&cbt, key[i]);
  bm_report("MFCB insert");
  REP(i, m) if (!mfcb_contains(&cbt, key[i])) {
    fprintf(stderr, "BUG!\n");
    exit(1);
  }
  bm_report("MFCB get");
  int inc(const char* ignore0, void* ignore1) {
    count++;
    return 1;
  }
  mfcb_find_suffixes(&cbt, "", inc, 0);
  if (count != m) {
    fprintf(stderr, "BUG!\n");
    exit(1);
  }
  bm_report("MFCB allprefixed");
  REP(i, m) mfcb_rem(&cbt, key[i]);
  bm_report("MFCB delete");
}

int main() {
  bm_read_keys(f);
  return 0;
}
