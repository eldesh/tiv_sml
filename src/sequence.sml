structure Sequence:> SEQUENCE =
   struct
      datatype 'a t =
         List of 'a list
       | One of 'a
       | Seq of 'a t list

      val list = List
      val one = One
      val seq = Seq

      fun foldr (s, b, f) =
         recur
         ((s, b), fn ((s, b), loop) =>
          case s of
             List l => List.fold (rev l, b, f)
           | One a => f (a, b)
           | Seq ss => List.fold (rev ss, b, loop))
   end
