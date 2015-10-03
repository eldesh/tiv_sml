structure BoolTycon = Tycon0 (type t = bool
                              val name = "bool")

structure Z = DummyEqualsShow0 (structure Tycon = BoolTycon
                                val dummy = false
                                val equals = op =
                                fun show ? = Sequence.one (Bool.toString (Util.fst ?)))
