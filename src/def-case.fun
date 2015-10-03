functor DefCase0
   (structure Tycon: TYCON0
    structure Value: TIV
    val rule: Tycon.t Value.t): EMPTY =
   struct
      val () =
         RawTiv.defCase
         (Value.tiv, Tycon.tycon,
          fn ([], ()) => Iso.inject (Value.iso (Type.iso Tycon.ty), rule)
           | _ => die "DefCase0")
   end

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

functor DefCase2
   (structure Tycon: TYCON2
    structure Value: TIV
    val rule: ('a1 Type.t * 'a2 Type.t
               * ('a1, 'a2, 'b) Tycon.Rep.t
               * ('b, Univ.t) Iso.t
               -> 'b Value.t))
   : EMPTY =
   struct
      val () =
         RawTiv.defCase
         (Value.tiv, Tycon.tycon,
          fn ([a, b], u) => rule (Type.makeId a, Type.makeId b, u, Iso.id)
           | _ => die "DefCase2")
   end

functor DefCase2Iso
   (S: sig
          structure Tycon: TYCON2_ISO
          structure Value: TIV
          val rule: 'a1 Type.t * 'a2 Type.t
                    * (('a1, 'a2, 'b) Tycon.R.t, 'b) Iso.t -> 'b Value.t
       end)
   : EMPTY =
   DefCase2 (open S
             fun rule (ta, tb, i, _) = S.rule (ta, tb, i))

functor DefCase2Simple
   (S: sig
          structure Tycon: TYCON2_SIMPLE
          structure Value: TIV
          val rule: 'a Type.t * 'b Type.t -> ('a, 'b) Tycon.t Value.t
       end)
   : EMPTY =
   DefCase2Iso (open S
                fun rule (a, b, i) = Iso.inject (Value.iso i, S.rule (a, b)))
