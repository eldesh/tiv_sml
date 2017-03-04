
functor DummyEqualsShow0 (structure Tycon: TYCON0_SIMPLE
                          val dummy: Tycon.t Dummy.t
                          val equals: Tycon.t Equals.t
                          val show: Tycon.t Show.t): EMPTY =
struct
  structure Z = DefCase0Simple (structure Tycon = Tycon
                                structure Value = Dummy
                                val rule = dummy)
  structure Z = DefCase0Simple (structure Tycon = Tycon
                                structure Value = Equals
                                val rule = equals)
  structure Z = DefCase0Simple (structure Tycon = Tycon
                                structure Value = Show
                                val rule = show)
end

