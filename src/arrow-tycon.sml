structure ArrowTycon =
   Tycon2Simple (type ('a, 'b) t = 'a -> 'b
                 val name = "arrow"
                 val iso = Iso.arrow)

structure Z = DefCase2Simple (structure Tycon = ArrowTycon
                              structure Value = Dummy
                              fun rule (_, b) = const (Dummy.apply b))

structure Z = DefCase2Simple (structure Tycon = ArrowTycon
                              structure Value = Show
                              fun rule _ _ = Sequence.one "<fn>")
