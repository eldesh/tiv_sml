
structure LargeIntTycon =
  Tycon0Simple (
    type t = LargeInt.int
    val iso = Iso.id
    val name = "LargeInt.int")

structure Z = DummyEqualsShow0 (structure Tycon = LargeIntTycon
                                val dummy : LargeInt.int = 13
                                val equals = op =
                                fun show ? = Sequence.one (LargeInt.toString (Util.fst ?)))

