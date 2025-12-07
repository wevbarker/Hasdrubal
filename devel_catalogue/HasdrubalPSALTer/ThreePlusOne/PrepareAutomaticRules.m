(*=========================*)
(*  PrepareAutomaticRules  *)
(*=========================*)

$ConvertToTimeDRules={};
PrepareAutomaticRule[InputHead_[InputInds___]]:=Module[{
	SymmExpr,PrintAsSymbol,Expr,NewHead},

	SymmExpr=SymmetryGroupOfTensor@InputHead[InputInd];
	PrintAsSymbol=InputHead;
	PrintAsSymbol//=PrintAs;

	NewHead=Symbol@(ToString@InputHead<>"ConjugateMomentum");
	DefTimeTensor[NewHead[InputInds]/.{SomeIndex_?TangentM4`Q->-SomeIndex},
		M4,SymmExpr,
		PrintAs->("\[CapitalPi]("<>PrintAsSymbol<>")")];
	$ConjugateMomenta~AppendTo~(NewHead);

	NewHead=Symbol@(ToString@InputHead<>"LagrangeMultiplier");
	DefTimeTensor[NewHead[InputInds],
		M4,SymmExpr,
		PrintAs->("\[CapitalLambda]("<>PrintAsSymbol<>")")];
	$LagrangeMultipliers~AppendTo~(NewHead);

	NewHead=Symbol@(ToString@InputHead<>"CanonicalField");
	DefTimeTensor[NewHead[InputInds],M4,SymmExpr,PrintAs->PrintAsSymbol];
	$CanonicalFields~AppendTo~(NewHead);

	$Velocities~AppendTo~(Symbol@(ToString@NewHead<>"p"));
	$ConvertToTimeDRules~AppendTo~(InputHead->NewHead);
	$DerivativeRules~AppendTo~MakeRule[
		{Evaluate@(V[z]*CD[-z][NewHead[InputInds]]),
		Evaluate@(TimeD@NewHead[InputInds])},
		MetricOn->All,ContractMetrics->True];
	$DerivativeRules//=Flatten;
];

Options[PrepareAutomaticRules]={DeclaredFieldSpinParityTensorHeads-><||>};
PrepareAutomaticRules[FieldName_,OptionsPattern[]]:=Module[{Class,Expr},
	If[Length@OptionValue@DeclaredFieldSpinParityTensorHeads>0,
		Expr=OptionValue@DeclaredFieldSpinParityTensorHeads;
		Expr//=(#@FieldName)&;
	,
		Class=FieldName;
		Class//=xAct`PSALTer`Private`FieldAssociation;
		Expr=Flatten@Values@(Flatten/@(Values/@(Values/@(Class@xAct`PSALTer`Private`FieldSpinParityTensorHeads))));
	];
	Expr//=((FromIndexFree@ToIndexFree@#)&/@#)&;
	Do[
		PrepareAutomaticRule[SpinParityPart],
		{SpinParityPart,Expr}
	];
];
