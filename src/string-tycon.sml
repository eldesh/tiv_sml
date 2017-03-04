
structure StringTycon =
  Tycon0Simple (
    type t = String.string
    val iso = Iso.id
    val name = "string"
  )

structure Z = DummyEqualsShow0 (structure Tycon = StringTycon
                                val dummy = ""
                                val equals = op =
                                fun show ? = Sequence.one (Util.fst ?))
