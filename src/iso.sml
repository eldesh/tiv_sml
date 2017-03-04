structure Iso:> ISO =
struct
  open Util

  datatype ('a, 'b) t = T of ('a -> 'b) * ('b -> 'a)

  val make = T

  val id = T (id, id)

  fun compose (T (f1, g1), T (f2, g2)) = T (f2 o f1, g1 o g2)

  fun flip (T (f, g)) = T (g, f)

  fun inject (T (i, _), a) = i a

  fun project (T (_, p), b) = p b

  fun arrow (ia, ib) =
     T (fn f => fn a2 => inject (ib, f (project (ia, a2))),
        fn f => fn a1 => project (ib, f (inject (ia, a1))))

  fun tuple2 (ia, ib) =
     T (fn (a1, b1) => (inject (ia, a1), inject (ib, b1)),
        fn (a2, b2) => (project (ia, a2), project (ib, b2)))

  fun iso (ia, ib) =
     let
        val iab = arrow (ia, ib)
        val iba = arrow (ib, ia)
     in
        T (fn T (ab, ba) => T (inject (iab, ab), inject (iba, ba)),
           fn T (ab, ba) => T (project (iab, ab), project (iba, ba)))
     end
end

