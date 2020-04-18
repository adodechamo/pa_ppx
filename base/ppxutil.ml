(* camlp5r *)
(* pa_passthru.ml,v *)
(* Copyright (c) INRIA 2007-2017 *)

#load "pa_extend.cmo";
#load "q_MLast.cmo";

open Asttools;
open MLast;

value starts_with ~{pat} s =
  let patlen = String.length pat in
  (String.length s >= patlen) && pat = String.sub s 0 patlen
;

value duplicated (l : list string) =
  let l = List.sort Stdlib.compare l in
  let rec duprec = fun [
    [] -> False
  | [ h1 ; h2 :: acc ] when h1=h2 -> True
  | [ _ :: acc ] -> duprec acc
  ] in
  duprec l
;

value filter p =
  let rec filter_aux = fun [
      [] -> []
    | [x::l] -> if p x then [x::filter_aux l] else filter_aux l ]
  in filter_aux
;

value intersect l1 l2 = filter (fun x -> List.mem x l2) l1 ;

value count p l = List.length (filter p l) ;

value push r v = r.val := [v :: r.val] ;

value attr_id attr = Pcaml.unvala (fst (Pcaml.unvala attr)) ;

module Expr = struct

value prepend_longident li e =
  let rec prerec li e = match li with [
    <:longident:< $uid:uid$ >> -> <:expr< $uid:uid$ . $e$ >>
  | <:longident:< $longid:li$ . $uid:uid$ >> -> prerec li <:expr< $uid:uid$ . $e$ >>
  | _ -> assert False
  ] in
  prerec li e
;

value abstract_over l e =
  List.fold_right (fun p e -> let loc = loc_of_patt p in <:expr< fun $p$ -> $e$ >>) l e
;

value applist e el =
  List.fold_left (fun e arg -> let loc = loc_of_expr arg in <:expr< $e$ $arg$ >>) e el
;
end ;

module Patt = struct

value applist e el =
  List.fold_left (fun e arg -> let loc = loc_of_patt arg in <:patt< $e$ $arg$ >>) e el
;
end ;

module Ctyp = struct

value arrows_list loc l ty =
  List.fold_right (fun argty ty -> <:ctyp< $argty$ -> $ty$ >>)
    l ty
;

value wrap_attrs ty al =
  let loc = loc_of_ctyp ty in
  List.fold_left (fun ty attr -> <:ctyp< $ty$  [@ $_attribute:attr$ ] >>)
    ty al
;


value unwrap_attrs e =
  let rec unrec acc = fun [
    <:ctyp< $t$  [@ $_attribute:attr$ ] >> -> unrec [attr::acc] t
  | t -> (t,acc)
  ] in unrec [] e
;

value applist e el =
  List.fold_left (fun e arg -> let loc = loc_of_ctyp arg in <:ctyp< $e$ $arg$ >>) e el
;

value unapplist e =
  let rec unrec acc = fun [
    <:ctyp< $t$ $arg$ >> -> unrec [arg::acc] t
  | t -> (t,acc)
  ] in unrec [] e
;
end ;

value longid_to_string_list li =
  let rec lirec = fun [
    <:longident< $uid:uid$ >> -> [uid]
  | <:longident< $longid:li$ . $uid:uid$ >> -> (lirec li) @ [uid]
  | <:extended_longident< $longid:_$ ( $longid:_$ ) >> ->
    failwith "longid_to_string_list: LiApp not allowed here"
  | <:longident< $_uid:_$ >> | <:longident< $longid:_$ . $_uid:_$ >> ->
    failwith "[internal error] longid_to_string_list: called with longid containing placeholders"
  ] in
  lirec li
;

value rec is_poly_variant t =
  let (t,_) = Ctyp.unwrap_attrs t in
  match t with [
    <:ctyp< [ = $list:_$ ] >> -> True
  | <:ctyp< [ > $list:_$ ] >> -> True
  | <:ctyp< [ < $list:_$ ] >> -> True
  | _ -> False ] 
;

value rec is_generative_type t =
  let (t,_) = Ctyp.unwrap_attrs t in
  match t with [
    <:ctyp< [ $list:_$ ] >> -> True
  | <:ctyp< { $list:_$ } >> -> True
  | _ -> False ] 
;
