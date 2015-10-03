structure SuperReverse =
   Tiv (type 'a t = 'a -> 'a
        fun iso i = Iso.arrow (i, i)
        val name = "superReverse")

structure Z =
   DefDefault (structure Value = SuperReverse
               fun rule _ = id)
   
structure Z =
   DefCase1Iso
   (structure Tycon = ListTycon
    structure Value = SuperReverse
    fun rule (t, iso) =
       let
          val reverseElt = SuperReverse.apply t
       in
          fn l =>
          recur ((l, Iso.inject (iso, Nil)), fn ((u, ac), loop) =>
                 case Iso.project (iso, u) of
                    Nil => ac
                  | Cons (x, l) =>
                       loop (l, Iso.inject (iso, Cons (reverseElt x, ac))))
       end)
