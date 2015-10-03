structure RealTycon = Tycon0 (type t = real
                              val name = "real")

structure Z = DummyEqualsShow0 (structure Tycon = RealTycon
                                val dummy = 17.0
                                val equals = Real.==
                                val show = Sequence.one o Real.toString o fst)
