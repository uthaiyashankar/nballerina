@_bal_stack_guard = external global i8*
declare void @_bal_panic (i64)
declare i8* @_bal_alloc (i64)
declare {i64, i1} @llvm.ssub.with.overflow.i64 (i64, i64) nounwind readnone speculatable willreturn
declare void @_Bio__println (i8*)
define void @_B_main () {
  %_0 = alloca i8*
  %_1 = alloca i8*
  %_2 = alloca i8*
  %_3 = alloca i8*
  %_4 = alloca i64
  %_5 = alloca i64
  %_6 = alloca i8*
  %_7 = alloca i64
  %_8 = alloca i8
  %_9 = load i8*, i8** @_bal_stack_guard
  %_10 = icmp ult i8* %_8, %_9
  br i1 %_10, label %L3, label %L1
L1:
  %_11 = call i8* @_bal_alloc (i64 8)
  %_12 = bitcast i8* %_11 to i64*
  store i64 57, i64* %_12, align 8
  %_13 = getelementptr i8, i8* %_11, i64 504403158265495552
  call void @_B_foo (i8* %_13)
  store i8* null, i8** %_0
  %_14 = zext i1 1 to i64
  %_15 = or i64 %_14, 72057594037927936
  %_16 = getelementptr i8, i8* null, i64 %_15
  call void @_B_foo (i8* %_16)
  store i8* null, i8** %_1
  call void @_B_foo (i8* null)
  store i8* null, i8** %_2
  %_17 = call i8* @_bal_alloc (i64 8)
  %_18 = bitcast i8* %_17 to i64*
  store i64 9223372036854775807, i64* %_18, align 8
  %_19 = getelementptr i8, i8* %_17, i64 504403158265495552
  call void @_B_foo (i8* %_19)
  store i8* null, i8** %_3
  %_20 = call {i64, i1} @llvm.ssub.with.overflow.i64 (i64 -9223372036854775807, i64 1)
  %_21 = extractvalue {i64, i1} %_20, 1
  br i1 %_21, label %L5, label %L4
L2:
  %_27 = load i64, i64* %_7
  call void @_bal_panic (i64 %_27)
  unreachable
L3:
  call void @_bal_panic (i64 516)
  unreachable
L4:
  %_22 = extractvalue {i64, i1} %_20, 0
  store i64 %_22, i64* %_5
  %_23 = load i64, i64* %_5
  %_24 = call i8* @_bal_alloc (i64 8)
  %_25 = bitcast i8* %_24 to i64*
  store i64 %_23, i64* %_25, align 8
  %_26 = getelementptr i8, i8* %_24, i64 504403158265495552
  call void @_B_foo (i8* %_26)
  store i8* null, i8** %_6
  ret void
L5:
  store i64 1793, i64* %_7
  br label %L2
}
define internal void @_B_foo (i8* %_0) {
  %x = alloca i8*
  %_1 = alloca i8*
  %_2 = alloca i8
  %_3 = load i8*, i8** @_bal_stack_guard
  %_4 = icmp ult i8* %_2, %_3
  br i1 %_4, label %L2, label %L1
L1:
  store i8* %_0, i8** %x
  %_5 = load i8*, i8** %x
  call void @_Bio__println (i8* %_5)
  store i8* null, i8** %_1
  ret void
L2:
  call void @_bal_panic (i64 2564)
  unreachable
}
