
structure BoolTycon =
  Tycon0Simple (
    type t = bool
    val iso = Iso.id
    val name = "bool"
  )

structure Z = DummyEqualsShow0 (structure Tycon = BoolTycon
                                val dummy = false
                                val equals = op =
                                fun show ? = Sequence.one (Bool.toString (Util.fst ?)))

