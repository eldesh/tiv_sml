structure RawTiv:> RAW_TIV =
struct

open Util

structure Tycon =
   struct
      structure Name =
         struct
            datatype t = T of {name: string,
                               uniq: unit ref}

            fun make {name} =
               T {name = name,
                  uniq = ref ()}

            fun equals (T {uniq = u, ...}, T {uniq = u', ...}) = u = u'

            fun toString (T {name, ...}) = name
         end

      structure Univ:> UNIV = Univ

      datatype 'a t = T of {iso: ('a, Univ.t) Iso.t,
                            name: Name.t}

      local
         fun make f (T r) = f r
      in
         val iso = fn ? => make #iso ?
         val name = fn ? => make #name ?
      end

      fun make n =
         T {iso = Univ.iso (),
            name = Name.make n}
   end

structure Type =
   struct
      structure Raw =
         struct
            datatype t = App of Tycon.Name.t * t list * Tycon.Univ.t

            fun equals (App (tyc, ts, _), App (tyc', ts', _)) =
               Tycon.Name.equals (tyc, tyc')
               andalso List.equals (ts, ts', equals)

            fun toString (App (tyc, ts, _)) =
               concat
               [Tycon.Name.toString tyc,
                " ",
                concat ["[",
                        concat (List.separate
                                (List.map (ts, toString), ",")),
                        "]"]]
         end
            
      datatype 'a t = T of {iso: ('a, Univ.t) Iso.t,
                            raw: Raw.t}

      local
         fun make f (T r) = f r
      in
         val iso = fn ? => make #iso ?
         val raw = fn ? => make #raw ?
      end

      fun make (raw, iso) = T {iso = iso, raw = raw}

      fun makeId r = make (r, Iso.id)

      fun apply (Tycon.T {iso, name, ...}: 'a Tycon.t,
                 args: Raw.t list,
                 f: ('b, Univ.t) Iso.t -> 'a): 'b t =
         let
            val iso' = Univ.iso ()
            val raw = Raw.App (name, args, Iso.inject (iso, f iso'))
         in
            T {iso = iso',
               raw = raw}
         end
   end

datatype 'a t =
   T of {cases: ((Tycon.Name.t * (Type.Raw.t list * Tycon.Univ.t -> 'a))
                 list ref),
         default: (Type.Raw.t -> 'a) option ref,
         name: string}
         
fun make {name}: 'a t =
   T {cases = ref [],
      default = ref NONE,
      name = name}

fun defCase (T {cases, name = tivName, ...}, Tycon.T {iso, name, ...}, f) =
   if List.exists (!cases, fn (n, _) => Tycon.Name.equals (n, name)) then
      die (concat
           ["type-indexed value '", tivName,
            "' got duplicate definition of rule for tycon '",
            Tycon.Name.toString name, "'"])
   else
      List.push (cases, (name, fn (a, u) => f (a, Iso.project (iso, u))))

fun defDefault (T {default, ...}, a) = default := SOME a
         
fun apply (T {cases, default, name}, raw as Type.Raw.App (tyc, rs, aux)) =
   case List.peek (!cases, fn (tyc', _) =>
                   Tycon.Name.equals (tyc, tyc')) of
      NONE =>
         (case !default of
             NONE =>
                die (concat ["type-indexed value '", name,
                             "' not defined for type: ", Type.Raw.toString raw])
           | SOME f => f raw)
    | SOME (_, f) =>
         f (rs, aux)

end

local
   open RawTiv
in
   structure Tycon = Tycon
   structure Type = Type
end
