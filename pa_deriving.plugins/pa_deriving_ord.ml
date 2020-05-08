(* camlp5r *)
(* pa_deriving_ord.ml,v *)
(* Copyright (c) INRIA 2007-2017 *)

#load "pa_extend.cmo";
#load "q_MLast.cmo";
#load "pa_macro.cmo";
#load "pa_macro_gram.cmo";
#load "pa_extfun.cmo";

open Asttools;
open MLast;
open Pa_ppx_base ;
open Pa_passthru ;
open Ppxutil ;
open Surveil ;
open Pa_deriving_base ;

value ord_fname arg tyname =
  if tyname = "t" then "compare"
  else "compare_"^tyname
;

type attrmod_t = [ Nobuiltin ] ;

value fmt_expression arg param_map ty0 =
  let rec fmtrec ?{attrmod=None} = fun [
    <:ctyp:< $lid:lid$ >> when attrmod = Some Nobuiltin ->
  let fname = ord_fname arg lid in
  <:expr< $lid:fname$ >>

  | <:ctyp:< _ >> -> <:expr< fun _ _ -> 0 >>
  | <:ctyp:< unit >> -> <:expr< fun _ _ -> 0 >>
  | <:ctyp:< int >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< int32 >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< int64 >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< nativeint >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< float >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< bool >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< char >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< string >> -> <:expr< fun a b -> Stdlib.compare a b >>
  | <:ctyp:< bytes >> -> <:expr< fun a b -> Stdlib.compare a b >>

| <:ctyp:< $t$ [@ $attrid:(_, id)$ ] >> when id = DC.allowed_attribute (DC.get arg) "ord" "nobuiltin" ->
    fmtrec ~{attrmod=Some Nobuiltin} t

  | <:ctyp:< $t$ [@ $attrid:(_, id)$ $exp:e$ ;] >> when id = DC.allowed_attribute (DC.get arg) "ord" "compare" -> e

  | <:ctyp:< $t$ [@ $attribute:_$ ] >> -> fmtrec t

  | <:ctyp:< list $ty$ >> ->
  let fmt1 = fmtrec ty in
  <:expr< let rec loop x y =
        match (x, y) with [
          ([], []) -> 0
        | ([], _) -> (-1)
        | (_, []) -> 1
        | ([a::x], [b::y]) -> (match $fmt1$ a b with [ 0 -> loop x y | x -> x ]) ] in
      fun x -> fun y -> loop x y >>

  | <:ctyp:< array $ty$ >> ->
  let fmt1 = fmtrec ty in
  <:expr< fun x ->
        fun y ->
          let rec loop i =
            if i = (Array.length x)
            then 0
            else
              (match $fmt1$ (x.(i)) (y.(i)) with [
                 0 -> loop (i + 1)
               | x -> x ]) in
          match Stdlib.compare (Array.length x) (Array.length y) with [
            0 -> loop 0
          | x -> x ] >>

  | (<:ctyp:< ref $ty$ >> | <:ctyp:< Pervasives.ref $ty$ >>) ->
    let fmt1 = fmtrec ty in
    <:expr< fun a b -> $fmt1$ a.val b.val >>

  | <:ctyp:< lazy_t $ty$ >> ->
    let fmt1 = fmtrec ty in
    <:expr< fun [ lazy x -> fun [ lazy y  -> $fmt1$ x y ] ] >>

  | <:ctyp:< option $ty$ >> ->
    let fmt1 = fmtrec ty in
    <:expr< fun x ->
        fun y ->
          match (x, y) with [
            (None, None) -> 0
          | (Some a, Some b) -> $fmt1$ a b
          | (None, Some _) -> (-1)
          | (Some _, None) -> 1 ] >>

| (<:ctyp:< result $ty1$ $ty2$ >> | <:ctyp:< Result.result $ty1$ $ty2$ >>) ->
  <:expr< fun x y -> match (x, y) with [
              (Result.Error a, Result.Error b) ->
                $(fmtrec ty2)$ a b
            | (Result.Ok a, Result.Ok b) ->
                $(fmtrec ty1)$ a b
            | (Result.Ok _, Result.Error _) -> (-1)
            | (Result.Error _, Result.Ok _) -> 1 ] >>

| <:ctyp:< $t1$ $t2$ >> -> <:expr< $fmtrec t1$ $fmtrec t2$ >>

| <:ctyp:< '$i$ >> ->
  let fmtf = match List.assoc i param_map with [
    x -> x | exception Not_found -> failwith "pa_deriving.ord: unrecognized param-var in type-decl"
  ] in
  <:expr< $lid:fmtf$ >>

| <:ctyp:< $lid:lid$ >> ->
  let fname = ord_fname arg lid in
  <:expr< $lid:fname$ >>
| <:ctyp:< $longid:li$ . $lid:lid$ >> ->
  let fname = ord_fname arg lid in
  Expr.prepend_longident li <:expr< $lid:fname$ >>

| <:ctyp:< ( $list:tyl$ ) >> ->
    let var_patt_expr_fmts = List.mapi (fun i ty ->
        let mk1 s = (s, <:patt< $lid:s$ >>, <:expr< $lid:s$ >>) in
        (mk1 (Printf.sprintf "a_%d" i), mk1 (Printf.sprintf "b_%d" i), fmtrec ty)) tyl in

    let var1pats = List.map (fun ((_,p,_), _, _) -> p) var_patt_expr_fmts in
    let var2pats = List.map (fun (_, (_,p,_), _) -> p) var_patt_expr_fmts in

    let body = List.fold_right (fun ((_,_,e1),(_, _, e2), fmtf) body ->
      <:expr< match $fmtf$ $e1$ $e2$ with [
                0 -> $body$ | x -> x
              ] >>) var_patt_expr_fmts <:expr< 0 >> in

    <:expr< fun ( $list:var1pats$ ) ( $list:var2pats$ ) -> $body$ >>

| <:ctyp:< [ $list:l$ ] >> ->
  let branches = List.map (fun [
    (loc, cid, <:vala< [TyRec _ fields] >>, None, _) ->
    let cid = uv cid in
    let (rec1pat, rec2pat, body) = fmt_record loc arg (uv fields) in

    let conspat = <:patt< ($uid:cid$ $rec1pat$, $uid:cid$ $rec2pat$) >> in
    (conspat, <:vala< None >>, body)

  | (loc, cid, tyl, None, attrs) ->
    let cid = uv cid in
    let tyl = uv tyl in
    let var_patt_expr_fmts = List.mapi (fun i ty ->
        let mk1 s = (s, <:patt< $lid:s$ >>, <:expr< $lid:s$ >>) in
        (mk1 (Printf.sprintf "a_%d" i), mk1 (Printf.sprintf "b_%d" i), fmtrec ty)) tyl in

    let var1pats = List.map (fun ((_,p,_), _, _) -> p) var_patt_expr_fmts in
    let var2pats = List.map (fun (_, (_,p,_), _) -> p) var_patt_expr_fmts in

    let cons1pat = List.fold_left (fun p vp -> <:patt< $p$ $vp$ >>)
        <:patt< $uid:cid$ >> var1pats in
    let cons2pat = List.fold_left (fun p vp -> <:patt< $p$ $vp$ >>)
        <:patt< $uid:cid$ >> var2pats in
    let conspat = <:patt< ($cons1pat$, $cons2pat$) >> in
    
    let body = List.fold_right (fun ((_,_,e1),(_, _, e2), fmtf) body ->
      <:expr< match $fmtf$ $e1$ $e2$ with [
                0 -> $body$ | x -> x
              ] >>) var_patt_expr_fmts <:expr< 0 >> in

    (conspat, <:vala< None >>, body)

  | (_, _, _, Some _, _) -> assert False
  ]) l in
  let tag2int_exp =
    let branches = List.mapi (fun i (_, cid, tyl, _, _) ->
        let cid = uv cid in
        let tyl = uv tyl in
        let underscores = List.map (fun _ -> <:patt< _ >>) tyl in
        (Patt.applist <:patt< $uid:cid$ >> underscores, <:vala< None >>,
         <:expr< $int:(string_of_int i)$ >>)) l in
    <:expr< fun [ $list:branches$ ] >> in
  let branches =
    if List.length l = 1 then branches
    else
      branches @ [ (<:patt< _ >>, <:vala< None >>,
                    <:expr< let tag2int = $tag2int_exp$ in Stdlib.compare (tag2int a) (tag2int b) >>) ] in
  <:expr< fun a b -> 
          (match (a,b) with [ $list:branches$ ] [@ocaml.warning "-A";]) >>


| <:ctyp:< [= $list:l$ ] >> ->
  let branches = List.map (fun [
    PvTag loc cid _ tyl _ ->
    let cid = uv cid in
    let tyl = uv tyl in
    let var_patt_expr_fmts = List.mapi (fun i ty ->
        let mk1 s = (s, <:patt< $lid:s$ >>, <:expr< $lid:s$ >>) in
        (mk1 (Printf.sprintf "a_%d" i), mk1 (Printf.sprintf "b_%d" i), fmtrec ty)) tyl in

    let var1pats = List.map (fun ((_,p,_), _, _) -> p) var_patt_expr_fmts in
    let var2pats = List.map (fun (_, (_,p,_), _) -> p) var_patt_expr_fmts in

    let cons1pat = List.fold_left (fun p vp -> <:patt< $p$ $vp$ >>)
        <:patt< ` $cid$ >> var1pats in
    let cons2pat = List.fold_left (fun p vp -> <:patt< $p$ $vp$ >>)
        <:patt< ` $cid$ >> var2pats in
    let conspat = <:patt< ($cons1pat$, $cons2pat$) >> in
    
    let body = List.fold_right (fun ((_,_,e1),(_, _, e2), fmtf) body ->
      <:expr< match $fmtf$ $e1$ $e2$ with [
                0 -> $body$ | x -> x
              ] >>) var_patt_expr_fmts <:expr< 0 >> in

    (conspat, <:vala< None >>, body)

  | PvInh _ ty ->
    let lili = match ty with [
      <:ctyp< $_lid:lid$ >> -> (None, lid)
    | <:ctyp< $longid:li$ . $_lid:lid$ >> -> (Some li, lid)
    ] in
    let conspat = <:patt< (( # $lilongid:lili$ as a ), ( # $lilongid:lili$ as b )) >> in
    let fmtf = fmtrec ty in
    (conspat, <:vala< None >>, <:expr< $fmtf$ a b >>)
  ]) l in
  let tag2int_exp =
    let branches = List.mapi (fun i -> fun [
        PvTag loc cid _ tyl _ ->
        let cid = uv cid in
        let tyl = uv tyl in
        let underscores = List.map (fun _ -> <:patt< _ >>) tyl in
        (Patt.applist <:patt< ` $cid$ >> underscores, <:vala< None >>,
         <:expr< $int:(string_of_int i)$ >>)
      | PvInh _ ty ->
        let lili = match ty with [
          <:ctyp< $_lid:lid$ >> -> (None, lid)
        | <:ctyp< $longid:li$ . $_lid:lid$ >> -> (Some li, lid)
        ] in
        (<:patt< ( # $lilongid:lili$ ) >>, <:vala< None >>,
         <:expr< $int:(string_of_int i)$ >>)
                                        ]) l in
    <:expr< fun [ $list:branches$ ] >> in

  let branches =
    if List.length l = 1 then branches
    else
      branches @ [ (<:patt< _ >>, <:vala< None >>,
                    <:expr< let tag2int = $tag2int_exp$ in Stdlib.compare (tag2int a) (tag2int b) >>) ] in
  <:expr< fun a b ->
          (match (a,b) with [ $list:branches$ ] [@ocaml.warning "-A";]) >>

  | <:ctyp:< { $list:fields$ } >> ->
  let (rec1pat, rec2pat, body) = fmt_record loc arg fields in
  <:expr< fun $rec1pat$ -> fun $rec2pat$ -> $body$ >>

| [%unmatched_vala] -> failwith "pa_deriving_ord.fmt_expression"
  ]
  and fmt_record loc arg fields = 
  let label_var_patt_expr_fmts = List.map (fun (_, fname, _, ty, attrs) ->
        let ty = ctyp_wrap_attrs ty (uv attrs) in
        let mk1 s = (s, <:patt< $lid:s$ >>, <:expr< $lid:s$ >>) in
        (fname, mk1 (Printf.sprintf "a_%s" fname), mk1 (Printf.sprintf "b_%s" fname), fmtrec ty)) fields in

  let v1_pl = List.map (fun (f, (v,_,_), _,  _) -> (<:patt< $lid:f$ >>, <:patt< $lid:v$ >>)) label_var_patt_expr_fmts in
  let v1pat = <:patt< { $list:v1_pl$ } >> in
  let v2_pl = List.map (fun (f, _, (v,_,_),  _) -> (<:patt< $lid:f$ >>, <:patt< $lid:v$ >>)) label_var_patt_expr_fmts in
  let v2pat = <:patt< { $list:v2_pl$ } >> in

  let body = List.fold_right (fun (_,(_,_,e1),(_, _, e2), fmtf) body ->
      <:expr< match $fmtf$ $e1$ $e2$ with [
                0 -> $body$ | x -> x
              ] >>) label_var_patt_expr_fmts <:expr< 0 >> in


  (v1pat, v2pat, body)
 in
  fmtrec ty0
;

value fmt_top arg params = fun [
  <:ctyp< $t1$ == $_priv:_$ $t2$ >> ->
  fmt_expression arg params t2
| t -> fmt_expression arg params t
]
;

value str_item_top_funs arg td =
  let (loc, tyname) = uv td.tdNam in
  let param_map = PM.make "ord" loc (uv td.tdPrm) in
  let ty = td.tdDef in
  let tyname = uv tyname in
  let ordfname = ord_fname arg tyname in
  let e = fmt_top arg param_map ty in

  let paramfun_patts = List.map (fun (_,ordf) -> <:patt< $lid:ordf$ >>) param_map in
  [(ordfname, Expr.abstract_over paramfun_patts
      <:expr< fun a b -> $e$ a b >>)]
;

value sig_item_top_funs arg td =
  let (loc, tyname) = uv td.tdNam in
  let param_map = PM.make "ord" loc (uv td.tdPrm) in
  let tyname = uv tyname in
  let ordfname = ord_fname arg tyname in
  let paramtys = List.map (fun (tyna, _) -> <:ctyp< '$tyna$ >>) param_map in
  let argfmttys = List.map (fun pty -> <:ctyp< $pty$ -> $pty$ -> Stdlib.Int.t >>) paramtys in  
  let ty = <:ctyp< $lid:tyname$ >> in
  let thety = Ctyp.applist ty paramtys in
  let ordftype = Ctyp.arrows_list loc argfmttys <:ctyp< $thety$ -> $thety$ -> Stdlib.Int.t >> in
  [(ordfname, ordftype)]
;

value str_item_funs arg td =
  let loc = fst (uv td.tdNam) in
  let param_map = PM.make "ord" loc (uv td.tdPrm) in
  let funs = str_item_top_funs arg td in
  let types = sig_item_top_funs arg td in
  wrap_type_constraints loc param_map funs types
;

value sig_items arg td =
  let loc = fst (uv td.tdNam) in
  let l = sig_item_top_funs arg td in
  List.map (fun (fname, ty) ->
      <:sig_item< value $lid:fname$ : $ty$>>) l
;

value is_deriving_ord attr = match uv attr with [
  <:attribute_body< deriving $structure:sil$ >> ->
    List.exists (fun [
      <:str_item< ord >> -> True
    | _ -> False ]) sil
| _ -> False
]
;

value str_item_gen_ord0 arg td =
  str_item_funs arg td
;

value loc_of_type_decl td = fst (uv td.tdNam) ;

value str_item_gen_ord name arg = fun [
  <:str_item:< type $_flag:_$ $list:tdl$ >> ->
    let loc = loc_of_type_decl (List.hd tdl) in
    let l = List.concat (List.map (str_item_gen_ord0 arg) tdl) in
    <:str_item< value rec $list:l$ >>
| _ -> assert False ]
;

value sig_item_gen_ord name arg = fun [
  <:sig_item:< type $_flag:_$ $list:tdl$ >> as z ->
    let loc = loc_of_type_decl (List.hd tdl) in
    let l = List.concat (List.map (sig_items arg) tdl) in
    <:sig_item< declare $list:l$ end >>
| _ -> assert False ]
;

value expr_ord arg = fun [
  <:expr:< [% $attrid:(_, id)$: $type:ty$ ] >> when id = "ord" || id = "derive.ord" ->
    let loc = loc_of_ctyp ty in
    let e = fmt_top arg [] ty in
    <:expr< fun a b ->  $e$ a b >>
| _ -> assert False ]
;

Pa_deriving.(Registry.add PI.{
  name = "ord"
; alternates = []
; options = ["optional"]
; default_options = let loc = Ploc.dummy in [ ("optional", <:expr< False >>) ]
; alg_attributes = ["compare";"nobuiltin"]
; expr_extensions = ["ord"]
; expr = expr_ord
; str_item = str_item_gen_ord
; sig_item = sig_item_gen_ord
})
;

