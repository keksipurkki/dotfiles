syn clear fortranConstant
syn keyword fortranConstant         c_null_char c_alert c_backspace c_form_feed c_new_line c_carriage_return c_horizontal_tab c_vertical_tab
syn keyword fortranConstant         c_int c_short c_long c_long_long c_signed_char c_size_t c_int8_t c_int16_t c_int32_t c_int64_t c_int_least8_t c_int_least16_t c_int_least32_t c_int_least64_t c_int_fast8_t c_int_fast16_t c_int_fast32_t c_int_fast64_t c_intmax_t C_intptr_t c_float c_double c_long_double c_float_complex c_double_complex c_long_double_complex c_bool c_char c_null_ptr c_null_funptr
syn keyword fortranConstant         character_storage_size error_unit file_storage_size input_unit iostat_end iostat_eor numeric_storage_size output_unit stat_failed_image stat_unlocked_failed_image
syn keyword fortranConstant         int8 int16 int32 int64 real16 real32 real64 real128 character_kinds integer_kinds logical_kinds real_kinds iostat_inquire_internal_unit
syn keyword fortranConstant         ieee_negative_subnormal ieee_positive_subnormal


"hi def link fortranKeyword 	Keyword
"hi def link fortranConstructName	Identifier
"hi def link fortranConditional	Conditional
"hi def link fortranRepeat	Repeat
"hi def link fortranTodo		Todo
"hi def link fortranContinueMark	Special
"hi def link fortranString	String
"hi def link fortranNumber	Number
"hi def link fortranBinary	Number
"hi def link fortranOctal	Number
"hi def link fortranHex  	Number
"hi def link fortranOperator	Operator
"hi def link fortranBoolean	Boolean
"hi def link fortranLabelError	Error
"hi def link fortranObsolete	Todo
"hi def link fortranType		Type
"hi def link fortranStructure	Type
"hi def link fortranStorageClass	StorageClass
hi! def link fortranCall		Keyword
hi! def link fortranUnitHeader	Keyword
"hi def link fortranReadWrite	Keyword
"hi def link fortranIO		Keyword
"hi def link fortranIntrinsic	Function
"hi def link fortranConstant	Constant
"
"hi def link fortranUnitHeaderOb    fortranObsolete
"hi def link fortranKeywordOb       fortranObsolete
"hi def link fortranConditionalOb   fortranObsolete
"hi def link fortranTypeOb          fortranObsolete
"hi def link fortranKeywordDel      fortranObsolete
"
"hi! def link fortranIntrinsicR	fortranIntrinsic
"hi! def link fortranUnitHeaderR	fortranPreCondit
"hi! def link fortranTypeR		fortranType
"hi! def link fortranStorageClassR	fortranStorageClass
"hi! def link fortranOperatorR	        fortranOperator
"hi! def link fortranInclude	        Include
"hi! def link fortranLabelNumber	Special
"hi! def link fortranTarget	        Special
"hi! def link fortranFloatIll	        fortranFloat
"hi! def link fortranIOR		fortranIO
"hi! def link fortranKeywordR	        fortranKeyword
"hi! def link fortranStringR	        fortranString
"hi! def link fortranConditionalR	fortranConditional
"
"hi def link fortranFormatSpec	Identifier
"hi def link fortranFloat	Float
"hi def link fortranPreCondit	PreCondit
"hi def link cIncluded		fortranString
"hi def link cInclude		Include
"hi def link cPreProc		PreProc
"hi def link cPreCondit		PreCondit
"hi def link fortranOpenMP       PreProc
"hi def link fortranParenError	Error
"hi def link fortranComment	Comment
"hi def link fortranSerialNumber	Todo
"hi def link fortranTab		Error
hi! def link PreProc Comment
hi! def link PreCondit Comment

let b:fortran_dialect="f08"
