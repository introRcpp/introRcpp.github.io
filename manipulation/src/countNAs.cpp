#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
int countNAs(NumericVector x) {
  int re = 0;
  int n = x.size();
  for(int i = 0; i < n; i++) {
    re += NumericVector::is_na(x[i]);
  }
  return(re);
}
