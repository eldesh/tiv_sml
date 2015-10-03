structure RefRep =
   struct
      datatype ('a, 'b) t =
         T of {get: 'b -> 'a, 
               equals: 'b * 'b -> bool,
               make: 'a -> 'b,
               set: 'b * 'a -> unit}
   end

structure RefTycon =
   Tycon1
   (structure Rep = RefRep
    type 'a t = 'a ref
    val name = "ref"
    fun makeRep (ix, ir) =
       RefRep.T {get = fn r => Iso.inject (ix, ! (Iso.project (ir, r))),
              equals = (fn (r, r') =>
                        (Iso.project (ir, r) = Iso.project (ir, r')
                         handle _ => false)),
              make = fn x => Iso.inject (ir, ref (Iso.project (ix, x))),
              set = fn (r, x) => Iso.project (ir, r) := Iso.project (ix, x)})

structure Z =
   DefCase1
   (structure Tycon = RefTycon
    structure Value = Dummy
    fun rule (t, RefRep.T {make, ...}, _) = make (Dummy.apply t))
          
structure Z =
   DefCase1
   (structure Tycon = RefTycon
    structure Value = Equals
    fun rule (_, RefRep.T {equals, ...}, _) = equals)

structure Z =
   DefCase1
   (structure Tycon = RefTycon
    structure Value = Show
    fun rule (t, RefRep.T {get, equals, ...}, iso) =
       let
          val elt = Show.apply t
       in
          fn (b, seen) =>
          Show.checkSeen (Iso.inject (iso, b), seen,
                     fn (u1, u2) => equals (Iso.project (iso, u1),
                                            Iso.project (iso, u2)),
                     fn () => elt (get b, seen))
       end)

