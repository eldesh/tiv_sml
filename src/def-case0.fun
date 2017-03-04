val die = Util.die

functor DefCase0
   (structure Tycon: TYCON0
    structure Value: TIV
    val rule: 'b Tycon.Rep.t * ('b, Univ.t) Iso.t
                -> 'b Value.t)
    : EMPTY =
    struct
      val () =
        RawTiv.defCase
        (Value.tiv, Tycon.tycon,
         (* fn ([], b) => Iso.inject (Value.iso (Type.iso Tycon.ty), rule) *)
         fn ([], b) => rule (b, Iso.id)
          | _ => die "DefCase0")
   end

functor DefCase0Iso
   (S: sig
          structure Tycon: TYCON0_ISO
          structure Value: TIV
          val rule: ('b Tycon.R.t, 'b) Iso.t -> 'b Value.t
       end): EMPTY =
   DefCase0 (open S
             fun rule (i, _) = S.rule i)

functor DefCase0Simple
   (S: sig
          structure Tycon: TYCON0_SIMPLE
          structure Value: TIV
          val rule: Tycon.t Value.t
       end): EMPTY =
   DefCase0Iso (open S
                fun rule i = Iso.inject (Value.iso i, S.rule))

