structure RealTycon =
  Tycon0Simple (
    type t = real
    val iso = Iso.id
    val name = "real"
  )

structure Z = DummyEqualsShow0 (structure Tycon = RealTycon
                                val dummy = 17.0
                                val equals = Real.==
                                fun show ? = Sequence.one (Real.toString (Util.fst ?)))
