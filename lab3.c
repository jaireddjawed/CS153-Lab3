#include "types.h"
#include "user.h"

#pragma GCC push_options
#pragma GCC optimize ("O0")

static int make_recursion(int n) {
  if (n == 0) {
    return 0;
  }

  return n - make_recursion(n - 1);
}

#pragma GCC pop_options

int main() {
  int numRecursiveTimes[] = {150, 300, 500};
  int length = 3;
  int i;
  
  for (i = 0; i < length; i++) {
    printf(1, "Recurring %d times.\n", numRecursiveTimes[i]);
    make_recursion(numRecursiveTimes[i]);
    printf(1, "\n");
  }

  exit();
}
