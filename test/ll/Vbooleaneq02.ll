@_bal_stack_guard = external global i8*
declare void @_bal_panic (i64)
declare i8* @_bal_alloc (i64)
declare void @_Bio__println (i8*)
define void @_B_main () {
  %_0 = alloca i1
  %_1 = alloca i8*
  %_2 = alloca i1
  %_3 = alloca i8*
  %_4 = alloca i64
  %_5 = alloca i1
  %_6 = alloca i8*
  %_7 = alloca i1
  %_8 = alloca i8*
  %_9 = alloca i1
  %_10 = alloca i8*
  %_11 = alloca i1
  %_12 = alloca i8*
  %_13 = alloca i64
  %_14 = alloca i1
  %_15 = alloca i8*
  %_16 = alloca i8
  %_17 = load i8*, i8** @_bal_stack_guard
  %_18 = icmp ult i8* %_16, %_17
  br i1 %_18, label %L2, label %L1
L1:
  %_19 = call i1 @_B_eq (i64 1, i64 2)
  store i1 %_19, i1* %_0
  %_20 = load i1, i1* %_0
  call void @_B_printBoolean (i1 %_20)
  store i8* null, i8** %_1
  %_21 = call i1 @_B_ne (i64 2, i64 1)
  store i1 %_21, i1* %_2
  %_22 = load i1, i1* %_2
  call void @_B_printBoolean (i1 %_22)
  store i8* null, i8** %_3
  %_23 = call i1 @_B_eq (i64 2, i64 -1)
  store i1 %_23, i1* %_5
  %_24 = load i1, i1* %_5
  call void @_B_printBoolean (i1 %_24)
  store i8* null, i8** %_6
  %_25 = call i1 @_B_ne (i64 1, i64 2)
  store i1 %_25, i1* %_7
  %_26 = load i1, i1* %_7
  call void @_B_printBoolean (i1 %_26)
  store i8* null, i8** %_8
  %_27 = call i1 @_B_eq (i64 0, i64 0)
  store i1 %_27, i1* %_9
  %_28 = load i1, i1* %_9
  call void @_B_printBoolean (i1 %_28)
  store i8* null, i8** %_10
  %_29 = call i1 @_B_ne (i64 2, i64 1)
  store i1 %_29, i1* %_11
  %_30 = load i1, i1* %_11
  call void @_B_printBoolean (i1 %_30)
  store i8* null, i8** %_12
  %_31 = call i1 @_B_eq (i64 -1, i64 17)
  store i1 %_31, i1* %_14
  %_32 = load i1, i1* %_14
  call void @_B_printBoolean (i1 %_32)
  store i8* null, i8** %_15
  ret void
L2:
  call void @_bal_panic (i64 772)
  unreachable
}
define internal void @_B_printBoolean (i1 %_0) {
  %b = alloca i1
  %_1 = alloca i8*
  %_2 = alloca i8*
  %_3 = alloca i8
  %_4 = load i8*, i8** @_bal_stack_guard
  %_5 = icmp ult i8* %_3, %_4
  br i1 %_5, label %L5, label %L1
L1:
  store i1 %_0, i1* %b
  %_6 = load i1, i1* %b
  br i1 %_6, label %L2, label %L3
L2:
  %_7 = call i8* @_bal_alloc (i64 8)
  %_8 = bitcast i8* %_7 to i64*
  store i64 1, i64* %_8, align 8
  %_9 = getelementptr i8, i8* %_7, i64 504403158265495552
  call void @_Bio__println (i8* %_9)
  store i8* null, i8** %_1
  br label %L4
L3:
  %_10 = call i8* @_bal_alloc (i64 8)
  %_11 = bitcast i8* %_10 to i64*
  store i64 0, i64* %_11, align 8
  %_12 = getelementptr i8, i8* %_10, i64 504403158265495552
  call void @_Bio__println (i8* %_12)
  store i8* null, i8** %_2
  br label %L4
L4:
  ret void
L5:
  call void @_bal_panic (i64 3332)
  unreachable
}
define internal i1 @_B_eq (i64 %_0, i64 %_1) {
  %x = alloca i64
  %y = alloca i64
  %_2 = alloca i1
  %_3 = alloca i8
  %_4 = load i8*, i8** @_bal_stack_guard
  %_5 = icmp ult i8* %_3, %_4
  br i1 %_5, label %L2, label %L1
L1:
  store i64 %_0, i64* %x
  store i64 %_1, i64* %y
  %_6 = load i64, i64* %x
  %_7 = load i64, i64* %y
  %_8 = icmp eq i64 %_6, %_7
  store i1 %_8, i1* %_2
  %_9 = load i1, i1* %_2
  ret i1 %_9
L2:
  call void @_bal_panic (i64 5636)
  unreachable
}
define internal i1 @_B_ne (i64 %_0, i64 %_1) {
  %x = alloca i64
  %y = alloca i64
  %_2 = alloca i1
  %_3 = alloca i8
  %_4 = load i8*, i8** @_bal_stack_guard
  %_5 = icmp ult i8* %_3, %_4
  br i1 %_5, label %L2, label %L1
L1:
  store i64 %_0, i64* %x
  store i64 %_1, i64* %y
  %_6 = load i64, i64* %x
  %_7 = load i64, i64* %y
  %_8 = icmp ne i64 %_6, %_7
  store i1 %_8, i1* %_2
  %_9 = load i1, i1* %_2
  ret i1 %_9
L2:
  call void @_bal_panic (i64 6660)
  unreachable
}
