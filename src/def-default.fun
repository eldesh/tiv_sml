functor DefDefault (structure Value: TIV
                    val rule: 'a Type.t -> 'a Value.t): EMPTY =
   struct
      val () = RawTiv.defDefault (Value.tiv, rule o Type.makeId)
   end
