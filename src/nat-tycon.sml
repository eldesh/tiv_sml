
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

structure NatTyconRep =
struct
  datatype 'r t = Zero | Succ of 'r

  fun iso (ir:('ra,'rb) Iso.t) : ('ra t,'rb t) Iso.t =
  let
    fun fmap fr =
      fn Zero => Zero
       | Succ r => Succ (fr(ir, r))
  in
    Iso.make (fmap Iso.inject
            , fmap Iso.project)
  end
end

structure NatTycon =
struct
  (*
  Tycon0Iso
    (structure R = NatTyconRep
     type t = Nat.t
     val name = "nat"
     fun isorec () =
       Iso.make (fn R.Succ r=>Nat.Succ r | R.Zero=>Nat.Zero
               , fn Nat.Zero=>R.Zero | fn Nat.Succ r=>R.Succ r))
               *)
end

