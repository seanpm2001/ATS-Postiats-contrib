//
// Animating Quicksort
//
(* ****** ****** *)
//
#define
LIBCAIRO_targetloc
"\
$PATSHOME\
/npm-utils/contrib\
/atscntrb/atscntrb-hx-libcairo"
//
(* ****** ****** *)
//
#include
"share/atspre_define.hats"
#include
"share/atspre_staload.hats"
#include
"share/HATS\
/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)
//
#staload UN = $UNSAFE // opening it
//
(* ****** ****** *)
//
#staload "libats/SATS/hashfun.sats"
#staload "libats/SATS/hashtbl_chain.sats"
//
#staload _ = "libats/DATS/hashfun.dats"
#staload _ = "libats/DATS/hashtbl_chain.dats"
//
(* ****** ****** *)
//
//
#define
HX_MYTESTING_targetloc
"\
$PATSHOME\
/contrib/atscntrb\
/atscntrb-hx-mytesting"
//
#staload
"{$HX_MYTESTING}/SATS/randgen.sats"
#staload _ =
"{$HX_MYTESTING}/DATS/randgen.dats"
//
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/BUCS/DATS/BUCS320.dats"
//
(* ****** ****** *)

#define MYMAX 100

(* ****** ****** *)

typedef int2 = (int, int)

(* ****** ****** *)

local
//
val theCirclst =
  ref<list0(int2)> (nil0())
//
in (* in-of-local *)

fun
theCirclst_add
  (i1: int, i2: int): void =
(
  !theCirclst := cons0 ((i1, i2), !theCirclst)
)

fun
theCirclst_get_all
(
// argumentlst
) : list0(int2) = let
  val xys = !theCirclst
  val ((*void*)) = !theCirclst := nil0((*void*))
in
  list0_reverse (xys)
end // end of [theCirclst_get_all]

end // end of [local]

(* ****** ****** *)

extern
fun{
a:t@ype
} mergesort (A: array0 (a)): void

(* ****** ****** *)
//  
extern
fun{
a:t@ype
} mergesort2
  (A: array0 (a), i: int, j: int): void
// 
(* ****** ****** *)
//
implement
{a}(*tmp*)
mergesort (A) =
  mergesort2<a> (A, 0, sz2i(A.size()))
//
(* ****** ****** *)
//
extern
fun{
a:t@ype
} sortedmerge
  (A: array0 (a), i: int, split: int, j: int): void
//
(* ****** ****** *)

implement
{a}(*tmp*)
mergesort2
  (A, i, j) = let
//
val len = j - i
//
in
//
if
len >= 2
then let
  val split = i + half(len)
  val ((*void*)) = mergesort2 (A, i, split)
  val ((*void*)) = mergesort2 (A, split, j)
  val ((*void*)) = sortedmerge (A, i, split, j)
in
  // nothing
end // end of [then]
else () // end of [else]
//
end // end of [mergesort2]

(* ****** ****** *)

extern
fun{
a:t@ype
} subcirculate
  (A: array0 (a), i: int, j: int): void

(* ****** ****** *)

implement
{a}(*tmp*)
subcirculate
  (A0, i, j) = let
//
val i = g1ofg0 (i)
val j = g1ofg0 (j)
val () = assertloc (i >= 0)
and () = assertloc (j >= 0)
val i = i2sz (i) and j = i2sz (j)
val [n:int] (A, n) = array0_get_refsize (A0)
val () = assertloc (i < n)
and () = assertloc (j < n)
//
val (vbox pf | p) = arrayref_get_viewptr (A)
//
in
  array_subcirculate (!p, i, j)
end // end of [subcirculate]

(* ****** ****** *)

implement
{a}(*tmp*)
sortedmerge
  (A, i, split, j) = let
in
//
if
i < split && split < j
then let
//
val sgn =
  gcompare_val_val<a> (A[i], A[split])
//
in
//
if sgn <= 0
  then let
    val () = theCirclst_add (i, i)
  in
    sortedmerge<a> (A, i+1, split, j)
  end // end of [then]
  else let
    val () = theCirclst_add (i, split)
    val () = subcirculate (A, i, split)
  in
    sortedmerge<a> (A, i, split+1, j)
  end // end of [else]
//
end // end of [then]
else () // end of [else]
//
end // end of [sortedmerge]

(* ****** ****** *)

local

implement
randgen_val<int> () = randint (MYMAX)

in (* in-of-local *)

fun
genScript{n:int}
(
  out: FILEref, asz: size_t(n)
) :
(
  array0 (int), list0(int2)
) = let
//
val A =
randgen_arrayref<int> (asz)
//
val A = array0 (A, asz)
val A2 = array0_copy (A)
//
val () = mergesort (A2)
//
(*
val () = fprint (out, A, asz)
val () = fprint_newline (out)
val () = fprint (out, A2, asz)
val () = fprint_newline (out)
*)
//
in
  (A, theCirclst_get_all ())
end (* end of [genScript] *)

end // end of [local]

(* ****** ****** *)
//
#staload "{$LIBCAIRO}/SATS/cairo.sats"
//
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/SATS/mydraw.sats"
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/SATS/mydraw_cairo.sats"
//
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/DATS/mydraw_bargraph.dats"
//
#staload _ =
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/DATS/mydraw.dats"
#staload _ =
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/DATS/mydraw_cairo.dats"
//
(* ****** ****** *)
//
#define
LIBATSHWXI_targetloc
"$PATSCONTRIB/contrib/libats-hwxi"
//
#staload
"{$LIBATSHWXI}/teaching/myGTK/SATS/gtkcairotimer.sats"
#staload
"{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairotimer/gtkcairotimer_toplevel.dats"
//
#staload CP =
"{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairotimer/ControlPanel.dats"
#staload DP =
"{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairotimer/DrawingPanel.dats"
#staload MAIN =
"{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairotimer/gtkcairotimer_main.dats"
#staload TIMER =
"{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairotimer/gtkcairotimer_timer.dats"
//
(* ****** ****** *)

