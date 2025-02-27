(* ****** ****** *)
//
// Linear Algebra vector operations
//
(* ****** ****** *)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2013 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** Permission to use, copy, modify, and distribute this software for any
** purpose with or without fee is hereby granted, provided that the above
** copyright notice and this permission notice appear in all copies.
** 
** THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
** WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
** MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
** ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
** WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
** ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
** OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*)

(* ****** ****** *)


staload
UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "libats/SATS/gvector.sats"
staload "libats/SATS/refcount.sats"

(* ****** ****** *)

staload "./../SATS/blas.sats"
staload "./../SATS/lavector.sats"

(* ****** ****** *)

local

vtypedef
sourcerfc = refcnt (ptr)

datavtype
LAgvec
  (a:t@ype, int) =
  {n:int}{d:int | d >= 1}
  LAGVEC (a, n) of (uint(*rfc*), sourcerfc, ptr, int(n), int(d))
// end of [LAgvec]

assume
LAgvec_vtype
  (a:t0p, l:addr, n:int) = LAgvec (a, n)
// end of [assume]

in (* in of [local] *)

(* ****** ****** *)

implement{}
LAgvec_size (V) = let
//
val+LAGVEC(_, _, _, n, _) = V in n
//
end // end of [LAgvec_size]

(* ****** ****** *)

implement{}
LAgvec_vtakeout_vector
  {a}{n} (V, d0) = let
//
val+LAGVEC
  (_, _, gvp, n, d) = V
val () = (d0 := d)
prval [d:int]
  EQINT () = eqint_make_gint (d)
//
in
  $UN.ptr0_vtake{gvector(a,n,d)}(gvp)
end // end of [LAgvec_vtakeout_vector]

(* ****** ****** *)

implement{}
LAgvec_incref
  {a}{l}{n} (V) = let
//
val+@LAGVEC(rfc, _, _, _, _) = V
val ((*void*)) = (rfc := succ(rfc))
prval () = fold@(V)
//
in
  $UN.castvwtp1{LAgvec(a,l,n)}(V)
end // end of [LAgvec_incref]

(* ****** ****** *)

implement{}
LAgvec_decref
  {a}{l}{n} (V) = let
//
val+@LAGVEC
  (rfc, src, _, _, _) = V
val rfc1 = pred (rfc)
//
in (* in of [LAgvec_decref] *)
//
if
isgtz(rfc1)
then let
  val () = rfc := rfc1
  prval () = fold@(V)
  prval () = $UN.cast2void (V)
in
  // nothing
end else let
  val opt =
    refcnt_decref_opt (src)
  val () = free@{a}{n}{1}(V)
  extern
  fun __free (ptr): void = "mac#atspre_mfree_gc"
in
  case+ opt of
  | ~Some_vt (gvp) => __free(gvp) | ~None_vt () => ()
end // end of [if]
//
end // end of [LAgvec_decref]

(* ****** ****** *)

implement{}
LAgvec_make_arrayptr
  (A, n) = let
  val pA = $UN.castvwtp0{ptr}(A)
  val src = refcnt_make_elt<ptr> (pA)
in
  LAGVEC (1u(*rfc*), src, pA, n, 1)
end // end of [LAgvec_make_arrayptr]

(* ****** ****** *)

implement{a}
LAgvec_make_uninitized (n) = let
//
val A = arrayptr_make_uninitized<a> (i2sz(n))
//
in
  LAgvec_make_arrayptr (A, n)
end // end of [LAgvec_make_uninitized]

(* ****** ****** *)

implement{a}
LAgvec_get_at
  (V, i) = x where
{
//
val cp = LAgvec_getref_at (V, i)
val (pf, fpf | p) = $UN.p2tr_vtake (cp)
val x = !p
prval () = fpf (pf)
//
} // end of [LAgvec_get_at]

implement{a}
LAgvec_set_at
  (V, i, x) = () where
{
//
val cp = LAgvec_getref_at (V, i)
val (pf, fpf | p) = $UN.p2tr_vtake (cp)
val () = !p := x
prval () = fpf (pf)
//
} // end of [LAgvec_get_at]

(* ****** ****** *)

implement{a}
LAgvec_getref_at
  (V, i) = let
//
var d: int
val (pf, fpf | p) = LAgvec_vtakeout_vector (V, d)
val p_i = ptr_add<a>(p, i*d)
prval () = fpf (pf)
//
in
  $UN.cast{P2tr1(a)}(p_i)
