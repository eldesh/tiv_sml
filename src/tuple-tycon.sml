structure TupleTycon:
   sig
      type u = (Univ.t list, Univ.t) Iso.t

      val ty2: 'a Type.t * 'b Type.t -> ('a * 'b) Type.t
      val ty3: 'a Type.t * 'b Type.t * 'c Type.t -> ('a * 'b * 'c) Type.t
      val tycon: u Tycon.t
   end =
   struct
      type u = (Univ.t list, Univ.t) Iso.t

      val tycon: u Tycon.t = Tycon.make {name = "tuple"}

      fun inj ty a = Iso.inject (Type.iso ty, a)
      fun proj ty u = Iso.project (Type.iso ty, u)

      fun ty2 (ta, tb) =
         Type.apply
         (tycon, [Type.raw ta, Type.raw tb], fn iso =>
          Iso.compose (Iso.make (fn [ua, ub] => (proj ta ua, proj tb ub)
        | _ => Util.die "ty2",
                                 fn (a, b) => [inj ta a, inj tb b]),
                       iso))

      fun ty3 (ta, tb, tc) =
         Type.apply
         (tycon, [Type.raw ta, Type.raw tb, Type.raw tc], fn iso =>
          Iso.compose
          (Iso.make (fn [ua, ub, uc] => (proj ta ua, proj tb ub, proj tc uc)
        | _ => Util.die "ty3",
                     fn (a, b, c) => [inj ta a, inj tb b, inj tc c]),
           iso))
   end
