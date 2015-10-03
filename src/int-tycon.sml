structure IntTycon = Tycon0 (type t = int
                             val name = "int")

structure Z = DummyEqualsShow0 (structure Tycon = IntTycon
                                val dummy = 13
                                val equals = op =
                                val show = Sequence.one o Int.toString o fst)

