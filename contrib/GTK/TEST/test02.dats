(*
**
** A simple GTK example
** one button in a window
**
** Author: Hongwei Xi
** Authoremail: hwxiATcsDOTbuDOTedu
** Start Time: April, 2010
**
*)
(*
**
** Ported to ATS2
**
** Author: Hongwei Xi
** Authoremail: gmhwxiATgmailDOTcom
** Time: September, 2013
**
*)

(* ****** ****** *)
//
#define
GLIB_targetloc
"$PATSCONTRIB/contrib/glib"
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

staload UN = $UNSAFE

(* ****** ****** *)

staload "{$GLIB}/SATS/glib.sats"

(* ****** ****** *)

staload "./../SATS/gdk.sats"
staload "./../SATS/gtk.sats"
staload "{$GLIB}/SATS/glib-object.sats"

(* ****** ****** *)

%{^
typedef char **charpp ;
%} ;
abstype charpp = $extype"charpp"

(* ****** ****** *)

fun hello
(
  widget: !GtkWidget1, _: gpointer
) : void = print ("Hello, world!\n")

fun on_delete_event
(
  widget: !GtkWidget1
, event: &GdkEvent, udata: gpointer
) : gboolean = let
  val () = print ("delete event occurred\n")
in
  GTRUE // handling of delete-event is finished
end // end of [on_delete_event]

fun on_destroy
  (widget: !GtkWidget1, _: gpointer): void = gtk_main_quit ()
// end of [on_destroy]

(* ****** ****** *)

macdef nullp = the_null_ptr

(* ****** ****** *)

implement
main0 (argc, argv) =
{
//
var argc: int = argc
var argv: charpp = $UN.castvwtp1{charpp}(argv)
//
val () = $extfcall (void, "gtk_init", addr@(argc), addr@(argv))
//
val window =
  gtk_window_new (GTK_WINDOW_TOPLEVEL)
val () = assertloc (ptrcast(window) > 0)
//
val _(*id*) =
g_signal_connect
(
  window, (gsignal)"destroy", (G_CALLBACK)on_destroy, gpointer(nullp)
) (* end of [val] *)
val _(*id*) =
g_signal_connect
(
  window, (gsignal)"delete_event", (G_CALLBACK)on_delete_event, gpointer(nullp)
) (* end of [val] *)
//
val () = gtk_container_set_border_width (window, guint(10))
val button = gtk_button_new_with_label (gstring("Hello, world!"))
val () = assertloc (ptrcast(button) > 0)
//
val () = gtk_widget_show (button)
val () = gtk_container_add (window, button)
val () = gtk_widget_show (window)
//
val _(*id*) =
g_signal_connect
(
  button, (gsignal)"clicked", (G_CALLBACK)hello, gpointer(nullp)
)
val _(*id*) =
g_signal_connect_swapped
(
  button, (gsignal)"clicked", (G_CALLBACK)gtk_widget_destroy, window
)
//
val () = g_object_unref (button)
val () = g_object_unref (window) // ref-count becomes 1!
//
val ((*void*)) = gtk_main ()
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [test02.dats] *)
