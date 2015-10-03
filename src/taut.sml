structure Taut:>
   sig
      structure Ok:
         sig
            type 'a t

            val bool: bool Type.t t
            val arrow: 'a Type.t t -> (bool -> 'a) Type.t t
         end

      val taut: 'a Type.t * 'a Type.t Ok.t -> 'a -> bool
   end =
   struct
      structure Ok =
         struct
            type 'a t = unit

            val bool = ()
            val arrow = ignore
         end

      structure FromBool =
         Tiv (type 'a t = bool -> 'a
              fun iso i = let open Iso in arrow (id, i) end
              val name = "fromBool")

      structure Z =
         DefCase0 (structure Tycon = BoolTycon
                   structure Value = FromBool
                   val rule = id)

      structure Taut =
         Tiv (type 'a t = 'a -> bool
              fun iso i = let open Iso in arrow (i, id) end
              val name = "taut")

      structure Z =
         DefCase0 (structure Tycon = BoolTycon
                   structure Value = Taut
                   val rule = id)
         
      structure Z =
         DefCase2Simple
         (structure Tycon = ArrowTycon
          structure Value = Taut
          fun rule (ta, tb) =
             let
                val arg = FromBool.apply ta
                val res = Taut.apply tb
             in
                fn f => let
                           fun one b = res (f (arg b))
                        in
                           one true andalso one false
                        end
             end)
             
      fun taut (t, _) = Taut.apply t
   end
