
structure Nat =
struct
  datatype t = Zero
             | Succ of t

  fun toInt Zero = 0
    | toInt (Succ n) = 1 + toInt n

  fun fromInt 0 = Zero
    | fromInt n = if 0 < n then Succ(fromInt n)
                  else raise Domain

  fun compare (n,m) =
    case (n,m)
      of (Zero  ,Zero  ) => General.EQUAL
       | (Succ _,Zero  ) => General.LESS
       | (Zero  ,Succ _) => General.GREATER
       | (Succ n,Succ m) => compare (n,m)
end

