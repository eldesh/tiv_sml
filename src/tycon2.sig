signature TYCON2_ARG =
   sig
      structure Rep:
         sig
            type ('a, 'b, 'c) t
         end

      type ('a, 'b) t

      val makeRep:
         ('a1, 'b1) Iso.t
         * ('a2, 'b2) Iso.t
         * (('a1, 'a2) t, 'c) Iso.t -> ('b1, 'b2, 'c) Rep.t
      val name: string
   end

signature TYCON2 =
   sig
      include TYCON2_ARG

      type u = (Univ.t, Univ.t, Univ.t) Rep.t

      val ty: 'a Type.t * 'b Type.t -> ('a, 'b) t Type.t
      val tycon: u Tycon.t
   end

signature ISO3 =
   sig
      type ('a, 'b, 'c) t

      val iso:
         ('a1, 'b1) Iso.t
         * ('a2, 'b2) Iso.t
         * ('a3, 'b3) Iso.t
         -> (('a1, 'a2, 'a3) t, ('b1, 'b2, 'b3) t) Iso.t
   end

signature TYCON2_ISO_ARG =
   sig
      structure R: ISO3

      type ('a1, 'a2) t

      val isorec: unit -> (('a1, 'a2, ('a1, 'a2) t) R.t, ('a1, 'a2) t) Iso.t
      val name: string
   end

signature TYCON2_ISO =
   sig
      include TYCON2_ISO_ARG

      structure Rep:
         sig
            type ('a, 'b, 'c) t = (('a, 'b, 'c) R.t, 'c) Iso.t
         end

      type u = (Univ.t, Univ.t, Univ.t) Rep.t

      val makeRep:
         ('a1, 'b1) Iso.t
         * ('a2, 'b2) Iso.t
         * (('a1, 'a2) t, 'c) Iso.t -> ('b1, 'b2, 'c) Rep.t
      val ty: 'a Type.t * 'b Type.t -> ('a, 'b) t Type.t
      val tycon: u Tycon.t
   end

signature TYCON2_SIMPLE_ARG =
   sig
      type ('a, 'b) t
         
      val iso: ('a1, 'b1) Iso.t * ('a2, 'b2) Iso.t
               -> (('a1, 'a2) t, ('b1, 'b2) t) Iso.t
      val name: string
   end

signature TYCON2_SIMPLE =
   sig
      type ('a, 'b) t

      structure R: ISO3 where type ('a, 'b, 'c) t = ('a, 'b) t
      
      structure Rep:
         sig
            type ('a, 'b, 'c) t = (('a, 'b) t, 'c) Iso.t
         end

      type u = (Univ.t, Univ.t, Univ.t) Rep.t

      val isorec: unit -> (('a1, 'a2) t, ('a1, 'a2) t) Iso.t
      val makeRep: ('a1, 'b1) Iso.t
                   * ('a2, 'b2) Iso.t
                   * (('a1, 'a2) t, 'c) Iso.t
                   -> ('b1, 'b2, 'c) Rep.t
      val name: string
      val ty: 'a Type.t * 'b Type.t -> ('a, 'b) t Type.t
      val tycon: u Tycon.t
   end
   
