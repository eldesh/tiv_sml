
signature TYCON0_ARG =
sig
  structure Rep :
  sig
    type 'r t
  end

  type t

  val makeRep: (t, 'c) Iso.t -> 'c Rep.t
  val name: string
end

signature TYCON0 =
sig
  include TYCON0_ARG

  type u = Univ.t Rep.t

  val ty: t Type.t
  val tycon: u Tycon.t
end

signature ISO1 =
sig
  type 'a t

  val iso : ('a, 'b) Iso.t
			-> ('a t, 'b t) Iso.t
end

signature TYCON0_ISO_ARG =
sig
  structure R: ISO1

  type t

  val isorec: unit -> (t R.t, t) Iso.t
  val name: string
end

signature TYCON0_ISO =
sig
  include TYCON0_ISO_ARG

  structure Rep:
  sig
	type 'b t = ('b R.t, 'b) Iso.t
  end

  type u = Univ.t Rep.t

  val makeRep: (t, 'c) Iso.t -> 'c Rep.t
  val ty: t Type.t
  val tycon: u Tycon.t
end

signature TYCON0_SIMPLE_ARG =
sig
  type t
  val iso: (t, t) Iso.t
  val name: string
end

signature TYCON0_SIMPLE =
sig
  type t

  structure R: ISO1 where type 'a t = t

  structure Rep:
  sig
	type 'b t = ('b R.t, 'b) Iso.t
  end

  type u = Univ.t Rep.t

  val isorec: unit -> (t, t) Iso.t
  val makeRep: (t, 'c) Iso.t -> 'c Rep.t
  val name: string
  val ty: t Type.t
  val tycon: u Tycon.t
end

