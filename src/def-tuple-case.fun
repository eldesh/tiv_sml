functor DefTupleCase
   (structure Accum:
       sig
          type 'a t

          val iso: ('a, 'b) Iso.t -> ('a t, 'b t) Iso.t
       end
    structure Value: TIV
    val base: unit Accum.t
    val finish: 'a Accum.t -> 'a Value.t
    val step: 'a Type.t * 'b Accum.t -> ('a * 'b) Accum.t): EMPTY =
   struct
      val () =
         RawTiv.defCase
         (Value.tiv, TupleTycon.tycon,
          fn (ts, iso) =>
          Iso.inject
          (Value.iso iso,
           finish
           (List.fold
            (rev ts,
             Iso.inject
             (Accum.iso (Iso.make (fn () => [],
                                   fn [] => () | _ => Util.die "tuple iso")),
              base),
             fn (t, ac) =>
             Iso.inject
             (Accum.iso
              (Iso.make (op ::,
                         fn u :: us => (u, us) | _ => Util.die "tuple iso")),
              step (Type.makeId t, ac): (Univ.t * Univ.t list) Accum.t)))))

   end
