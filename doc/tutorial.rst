==========
 Tutorial
==========

Organization of Findlib Packages
================================

There are a bunch of findlib packages.  Maybe too many and too
confusing, I can't tell.  But the general idea is that for each
rewriter or group of rewriters, there are two packages:

1. the package for linking into a program, viz. ``pa_ppx.deriving_plugins.show.link``
2. the package for loading into the toplevel or adding to camlp5 during preprocessing,
viz. ``pa_ppx.deriving_plugins.show``

Note the ``.link`` at the end there.  These are separated like this so
we can specify "preprocess with the show plugin, but don't link it
into the program" and separately "link the show plugin into the
program, but don't preprocess with it".

[I thought of having a "virtual package" that just required the both,
but it turns out that findlib doesn't support that (and I can see the
reasoning there -- it could be a source of hard-to-understand bugs).

Using ``pa_ppx`` PPX Rewriters
==============================

This example can be found in `tutorial/simple_show`.

Batch compilation with Make
---------------------------

To use ``pa_ppx`` PPX rewriters, let's start with a really simple file
that works with the standard PPX rewriters (simple_show.ml)::

  type a1 = int * int [@@deriving show]
  let _ = print_string ([%show: a1] (5,6))

and we compile it thus::

  ocamlfind ocamlc -package ppx_deriving.show simple_show.ml  -o simple_show.byte

Running it yields::

  $ ./simple_show.byte
  (5, 6)

To compile with ``pa_ppx``::

  ocamlfind ocamlc -package pa_ppx.deriving_plugins.show -syntax camlp5o simple_show.ml -linkpkg  -o simple_show.byte

with identical output::

  $ ./simple_show.byte
  (5, 6)

There's really only two important differences:

1. need to specify the syntax (``-syntax camlp5o``)
2. instead of ``ppx_deriving.show`` specify ``pa_ppx.deriving_plugins.show``

The other linking flags, I just haven't figured out precisely how to get rid of.

Sometimes more packages must be specified (e.g. for ``expect_test``
and ``inline_test``) because ``dune`` is adding those
under-the-covers, and these instructions are all Makefile-friendly.

Batch compilation with Dune
---------------------------

Dune requires that we provide a command that will preprocess, but not
compile.  Since this is cumbersome to do with ocamlfind, `pa_ppx`
builds a number of such preprocessors (basically, one for each
subdirectory, and one that includes them all) and installs them as
part of the package.  In the case of ``simple_show.ml``, we want the
deriving plugins, which can be invoked thus:

::

   ocamlfind pa_ppx/camlp5o.pa_ppx_deriving_plugins  ./simple_show.ml

[BTW, this command was built using ``mkcamlp5``, and you can see the
build command in the ``pa_ppx/pa_deriving.plugins`` Makefile.]

With this command, we can modify a dune file pretty easily.  Here's the modification for
`Yara <https://github.com/XVilka/yara-ocaml>`_:

::

   @@ -2,7 +2,13 @@
     (name yara)
     (public_name yara)
     (wrapped false)
   - (preprocess
   -  (pps ppx_deriving.std))
   +
   +;; (preprocess
   +;;  (pps ppx_deriving.std))
   +
   + (preprocess (action
   +      (run ocamlfind pa_ppx/camlp5o.pa_ppx_deriving_plugins %{input-file})
   +    ))
   +


and here's a dunefile that will compile ``test_deriving_show.ml``:

::

   (env
     (dev
       (flags (:standard -w -27 -w -32))))
   
   (executable
    (name simple_show)
    (libraries fmt pa_ppx.runtime ppx_deriving.runtime)
    (preprocess (action
         (run ocamlfind pa_ppx/camlp5o.pa_ppx_deriving_plugins %{input-file})
         )))

[The warnings must be silenced b/c the test itself elicits warnings,
and I didn't want to modify it.  OTOH, I didn't silence all warnings
b/c if there are warnings produced by the generated code, I'd like to
know about them.]


In the toplevel
---------------

