structure Option: OPTION =
struct

datatype t = datatype option

fun map (opt: 'a t, f: 'a -> 'b): 'b t =
   case opt of
      NONE => NONE
    | SOME x => SOME (f x)

end
