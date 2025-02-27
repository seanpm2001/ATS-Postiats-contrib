(*
**
** A simple GTK/CAIRO-clock
**
** Author: Hongwei Xi
** Authoremail: hwxiATcsDOTbuDOTedu
** Start Time: April, 2010
**
*)

(* ****** ****** *)

(*
** Ported to ATS2 by Hongwei Xi, September, 2013
*)

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
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload
UN =
"prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
staload
"libats/libc/SATS/math.sats"
staload
_(*anon*) =
"libats/libc/DATS/math.dats"
//
(* ****** ****** *)
//
macdef PI = M_PI
macdef PI2 = PI/2
macdef _2PI = 2*PI
//
(* ****** ****** *)
//
staload
"libats/libc/SATS/time.sats"
staload
"libats/libc/SATS/sys/time.sats"
//
(* ****** ****** *)

staload "{$LIBCAIRO}/SATS/cairo.sats"

(* ****** ****** *)

stadef dbl = double

(* ****** ****** *)

extern
fun mytime_get (
): @(dbl, dbl, dbl)
implement
mytime_get () = let
//
var tv: timeval?
val err = gettimeofday (tv)
val () = assertloc (err >= 0)
prval () = opt_unsome (tv)
//
var tm: tm_struct // unintialized
val ptr_ = localtime_r (tv.tv_sec, tm)
val () = assert_errmsg (ptr_ > 0, $mylocation)
prval () = opt_unsome (tm)
val sec = tm.tm_sec
val msec = $UN.cast2int(tv.tv_usec)
val ss = (1.0 * sec + 1.0 * msec / 1000000) * PI / 30
val ms = tm.tm_min * PI / 30 + ss / 60
val hs = tm.tm_hour * PI / 6 + ms / 12
//
in
  (hs, ms, ss)
end // end of [mytime_get]

(* ****** ****** *)

fn draw_clock
  (cr: !cairo_ref1): void = () where {
//
(*
  var tm: tm_struct // unintialized
  val ptr_ = localtime_r (t, tm)
  val () = assert_errmsg (ptr_ > 0, $mylocation)
  prval () = opt_unsome {tm_struct} (tm)
  val ss = tm.tm_sec * PI / 30
  val ms = tm.tm_min * PI / 30 // + ss / 60
  val hs = tm.tm_hour * PI / 6 + ms / 12
*)
  val (hs, ms, ss) = mytime_get ()
//
  val () = cairo_set_source_rgba (cr, 1.0, 1.0, 1.0, 1.0)
  val () = cairo_paint (cr)
  val () = cairo_set_line_cap (cr, CAIRO_LINE_CAP_ROUND)
  val () = cairo_set_line_width (cr, 0.1)
//
  // draw a black clock outline
  val () = cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 1.0)
  val () = cairo_translate (cr, 0.5, 0.5)
  val () = cairo_arc (cr, 0.0, 0.0, 0.4, 0.0, _2PI)
  val () = cairo_stroke (cr)
//
  // draw a white dot on the current second
  val () = cairo_set_source_rgba (cr, 1.0, 1.0, 1.0, 0.6)
  val () = cairo_arc (cr, 0.4 * sin(ss), 0.4 * ~cos(ss), 0.05, 0.0, _2PI)
  val () = cairo_fill (cr)
//
  // draw the minutes indicator
  val () = cairo_set_source_rgba (cr, 0.2, 0.2, 1.0, 0.6)
  val () = cairo_move_to (cr, 0.0, 0.0)
  val () = cairo_line_to (cr, 0.4 * sin(ms), 0.4 * ~cos(ms))
  val () = cairo_stroke(cr)
//
  // draw the hours indicator
  val () = cairo_set_source_rgba (cr, 1.0, 0.2, 0.2, 0.6)
  val () = cairo_move_to (cr, 0.0, 0.0)
  val () = cairo_line_to (cr, 0.2 * sin(hs), 0.2 * ~cos(hs))
  val () = cairo_stroke (cr)
//
} // end of [draw_clock]

(* ****** ****** *)

extern
fun mydraw_clock
  (cr: !cairo_ref1, width: int, height: int): void
// end of [mydraw_clock]

(* ****** ****** *)

implement
mydraw_clock
(
  cr, width, height
) = () where {
  val w = g0int2float_int_double(width)
  val h = g0int2float_int_double(height)
  val mn = min (w, h)
  val xc = w / 2 and yc = h / 2
  val (pf0 | ()) = cairo_save (cr)
  val () = cairo_scale (cr, w, h)
  val () = draw_clock (cr)
  val () = cairo_restore (pf0 | cr)
} (* end of [mydraw_clock] *)

(* ****** ****** *)

%{^
typedef char **charptrptr ;
%} ;
abstype charptrptr = $extype"charptrptr"

(* ****** ****** *)
//
#define
LIBATSHWXI_targetloc
"$PATSCONTRIB/contrib/libats-/hwxi"
//
(* ****** ****** *)
//
staload
"{$LIBATSHWXI}/teaching/myGTK/SATS/gtkcairoclock.sats"
staload _ =
"{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairoclock.dats"
//
(* ****** ****** *)

implement
main0 (argc, argv) =
{
//
var argc: int = argc
var argv: charptrptr = $UN.castvwtp1{charptrptr}(argv)
//
val () = $extfcall (void, "gtk_init", addr@(argc), addr@(argv))
//
implement
gtkcairoclock_title<> () = stropt_some"gtkcairoclock"
implement
gtkcairoclock_timeout_interval<> () = 40U // millisecs
implement
gtkcairoclock_mydraw<> (cr, width, height) = mydraw_clock (cr, width, height)
//
val ((*void*)) = gtkcairoclock_main ((*void*))
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [myclock2.dats] *)
