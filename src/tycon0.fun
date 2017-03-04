
functor Tycon0 (S: TYCON0_ARG): TYCON0 =
struct
  open S

  type u = Univ.t Rep.t

  val tycon: u Tycon.t = Tycon.make {name = name}

  val ty: t Type.t =
    Type.apply (tycon, [], makeRep)
end

functor Tycon0Iso (S: TYCON0_ISO_ARG): TYCON0_ISO =
struct
  structure T =
    Tycon0
    (open S
     structure Rep =
     struct
       type 'b t = ('b R.t, 'b) Iso.t
     end
     fun makeRep (ia : (t, 'c) Iso.t) : 'c Rep.t =
        Iso.compose (Iso.flip (R.iso ia),
                     Iso.compose (isorec (), ia)))
  open S T
end
           
functor Tycon0Simple (S: TYCON0_SIMPLE_ARG): TYCON0_ISO =
  Tycon0Iso
   (structure R : ISO1 =
    struct
      type 'a t = S.t
      fun iso (_ : ('a,'b) Iso.t) : ('a t, 'b t) Iso.t = S.iso
    end
    open S
    fun isorec () = Iso.id)

