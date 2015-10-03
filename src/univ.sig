signature UNIV =
   sig
      type t

      val iso: unit -> ('a, t) Iso.t
   end
