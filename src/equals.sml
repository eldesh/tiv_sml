structure Equals =
   Tiv (type 'a t = 'a * 'a -> bool
        val name = "equals"
        fun iso i = let open Iso in arrow (tuple2 (i, i), Iso.id) end)

structure Z =
   DefTupleCase
   (structure Accum = Equals
    structure Value = Equals
    fun base _ = true
    val finish = Util.id
    fun step (a, equalsR) =
       let
          val equalsA = Equals.apply a
       in
          fn ((a1, r1), (a2, r2)) =>
          equalsA (a1, a2) andalso equalsR (r1, r2)
       end)
