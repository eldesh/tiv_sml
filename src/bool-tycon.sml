structure BoolTycon = Tycon0 (type t = bool
                              val name = "bool")

structure Z = DummyEqualsShow0 (structure Tycon = BoolTycon
                                val dummy = false
                                val equals = op =
                                val show = Sequence.one o Bool.toString o fst)