dynload "./gtkcairotimer_toplevel.dats"

(* ****** ****** *)

local
//
val () = srandom_with_time ()
//
val xy0 = ref<int2> ((~1, 0))
//
val (A0, xys0) =
  genScript (stdout_ref, i2sz(96))
//
val theCirclst2 = ref<list0(int2)> (xys0)
//
in (* in-of-local *)

val ASZ = array0_copy (A0)

extern
fun
ASZ_reset (): void
implement
ASZ_reset () = {
//
val () = srandom_with_time ()
//
var i: size_t
val () = !xy0 := ((~1, 0))
val () = for (i := i2sz(0); i < A0.size(); i := succ(i)) ASZ[i] := A0[i]
val () = !theCirclst2 := xys0
//
} (* end of [ASZ_reset] *)

extern
fun
ASZ_update (): void
implement
ASZ_update () = let
//
  val ij = !xy0
  val xys = !theCirclst2
//
  val () = (
    case+ xys of
    | nil0 () => !xy0 := ((~1, 0))
    | cons0 (xy, xys) => (!xy0 := xy; !theCirclst2 := xys)
  ) (* end of [val] *)
//
  val i = ij.0 and j = ij.1
//
in
  if i >= 0 then subcirculate (ASZ, i, j)
end (* end of [ASZ_update] *)

end // end of [local]

(* ****** ****** *)

implement
the_timer_reset_after<> () = ASZ_reset ()

(* ****** ****** *)

extern
fun
cairo_draw_array0
(
  cr: !cairo_ref1
, point, point, point, point, array0(int)
) : void // end-of-fun

(* ****** ****** *)
//
extern
fun
colorgen (x: int): color
//
implement
colorgen (x) = let
//
  val x = $UN.cast{uint32}(x)
  val hval = $extfcall (uint32, "atslib_inthash_jenkins", x)
  val hval = $UN.cast{uint}(hval)
//
  val r = $UN.cast{int}(hval mod 256u)
  val hval = hval / 256u
  val g = $UN.cast{int}(hval mod 256u)
  val hval = hval / 256u
  val b = $UN.cast{int}(hval mod 256u)
//
in
  color_make (r/256.0, g/256.0, b/256.0)
end // end of [colorgen]
//
(* ****** ****** *)

implement
cairo_draw_array0
(
  cr, p1, p2, p3, p4, ASZ
) = let
//
val p_cr = ptrcast (cr)
//
implement
mydraw_get0_cairo<> () = let
//
extern
castfn __cast {l:addr} (ptr(l)): vttakeout (void, cairo_ref(l))
//
in
  __cast (p_cr)
end // end of [mydraw_get0_cairo]
//
implement
mydraw_bargraph$color<> (i) = colorgen (ASZ[i])

implement
mydraw_bargraph$height<> (i) = 1.0 * (ASZ[i]+1) / MYMAX
//
val asz = ASZ.size()
val asz = sz2i (asz)
val asz = ckastloc_gintGt (asz, 0)
//
in
  mydraw_bargraph (asz, p1, p2, p3, p4)
end // end of [cairo_draw_array0]

(* ****** ****** *)

extern
fun
mydraw_clock
  (cr: !cairo_ref1, width: int, height: int) : void
// end of [mydraw_clock]

(* ****** ****** *)

implement
mydraw_clock
  (cr, W, H) = let
//
val W =
g0int2float_int_double(W)
and H =
g0int2float_int_double(H)
//
val WH = min (W, H)
//
val xm = (W - WH) / 2
val ym = (H - WH) / 2
//
val v0 = vector_make (xm, ym)
//
val p1 = point_make (0. , WH) + v0
val p2 = point_make (WH , WH) + v0
val p3 = point_make (WH , 0.) + v0
val p4 = point_make (0. , 0.) + v0
//
val () =
if the_timer_is_running () then ASZ_update ()
//
val (pf | ()) = cairo_save (cr)
val () = cairo_draw_array0 (cr, p1, p2, p3, p4, ASZ)
val ((*void*)) = cairo_restore (pf | cr)
//
in
  // nothing
end // [mydraw_clock]

(* ****** ****** *)
//
%{^
typedef char **charptrptr ;
%} ;
abstype charptrptr = $extype"charptrptr"
//
(* ****** ****** *)

implement
main0{n}
(
  argc, argv
) = let
//
var argc: int = argc
var argv: charptrptr = $UN.castvwtp1{charptrptr}(argv)
//
val () = $extfcall (void, "gtk_init", addr@(argc), addr@(argv))
//
implement
gtkcairotimer_title<>
(
// argumentless
) = stropt_some"QuicksortAnimation"
implement
gtkcairotimer_timeout_interval<> () = 100U // millisecs
implement
gtkcairotimer_mydraw<> (cr, width, height) = mydraw_clock (cr, width, height)
//
val ((*void*)) = gtkcairotimer_main ((*void*))
//
in
  // nothing
end // end of [main0]

(* ****** ****** *)

(* end of [quicksort_anim2.dats] *)
