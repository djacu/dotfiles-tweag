{lib}: rec {
  /*
   Base raised to the power of the exponent.
   
   Type: pow :: int or float -> int -> int
   
   Args:
     base: The base.
     exponent: The exponent.
   
   Example:
     pow 0 1000
     => 0
     pow 1000 0
     => 1
     pow 2 30
     => 1073741824
     pow 3 3
     => 27
     pow (-5) 3
     => -125
   
   */
  pow = base: exponent:
    if exponent > 1
    then let
      x = pow base (exponent / 2);
      odd_exp = lib.mod exponent 2 == 1;
    in
      x
      * x
      * (
        if odd_exp
        then base
        else 1
      )
    else if exponent == 1
    then base
    else if exponent == 0
    then 1
    else throw "undefined";
}
