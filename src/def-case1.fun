val die = Util.die

functor DefCase1
   (structure Tycon: TYCON1
    structure Value: TIV
    val rule: ('a Type.t * ('a, 'b) Tycon.Rep.t * ('b, Univ.t) Iso.t
               -> 'b Value.t))
   : EMPTY =
   struct
      val () =
         RawTiv.defCase
         (Value.tiv, Tycon.tycon,
          fn ([a], b) => rule (Type.makeId a, b, Iso.id)
           | _ => die "DefCase1")
   end

functor DefCase1Iso
   (S: sig
          structure Tycon: TYCON1_ISO
          structure Value: TIV
          val rule: 'a Type.t * (('a, 'b) Tycon.R.t, 'b) Iso.t -> 'b Value.t
       end): EMPTY =
   DefCase1 (open S
             fun rule (a, i, _) = S.rule (a, i))

functor DefCase1Simple
   (S: sig
          structure Tycon: TYCON1_SIMPLE
          structure Value: TIV
          val rule: 'a Type.t -> 'a Tycon.t Value.t
       end): EMPTY =
   DefCase1Iso (open S
                fun rule (a, i) = Iso.inject (Value.iso i, S.rule a))

