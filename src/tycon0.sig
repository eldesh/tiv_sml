signature TYCON0_ARG =
   sig
      type t

      val name: string
   end

signature TYCON0 =
   sig
      include TYCON0_ARG

      type u = unit

      val ty: t Type.t
      val tycon: u Tycon.t
   end
