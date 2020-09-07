
module SRC = All_ast.Ast_4_08
module DST = All_ast.Ast_4_07

let src_loc_none =
  let open SRC.Lexing in
  let open SRC.Location in
  let loc = {
    pos_fname = "";
    pos_lnum = 1;
    pos_bol = 0;
    pos_cnum = -1;
  } in
  { loc_start = loc; loc_end = loc; loc_ghost = true }

let dst_loc_none =
  let open DST.Lexing in
  let open DST.Location in
  let loc = {
    pos_fname = "";
    pos_lnum = 1;
    pos_bol = 0;
    pos_cnum = -1;
  } in
  { loc_start = loc; loc_end = loc; loc_ghost = true }

let wrap_loc inh v =
  let loc = match inh with
      None -> src_loc_none
    | Some loc -> loc in
  let open SRC.Location in
  { txt = v ; loc = loc }

let map_loc f v =
  let open SRC.Location in
  { txt = f v.txt ; loc = v.loc }

let unwrap_loc v = v.SRC.Location.txt

exception Migration_error of string * SRC.Location.t option

let migration_error location feature =
  raise (Migration_error (feature, location))

let _rewrite_list subrw0 __dt__ __inh__ l =
  List.map (subrw0 __dt__ __inh__) l

type lexing_position = [%import: All_ast.Ast_4_08.Lexing.position]
and location_t = [%import: All_ast.Ast_4_08.Location.t
    [@with Lexing.position := lexing_position]
]
and 'a location_loc = [%import: 'a All_ast.Ast_4_08.Location.loc
    [@with t := location_t]
]
and longident_t = [%import: All_ast.Ast_4_08.Longident.t
    [@with t := longident_t]
]

and label = [%import: All_ast.Ast_4_08.Asttypes.label]
and arg_label = [%import: All_ast.Ast_4_08.Asttypes.arg_label]

