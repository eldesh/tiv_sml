
まとめ。

ジェネリックプログラミングをSMLで行うために、
型と一対一で対応する値を用いるテクニックを開発した。

これを Tiv と呼ぶ。
例えば、 BoolTycon.ty の型は bool Type.t であり、この型を持つ値は BoolTycon.ty しか存在しない。

多相型も同じく ListTycon.ty IntTycon.ty : int list Type.t のようにして表す。
これを用いて、それぞれの型の唯一の値(表現) ≒型 によって処理を分岐する計算を記述する。
これら、型コンストラクタを表すstructurenはシグネチャTYCON<n>を持つ。
nはアリティである。

シグネチャ TIV を持つ structure は、型によって処理を分岐したいジェネリックな関数に対応し、
型('a Type.t) を渡して、型に特化した関数を返す。

Tiv に型('a Type.t)を渡して特化した関数を得るには TIV.apply 関数を使う。
例えば、

::
  Equals.apply IntTycon.ty : int * int -> bool

となる。

ユーザ定義の型を既存のtivに対応させるには、(tiv用の)型コンストラクタを定義する必要がある。
これには Tycon() ファンクタを使用する。

本手法では再帰型やミュータブルな型も扱えるが、非再帰かつimmutableな定義に特化したヘルパファンクタ(Tycon<n>Simple)が提供されている。

tivをユーザ定義するには Tiv ファンクタを使用する。
tivは任意の型のisomorphismｋ関係を、その型上のisomorhism関係に持ち上げる方法を提供する。(何に使うんだ？)


任意の tiv について任意の Tycon 規則を使用させるには、DefCase<n> ファンクタを使用する。(nは型のアリティ)
これは、グローバルコレクションに各 tiv の各Tycon に対応する関数を追加する物である。


基礎ツール
====================

実装に用いられているユーティリティ。

('a,'b) Iso.t
  任意の二つの型の間のお互いへの変換。(isomorphism関係)

Univ
  ユニバーサルタイプの実装。
  異なる型の関数を保持するためにライブラリのバックエンドで使用される。



用語

 inductive rule


型

BoolTycon

Equals : TIV where 'a t = 'a * 'a -> bool

Tiv(TIV_ARG)
TIV

DefCase<N>

空のシグネチャ。
副作用のあるファンクタ適用の結果を示す。

::
  signature EMPTY = sig end

::
  DefCase0 (
      structure Tycon: TYCON0
      structure Value: TIV
      val rule: Tycon.t Value.t) : EMPTY

::
  functor DefCase<n>Simple
     (S: sig
            structure Tycon: TYCON<n>_SIMPLE
            structure Value: TIV
            val rule: 'a1 Type.t * ... * 'a<n> Type.t 
                      -> ('a1, ..., 'a<n>) Value.t
         end): EMPTY

::
  functor DefCase<n>Iso
     (structure Tycon: TYCON<n>_ISO
      structure Value: TIV
      val rule: 'a1 Type.t * ... * 'a<n> Type.t 
                * (('a1, ..., 'a<n>, 'b) Tycon.R.t, 'b) Iso.t
                -> 'b Value.t): EMPTY

::
  functor DefCase<n>
     (structure Tycon: TYCON<n>
      structure Value: TIV
      val rule: 'a1 Type.t * ... * 'a<n> Type.t
                * ('a1, ..., 'a<n>, 'b) Tycon.Rep.t
                * ('b, Univ.t) Iso.t
                -> 'b Value.t)): EMPTY

::
  functor DefDefault (structure Value: TIV
                      val rule: 'a Type.t -> 'a Value.t): EMPTY


任意アリティのタプルについて tiv の定義をする.

::
  functor DefTupleCase
     (structure Accum:
         sig
            type 'a t
  
            val iso: ('a, 'b) Iso.t -> ('a t, 'b t) Iso.t
         end
      structure Value: TIV
      val base: unit Accum.t
      val finish: 'a Accum.t -> 'a Value.t
      val step: 'a Type.t * 'b Accum.t -> ('a * 'b) Accum.t): EMPTY




型コンストラクタの表現を定義する

Tycon<n>(TYCON<n>_ARG) : TYCON<n>

nullary版
Tycon0 (TYCON0_ARG) : TYCON0
TYCON0_ARG

イミュータブル且つ非再帰的な Tycon<n> のスペシャライズ版。

::
  Tycon<n>Simple(TYCON<>_SIMPLE_ARG) : TYCON<n>_SIMPLE
  
  signature TYCON<n>_SIMPLE_ARG =
     sig
        type ('a1, ..., 'a<n>) t
         
        val iso: ('a1, 'b1) Iso.t * ... * ('a<n>, 'b<n>) Iso.t
                 -> (('a1, ..., 'a<n>) t, ('b1, ..., 'b<n>) t) Iso.t
        val name: string
     end

再帰型用のスペシャライズ版

::
  functor Tycon<n>Iso (S: TYCON<n>_ISO_ARG): TYCON<n>_ISO

  signature TYCON<n>_ISO_ARG =
     sig
        structure R:
           sig
              type ('a1, ..., 'a<n>, 'r) t
  
              val iso:
                 ('a1, 'b1) Iso.t * ... * ('a<n>, 'bn) Iso.t * ('ra, 'rb) Iso.t
                 -> (('a1, ..., 'a<n>, 'ra) t, ('b1, ..., 'b<n>, 'rb) t) Iso.t
           end
  
        type ('a1, ..., 'a<n>) t

        val isorec: unit -> (('a1, ..., 'a<n>, ('a1, ..., 'a<n>) t) R.t,
                             ('a1, ..., 'a<n>) t) Iso.t
        val name: string
     end

::
  functor Tycon<n> (S: TYCON<n>_ARG): TYCON<n>

  signature TYCON<N>_ARG =
     sig
        structure Rep:
           sig
              type ('a1, ..., 'a<n>, 'b) t
           end
  
        type ('a1, ..., 'a<n>) t
           
        val makeRep: ('a1, 'b1) Iso.t
                     * ...
                     * ('a<n>, 'b<n>) Iso.t
                     * (('a1, ..., 'a<n>) t, 'c) Iso.t 
                     -> ('b1, ..., 'b<n>, 'c) Rep.t
        val name: string
     end


