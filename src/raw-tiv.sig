signature RAW_TIV =
   sig
      structure Tycon:
         sig
            type 'a t

            val make: {name: string} -> 'a t
         end
      
      structure Type:
         sig
            structure Raw:
               sig
                  type t
               end
            
            type 'a t

            val apply:
               'a Tycon.t * Raw.t list * (('b, Univ.t) Iso.t -> 'a) -> 'b t
            val iso: 'a t -> ('a, Univ.t) Iso.t
            val make: Raw.t * ('a, Univ.t) Iso.t -> 'a t
            val makeId: Raw.t -> Univ.t t
            val raw: 'a t -> Raw.t
         end

      type 'a t

      val apply: 'a t * Type.Raw.t -> 'a
      val make: {name: string} -> 'a t
      val defCase: 'a t * 'b Tycon.t * (Type.Raw.t list * 'b -> 'a) -> unit
      val defDefault: 'a t * (Type.Raw.t -> 'a) -> unit
   end
