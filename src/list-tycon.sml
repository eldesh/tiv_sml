
structure ListTyconRep =
struct
  datatype ('a, 'r) t = Cons of 'a * 'r
                      | Nil

  fun iso (ia, ir) =
    let
      fun map (fa, fr) =
        fn Cons (a, r) => Cons (fa (ia, a), fr (ir, r))
         | Nil => Nil
    in
      Iso.make (map (Iso.inject, Iso.inject),
                map (Iso.project, Iso.project))
    end
end

datatype z = datatype ListTyconRep.t

structure ListTycon =
   Tycon1Iso
   (structure R = ListTyconRep
    type 'a t = 'a list
    val name = "list"
    fun isorec () = 
       Iso.make (fn Cons (x, l) => x:: l | Nil => [],
                 fn [] => Nil | x :: l => Cons (x, l)))

structure Z =
   DefCase1Iso
   (structure Tycon = ListTycon
    structure Value = Dummy
    fun rule (t, i) =
       Iso.inject (i, Cons (Dummy.apply t, Iso.inject (i, Nil))))

structure Z =
   DefCase1Iso
   (structure Tycon = ListTycon
    structure Value = Equals
    fun rule (t, i) =
       let
          val elt = Equals.apply t
       in
          fn z =>
          Util.recur (z, fn ((b1, b2), loop) =>
                 case (Iso.project (i, b1), Iso.project (i, b2)) of
                    (Nil, Nil) => true
                  | (Cons (x1, b1), Cons (x2, b2)) =>
                       elt (x1, x2) andalso loop (b1, b2)
                  | _ => false)
       end)

(**
 * import from show.sml
 *)
fun seq (pre, suf, l) : string Sequence.t =
   let
      open Sequence
   in
      seq [one pre, seq (List.separate (l, one ", ")), one suf]
   end

structure Z =
  DefCase1Iso
    (structure Tycon = ListTycon
     structure Value = Show
     fun rule (t, iso) =
       let
         val elt = Show.apply t
       in
         fn (b, seen) =>
           seq ("[", "]",
             Util.recur ((b, []), fn ((b, ac), loop) =>
               case Iso.project (iso, b)
                 of Nil => rev ac
                  | Cons (x, l) => loop (l, elt (x, seen) :: ac)))
       end)

