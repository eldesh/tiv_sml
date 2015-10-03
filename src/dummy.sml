structure Dummy =
   Tiv (type 'a t = 'a
        val name = "dummy"
        fun iso i = i)

structure Z =
   DefTupleCase
   (structure Accum = Dummy
    structure Value = Dummy
    val base = ()
    val finish = id
    fun step (t, ac) = (Dummy.apply t, ac))
