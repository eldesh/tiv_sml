
functor Tycon2 (S: TYCON2_ARG): TYCON2 =
struct
  open S

  type u = (Univ.t, Univ.t, Univ.t) Rep.t

  val tycon: u Tycon.t = Tycon.make {name = name}

  fun ty (at, bt) =
    Type.apply
    (tycon, [Type.raw at, Type.raw bt], fn iso =>
    makeRep (Type.iso at, Type.iso bt, iso))
end

functor Tycon2Iso (S: TYCON2_ISO_ARG): TYCON2_ISO =
struct
  structure T =
    Tycon2
    (open S
     structure Rep =
     struct
       type ('a, 'b, 'c) t = (('a, 'b, 'c) R.t, 'c) Iso.t
     end
     fun makeRep (ia1, ia2, ita) =
       Iso.compose (Iso.flip (R.iso (ia1, ia2, ita)),
                    Iso.compose (isorec (), ita)))
  open S T
end

functor Tycon2Simple (S: TYCON2_SIMPLE_ARG): TYCON2_SIMPLE =
  Tycon2Iso
  (structure R =
   struct
     type ('a, 'b, 'c) t = ('a, 'b) S.t
     fun iso (ia, ib, _) = S.iso (ia, ib)
   end
   open S
   fun isorec () = Iso.id)

