
signature TIV_ARG =
sig
  type 'a t

  val iso : ('a, 'b) Iso.t -> ('a t, 'b t) Iso.t
  val name : string
end

signature TIV =
sig
  include TIV_ARG

  val apply : 'a Type.t -> 'a t
  val tiv : Univ.t t RawTiv.t
end

