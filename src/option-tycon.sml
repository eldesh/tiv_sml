local
   structure I = MapToIso1 (type 'a t = 'a option
                            val map = Option.map)
in
   structure OptionTycon =
      Tycon1Simple (type 'a t = 'a option
                    val iso = I.iso
                    val name = "option")
end

structure OptionTycon =
   Tycon1Simple (type 'a t = 'a option
                 fun iso i =
                    let
                       fun map f =
                          fn NONE => NONE
                           | SOME x => SOME (f (i, x))
                    in
                       Iso.make (map Iso.inject, map Iso.project)
                    end
                 val name = "option")

structure Z = DefCase1Simple (structure Tycon = OptionTycon
                              structure Value = Dummy
                              val rule: 'a Type.t -> 'a option =
                                 fn t => SOME (Dummy.apply t))

structure Z = 
   DefCase1Simple 
   (structure Tycon = OptionTycon
    structure Value = Equals
    val rule: 'a Type.t -> 'a option * 'a option -> bool =
       fn t =>
       let
          val eltEquals = Equals.apply t
       in
          fn (NONE, NONE) => true
           | (SOME x, SOME y) => eltEquals (x, y)
           | _ => false
       end)

structure Z =
   DefCase1Simple
   (structure Tycon = OptionTycon
    structure Value = Show
    fun rule t =
       let
          val showElt = Show.apply t
       in
          fn (opt, seen) =>
          case opt of
             NONE => Sequence.one "NONE"
           | SOME x =>
                let
                   open Sequence
                in
                   seq [one "SOME (", showElt (x, seen), one ")"]
                end
       end)