It's also straightforward to use ``pa_ppx`` PPX rewriters in the toplevel:

::

           OCaml version 4.10.0
   #use "topfind.camlp5";;
   - : unit = ()
   # #camlp5o ;;
	Camlp5 parsing version 8.00-alpha01
   # #require "pa_ppx.deriving_plugins.show";;

   # type a1 = int * int [@@deriving show] ;;
   type a1 = int * int
   val pp_a1 : a1 Fmt.t = <fun>
   val show_a1 : a1 -> String.t = <fun>
   # let _ =
     print_string ([%show: a1] (5,6)) ;;
   (5, 6)- : unit = ()
   # 

And again, just the ocaml toplevel phrases:

::

   #use "topfind.camlp5";;
   #camlp5o ;;
   require "pa_ppx.deriving_plugins.show";;
    type a1 = int * int [@@deriving show] ;;
   let _ =
     print_string ([%show: a1] (5,6)) ;;

Writing new PPX Rewriters upon Pa_ppx
=====================================

In this section, we'll describe at a high level the process of PPX
rewriter execution in ``Pa_ppx``, and how that results in the process
for writing new ones.

In ``Pa_ppx`` rewriters are "installed" into the ``camlp5``
preprocessor (which loads them all, unlike with standard PPX
rewriters, which are sometimes run in separate processes).  The
``Pa_ppx_base`` module accumulates the list of all loaded rewriters,
and just before applying them to an AST, it topologically sorts them
based on declared constraints.  Then each rewriter is called with a
"context" object (where it can stash information for later passes, or
as a form of inherited or synthesized attribute (loosely as in
attribute-grammars) and the AST; it returns a (possibly) rewritten
AST.  This AST is then passed along to the next rewriter, and so on
until a final AST is produced, which is then output to the Ocaml main
compiler process.

Each rewriter in turn is passed an AST.  The Camlp5 ML AST has a
number of "important" types (e.g. ``expr``, ``patt``, ``module_expr``,
``module_type``, ``ctyp``, etc).  A function much like what would be
generated by ``ppx_deriving.map`` is called on the AST, and it
recursively walks the entire AST.  But at each of these major types,
there is an "extensible function" that gets called before calling the
(as-if-)generated "map" function, and that extensible function can
rewrite the AST (or decline and do nothing).

So to implement a rewriter typically means to add some code to the
extension-points that correspond to the AST types that might need to
be rewritten.  For example, in the next section we present an example
where the sole extension point would be ``expr``.  In
``pa_ppx.deriving``, the types ``str_item`` (structure-item) and
``sig_item`` (signature-item) are rewritten.  Typically, a single
rewriter only rewrites AST nodes of a few types, and then only when
they match certain criteria.  So in both extensible functions, and
normal code that does rewriting, we'll make extensive use of
``camlp5`` "quotations" (text that looks like ML surface syntax, but
is expanded by ``camlp5`` into ML code for patterns or expressions,
depending on context).

Now we can describe the steps in writing a PPX rewriter:

1. write some code that, for the specific AST nodes of interest,
pattern-matches and generates rewritten nodes, assuming that the nodes
are suitable.  Perhaps access lookaside information in the "context",
or maybe stash information there for other code.

2. Extend the specific extensible-functions for the AST node types we
need to rewrite, using pattern-matching to select suitable nodes and
then calling our rewrite functions from step 1.

3. Then install these extensible functions into ``Pa_ppx_base`` with
indications of when they should be run (before/after which other PPX
rewriters).


An Example PPX Rewriter based on Pa_ppx
=======================================

NOTE WELL: This code is taken from ``pa_ppx/pa_here_original``, an
"original syntax" version of ``pa_ppx/pa_here`` . The function of
these two PPX rewriters is identical: ``pa_here_original`` is written
in original syntax to show that it's straightforward to do so (no
revised syntax required (except in quotations)).

