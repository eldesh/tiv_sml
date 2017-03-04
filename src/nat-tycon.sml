
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

datatype z = datatype NatTyconRep.t

structure NatTycon =
  Tycon0Iso
    (structure R = NatTyconRep
     type t = Nat.t
     val name = "nat"
     fun isorec () =
       Iso.make (fn R.Succ r=>Nat.Succ r | R.Zero=>Nat.Zero
               , fn Nat.Zero=>R.Zero | Nat.Succ r=>R.Succ r))


structure Z =
  DefCase0Iso
    (structure Tycon = NatTycon
     structure Value = Dummy
     fun rule (i:('b Tycon.R.t, 'b) Iso.t) : 'b Value.t =
       Iso.inject (i, Succ (Iso.inject (i, Zero)))
    )


structure Z =
  DefCase0Iso
    (structure Tycon = NatTycon
     structure Value = Equals
     fun rule i =
       fn z =>
         Util.recur (z, fn ((b1,b2), loop) =>
           case (Iso.project(i, b1), Iso.project(i,b2))
             of (Zero, Zero) => true
              | (Succ n, Succ m) => loop (n, m)
              | _ => false)
    )


structure Z =
  DefCase0Iso
    (structure Tycon = NatTycon
     structure Value = Show
     fun rule iso =
       fn (b, seen) =>
         Sequence.seq (
           Util.recur ((b, []), fn ((b, ac), loop) =>
             case Iso.project (iso, b)
               of Zero => rev (Sequence.one "Z" :: ac)
                | Succ l => loop (l, Sequence.one "S(" :: ac) @ [Sequence.one ")"])
         )
    )

