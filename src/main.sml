structure Main: EMPTY =
struct

val dummy = Dummy.apply

val equals = Equals.apply

fun show t =
   let
      val s = Show.apply t
   in
      fn a => concat (Sequence.foldr (s (a, ref []), [], op ::))
   end

structure Flatten = Flatten (structure Base = IntTycon)

val flatten = Flatten.apply
val superReverse = SuperReverse.apply

structure Type =
   struct
      val array = ArrayTycon.ty
      val arrow = ArrowTycon.ty
      val bool = BoolTycon.ty
      val int = IntTycon.ty
      val list = ListTycon.ty
      val option = OptionTycon.ty
      val real = RealTycon.ty
      val reff = RefTycon.ty
      val tuple2 = TupleTycon.ty2
      val tuple3 = TupleTycon.ty3
   end

local
   open Type
in
   val irb = tuple3 (int, real, bool)
   val il = list int
   val ill = list il
   val b3 = arrow (bool, arrow (bool, bool))
end

fun pl s = print (concat [s, "\n"])

val d: int * real * bool = dummy irb
val () = pl (show irb d)

val z = [[1, 2, 3], [4, 5], [6], []]
val () = pl (show ill z)

val () = 
   let
      val t = let open Type in reff int end
      val r = dummy t
   in
      pl (show (Type.tuple2 (t, t)) (r, r))
   end

val () =
   let
      val t = let open Type in array int end
      val r = dummy t
   in
      pl (show (Type.tuple2 (t, t)) (r, r))
   end

val () =
   let
      val t = Type.option (Type.option Type.int)
   in
      pl (show t (dummy t))
   end

val () = pl (show il ((flatten ill o superReverse ill) z))

val () = pl (Bool.toString
             ((Taut.taut (let open Type in
                             arrow (bool, arrow (bool, bool))
                          end,
                             let open Taut.Ok in arrow (arrow bool) end))
              (fn b1 => fn b2 => b1 orelse b2)))


end
