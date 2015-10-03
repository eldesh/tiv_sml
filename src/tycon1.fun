functor Tycon1 (S: TYCON1_ARG): TYCON1 =
struct

open S

type u = (Univ.t, Univ.t) Rep.t

val tycon: u Tycon.t = Tycon.make {name = name}
         
fun ty at =
   Type.apply (tycon, [Type.raw at], fn iso =>
               makeRep (Type.iso at, iso))

end

functor Tycon1Iso (S: TYCON1_ISO_ARG): TYCON1_ISO =
   struct
      structure T =
         Tycon1
         (open S
          structure Rep =
             struct
                type ('a, 'b) t = (('a, 'b) R.t, 'b) Iso.t
             end
          fun makeRep (ia, ita) =
             Iso.compose (Iso.flip (R.iso (ia, ita)),
                          Iso.compose (isorec (), ita)))
      open S T
   end
             
functor Tycon1Simple (S: TYCON1_SIMPLE_ARG): TYCON1_ISO =
   Tycon1Iso
   (structure R =
       struct
          type ('a, 'b) t = 'a S.t

          fun iso (i, _) = S.iso i
       end
    open S
    fun isorec () = Iso.id)
