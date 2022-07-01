#include <Rcpp.h>
using namespace Rcpp;
//[[Rcpp::export]]
List createList() {
  List L;
  L["a"] = NumericVector::create(1.0, 2.0, 4.0);
  L["b"] = 12;
  L["c"] = rnorm(4, 0.0, 1.0);
  return L;
}

