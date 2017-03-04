
structure ToJson =
struct
local
  structure T =
    Tiv (type 'a t = 'a -> JSON.value
         val name = "ToJson"
         fun iso i = let open Iso in arrow (i, id) end)
in
  open T
end (* local *)
end

structure Z =
  DefCase0Simple
    (structure Tycon = BoolTycon
     structure Value = ToJson
     fun rule b = JSON.BOOL b)

structure Z =
  DefCase0Simple
    (structure Tycon = LargeIntTycon
     structure Value = ToJson
     fun rule i = JSON.INT i)

structure Z =
  DefCase0Simple
    (structure Tycon = IntTycon
     structure Value = ToJson
     fun rule i = JSON.INT (Int.toLarge i))

structure Z =
  DefCase0Simple
    (structure Tycon = StringTycon
     structure Value = ToJson
     fun rule s = JSON.STRING s)

structure Z =
  DefCase0Simple
    (structure Tycon = RealTycon
     structure Value = ToJson
     fun rule r = JSON.FLOAT r)

structure Z =
  DefCase1Iso
    (structure Tycon = ListTycon
     structure Value = ToJson
     fun rule (t, i) =
       let
         open ListTyconRep
         val elt = ToJson.apply t
       in
         fn z =>
           Util.recur (z, fn (b, loop) =>
             case Iso.project (i, b)
               of Nil        => JSON.ARRAY []
                | Cons (x,r) =>
                    case loop r
                      of JSON.ARRAY ars => JSON.ARRAY (elt x::ars)
                       | other => raise Fail "toJson")
       end)

