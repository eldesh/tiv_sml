structure ArrayRep =
   struct
      datatype ('a, 'b) t =
         T of {equals: 'b * 'b -> bool,
               length: 'b -> int,
               make: int * 'a -> 'b,
               sub: 'b * int -> 'a,
               update: 'b * int * 'a -> unit}
   end

structure ArrayTycon =
   Tycon1
   (structure Rep = ArrayRep
    type 'a t = 'a array
    val name = "array"
    fun makeRep (ix, ia) =
       Rep.T {equals = (fn (a, a') =>
                        (Iso.project (ia, a) = Iso.project (ia, a')
                         handle _ => false)),
              length = fn a => Array.length (Iso.project (ia, a)),
              make = (fn (n, x) =>
                      Iso.inject (ia, Array.array (n, Iso.project (ix, x)))),
              sub = (fn (a, i) =>
                     Iso.inject (ix, Array.sub (Iso.project (ia, a), i))),
              update = (fn (a, i, x) =>
                        Array.update (Iso.project (ia, a), i,
                                      Iso.project (ix, x)))})

structure Z =
   DefCase1
   (structure Tycon = ArrayTycon
    structure Value = Dummy
    fun rule (t, ArrayRep.T {make, ...}, _) = make (3, Dummy.apply t))

structure Z =
   DefCase1
   (structure Tycon = ArrayTycon
    structure Value = Equals
    fun rule (_, ArrayRep.T {equals, ...}, _) = equals)

structure Z =
   DefCase1
   (structure Tycon = ArrayTycon
    structure Value = Show
    fun rule (t, ArrayRep.T {equals, length, sub, ...}, iso) =
       let
          val elt = Show.apply t
       in
          fn (b, seen) =>
          checkSeen (Iso.inject (iso, b), seen,
                     fn (u1, u2) => equals (Iso.project (iso, u1),
                                            Iso.project (iso, u2)),
                     fn () =>
                     seq ("[|", "|]",
                          List.tabulate
                          (length b, fn i => elt (sub (b, i), seen))))
       end)