end // end of [LAgvec_getref_at]

(* ****** ****** *)

implement{a}
LAgvec_split
  (V, i) = let
//
val+LAGVEC
  (_, src, p, n, d) = V
//
val src1 = refcnt_incref (src)
val src2 = refcnt_incref (src)
val ((*void*)) = LAgvec_decref (V)
//
val p1 = p
val i1 = i
val p2 = ptr_add<a> (p, i)
val i2 = n-i
val V1 = LAGVEC (1u(*rfc*), src1, p1, i1, d)
val V2 = LAGVEC (1u(*rfc*), src2, p2, i2, d)
//
in
  (V1, V2)
end // end of [LAgvec_split]

(* ****** ****** *)

end // end of [local]

(* ****** ****** *)

implement{}
fprint_LAgvec$sep (out) = fprint (out, ", ")
implement{a}
fprint_LAgvec (out, V) = let
//
val n = LAgvec_size (V)
//
var d: int
val (pf, fpf | p) = LAgvec_vtakeout_vector (V, d)
//
local
implement
fprint_gvector$sep<> (out) = fprint_LAgvec$sep (out)
in (* in of [local] *)
val () = fprint_gvector (out, !p, n, d)
end // end of [local]
//
prval () = fpf (pf)
//
in
  // nothing
end // end of [fprint_LAgvec]

(* ****** ****** *)

implement{a}
LAgvec_tabulate (n) = let
//
implement
array_tabulate$fopr<a>
  (i) = LAgvec_tabulate$fopr (g0u2i(i))
//
in
  LAgvec_make_arrayptr (arrayptr_tabulate<a> (i2sz(n)), n)
end // end of [LAgvec_tabulate]

(* ****** ****** *)

implement
{a}(*tmp*)
LAgvec_inner
  (V1, V2) = let
//
val n = LAgvec_size V1
//
var d1: int and d2: int
//
val
(
  pf1, fpf1 | p1
) = LAgvec_vtakeout_vector (V1, d1)
val
(
  pf2, fpf2 | p2
) = LAgvec_vtakeout_vector (V2, d2)
//
val res = blas_inner (!p1, !p2, n, d1, d2)
//
prval () = fpf1 (pf1) and () = fpf2 (pf2)
//
in
  res
end // end of [LAgvec_inner]

(* ****** ****** *)

implement
{a}(*tmp*)
LAgvec_copy
  (V1, V2) = let
//
val n = LAgvec_size V1
var d1: int and d2: int
//
val (
  pf1, fpf1 | p1
) = LAgvec_vtakeout_vector (V1, d1)
val (
  pf2, fpf2 | p2
) = LAgvec_vtakeout_vector (V2, d2)
//
val () = blas_copy (!p1, !p2, n, d1, d2)
//
prval (
) = gvector_uninitize(!p2)
prval () = fpf1 (pf1) and () = fpf2 (pf2)
//
prval () = LAgvec_initize{a}(V2)
//
in
  // nothing
end // end of [LAgvec_copy]

(* ****** ****** *)

implement
{a}(*tmp*)
copy_LAgvec
  (V) = V2 where
{
//
prval () = lemma_LAgvec_param (V)
//
val n = LAgvec_size (V)
val V2 = LAgvec_make_uninitized<a> (n)
val () = LAgvec_copy (V, V2)
//
} // end of [copy_LAgvec]

(* ****** ****** *)

implement
{a}(*tmp*)
LAgvec_swap
  (V1, V2) = let
//
val n = LAgvec_size V1
var d1: int and d2: int
//
val (
  pf1, fpf1 | p1
) = LAgvec_vtakeout_vector (V1, d1)
val (
  pf2, fpf2 | p2
) = LAgvec_vtakeout_vector (V2, d2)
//
val () = blas_swap (!p1, !p2, n, d1, d2)
//
prval () = fpf1 (pf1) and () = fpf2 (pf2)
//
in
  // nothing
end // end of [LAgvec_swap]

(* ****** ****** *)

implement{a}
add11_LAgvec_LAgvec
  (V1, V2) = res where
{
//
val res = copy_LAgvec (V2)
val ((*void*)) = LAgvec_1x1y (V1, res)
//
} // end of [add11_LAgvec_LAgvec]

(* ****** ****** *)

(* end of [lavector.dats] *)
