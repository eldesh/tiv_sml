structure List: LIST =
struct

open Util

datatype t = datatype list

fun tabulate (n, f) =
   Util.recur
   ((n, []), fn ((i, ac), loop) =>
    let
       val i = i - 1
    in
       if i < 0 then ac else loop (i, f i :: ac)
    end)

val isEmpty = fn [] => true | _ => false

fun recur (l, b, done, step) =
   Util.recur ((l, b), fn ((l, b), loop) =>
               case l of
                  [] => done b
                | x :: l => step (x, b, fn b => loop (l, b)))

fun recur2 (l1, l2, b, done, mismatch, step) =
   Util.recur ((l1, l2, b), fn ((l1, l2, b), loop) =>
               case (l1, l2) of
                  ([], []) => done b
                | (x1 :: l1, x2 :: l2) =>
                     step (x1, x2, b, fn b => loop (l1, l2, b))
                | _ => mismatch ())

fun equals (l1, l2, e) =
   recur2 (l1, l2, (), const false, const false,
           fn (x1, x2, (), k) => e (x1, x2) andalso k ())
                
fun peekMap (l, f) =
   recur (l, (), const NONE, fn (x, (), k) =>
          case f x of
             NONE => k ()
           | opt as SOME _ => opt)

fun peek (l, f) = peekMap (l, fn x => if f x then SOME x else NONE)
         
fun fold (l, b, f) = recur (l, b, id, fn (x, b, k) => k (f (x, b)))

fun fold2 (l1, l2, b, f) =
   recur2 (l1, l2, b, id,
           fn () => die "List.fold2",
           fn (x1, x2, b, k) => k (f (x1, x2, b)))
         
fun reverse l = fold (l, [], op ::)
         
fun map (l, f) = reverse (fold (l, [], fn (x, l) => f x :: l))

fun map2 (l1, l2, f) =
   reverse (fold2 (l1, l2, [], fn (x1, x2, l) => f (x1, x2) :: l))

fun push (r, x) = r := x :: !r

fun separate (l, x) =
   case l of
      [] => []
    | a :: l => rev (fold (l, [a], fn (b, ac) => b :: x :: ac))

fun exists (l, f) = recur (l, (), const false, fn (x, (), k) => f x orelse k ())
          
end
