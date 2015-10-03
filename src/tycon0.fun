functor Tycon0 (S: TYCON0_ARG): TYCON0 =
struct

open S

type u = unit

val tycon: u Tycon.t = Tycon.make {name = name}

val ty: t Type.t = Type.apply (tycon, [], const ())
         
end