In this section, we will describe the simplest rewriter
(``pa_ppx.here_original``).  This rewriter replaces the extension point
``[%here]`` with code that produces a ``Lexing.position`` of the
position in the file where the extension-point was found.  So a line (in a file "test_here.ml")::

  let here = [%here]

is rewritten to::

  let here =
    let open Lexing in
    {pos_fname = "test_here.ml"; pos_lnum = 4; pos_bol = 32;
     pos_cnum = 43}

We won't go into excruciating detail, because this depends on a number
of ``camlp5`` and ``pa_ppx`` facilities that are described in more
detail either in the ``camlp5`` documentation, or elsewhere in this
documentation.

1. Open necessary libraries (``Pa_ppx_base`` contains support
infrastructure for all PPX rewriters)::

  open Pa_ppx_base
  open Pa_passthru
  open Ppxutil

2. Implement a function that rewrites the simple extension-point,
using ``camlp5`` "quotations".  The function ``quote_position`` uses
quotations for expressions that themselves have anti-quotations ("holes") for
expressions we want to fill with bits from the ``Lexing.position``::

   let quote_position loc p =
     let open Lexing in
     <:expr< let open Lexing in {
     pos_fname = $str:p.pos_fname$ ;
     pos_lnum = $int:string_of_int p.pos_lnum$ ;
     pos_bol = $int:string_of_int p.pos_bol$ ;
     pos_cnum = $int:string_of_int p.pos_cnum$ } >>

Next we write a function that pattern-matches on an expression
(expected to be ``[%here]``) and rewrites it using ``quote_position``::

   let rewrite_expr arg = function
     <:expr:< [%here] >> ->
       let pos = start_position_of_loc loc in
       quote_position loc pos
   | _ -> assert false

And finally, we add this function to the "extensible function" for
expressions.  Notice the ``fallback`` argument below: if rewriting of
subtrees of this AST node were needed after this ``pa_here_original``
rewrite, we could call that to make it happen.  The type ``EF.t`` is a
dispatch table of "extension points", one for each important type in
the Camlp5 ML AST.  All these extension-points start off empty, and we
want to add our function to the extension-point for expressions
(notice the keyword "extfun").  Then we "install" this table in the
``Pa_passthru`` module, giving it a name.  We can specify that it
comes before or after other rewriters, or specify a pass number
(0..99), though this is almost never used.  Instead, by specifying
which rewriters to run before or after, we give ``Pa_passthru`` the
information to topologically sort all loaded rewriters before running
them::

   let install () = 
   let ef = EF.mk () in 
   let ef = EF.{ (ef) with
               expr = extfun ef.expr with [
       <:expr:< [%here] >> as z ->
       fun arg fallback ->
         Some (rewrite_expr arg z)
     ] } in
     Pa_passthru.(install { name = "pa_here"; ef =  ef ; pass = None ; before = [] ; after = [] })
   ;;

   install();;

An example of a rewriter that specifies a "before" constraint would be
``pa_ppx.import``, which should be run before ``pa_ppx.deriving``, so
that a type can be imported, and then have type-based code derived
from that imported type.

Troubleshooting PPX Rewriter Invocations
========================================

Everybody eventually uses a PPX rewriter that doesn't produce the
results they desire.  There are two ways of debugging that issue:

1. using ``not-ocamlfind preprocess``
2. using the toplevel

Debugging using ``not-ocamlfind preprocess``
--------------------------------------------

Suppose that the ``ocamlfind ocamlc`` invocation above didn't produce
the results we desired.  For instance, suppose that we forgot the
``-syntax camlp5o``::

  ocamlfind ocamlc -package pa_ppx.deriving_plugins.show -c simple_show.ml
  File "simple_show.ml", line 5, characters 18-22:
  5 |   print_string ([%show: a1] (5,6))
                      ^^^^
  Error: Uninterpreted extension 'show'.

