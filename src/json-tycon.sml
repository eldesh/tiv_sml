
structure JsonTyconRep =
struct
  datatype 'r t =
      OBJECT of (string * 'r) list
    | ARRAY of 'r list
    | NULL
    | BOOL of bool
    | INT of IntInf.int
    | FLOAT of real
    | STRING of string

  fun iso ir =
    let
      fun fmap fr =
        fn OBJECT objs => OBJECT (map (fn (label,ob)=> (label,fr(ir, ob))) objs)
         | ARRAY  arrs => ARRAY (map (fn e=> fr(ir, e)) arrs)
         | NULL        => NULL
         | BOOL      b => BOOL b
         | INT     int => INT int
         | FLOAT  real => FLOAT real
         | STRING  str => STRING str
    in
      Iso.make (fmap Iso.inject
              , fmap Iso.project)
    end
end

datatype z = datatype JsonTyconRep.t

structure JsonTycon =
  Tycon0Iso
    (structure R = JsonTyconRep
     type t = JSON.value
     val name = "json"
     fun isorec () =
       Iso.make (
         fn OBJECT objs => JSON.OBJECT objs
          | ARRAY  arrs => JSON.ARRAY arrs
          | NULL        => JSON.NULL
          | BOOL      b => JSON.BOOL b
          | INT     int => JSON.INT int
          | FLOAT  real => JSON.FLOAT real
          | STRING  str => JSON.STRING str,
         fn JSON.OBJECT objs => OBJECT objs
          | JSON.ARRAY  arrs => ARRAY arrs
          | JSON.NULL        => NULL
          | JSON.BOOL      b => BOOL b
          | JSON.INT     int => INT int
          | JSON.FLOAT  real => FLOAT real
          | JSON.STRING  str => STRING str))


structure Z =
  DefCase0Iso
    (structure Tycon = JsonTycon
     structure Value = Dummy
     fun rule (i:('b Tycon.R.t, 'b) Iso.t) : 'b Value.t =
       Iso.inject (i, NULL)
    )


structure Z =
  DefCase0Iso
    (structure Tycon = JsonTycon
     structure Value = Equals
     fun rule i =
       let
         fun eqObj f [] [] = true
           | eqObj f ((la,oa)::xs) ((lb,ob)::ys) =
                     la = lb andalso f (oa,ob) andalso eqObj f xs ys
           | eqObj f _ _ = false

         fun eqArr f [] [] = true
           | eqArr f (x::xs) (y::ys) =
                     f (x,y) andalso eqArr f xs ys
           | eqArr f _ _ = false
        in
         fn z =>
           Util.recur (z, fn ((b1,b2), loop) =>
             case (Iso.project(i, b1), Iso.project(i,b2))
               of (OBJECT oas, OBJECT obs) => eqObj loop oas obs
                | (ARRAY  ars, ARRAY  brs) => eqArr loop ars brs
                | (NULL        , NULL        ) => true
                | (BOOL      ba, BOOL      bb) => ba = bb
                | (INT     inta, INT     intb) => inta = intb
                | (FLOAT  reala, FLOAT  realb) => Real.== (reala, realb)
                | (STRING  stra, STRING  strb) => stra = strb
                | _ => false)
       end
    )

(**
 * import from show.sml
 *)
fun seq (pre, suf, (l : string Sequence.t list)) : string Sequence.t =
   let
      open Sequence
   in
      seq [one pre, seq (List.separate (l, one ", ")), one suf]
   end

structure Z =
  DefCase0Iso
    (structure Tycon = JsonTycon
     structure Value = Show
     fun rule iso =
       fn (b, seen) =>
         Sequence.seq (
         Util.recur ((b, []), fn ((b, ac), loop) =>
           case Iso.project (iso, b)
             of OBJECT objs => [seq ("{", "}",
                                  (map (fn (l,ob)=> Sequence.seq
                                      (seq ("\"", "\"", [Sequence.one l])::
                                       Sequence.one ":" ::
                                       loop (ob,[]))) objs))]
              | ARRAY  arrs => [seq ("[", "]",
                                  (map (fn arr=> Sequence.seq (loop (arr, []))) arrs))]
              | NULL        => [Sequence.one "null"]
              | BOOL      b => [Sequence.one (if b then "true" else "false")]
              | INT     int => [Sequence.one (LargeInt.toString int)]
              | FLOAT  real => [Sequence.one (Real.toString real)]
              | STRING  str => [Sequence.one ("\""^str^"\"")])
         )
    )


