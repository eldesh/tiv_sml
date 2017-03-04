
structure MapUtil =
   struct
      fun inj i a = Iso.inject (i, a)
      fun prj i a = Iso.project (i, a)
   end

functor MapToIso1
  (S: sig
        type 'a t
        val map: 'a t * ('a -> 'b) -> 'b t
      end):
  sig
    type 'a t
    val iso: ('a, 'b) Iso.t -> ('a t, 'b t) Iso.t
  end =
  struct
    type 'a t = 'a S.t

    open MapUtil

    fun map f x = S.map (x, f)
       
    fun iso i = Iso.make (map (inj i), map (prj i))
  end

functor MapToIso2
   (S:
    sig
       type ('a, 'b) t
       val map: ('a1, 'b1) t * ('a1 -> 'a2) * ('b1 -> 'b2) -> ('a2, 'b2) t
    end):
   sig
      type ('a, 'b) t

      val iso:
         ('a1, 'a2) Iso.t * ('b1, 'b2) Iso.t
         -> (('a1, 'b1) t, ('a2, 'b2) t) Iso.t
   end =
   struct
      type ('a, 'b) t = ('a, 'b) S.t

      open MapUtil
         
      fun map (fa, fb) x = S.map (x, fa, fb)

      fun iso (ia: ('a1, 'a2) Iso.t,
               ib: ('b1, 'b2) Iso.t) =
         Iso.make (map (inj ia, inj ib), map (prj ia, prj ib))
   end
