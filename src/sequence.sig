signature SEQUENCE =
   sig
      type 'a t

      val foldr: 'a t * 'b * ('a * 'b -> 'b) -> 'b
      val list: 'a list -> 'a t
      val one: 'a -> 'a t
      val seq: 'a t list -> 'a t
   end
