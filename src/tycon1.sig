signature TYCON1_ARG =
   sig
      structure Rep:
         sig
            type ('a, 'b) t
         end

      type 'a t
         
      val makeRep: ('a, 'b) Iso.t * ('a t, 'c) Iso.t -> ('b, 'c) Rep.t
      val name: string
   end

signature TYCON1 =
   sig
      include TYCON1_ARG
         
      type u = (Univ.t, Univ.t) Rep.t

      val ty: 'a Type.t -> 'a t Type.t
      val tycon: u Tycon.t
   end

signature ISO2 =
   sig
      type ('a, 'b) t
         
      val iso:
         ('a1, 'b1) Iso.t * ('a2, 'b2) Iso.t
         -> (('a1, 'a2) t, ('b1, 'b2) t) Iso.t
   end

signature TYCON1_ISO_ARG =
   sig
      structure R: ISO2

      type 'a t

      val isorec: unit -> (('a, 'a t) R.t, 'a t) Iso.t
      val name: string
   end

signature TYCON1_ISO =
   sig
      include TYCON1_ISO_ARG

      structure Rep:
         sig
            type ('a, 'b) t = (('a, 'b) R.t, 'b) Iso.t
         end

      type u = (Univ.t, Univ.t) Rep.t

      val makeRep: ('a, 'b) Iso.t * ('a t, 'c) Iso.t -> ('b, 'c) Rep.t
      val ty: 'a Type.t -> 'a t Type.t
      val tycon: u Tycon.t
   end

signature TYCON1_SIMPLE_ARG =
   sig
      type 'a t
         
      val iso: ('a, 'b) Iso.t -> ('a t, 'b t) Iso.t
      val name: string
   end


signature TYCON1_SIMPLE =
   sig
      type 'a t

      structure R: ISO2 where type ('a, 'b) t = 'a t

      structure Rep:
         sig
            type ('a, 'b) t = (('a, 'b) R.t, 'b) Iso.t
         end

      type u = (Univ.t, Univ.t) Rep.t

      val isorec: unit -> ('a t, 'a t) Iso.t
      val makeRep: ('a, 'b) Iso.t * ('a t, 'c) Iso.t -> ('b, 'c) Rep.t
      val name: string
      val ty: 'a Type.t -> 'a t Type.t
      val tycon: u Tycon.t
   end
