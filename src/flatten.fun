
functor Flatten (structure Base: TYCON0_SIMPLE)
   : TIV where type 'a t = 'a -> Base.t list =
struct
  structure Flatten =
    Tiv (type 'a t = 'a -> Base.t list
         val name = "flatten"
         fun iso i = let open Iso in arrow (i, id) end)

  structure Z =
    DefCase0Simple
     (structure Tycon = Base
      structure Value = Flatten
      fun rule i = [i])
         
  datatype z = datatype ListTyconRep.t

  structure Z =
     DefCase1Iso
     (structure Tycon = ListTycon
      structure Value = Flatten
      fun rule (t, iso) =
         let
            val flattenElt = Flatten.apply t
         in
            fn l =>
            Util.recur (l, fn (l, loop) =>
                   case Iso.project (iso, l) of
                      Nil => []
                    | Cons (x, l) => flattenElt x @ loop l)
         end)

  open Flatten
end             