and closed_flag =  [%import: All_ast.Ast_4_08.Asttypes.closed_flag]
and rec_flag =  [%import: All_ast.Ast_4_08.Asttypes.rec_flag]
and direction_flag =  [%import: All_ast.Ast_4_08.Asttypes.direction_flag]
and private_flag =  [%import: All_ast.Ast_4_08.Asttypes.private_flag]
and mutable_flag =  [%import: All_ast.Ast_4_08.Asttypes.mutable_flag]
and virtual_flag =  [%import: All_ast.Ast_4_08.Asttypes.virtual_flag]
and override_flag =  [%import: All_ast.Ast_4_08.Asttypes.override_flag]
and variance =  [%import: All_ast.Ast_4_08.Asttypes.variance]
and constant =  [%import: All_ast.Ast_4_08.Parsetree.constant]
and location_stack = [%import: All_ast.Ast_4_08.Parsetree.location_stack
    [@with Location.t := location_t]
]
and attribute = [%import: All_ast.Ast_4_08.Parsetree.attribute
    [@with Asttypes.loc := location_loc
         ; Location.t := location_t
    ]
]
and extension = [%import: All_ast.Ast_4_08.Parsetree.extension
    [@with Asttypes.loc := location_loc]
]
and attributes = [%import: All_ast.Ast_4_08.Parsetree.attributes]
and payload = [%import: All_ast.Ast_4_08.Parsetree.payload]
and core_type = [%import: All_ast.Ast_4_08.Parsetree.core_type
    [@with Location.t := location_t]
]
and core_type_desc = [%import: All_ast.Ast_4_08.Parsetree.core_type_desc
    [@with Longident.t := longident_t
         ; Asttypes.loc := location_loc
         ; Asttypes.closed_flag := closed_flag
         ; Asttypes.arg_label := arg_label
         ; Asttypes.label := label
    ]
]
and package_type = [%import: All_ast.Ast_4_08.Parsetree.package_type
    [@with Longident.t := longident_t
          ; Asttypes.loc := location_loc
    ]
]
and row_field = [%import: All_ast.Ast_4_08.Parsetree.row_field
    [@with
      Asttypes.label := label
    ; Asttypes.loc := location_loc
    ; Location.t := location_t
    ]
]
and row_field_desc = [%import: All_ast.Ast_4_08.Parsetree.row_field_desc
    [@with
      Asttypes.label := label
    ; Asttypes.loc := location_loc
    ]
]
and object_field = [%import: All_ast.Ast_4_08.Parsetree.object_field
    [@with
      Asttypes.label := label
    ; Asttypes.loc := location_loc
    ; Location.t := location_t
    ]
]
and object_field_desc = [%import: All_ast.Ast_4_08.Parsetree.object_field_desc
    [@with
      Asttypes.label := label
    ; Asttypes.loc := location_loc
    ]
]
and pattern = [%import: All_ast.Ast_4_08.Parsetree.pattern
    [@with Location.t := location_t]
]
and pattern_desc = [%import: All_ast.Ast_4_08.Parsetree.pattern_desc
    [@with Longident.t := longident_t ;
      Asttypes.loc := location_loc ;
      Asttypes.label := label ;
      Asttypes.closed_flag := closed_flag
    ]
]
and expression = [%import: All_ast.Ast_4_08.Parsetree.expression
    [@with Location.t := location_t]
]
and expression_desc = [%import: All_ast.Ast_4_08.Parsetree.expression_desc
    [@with Longident.t := longident_t ;
      Asttypes.loc := location_loc ;
      Asttypes.label := label ;
      Asttypes.arg_label := arg_label ;
      Asttypes.rec_flag := rec_flag ;
      Asttypes.override_flag := override_flag ;
      Asttypes.direction_flag := direction_flag ;
    ]
]
and case = [%import: All_ast.Ast_4_08.Parsetree.case]
and letop = [%import: All_ast.Ast_4_08.Parsetree.letop]
and binding_op = [%import: All_ast.Ast_4_08.Parsetree.binding_op
    [@with Location.t := location_t ;
           Asttypes.loc := location_loc
    ]
]
and value_description = [%import: All_ast.Ast_4_08.Parsetree.value_description
    [@with Location.t := location_t ;
           Asttypes.loc := location_loc
    ]
]
and type_declaration = [%import: All_ast.Ast_4_08.Parsetree.type_declaration
    [@with Location.t := location_t
          ; Asttypes.loc := location_loc
          ; Asttypes.variance := variance
          ; Asttypes.private_flag := private_flag
    ]
]
and type_kind = [%import: All_ast.Ast_4_08.Parsetree.type_kind]
and label_declaration = [%import: All_ast.Ast_4_08.Parsetree.label_declaration
    [@with Location.t := location_t
         ; Asttypes.loc := location_loc
         ; Asttypes.mutable_flag := mutable_flag
    ]
]
and constructor_declaration = [%import: All_ast.Ast_4_08.Parsetree.constructor_declaration
    [@with Location.t := location_t ;
           Asttypes.loc := location_loc
    ]
]
and constructor_arguments = [%import: All_ast.Ast_4_08.Parsetree.constructor_arguments]
and type_extension = [%import: All_ast.Ast_4_08.Parsetree.type_extension
    [@with Longident.t := longident_t
         ; Asttypes.loc := location_loc
         ; Asttypes.variance := variance
         ; Asttypes.private_flag := private_flag
         ; Location.t := location_t
    ]
]
and extension_constructor = [%import: All_ast.Ast_4_08.Parsetree.extension_constructor
    [@with Location.t := location_t ;
           Asttypes.loc := location_loc
    ]
]
and type_exception = [%import: All_ast.Ast_4_08.Parsetree.type_exception
    [@with Location.t := location_t ;]
]
and extension_constructor_kind = [%import: All_ast.Ast_4_08.Parsetree.extension_constructor_kind
    [@with Longident.t := longident_t ;
           Asttypes.loc := location_loc
    ]
]
and class_type = [%import: All_ast.Ast_4_08.Parsetree.class_type
    [@with Location.t := location_t]
]
and class_type_desc = [%import: All_ast.Ast_4_08.Parsetree.class_type_desc
    [@with Longident.t := longident_t
         ; Asttypes.loc := location_loc
         ; Asttypes.label := label
         ; Asttypes.arg_label := arg_label
         ; Asttypes.override_flag := override_flag
    ]
]
and class_signature = [%import: All_ast.Ast_4_08.Parsetree.class_signature]
and class_type_field = [%import: All_ast.Ast_4_08.Parsetree.class_type_field
    [@with Location.t := location_t]
]
and class_type_field_desc = [%import: All_ast.Ast_4_08.Parsetree.class_type_field_desc
    [@with
      Asttypes.private_flag := private_flag
    ; Asttypes.mutable_flag := mutable_flag
    ; Asttypes.virtual_flag := virtual_flag
    ; Asttypes.label := label
    ; Asttypes.loc := location_loc
    ]
]
and 'a class_infos = [%import: 'a All_ast.Ast_4_08.Parsetree.class_infos
    [@with Location.t := location_t
         ; Asttypes.loc := location_loc
         ; Asttypes.variance := variance
         ; Asttypes.virtual_flag := virtual_flag
    ]
]
and class_description = [%import: All_ast.Ast_4_08.Parsetree.class_description]
and class_type_declaration = [%import: All_ast.Ast_4_08.Parsetree.class_type_declaration]
and class_expr = [%import: All_ast.Ast_4_08.Parsetree.class_expr
    [@with Location.t := location_t]
]
and class_expr_desc = [%import: All_ast.Ast_4_08.Parsetree.class_expr_desc
    [@with Longident.t := longident_t
         ; Asttypes.loc := location_loc
         ; Asttypes.rec_flag := rec_flag
         ; Asttypes.label := label
         ; Asttypes.arg_label := arg_label
         ; Asttypes.override_flag := override_flag
    ]
]
and class_structure = [%import: All_ast.Ast_4_08.Parsetree.class_structure]
and class_field = [%import: All_ast.Ast_4_08.Parsetree.class_field
    [@with Location.t := location_t]
]
and class_field_desc = [%import: All_ast.Ast_4_08.Parsetree.class_field_desc
    [@with Asttypes.loc := location_loc
         ; Asttypes.override_flag := override_flag
         ; Asttypes.mutable_flag := mutable_flag
         ; Asttypes.private_flag := private_flag
         ; Asttypes.label := label
    ]
]
and class_field_kind = [%import: All_ast.Ast_4_08.Parsetree.class_field_kind
    [@with Asttypes.override_flag := override_flag
    ]
]
and class_declaration = [%import: All_ast.Ast_4_08.Parsetree.class_declaration]
and module_type = [%import: All_ast.Ast_4_08.Parsetree.module_type
    [@with Location.t := location_t]
]
and module_type_desc = [%import: All_ast.Ast_4_08.Parsetree.module_type_desc
    [@with Longident.t := longident_t ;
           Asttypes.loc := location_loc
    ]
]
and signature = [%import: All_ast.Ast_4_08.Parsetree.signature]
and signature_item = [%import: All_ast.Ast_4_08.Parsetree.signature_item
    [@with Location.t := location_t]
]
and signature_item_desc = [%import: All_ast.Ast_4_08.Parsetree.signature_item_desc
    [@with Asttypes.rec_flag := rec_flag]
]
and module_declaration = [%import: All_ast.Ast_4_08.Parsetree.module_declaration
    [@with Location.t := location_t ;
           Asttypes.loc := location_loc
    ]
]
and module_substitution = [%import: All_ast.Ast_4_08.Parsetree.module_substitution
    [@with Longident.t := longident_t
         ; Location.t := location_t
         ; Asttypes.loc := location_loc
    ]
]
and module_type_declaration = [%import: All_ast.Ast_4_08.Parsetree.module_type_declaration
    [@with Location.t := location_t
         ; Asttypes.loc := location_loc
    ]
]
and 'a open_infos = [%import: 'a All_ast.Ast_4_08.Parsetree.open_infos
    [@with Location.t := location_t
         ; Asttypes.loc := location_loc
         ; Asttypes.override_flag := override_flag
    ]
]
and open_description = [%import: All_ast.Ast_4_08.Parsetree.open_description
    [@with Longident.t := longident_t
          ; Asttypes.loc := location_loc
    ]
]
and open_declaration = [%import: All_ast.Ast_4_08.Parsetree.open_declaration]
and 'a include_infos = [%import: 'a All_ast.Ast_4_08.Parsetree.include_infos
    [@with Location.t := location_t]
]
and include_description = [%import: All_ast.Ast_4_08.Parsetree.include_description]
and include_declaration = [%import: All_ast.Ast_4_08.Parsetree.include_declaration]
and with_constraint = [%import: All_ast.Ast_4_08.Parsetree.with_constraint
    [@with Longident.t := longident_t
         ; Asttypes.loc := location_loc
    ]
]
and module_expr = [%import: All_ast.Ast_4_08.Parsetree.module_expr
    [@with Location.t := location_t]
]
and module_expr_desc = [%import: All_ast.Ast_4_08.Parsetree.module_expr_desc
    [@with Longident.t := longident_t ;
           Asttypes.loc := location_loc
    ]
]
and structure = [%import: All_ast.Ast_4_08.Parsetree.structure]
and structure_item = [%import: All_ast.Ast_4_08.Parsetree.structure_item
    [@with Location.t := location_t]
]
and structure_item_desc = [%import: All_ast.Ast_4_08.Parsetree.structure_item_desc
    [@with Location.t := location_t
          ; Longident.t := longident_t
          ; Asttypes.loc := location_loc
          ; Asttypes.rec_flag := rec_flag
    ]
]
and value_binding = [%import: All_ast.Ast_4_08.Parsetree.value_binding
    [@with Location.t := location_t
         ; Asttypes.loc := location_loc
    ]
]
and module_binding = [%import: All_ast.Ast_4_08.Parsetree.module_binding
    [@with Location.t := location_t
         ; Asttypes.loc := location_loc
    ]
]
and out_name = [%import: All_ast.Ast_4_08.Outcometree.out_name]
and out_ident = [%import: All_ast.Ast_4_08.Outcometree.out_ident]
and out_string = [%import: All_ast.Ast_4_08.Outcometree.out_string]
and out_attribute = [%import: All_ast.Ast_4_08.Outcometree.out_attribute]
and out_value = [%import: All_ast.Ast_4_08.Outcometree.out_value]
and out_type = [%import: All_ast.Ast_4_08.Outcometree.out_type]
and out_variant = [%import: All_ast.Ast_4_08.Outcometree.out_variant]
and out_class_type = [%import: All_ast.Ast_4_08.Outcometree.out_class_type]
and out_class_sig_item = [%import: All_ast.Ast_4_08.Outcometree.out_class_sig_item]
and out_module_type = [%import: All_ast.Ast_4_08.Outcometree.out_module_type]
and out_sig_item = [%import: All_ast.Ast_4_08.Outcometree.out_sig_item]
and out_type_decl = [%import: All_ast.Ast_4_08.Outcometree.out_type_decl
    [@with Asttypes.private_flag := private_flag]
]
and out_extension_constructor = [%import: All_ast.Ast_4_08.Outcometree.out_extension_constructor
    [@with Asttypes.private_flag := private_flag]
]
and out_type_extension = [%import: All_ast.Ast_4_08.Outcometree.out_type_extension
    [@with Asttypes.private_flag := private_flag]
]
and out_val_decl = [%import: All_ast.Ast_4_08.Outcometree.out_val_decl]
and out_rec_status = [%import: All_ast.Ast_4_08.Outcometree.out_rec_status]
and out_ext_status = [%import: All_ast.Ast_4_08.Outcometree.out_ext_status]
and out_phrase = [%import: All_ast.Ast_4_08.Outcometree.out_phrase]