We could start to debug the preprocessing process by using ``not-ocamlfind preprocess``::

  not-ocamlfind preprocess -package pa_ppx.deriving_plugins.show simple_show.ml
  ppx_execute: ocamlfind not-ocamlfind/papr_official.exe -binary-output -impl simple_show.ml /tmp/simple_show4d8e59
  format output file: ocamlfind not-ocamlfind/papr_official.exe -binary-input -impl /tmp/simple_show4d8e59
  type a1 = (int * int)[@@deriving show]
  let _ = print_string (([%show :a1]) (5, 6))

This tells us we didn't actually invoke camlp5 (or any PPX rewriters).
Instead, we use "papr_official.exe" to convert text to binary AST, and
then back to text.  A different kind of information is given by adding
``-verbose``::

  ocamlfind ocamlc -verbose -package pa_ppx.deriving_plugins.show -c simple_show.ml
  Effective set of compiler predicates: pkg_result,pkg_rresult,pkg_seq,pkg_stdlib-shims,pkg_fmt,pkg_sexplib0,pkg_pa_ppx.runtime,pkg_pa_ppx.deriving_plugins.show,autolink,byte

This also tells us that camlp5 isn't being invoked (no mention of
"preprocessor predicates"), and this would tell us that we needed to
add ``-syntax camlp5o`` (and maybe the ``camlp5`` package)::

  not-ocamlfind preprocess -package pa_ppx.deriving_plugins.show -syntax camlp5o simple_show.ml

will produce binary output, because we didn't specify what syntax we
wanted to print (official or revised); adding ``camlp5.pr_o`` will fix that::

  not-ocamlfind preprocess -package pa_ppx.deriving_plugins.show,camlp5.pr_o -syntax camlp5o simple_show.ml

Basically, any ``ocamlfind ocamlc`` command can be converted to
``not-ocamlfind preprocess`` by removing any flags/arguments that are
meant only for ocamlc (so: linking, warnings, ``-c``, etc) and adding
a camlp5 printing package (so: ``camlp5.pr_o`` or ``camlp5.pr_r``).

Debugging using the ocaml toplevel
----------------------------------

The other way to debug a ``Pa_ppx`` rewriter is via the Ocaml
toplevel.  Camlp5 and ``pa_ppx`` packages can be loaded into the
toplevel in the usual way.

1. Load supporting modules::

     #use "topfind.camlp5";;
     #require "camlp5.pa_o";;
     #require "camlp5.pr_o";;
     #directory "../tests-ounit2";;

     (* these are needed by this example, not by pa_ppx *)
     #require "compiler-libs.common" ;;
     #require "bos";;

     #load "../tests-ounit2/papr_util.cmo";;
     open Papr_util ;;

2. Load the PPX rewriter::

     #require "pa_ppx.deriving_plugins.show";;

3. And run it on a file::

     "simple_show.ml" |> Fpath.v |> Bos.OS.File.read
     |> Rresult.R.get_ok |> PAPR.Implem.pa1
     |> PAPR.Implem.pr |> print_string ;;
     type a1 = int * int[@@deriving_inline show]let rec (pp_a1 : a1 Fmt.t) =
       fun (ofmt : Format.formatter) arg ->
	 (fun (ofmt : Format.formatter) (v0, v1) ->
	    let open Pa_ppx_runtime.Runtime.Fmt in
	    pf ofmt "(@[%a,@ %a@])"
	      (fun ofmt arg ->
		 let open Pa_ppx_runtime.Runtime.Fmt in pf ofmt "%d" arg)
	      v0
	      (fun ofmt arg ->
		 let open Pa_ppx_runtime.Runtime.Fmt in pf ofmt "%d" arg)
	      v1)
	   ofmt arg[@@ocaml.warning "-39"] [@@ocaml.warning "-33"]
     and (show_a1 : a1 -> Stdlib.String.t) =
       fun arg -> Format.asprintf "%a" pp_a1 arg[@@ocaml.warning "-39"] [@@ocaml.warning "-33"][@@@end]let _ = print_string ((fun arg -> Format.asprintf "%a" pp_a1 arg) (5, 6))- : unit = ()
     # 
     
.. container:: trailer
