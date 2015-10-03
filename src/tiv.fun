functor Tiv (S: TIV_ARG): TIV =
struct

open S

val tiv: Univ.t t RawTiv.t = RawTiv.make {name = S.name}

fun apply t = Iso.project (S.iso (Type.iso t), RawTiv.apply (tiv, Type.raw t))

end