[@@deriving rewrite
    { inherit_type = [%typ: location_t option]
    ; dispatch_type = dispatch_table_t
    ; dispatch_table_value = dt
    ; dispatchers = {
        rewrite_option = {
          srctype = [%typ: 'a option]
        ; dsttype = [%typ: 'b option]
        ; subs = [ ([%typ: 'a], [%typ: 'b]) ]
        ; code = (fun subrw __dt__ __inh__ x -> Option.map (subrw __dt__ __inh__) x)
        }
      ; rewrite_Lexing_position = {
          srctype = [%typ: lexing_position]
        ; dsttype = [%typ: DST.Lexing.position]
        }
      ; rewrite_Location_t = {
          srctype = [%typ: location_t]
        ; dsttype = [%typ: DST.Location.t]
        }
      ; rewrite_string_Location_loc = {
          srctype = [%typ: string location_loc]
        ; dsttype = [%typ: string DST.Location.loc]
        }
      ; rewrite_label_Location_loc = {
          srctype = [%typ: label location_loc]
        ; dsttype = [%typ: label DST.Location.loc]
        }
      ; rewrite_longident_Location_loc = {
          srctype = [%typ: longident_t location_loc]
        ; dsttype = [%typ: DST.Longident.t DST.Location.loc]
        }
      ; rewrite_Location_loc = {
          srctype = [%typ: 'a location_loc]
        ; dsttype = [%typ: 'b DST.Location.loc]
        ; subs = [ ([%typ: 'a], [%typ: 'b]) ]
        }
      ; rewrite_Longident_t = {
          srctype = [%typ: longident_t]
        ; dsttype = [%typ: DST.Longident.t]
        }
      ; rewrite_label = {
          srctype = [%typ: label]
        ; dsttype = [%typ: DST.Asttypes.label]
        }
      ; rewrite_arg_label = {
          srctype = [%typ: arg_label]
        ; dsttype = [%typ: DST.Asttypes.arg_label]
        }
      ; rewrite_closed_flag = {
          srctype = [%typ: closed_flag]
        ; dsttype = [%typ: DST.Asttypes.closed_flag]
        }
      ; rewrite_rec_flag = {
          srctype = [%typ: rec_flag]
        ; dsttype = [%typ: DST.Asttypes.rec_flag]
        }
      ; rewrite_direction_flag = {
          srctype = [%typ: direction_flag]
        ; dsttype = [%typ: DST.Asttypes.direction_flag]
        }
      ; rewrite_private_flag = {
          srctype = [%typ: private_flag]
        ; dsttype = [%typ: DST.Asttypes.private_flag]
        }
      ; rewrite_mutable_flag = {
          srctype = [%typ: mutable_flag]
        ; dsttype = [%typ: DST.Asttypes.mutable_flag]
        }
      ; rewrite_virtual_flag = {
          srctype = [%typ: virtual_flag]
        ; dsttype = [%typ: DST.Asttypes.virtual_flag]
        }
      ; rewrite_override_flag = {
          srctype = [%typ: override_flag]
        ; dsttype = [%typ: DST.Asttypes.override_flag]
        }
      ; rewrite_variance = {
          srctype = [%typ: variance]
        ; dsttype = [%typ: DST.Asttypes.variance]
        }
      ; rewrite_constant = {
          srctype = [%typ: constant]
        ; dsttype = [%typ: DST.Parsetree.constant]
        }
      ; rewrite_list = {
          srctype = [%typ: 'a list]
        ; dsttype = [%typ: 'b list]
        ; code = _rewrite_list
        ; subs = [ ([%typ: 'a], [%typ: 'b]) ]
        }
      ; rewrite_location_stack = {
          srctype = [%typ: location_stack]
        ; dsttype = [%typ: DST.Parsetree.location_stack]
        }
      ; rewrite_attribute = {
          srctype = [%typ: attribute]
        ; dsttype = [%typ: DST.Parsetree.attribute]
        ; code = fun __dt__ __inh__ { attr_name = attr_name;
                                      attr_payload = attr_payload;
                                      attr_loc = _ } ->
            (__dt__.rewrite_string_Location_loc __dt__ __inh__ attr_name,
             __dt__.rewrite_payload __dt__ __inh__ attr_payload)
        }
      ; rewrite_extension = {
          srctype = [%typ: extension]
        ; dsttype = [%typ: DST.Parsetree.extension]
        }
      ; rewrite_attributes = {
          srctype = [%typ: attributes]
        ; dsttype = [%typ: DST.Parsetree.attributes]
        }
      ; rewrite_payload = {
          srctype = [%typ: payload]
        ; dsttype = [%typ: DST.Parsetree.payload]
        }
      ; rewrite_core_type = {
          srctype = [%typ: core_type]
        ; dsttype = [%typ: DST.Parsetree.core_type]
        ; inherit_code = Some ptyp_loc
        ; skip_fields = [ ptyp_loc_stack ]
        }
      ; rewrite_core_type_desc = {
          srctype = [%typ: core_type_desc]
        ; dsttype = [%typ: DST.Parsetree.core_type_desc]
        }
      ; rewrite_package_type = {
          srctype = [%typ: package_type]
        ; dsttype = [%typ: DST.Parsetree.package_type]
        }
      ; rewrite_row_field = {
          srctype = [%typ: row_field]
        ; dsttype = [%typ: DST.Parsetree.row_field]
        ; code = fun __dt__ __inh__ -> function
              { prf_desc = Rtag (ll, b, ctl);
                prf_loc = prf_loc ;
                prf_attributes = prf_attributes } ->
              let open DST.Parsetree in
              Rtag(__dt__.rewrite_label_Location_loc __dt__ __inh__ ll,
                   __dt__.rewrite_attributes __dt__ __inh__ prf_attributes,
                   b,
                   List.map (__dt__.rewrite_core_type __dt__ __inh__) ctl)

            | { prf_desc = Rinherit ct;
                prf_loc = prf_loc ;
                prf_attributes = prf_attributes } ->
              let open DST.Parsetree in
              Rinherit (__dt__.rewrite_core_type __dt__ __inh__ ct)
        }
      ; rewrite_object_field = {
          srctype = [%typ: object_field]
        ; dsttype = [%typ: DST.Parsetree.object_field]
        ; code = fun __dt__ __inh__ -> function
              { pof_desc = Otag(ll, ct);
                pof_loc = pof_loc;
                pof_attributes = pof_attributes } ->
              let open DST.Parsetree in
              Otag(__dt__.rewrite_label_Location_loc __dt__ __inh__ ll,
                   __dt__.rewrite_attributes __dt__ __inh__ pof_attributes,
                   __dt__.rewrite_core_type __dt__ __inh__ ct)

            | { pof_desc = Oinherit ct;
                pof_loc = pof_loc;
                pof_attributes = pof_attributes } ->
              let open DST.Parsetree in
              Oinherit (__dt__.rewrite_core_type __dt__ __inh__ ct)
        }
      ; rewrite_pattern = {
          srctype = [%typ: pattern]
        ; dsttype = [%typ: DST.Parsetree.pattern]
        ; inherit_code = Some ppat_loc
        ; skip_fields = [ ppat_loc_stack ]
        }
      ; rewrite_pattern_desc = {
          srctype = [%typ: pattern_desc]
        ; dsttype = [%typ: DST.Parsetree.pattern_desc]
        }
      ; rewrite_expression = {
          srctype = [%typ: expression]
        ; dsttype = [%typ: DST.Parsetree.expression]
        ; inherit_code = Some pexp_loc
        ; skip_fields = [ pexp_loc_stack ]
        }
      ; rewrite_expression_desc = {
          srctype = [%typ: expression_desc]
        ; dsttype = [%typ: DST.Parsetree.expression_desc]
        ; custom_branches_code = function
            | Pexp_open ({ popen_expr = { pmod_desc = Pmod_ident ll;
                                          pmod_loc = pmod_loc ;
                                          pmod_attributes = pmod_attributes } ;
                           popen_override = popen_override;
                           popen_loc = popen_loc ;
                           popen_attributes = attributes }, e) ->
              let open DST.Parsetree in
              Pexp_open(__dt__.rewrite_override_flag __dt__ __inh__ popen_override,
                        __dt__.rewrite_longident_Location_loc __dt__ __inh__ ll,
                        __dt__.rewrite_expression __dt__ __inh__ e)
            | Pexp_open ({ popen_expr = _ ; }, _) ->
              migration_error __inh__ "Pexp_open:longident"
            | Pexp_letop _ ->
              migration_error __inh__ "Pexp_letop"
        }
      ; rewrite_case = {
          srctype = [%typ: case]
        ; dsttype = [%typ: DST.Parsetree.case]
        }
      ; rewrite_value_description = {
          srctype = [%typ: value_description]
        ; dsttype = [%typ: DST.Parsetree.value_description]
        ; inherit_code = Some pval_loc
        }
      ; rewrite_type_declaration = {
          srctype = [%typ: type_declaration]
        ; dsttype = [%typ: DST.Parsetree.type_declaration]
        ; inherit_code = Some ptype_loc
        }
      ; rewrite_type_kind = {
          srctype = [%typ: type_kind]
        ; dsttype = [%typ: DST.Parsetree.type_kind]
        }
      ; rewrite_label_declaration = {
          srctype = [%typ: label_declaration]
        ; dsttype = [%typ: DST.Parsetree.label_declaration]
        ; inherit_code = Some pld_loc
        }
      ; rewrite_constructor_declaration = {
          srctype = [%typ: constructor_declaration]
        ; dsttype = [%typ: DST.Parsetree.constructor_declaration]
        ; inherit_code = Some pcd_loc
        }
      ; rewrite_constructor_arguments = {
          srctype = [%typ: constructor_arguments]
        ; dsttype = [%typ: DST.Parsetree.constructor_arguments]
        }
      ; rewrite_type_extension = {
          srctype = [%typ: type_extension]
        ; dsttype = [%typ: DST.Parsetree.type_extension]
        ; skip_fields = [ ptyext_loc ]
        }
      ; rewrite_extension_constructor = {
          srctype = [%typ: extension_constructor]
        ; dsttype = [%typ: DST.Parsetree.extension_constructor]
        ; inherit_code = Some pext_loc
        }
      ; rewrite_extension_constructor_kind = {
          srctype = [%typ: extension_constructor_kind]
        ; dsttype = [%typ: DST.Parsetree.extension_constructor_kind]
        }
      ; rewrite_class_type = {
          srctype = [%typ: class_type]
        ; dsttype = [%typ: DST.Parsetree.class_type]
        ; inherit_code = Some pcty_loc
        }
      ; rewrite_class_type_desc = {
          srctype = [%typ: class_type_desc]
        ; dsttype = [%typ: DST.Parsetree.class_type_desc]
        ; custom_branches_code = function
            | Pcty_open ({ popen_expr = ll;
                   popen_override = popen_override;
                   popen_loc = popen_loc;
                   popen_attributes = popen_attributes }, ct) ->
              let open DST.Parsetree in
              Pcty_open (__dt__.rewrite_override_flag __dt__ __inh__ popen_override,
                         __dt__.rewrite_longident_Location_loc __dt__ __inh__ ll,
                        __dt__.rewrite_class_type __dt__ __inh__ ct)
        }
      ; rewrite_class_signature = {
          srctype = [%typ: class_signature]
        ; dsttype = [%typ: DST.Parsetree.class_signature]
        }
      ; rewrite_class_type_field = {
          srctype = [%typ: class_type_field]
        ; dsttype = [%typ: DST.Parsetree.class_type_field]
        ; inherit_code = Some pctf_loc
        }
      ; rewrite_class_type_field_desc = {
          srctype = [%typ: class_type_field_desc]
        ; dsttype = [%typ: DST.Parsetree.class_type_field_desc]
        }
      ; rewrite_class_infos = {
          srctype = [%typ: 'a class_infos]
        ; dsttype = [%typ: 'b DST.Parsetree.class_infos]
        ; inherit_code = Some pci_loc
        ; subs = [ ([%typ: 'a], [%typ: 'b]) ]
        }
      ; rewrite_class_description = {
          srctype = [%typ: class_description]
        ; dsttype = [%typ: DST.Parsetree.class_description]
        }
      ; rewrite_class_type_declaration = {
          srctype = [%typ: class_type_declaration]
        ; dsttype = [%typ: DST.Parsetree.class_type_declaration]
        }
      ; rewrite_class_expr = {
          srctype = [%typ: class_expr]
        ; dsttype = [%typ: DST.Parsetree.class_expr]
        ; inherit_code = Some pcl_loc
        }
      ; rewrite_class_expr_desc = {
          srctype = [%typ: class_expr_desc]
        ; dsttype = [%typ: DST.Parsetree.class_expr_desc]
        ; custom_branches_code = function
            Pcl_open
                ({ popen_expr = v_1;
                   popen_override = v_0 ;
                   popen_loc = popen_loc ;
                   popen_attributes = popen_attributes },
                 v_2) ->
              let open DST.Parsetree in
              Pcl_open (__dt__.rewrite_override_flag __dt__ __inh__ v_0,
                        __dt__.rewrite_longident_Location_loc __dt__ __inh__ v_1,
                        __dt__.rewrite_class_expr __dt__ __inh__ v_2)
        }
      ; rewrite_class_structure = {
          srctype = [%typ: class_structure]
        ; dsttype = [%typ: DST.Parsetree.class_structure]
        }
      ; rewrite_class_field = {
          srctype = [%typ: class_field]
        ; dsttype = [%typ: DST.Parsetree.class_field]
        ; inherit_code = Some pcf_loc
        }
      ; rewrite_class_field_desc = {
          srctype = [%typ: class_field_desc]
        ; dsttype = [%typ: DST.Parsetree.class_field_desc]
        }
      ; rewrite_class_field_kind = {
          srctype = [%typ: class_field_kind]
        ; dsttype = [%typ: DST.Parsetree.class_field_kind]
        }
      ; rewrite_class_declaration = {
          srctype = [%typ: class_declaration]
        ; dsttype = [%typ: DST.Parsetree.class_declaration]
        }
      ; rewrite_module_type = {
          srctype = [%typ: module_type]
        ; dsttype = [%typ: DST.Parsetree.module_type]
        ; inherit_code = Some pmty_loc
        }
      ; rewrite_module_type_desc = {
          srctype = [%typ: module_type_desc]
        ; dsttype = [%typ: DST.Parsetree.module_type_desc]
        }
      ; rewrite_signature = {
          srctype = [%typ: signature]
        ; dsttype = [%typ: DST.Parsetree.signature]
        }
      ; rewrite_signature_item = {
          srctype = [%typ: signature_item]
        ; dsttype = [%typ: DST.Parsetree.signature_item]
        ; inherit_code = Some psig_loc
        }
      ; rewrite_signature_item_desc = {
          srctype = [%typ: signature_item_desc]
        ; dsttype = [%typ: DST.Parsetree.signature_item_desc]
        ; custom_branches_code = function
            | Psig_exception {ptyexn_constructor = ptyexn_constructor} ->
              let open DST.Parsetree in
              Psig_exception (__dt__.rewrite_extension_constructor __dt__ __inh__ ptyexn_constructor)
            | Psig_modsubst _ ->
              migration_error __inh__ "Psig_modsubst"
            | Psig_typesubst _ -> migration_error __inh__ "Psig_typesubst"
        }
      ; rewrite_module_declaration = {
          srctype = [%typ: module_declaration]
        ; dsttype = [%typ: DST.Parsetree.module_declaration]
        ; inherit_code = Some pmd_loc
        }
      ; rewrite_module_type_declaration = {
          srctype = [%typ: module_type_declaration]
        ; dsttype = [%typ: DST.Parsetree.module_type_declaration]
        ; inherit_code = Some pmtd_loc
        }
      ; rewrite_open_description = {
          srctype = [%typ: open_description]
        ; dsttype = [%typ: DST.Parsetree.open_description]
        ; inherit_code = Some popen_loc
        ; skip_fields = [ popen_expr ]
        ; custom_fields_code = {
            popen_lid = __dt__.rewrite_longident_Location_loc __dt__ __inh__ popen_expr
          }
        }
      ; rewrite_include_infos = {
          srctype = [%typ: 'a include_infos]
        ; dsttype = [%typ: 'b DST.Parsetree.include_infos]
        ; inherit_code = Some pincl_loc
        ; subs = [ ([%typ: 'a], [%typ: 'b]) ]
        }
      ; rewrite_include_description = {
          srctype = [%typ: include_description]
        ; dsttype = [%typ: DST.Parsetree.include_description]
        }
      ; rewrite_include_declaration = {
          srctype = [%typ: include_declaration]
        ; dsttype = [%typ: DST.Parsetree.include_declaration]
        }
      ; rewrite_with_constraint = {
          srctype = [%typ: with_constraint]
        ; dsttype = [%typ: DST.Parsetree.with_constraint]
        }
      ; rewrite_module_expr = {
          srctype = [%typ: module_expr]
        ; dsttype = [%typ: DST.Parsetree.module_expr]
        ; inherit_code = Some pmod_loc
        }
      ; rewrite_module_expr_desc = {
          srctype = [%typ: module_expr_desc]
        ; dsttype = [%typ: DST.Parsetree.module_expr_desc]
        }
      ; rewrite_structure = {
          srctype = [%typ: structure]
        ; dsttype = [%typ: DST.Parsetree.structure]
        }
      ; rewrite_structure_item = {
          srctype = [%typ: structure_item]
        ; dsttype = [%typ: DST.Parsetree.structure_item]
        ; inherit_code = Some pstr_loc
        }
      ; rewrite_structure_item_desc = {
          srctype = [%typ: structure_item_desc]
        ; dsttype = [%typ: DST.Parsetree.structure_item_desc]
        ; custom_branches_code = function
            | Pstr_exception {ptyexn_constructor = ptyexn_constructor} ->
              let open DST.Parsetree in
              Pstr_exception (__dt__.rewrite_extension_constructor __dt__ __inh__ ptyexn_constructor)
            | Pstr_open { popen_expr = { pmod_desc = Pmod_ident ll;
                                 pmod_loc = pmod_loc ;
                                 pmod_attributes = pmod_attributes } ;
                          popen_override = popen_override;
                          popen_loc = popen_loc;
                          popen_attributes = popen_attributes } ->
              let open DST.Parsetree in
              Pstr_open { popen_lid = __dt__.rewrite_longident_Location_loc __dt__ __inh__ ll ;
                          popen_override = __dt__.rewrite_override_flag __dt__ __inh__ popen_override ;
                          popen_loc = __dt__.rewrite_Location_t __dt__ __inh__ popen_loc ;
                          popen_attributes  = __dt__.rewrite_attributes __dt__ __inh__ popen_attributes }
            | Pstr_open { popen_expr = _ ; } ->
              migration_error __inh__ "Pstr_open:longident"
        }
      ; rewrite_value_binding = {
          srctype = [%typ: value_binding]
        ; dsttype = [%typ: DST.Parsetree.value_binding]
        ; inherit_code = Some pvb_loc
        }
      ; rewrite_module_binding = {
          srctype = [%typ: module_binding]
        ; dsttype = [%typ: DST.Parsetree.module_binding]
        ; inherit_code = Some pmb_loc
        }
      ; rewrite_out_name = {
          srctype = [%typ: out_name]
        ; dsttype = [%typ: string]
        ; code = fun _ _ { printed_name = printed_name } -> printed_name
        }
      ; rewrite_out_ident = {
          srctype = [%typ: out_ident]
        ; dsttype = [%typ: DST.Outcometree.out_ident]
        }
      ; rewrite_out_string = {
          srctype = [%typ: out_string]
        ; dsttype = [%typ: DST.Outcometree.out_string]
        }
      ; rewrite_out_attribute = {
          srctype = [%typ: out_attribute]
        ; dsttype = [%typ: DST.Outcometree.out_attribute]
        }
      ; rewrite_printer = {
          srctype = [%typ: (Format.formatter -> unit)]
        ; dsttype = [%typ: (Format.formatter -> unit)]
        ; code = fun _ _ x -> x
        }
      ; rewrite_exn = {
          srctype = [%typ: exn]
        ; dsttype = [%typ: exn]
        ; code = fun _ _ x -> x
        }
      ; rewrite_out_value = {
          srctype = [%typ: out_value]
        ; dsttype = [%typ: DST.Outcometree.out_value]
        }
      ; rewrite_out_type = {
          srctype = [%typ: out_type]
        ; dsttype = [%typ: DST.Outcometree.out_type]
        ; custom_branches_code = function
              Otyp_module
                (Oide_ident { printed_name = v_0 },
                 v_1,
                 v_2) ->
              let open DST.Outcometree in
              Otyp_module (v_0, v_1,
                           List.map (__dt__.rewrite_out_type __dt__ __inh__) v_2)
            | Otyp_module _ -> migration_error __inh__ "Otyp_module:out_ident"
        }
      ; rewrite_out_variant = {
          srctype = [%typ: out_variant]
        ; dsttype = [%typ: DST.Outcometree.out_variant]
        }
      ; rewrite_out_class_type = {
          srctype = [%typ: out_class_type]
        ; dsttype = [%typ: DST.Outcometree.out_class_type]
        }
      ; rewrite_out_class_sig_item = {
          srctype = [%typ: out_class_sig_item]
        ; dsttype = [%typ: DST.Outcometree.out_class_sig_item]
        }
      ; rewrite_out_module_type = {
          srctype = [%typ: out_module_type]
        ; dsttype = [%typ: DST.Outcometree.out_module_type]
        }
      ; rewrite_out_sig_item = {
          srctype = [%typ: out_sig_item]
        ; dsttype = [%typ: DST.Outcometree.out_sig_item]
        }
      ; rewrite_out_type_decl = {
          srctype = [%typ: out_type_decl]
        ; dsttype = [%typ: DST.Outcometree.out_type_decl]
        }
      ; rewrite_out_extension_constructor = {
          srctype = [%typ: out_extension_constructor]
        ; dsttype = [%typ: DST.Outcometree.out_extension_constructor]
        }
      ; rewrite_out_type_extension = {
          srctype = [%typ: out_type_extension]
        ; dsttype = [%typ: DST.Outcometree.out_type_extension]
        }
      ; rewrite_out_val_decl = {
          srctype = [%typ: out_val_decl]
        ; dsttype = [%typ: DST.Outcometree.out_val_decl]
        }
      ; rewrite_out_rec_status = {
          srctype = [%typ: out_rec_status]
        ; dsttype = [%typ: DST.Outcometree.out_rec_status]
        }
      ; rewrite_out_ext_status = {
          srctype = [%typ: out_ext_status]
        ; dsttype = [%typ: DST.Outcometree.out_ext_status]
        }
      ; rewrite_out_phrase = {
          srctype = [%typ: out_phrase]
        ; dsttype = [%typ: DST.Outcometree.out_phrase]
        }
      }
    }
]
