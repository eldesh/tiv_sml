
structure Univ :> UNIV =
struct
  open Util

  type t = exn

  fun iso () =
  let
    exception E of 'a
  in
    Iso.make (E, fn E a => a | _ => die "project")
  end
end

