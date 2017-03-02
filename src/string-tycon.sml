
structure StringTycon =
  Tycon0 (type t = String.string
          val name = "string")

structure Z = DummyEqualsShow0 (structure Tycon = StringTycon
                                val dummy = ""
                                val equals = op =
                                fun show ? = Sequence.one (Util.fst ?))
