
structure Util :> UTIL =
struct
  fun const c _ = c

  fun cross (f, g) (x, y) = (f x, g y)

  fun curry f x y = f (x, y)

  fun die s = raise Fail s

  fun id x = x

  fun recur (x, f) = let fun loop x = f (x, loop) in loop x end

  fun fst (a, _) = a

  fun snd (_, b) = b
end

(* open Util *)
