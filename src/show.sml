
structure Show =
struct
local
  structure T =
   Tiv (type 'a t = 'a * (int * Univ.t) list ref -> string Sequence.t
        val name = "show"
        fun iso i = let open Iso in arrow (tuple2 (i, id), id) end)
in
  open T

  fun seq (pre, suf, l) =
    let
       open Sequence
    in
       seq [one pre, seq (List.separate (l, one ", ")), one suf]
    end

  fun checkSeen (u, seen, equals, new) =
     case List.peek (!seen, fn (_, u') => equals (u, u')) of
        NONE =>
           let
              val res = new ()
              val n =
                 case !seen of
                    [] => 0
                  | (n, _) :: _ => n + 1
              val () = List.push (seen, (n, u))
              open Sequence
           in
              seq [one (concat ["@", Int.toString n, "="]), res]
           end
      | SOME (n, _) =>
           Sequence.one (concat ["#", Int.toString n])
end
end

structure Z =
   DefTupleCase
   (structure Accum =
       struct
          type 'a t = 'a * (int * Univ.t) list ref -> string Sequence.t list
          fun iso i = let open Iso in arrow (tuple2 (i, id), id) end
       end
    structure Value = Show
    fun base _ = []
    fun finish f z = Show.seq ("(", ")", f z)
    fun step (a, showR) =
       let
          val showA = Show.apply a
       in
          fn ((a, r), seen) => showA (a, seen) :: showR (r, seen)
       end)


