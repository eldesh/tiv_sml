
signature ISO =
sig
  (* flip (compose (f, g)) = compose (flip g, flip f) *)
  type ('a, 'b) t

  val arrow: ('a1, 'a2) t * ('b1, 'b2) t -> ('a1 -> 'b1, 'a2 -> 'b2) t
  val compose: ('a, 'b) t * ('b, 'c) t -> ('a, 'c) t
  val flip: ('a, 'b) t -> ('b, 'a) t
  val id: ('a, 'a) t
  val iso: ('a1, 'a2) t * ('b1, 'b2) t -> (('a1, 'b1) t, ('a2, 'b2) t) t
  val inject: ('a, 'b) t * 'a -> 'b
  val make: ('a -> 'b) * ('b -> 'a) -> ('a, 'b) t
  val project: ('a, 'b) t * 'b -> 'a
  val tuple2: ('a1, 'b1) t * ('a2, 'b2) t -> ('a1 * 'a2, 'b1 * 'b2) t
end
