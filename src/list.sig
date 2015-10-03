signature LIST =
   sig
      datatype t = datatype list

      val equals: 'a t * 'b t * ('a * 'b -> bool) -> bool
      val exists: 'a t * ('a -> bool) -> bool
      val fold: 'a t * 'b * ('a * 'b -> 'b) -> 'b
      val map: 'a t * ('a -> 'b) -> 'b t
      val map2: 'a1 t * 'a2 t * ('a1 * 'a2 -> 'b) -> 'b t
      val peek: 'a t * ('a -> bool) -> 'a option
      val peekMap: 'a t * ('a -> 'b option) -> 'b option
      val push: 'a t ref * 'a -> unit
      val recur: 'a t * 'b * ('b -> 'c) * ('a * 'b * ('b -> 'c) -> 'c) -> 'c
      val separate: 'a t * 'a -> 'a t
      val tabulate: int * (int -> 'a) -> 'a t
   end
   
