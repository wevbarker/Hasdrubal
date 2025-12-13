# Hasdrubal Source Context
# Generated Mathematica sources for in-context learning

This document contains the complete source code for:
1. Hamilcar - Canonical field theory package
2. Model Catalogue - Worked examples of Dirac-Bergmann constraint analysis

Sat Dec 13 02:12:27 AM CET 2025

========================================


# Section 1: Hamilcar Package Sources

Project Path: Hamilcar

Source Tree:

```txt
Hamilcar
└── xAct
    └── Hamilcar
        ├── Hamilcar.m
        └── Sources
            ├── DefCanonicalField
            │   ├── DefInert.m
            │   ├── DefPower.m
            │   └── RegisterPair.m
            ├── DefCanonicalField.m
            ├── FindAlgebra
            │   ├── AugmentWithBoundary
            │   │   └── MakeDerivativeCombinations.m
            │   ├── AugmentWithBoundary.m
            │   ├── CollectConstraints.m
            │   ├── NewUtils.m
            │   ├── SchematicForm
            │   │   └── ToNonNumericIndexFree.m
            │   └── ToHigherDerivativeCanonical.m
            ├── FindAlgebra.m
            ├── PoissonBracket
            │   ├── CacheContexts.m
            │   ├── DefSmearingTensor.m
            │   ├── MonomialPoissonBracket
            │   │   └── ToDensities.m
            │   ├── MonomialPoissonBracket.m
            │   ├── MultiCD.m
            │   ├── SemiD.m
            │   └── ToDensities.m
            ├── PoissonBracket.m
            ├── ReloadPackage
            │   ├── CLICallStack
            │   │   ├── GUICallStack.m
            │   │   └── Status.m
            │   ├── CLICallStack.m
            │   ├── CallStackBegin.m
            │   ├── CallStackEnd.m
            │   ├── DefGeometry.m
            │   ├── MonitorParallel.m
            │   ├── NewParallelSubmit.m
            │   ├── StackSetDelayed
            │   │   ├── NameOfFunction.m
            │   │   └── StackStrip.m
            │   └── StackSetDelayed.m
            ├── ReloadPackage.m
            ├── RulesTotal
            │   └── Recanonicalize.m
            ├── RulesTotal.m
            └── TimeD.m

```

`Hamilcar/xAct/Hamilcar/Hamilcar.m`:

```m
(*=============*)
(*  Hamilcar  *)
(*=============*)

(*===========*)
(*  Version  *)
(*===========*)

(*xAct`Hamelin`$Version={"0.0.0",{2023,11,4}};*)
xAct`Hamilcar`$Version={"0.0.0-developer",DateList@FileDate@$InputFileName~Drop~(-3)};

If[Unevaluated[xAct`xCore`Private`$LastPackage]===xAct`xCore`Private`$LastPackage,xAct`xCore`Private`$LastPackage="xAct`Hamilcar`"];

(* here is an error-killing line, I can't quite remember why we needed it! *)
Off@(Solve::fulldim);
Off@(Syntax::stresc);
Off@(FrontEndObject::notavail);

(*This became necessary since Wolfram 14.1*)
Unprotect@Print;
Print[Expr___]:=Null/;!($KernelID==0);
Protect@Print;
Unprotect@Message;
Message[Expr___]:=Null/;!($KernelID==0);
Protect@Message;

(*==================*)
(*  xAct`Hamilcar`  *)
(*==================*)

BeginPackage["xAct`Hamilcar`",{"xAct`xTensor`","xAct`SymManipulator`","xAct`xPerm`","xAct`xCore`","xAct`xTras`"}];
ParallelNeeds["xAct`Hamilcar`"];
SetOptions[$FrontEndSession,EvaluationCompletionAction->"ScrollToOutput"];
Print[xAct`xCore`Private`bars];
Print["Package xAct`Hamilcar` version ",$Version[[1]],", ",$Version[[2]]];
Print["CopyRight \[Copyright] 2023, Will Barker, under the General Public License."];

If[$FrontEnd==Null,
	xAct`Hamilcar`Private`$CLI=True,
	xAct`Hamilcar`Private`$CLI=False,
	xAct`Hamilcar`Private`$CLI=False];
Quiet@If[xAct`Hamilcar`Private`$CLI,
	xAct`Hamilcar`Private`$WorkingDirectory=Directory[],
	SetOptions[$FrontEndSession,EvaluationCompletionAction->"ScrollToOutput"];
	If[NotebookDirectory[]==$Failed,
		xAct`Hamilcar`Private`$WorkingDirectory=Directory[],
		xAct`Hamilcar`Private`$WorkingDirectory=NotebookDirectory[],
		xAct`Hamilcar`Private`$WorkingDirectory=NotebookDirectory[]]];
$Path~AppendTo~xAct`Hamilcar`Private`$WorkingDirectory;
xAct`Hamilcar`Private`$InstallDirectory=Select[FileNameJoin[{#,"xAct/Hamilcar"}]&/@$Path,DirectoryQ][[1]];
(*If[xAct`Hamilcar`Private`$CLI,	
	Print@Import@FileNameJoin@{xAct`Hamilcar`Private`$InstallDirectory,
				"Logos","ASCIILogo.txt"},
	Print@Magnify[Import@FileNameJoin@{xAct`Hamilcar`Private`$InstallDirectory,
				"Logos","GitLabLogo.png"},0.3]];*)

(*==============*)
(*  Disclaimer  *)
(*==============*)

If[xAct`xCore`Private`$LastPackage==="xAct`Hamilcar`",
Unset[xAct`xCore`Private`$LastPackage];
Print[xAct`xCore`Private`bars];
Print["These packages come with ABSOLUTELY NO WARRANTY; for details type Disclaimer[]. This is free software, and you are welcome to redistribute it under certain conditions. See the General Public License for details."];
Print[xAct`xCore`Private`bars]];

(*============================*)
(*  Declaration of functions  *)
(*============================*)

DefCanonicalField::usage="DefCanonicalField";
PoissonBracket::usage="PoissonBracket";
FindAlgebra::usage="FindAlgebra";
Verify::usage="Verify";
Constraints::usage="Constraints";
DDIs::usage="DDIs";
TotalFrom::usage="TotalFrom";
TotalTo::usage="TotalTo";
PrependTotalFrom::usage="PrependTotalFrom";
PrependTotalTo::usage="PrependTotalTo";
Recanonicalize::usage="Recanonicalize";
DefTimeTensor::usage="DefTimeTensor";
TimeD::usage="TimeD";

(*===========================*)
(*  Declaration of geometry  *)
(*===========================*)

M3::usage="M3 is the three-dimensional Lorentzian spacetime manifold.";
Time::usage="Time is the time coordinate orthogonal to M3.";
G::usage="G[-a,-b] is the spatial metric on M3.";
GTime::usage="GTime[-a,-b] is the time-dependent spatial metric on M3.";
GTimeInverse::usage="GTimeInverse[a,b] is the inverse of the time-dependent spatial metric on M3.";
ConjugateMomentumG::usage="ConjugateMomentumG[a,b] is the momentum conjugate to the spatial metric on M3.";
CD::usage="CD[-a] is the covariant derivative on M3.";

(*====================*)
(*  Global variables  *)
(*====================*)

$DynamicalMetric::usage="$DynamicalMetric is a global variable that determines whether the spatial metric is dynamical or not. Default is True.";
$DynamicalMetric=True;
$ManualSmearing=False;

Begin["xAct`Hamilcar`Private`"];
$MaxDerOrd=5;
$MaxPowerNumber=3;
$RegisteredFields={};
$RegisteredPowers=<||>;
$RegisteredMomenta={};
$RegisteredTensorMomenta={};
$FromInert={};
$ToInert={};
(* Debugging infrastructure variables *)
$CallStack=Null;
$CallStackTraceFileName="hamilcar-call-stack-trace.txt";
$NumberOfCriticalPoints=50;
IncludeHeader[FunctionName_]:=Module[{PathName},
	PathName=$InputFileName~StringDrop~(-2);
	PathName=FileNameJoin@{PathName,FunctionName<>".m"};
	PathName//=Get;
];
ReadAtRuntime[FunctionName_]:=Module[{PathName,FunctionSymbol=Symbol@FunctionName},
	PathName=$InputFileName~StringDrop~(-2);
	PathName=FileNameJoin@{PathName,FunctionName<>".m"};
	FunctionSymbol[]:=PathName//Get;
];
RereadSources[]:=(Off@Syntax::stresc;(Get@FileNameJoin@{$InstallDirectory,"Sources",#})&/@{
	"ReloadPackage.m",
	"DefCanonicalField.m",
	"PoissonBracket.m",
	"RulesTotal.m",
	"FindAlgebra.m",
	"TimeD.m"};On@Syntax::stresc;);
RereadSources[];
ToInertRules={};
FromInertRules={};
Begin["xAct`Hamilcar`"];
	xAct`Hamilcar`Private`ReloadPackage[];
	Quiet@If[$FrontEnd==Null,
		xAct`Hamilcar`Private`$CLI=True,
		xAct`Hamilcar`Private`$CLI=False,
		xAct`Hamilcar`Private`$CLI=False];
	$DefInfoQ=False;
End[];
End[];
EndPackage[];

```

`Hamilcar/xAct/Hamilcar/Sources/DefCanonicalField.m`:

```m
(*=====================*)
(*  DefCanonicalField  *)
(*=====================*)

IncludeHeader@"DefPower";
IncludeHeader@"RegisterPair";

$DefInfoQ=False;
Unprotect@AutomaticRules;
Options[AutomaticRules]={Verbose->False};
Protect@AutomaticRules;

Options@DefCanonicalField={
	Dagger->Real,	
	FieldSymbol->"\[ScriptQ]",
	MomentumSymbol->"\[ScriptP]"
};

DefCanonicalField[FieldName_[Inds___],Opts___?OptionQ]~Y~DefCanonicalField[FieldName[Inds],GenSet[],Opts];

DefCanonicalField[FieldName_[Inds___],SymmExpr_,OptionsPattern[]]~Y~Module[{
	MomentumName=ToExpression@("ConjugateMomentum"<>(ToString@FieldName)),
	TensorMomentumName=ToExpression@("TensorConjugateMomentum"<>(ToString@FieldName)),
	FieldSymbolValue=OptionValue@FieldSymbol,
	NewSymmExpr,
	MomentumSymbolValue=OptionValue@MomentumSymbol,
	TensorMomentumSymbolValue="\[GothicCapitalT]"<>ToString@OptionValue@MomentumSymbol,
	DaggerValue=OptionValue@Dagger,
	CallStack},
	
	If[!xAct`Hamilcar`Private`$CLI,
		CallStack=PrintTemporary@Dynamic@Refresh[
			GUICallStack@$CallStack,
			TrackedSymbols->{$CallStack}];
	];
	
	DefTimeTensor[
		FieldName@Inds,M3,SymmExpr,PrintAs->FieldSymbolValue,Dagger->DaggerValue];	
	DefPower[FieldName,QuantitySymbol->OptionValue@FieldSymbol];
	NewSymmExpr=SymmExpr/.{SomeIndex_?TangentM3`Q->-SomeIndex};
	DefTimeTensor[
		MomentumName@@({Inds}/.{SomeIndex_?TangentM3`Q->-SomeIndex}),M3,NewSymmExpr,PrintAs->MomentumSymbolValue,Dagger->DaggerValue];
	DefTensor[
		TensorMomentumName@@({Inds}/.{SomeIndex_?TangentM3`Q->-SomeIndex}),M3,NewSymmExpr,PrintAs->TensorMomentumSymbolValue,Dagger->DaggerValue];
	DefPower[MomentumName,QuantitySymbol->MomentumSymbolValue];
	RegisterPair[FieldName,MomentumName,TensorMomentumName];
	If[!xAct`Hamilcar`Private`$CLI,
		FinishDynamic[];
		NotebookDelete@CallStack;
	];
];

```

`Hamilcar/xAct/Hamilcar/Sources/DefCanonicalField/DefInert.m`:

```m
(*============*)
(*  DefInert  *)
(*============*)

DefInert[InputTensorHead_]:=Module[{
	DerInd,
	ActDerInd,
	IneDerInd,
	TenInd,
	TenExp=FromIndexFree@ToIndexFree@InputTensorHead,
	DerExp,
	IneExp},

	TenInd=TenExp/.{InputTensorHead->List};
	Table[
		DerInd=(ToExpression/@Alphabet[])~Take~(-DerOrd);
		IneExp=("CD"~StringRepeat~DerOrd)<>ToString@Head@TenExp;
		IneExp//=ToExpression;
		IneExp//=((#)@@(DerInd~Join~TenInd))&;
		If[DerOrd>1,
			DefTensor[IneExp,M3,Symmetric@DerInd];
		,
			DefTensor[IneExp,M3];
		];
		Table[
			IneDerOrd=DerOrd-ActDerOrd;
			ActDerInd=(DerInd~Take~(-ActDerOrd));
			IneDerInd=DerInd~Take~IneDerOrd;
			DerExp=("CD"~StringRepeat~IneDerOrd)<>ToString@Head@TenExp;
			DerExp//=ToExpression;
			DerExp//=((#)@@(IneDerInd~Join~TenInd))&;
			(DerExp//=CD[#])&/@(Reverse@ActDerInd);
			ToInertRules=ToInertRules~Join~MakeRule[{
				Evaluate@DerExp,
				Evaluate@IneExp},
				MetricOn->All,ContractMetrics->True];
			If[ActDerOrd==DerOrd,
				FromInertRules=FromInertRules~Join~MakeRule[{
					Evaluate@IneExp,
					Evaluate@DerExp},
					MetricOn->All,ContractMetrics->True];
			];
		,
			{ActDerOrd,1,DerOrd}
		];
	,
		{DerOrd,1,$MaxDerOrd}
	];
];

```

`Hamilcar/xAct/Hamilcar/Sources/DefCanonicalField/DefPower.m`:

```m
(*============*)
(*  DefPower  *)
(*============*)

Options@DefPower={QuantitySymbol->"\[CapitalOmega]"};
DefPower[InputTensorHead_,OptionsPattern[]]:=Module[{
	DerInd,
	IndNumber,
	IneExp},

	IndNumber=InputTensorHead;
	IndNumber//=IndexFree;
	IndNumber//=FromIndexFree;
	IndNumber//=(List@@#)&;
	IndNumber//=Length;
	Table[
		Table[
			DerInd=(ToExpression/@Alphabet[])~Take~(-IndexNumber);
			IneExp=ToString@InputTensorHead<>
					ToString@PowerNumber<>
					ToString@IndexNumber;
			IneExp//=ToExpression;
			IneExp//=((#)@@(DerInd))&;
			DefTensor[IneExp,M3,
				PrintAs->(ToString@OptionValue@QuantitySymbol<>
					"("<>ToString@PowerNumber<>"|"<>
					ToString@IndexNumber<>")")];
			$RegisteredPowers@Head@IneExp={InputTensorHead,
				PowerNumber,IndexNumber};
		,
			{IndexNumber,IndNumber*PowerNumber,0,-2}
		];
	,
		{PowerNumber,1,$MaxPowerNumber}
	];
];

```

`Hamilcar/xAct/Hamilcar/Sources/DefCanonicalField/RegisterPair.m`:

```m
(*================*)
(*  RegisterPair  *)
(*================*)

RegisterPair[FieldName_,MomentumName_,TensorMomentumName_]~Y~Module[{
	IndexedField=FromIndexFree@ToIndexFree@FieldName,
	Indices,
	IndexedMomentum,
	IndexedTensorMomentum},

	$RegisteredFields~AppendTo~FromIndexFree@ToIndexFree@FieldName;

	Indices=List@@IndexedField;
	IndexedMomentum=MomentumName@@(Minus/@Indices);
	$RegisteredMomenta~AppendTo~IndexedMomentum;
	IndexedTensorMomentum=TensorMomentumName@@(Minus/@Indices);
	$RegisteredTensorMomenta~AppendTo~IndexedTensorMomentum;
];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra.m`:

```m
(*===============*)
(*  FindAlgebra  *)
(*===============*)

IncludeHeader@"CollectConstraints";
IncludeHeader@"NewUtils";
(*IncludeHeader@"ToHigherToSymmetrizedCanonical";*)

Options@FindAlgebra={Method->Solve,Constraints->{},Verify->False,DDIs->False};
FindAlgebra[InputBulkBracket_,InputSchematicAnsatz_,OptionsPattern[]]~Y~Module[{
	CallStack,
	BulkBracket=InputBulkBracket,
	SchematicAnsatz=InputSchematicAnsatz,	
	BulkAnsatz,
	OutputBulkBracket,
	BoundaryAnsatz,
	DDIAnsatz,
	BasicDDIAnsatz,
	AdvancedDDIAnsatz,
	DDIAnsatzParameters,
	MultiTensorRules,
	BulkAnsatzParameters,
	BoundaryAnsatzParameters,
	ParameterSolution=0},

	If[!xAct`Hamilcar`Private`$CLI,
		CallStack=PrintTemporary@Dynamic@Refresh[
			GUICallStack@$CallStack,
			TrackedSymbols->{$CallStack}];
	];

	Block[{DetG},
		DetG[]:=1;
		BulkAnsatz=SchematicAnsatz;
		BulkAnsatz//=MakePermutedBulk;
		BulkAnsatz//=MakeSchematicBulk;
		BulkAnsatz//=MakeBulkAnsatz;
		OutputBulkBracket=BulkAnsatz;
		BulkAnsatzParameters=BulkAnsatz;
		BulkAnsatzParameters//=ExtractParameters;
		BulkAnsatz//=TotalFrom;
		If[OptionValue@DDIs,
			DDIAnsatz=BulkAnsatz;
			DDIAnsatz//=(#/.{RicciScalarCD->Zero})&;
			DDIAnsatz//=RecoverBasicSchematicAnsatz;

			BasicDDIAnsatz=DDIAnsatz;
			BasicDDIAnsatz//=MakeBasicDDIs;
			If[BasicDDIAnsatz===0,
				DDIAnsatz=0;
				DDIAnsatzParameters={};
			,
				AdvancedDDIAnsatz=DDIAnsatz;
				AdvancedDDIAnsatz//=ExtractPowerGradients;
				If[AdvancedDDIAnsatz==={},
					DDIAnsatz=BasicDDIAnsatz;
				,
					AdvancedDDIAnsatz//=DevelopAllScalars;
					MultiTensorRules=$RequiredMultiTensors;
					MultiTensorRules//=DevelopAllDDIs;
					MultiTensorRules//=AllDDIsToMultiTensorRules;
					AdvancedDDIAnsatz//=(#~OuterRules~MultiTensorRules)&;
					DDIAnsatz=BasicDDIAnsatz+AdvancedDDIAnsatz;
				];
				DDIAnsatz//=CollectTensors[#,CollectMethod->ToExpandedCanonical]&;
				DDIAnsatzParameters=DDIAnsatz;
				DDIAnsatzParameters//=ExtractParameters;
			];
		];

		BoundaryAnsatz=BulkAnsatz;
		(*Useful for Gorof-Sagnotti, not for*)
		(*BoundaryAnsatz//=(#/.{RicciScalarCD->Zero})&;*)
		BoundaryAnsatz//=RecoverSchematicAnsatz;
		(**)BoundaryAnsatz//=CurvatureReduction;(**)
		BoundaryAnsatz//=MakeSchematicBoundaryCurrent;
		BoundaryAnsatz//=BoundaryCurrentToBoundary;
		BoundaryAnsatzParameters=BoundaryAnsatz;
		BoundaryAnsatzParameters//=ExtractParameters;
		(**)BoundaryAnsatzParameterQ[InputCoupling_]:=StringMatchQ[
			ToString@InputCoupling,"S"~~__];
		BoundaryAnsatzParameters//=Cases[#,_?BoundaryAnsatzParameterQ]&;(**)
		If[OptionValue@DDIs,
			BoundaryAnsatzParameters//=(#~Join~DDIAnsatzParameters)&;
		];
		BulkBracket//=TotalFrom;
		BulkBracket//=CleanInputBracket;
		ParameterSolution+=BulkBracket;
		ParameterSolution-=BulkAnsatz;
		ParameterSolution-=BoundaryAnsatz;
		If[OptionValue@DDIs,
			ParameterSolution-=DDIAnsatz;
		];
		ParameterSolution//=CollectTensors[#,CollectMethod->ToExpandedCanonical]&;
		(*ParameterSolution//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;*)
		ParameterSolution//=ObtainSolution[#,
			BulkAnsatzParameters,BoundaryAnsatzParameters,
			Method->OptionValue@Method]&;

		BulkBracket=InputBulkBracket;
		BulkBracket//=TotalFrom;
	];
	OutputBulkBracket//=(#/.ParameterSolution)&;
	OutputBulkBracket//=CollectTensors[#,CollectMethod->ToExpandedCanonical]&;
	BulkAnsatz//=(#/.ParameterSolution)&;
	BulkAnsatz//=CollectTensors[#,CollectMethod->ToExpandedCanonical]&;
	If[OptionValue@Constraints=!={},
		OutputBulkBracket//=(#~CollectConstraints~(OptionValue@Constraints))&;
	];
	If[OptionValue@Verify,
		BulkBracket~VerifyResult~BulkAnsatz;
	];

	If[!xAct`Hamilcar`Private`$CLI,
		FinishDynamic[];
		NotebookDelete@CallStack;
	];
OutputBulkBracket];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra/AugmentWithBoundary.m`:

```m
(*=======================*)
(*  AugmentWithBoundary  *)
(*=======================*)

IncludeHeader@"MakeDerivativeCombinations";

AugmentWithBoundary[InputExpr_]~Y~Module[{
	BoundaryAnsatz=InputExpr,
	AugmentedAnsatz,
	BoundaryAnsatzParameters},

	BoundaryAnsatz//=(#/.{DetG[]->1/Measure[]^2})&;
	BoundaryAnsatz//=PowerExpand;
	BoundaryAnsatz//=Expand;
	BoundaryAnsatz//=(List@@#)&;
	BoundaryAnsatz//=(MakeDerivativeCombinations/@#)&;
	BoundaryAnsatz//=(#/.{Measure[]->1/Sqrt@DetG[]})&;
	BoundaryAnsatz//=Flatten;

	BoundaryAnsatzParameters=$AnsatzCoefficients~Take~Length@BoundaryAnsatz;

	AugmentedAnsatz=Times~MapThread~{BoundaryAnsatzParameters,BoundaryAnsatz};
	AugmentedAnsatz//=Flatten;
	AugmentedAnsatz//=Total;
	AugmentedAnsatz//=ToHigherDerivativeCanonical;
	AugmentedAnsatz+=InputExpr;
AugmentedAnsatz];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra/AugmentWithBoundary/MakeDerivativeCombinations.m`:

```m
(*==============================*)
(*  MakeDerivativeCombinations  *)
(*==============================*)

MakeDerivativeCombinations[InputExpr_]~Y~Module[{
	Expr=InputExpr,
	ReciprocalValue,
	ReciprocalRule,
	$TermIsQuotient=False,
	ThirdDTerms,
	SecondDTerms,
	FirstDTerms,
	UndifferentiatedTerms,
	FirstDSurfaceTerms,
	SecondDSurfaceTerms,
	ThirdDSurfaceTerms},

	Expr//=Together;
	ReciprocalValue=Expr;
	ReciprocalValue//=Denominator;
	Expr//=Numerator;
	If[!((CD[-a]@ReciprocalValue)===0),$TermIsQuotient=True];
	If[$TermIsQuotient,
		ReciprocalRule=MakeRule[{GeneralReciprocal[],Evaluate[1/ReciprocalValue]},
			MetricOn->All,ContractMetrics->True];
		Expr*=GeneralReciprocal[];
	];
	Expr//=Variables;
	Expr//=DeleteCases[#,_?ConstantSymbolQ]&;

	ThirdDTerms=Cases[Expr,
		CD[FirstDIndex_]@CD[SecondDIndex_]@CD[ThirdDIndex_]@AnyTensor_,
		Infinity];
	Expr//=Complement[#,ThirdDTerms]&;

	SecondDTerms=Cases[Expr,
		CD[FirstDIndex_]@CD[SecondDIndex_]@AnyTensor_,
		Infinity];
	Expr//=Complement[#,SecondDTerms]&;

	FirstDTerms=Cases[Expr,
		CD[FirstDIndex_]@AnyTensor_,
		Infinity];
	Expr//=Complement[#,FirstDTerms]&;
	UndifferentiatedTerms=Expr;

	FirstDSurfaceTerms=Module[{
		TargetTerm,
		RemainingFirstDTerms,
		DIndex,
		UndifferentiatedTerm},

		RemainingFirstDTerms=FirstDTerms~Complement~{FirstDTerm};
		DIndex=FirstDTerm/.{CD[AnyInd_]@AnyTensor_->AnyInd};
		UndifferentiatedTerm=FirstDTerm/.{CD[FirstDIndex_]@AnyTensor_->AnyTensor};
		RemainingFirstDTerms~AppendTo~UndifferentiatedTerm;
		TargetTerm=Join[UndifferentiatedTerms,RemainingFirstDTerms,SecondDTerms,ThirdDTerms];
		TargetTerm//=Flatten;
		TargetTerm//=(Times@@#)&;
		TargetTerm//=CD@DIndex;
	TargetTerm]~Table~{FirstDTerm,FirstDTerms};

	SecondDSurfaceTerms=Module[{
		TargetTerm,
		RemainingSecondDTerms,
		DIndex,
		UndifferentiatedTerm},

		RemainingSecondDTerms=SecondDTerms~Complement~{SecondDTerm};
		DIndex=SecondDTerm/.{CD[AnyInd_]@CD[AnyOtherInd_]@AnyTensor_->AnyInd};
		UndifferentiatedTerm=SecondDTerm/.{CD[SecondDIndex_]@CD[AnyOtherInd_]@AnyTensor_->CD[AnyOtherInd]@AnyTensor};
		RemainingSecondDTerms~AppendTo~UndifferentiatedTerm;
		TargetTerm=Join[UndifferentiatedTerms,RemainingSecondDTerms,FirstDTerms,ThirdDTerms];
		TargetTerm//=Flatten;
		TargetTerm//=(Times@@#)&;
		TargetTerm//=CD@DIndex;
	TargetTerm]~Table~{SecondDTerm,SecondDTerms};

	ThirdDSurfaceTerms=Module[{
		TargetTerm,
		RemainingThirdDTerms,
		DIndex,
		UndifferentiatedTerm},

		RemainingThirdDTerms=ThirdDTerms~Complement~{ThirdDTerm};
		DIndex=ThirdDTerm/.{CD[AnyInd_]@CD[AnyOtherInd_]@CD[AnyOtherOtherInd_]@AnyTensor_->AnyInd};
		UndifferentiatedTerm=ThirdDTerm/.{CD[ThirdDIndex_]@CD[AnyOtherInd_]@CD[AnyOtherOtherInd_]@AnyTensor_->CD[AnyOtherInd]@CD[AnyOtherOtherInd]@AnyTensor};
		RemainingThirdDTerms~AppendTo~UndifferentiatedTerm;
		TargetTerm=Join[UndifferentiatedTerms,RemainingThirdDTerms,FirstDTerms,SecondDTerms];
		TargetTerm//=Flatten;
		TargetTerm//=(Times@@#)&;
		TargetTerm//=CD@DIndex;
	TargetTerm]~Table~{ThirdDTerm,ThirdDTerms};

	If[$TermIsQuotient,
		FirstDSurfaceTerms//=(#/.ReciprocalRule)&;
		SecondDSurfaceTerms//=(#/.ReciprocalRule)&;
		ThirdDSurfaceTerms//=(#/.ReciprocalRule)&;
	];

{FirstDSurfaceTerms,SecondDSurfaceTerms,ThirdDSurfaceTerms}];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra/CollectConstraints.m`:

```m
(*======================*)
(*  CollectConstraints  *)
(*======================*)

ConjugateTerm[InputExpr_,Constraint_[ConstInds___]]~Y~Module[{Expr=InputExpr},
	Expr//=(#/.{Constraint->DummyConstraint})&;
	Expr//=VarD[DummyConstraint[ConstInds],CD];
	Expr//=TotalTo;
	(*Expr//=ToHigherDerivativeCanonical;*)
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=FullSimplify;
	Constraint[ConstInds]*Expr];

CollectConstraints[InputExpr_,ConstraintsList_]~Y~Module[
	{Expr=0},
	(Expr+=ConjugateTerm[InputExpr,#])&/@ConstraintsList;
	(*(Expr+=(#*ToHigherDerivativeCanonical@TotalTo@(VarD[#,
		CD]@InputExpr)))&/@ConstraintsList;*)
Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra/NewUtils.m`:

```m
(*======================*)
(*  CurvatureExtension  *)
(*======================*)

PermuteAnsatz[InputExpr_]~Y~Module[{
	Expr=InputExpr,
	CDNumber=InputExpr,
	CDPositions},

	CDNumber//=(#/.{CD->1})&;
	CDNumber//=(#~Cases~(_?NumberQ))&;
	CDNumber//=Total;
	CDPositions=(Range@(Length@Expr-CDNumber))~Tuples~CDNumber;
	CDPositions//=(Sort/@#)&;
	CDPositions//=DeleteDuplicates;
	CDPositions//=Sort;
	Expr//=(#~DeleteCases~CD)&;
	Expr//=(#~ConstantArray~(Length@CDPositions))&;
	Expr//=MapThread[
		Module[{SubExpr=#1,CDPositionsActual=#2},
			(SubExpr[[#]]//=CD)&/@CDPositionsActual;
			SubExpr//=(Times@@#)&;
			SubExpr]&,
		{#,CDPositions}]&;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
Combinations@@Expr];

PermuteAnsatzIfVarList[InputExpr_]~Y~If[(Depth@InputExpr)===2,
	InputExpr//PermuteAnsatz,
	InputExpr];

MakePermutedBulk[InputExpr_]~Y~(PermuteAnsatzIfVarList//@InputExpr);

ExpandAnsatz[InputExpr_]~Y~Module[{Expr=InputExpr},
	If[
		!(Head@Expr===Combinations)
	,
		Expr//=(#/.{Combinations->List})&;
		Expr~PrependTo~Times;
		Expr//=(Outer@@#)&;
		Expr//=Flatten;
	,
		Expr//=(#/.{Combinations->List})&;
	];
Expr];

MakeSchematicBulk[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(ExpandAnsatz/@#)&;
	Expr//=Flatten;
	Expr//=DeleteDuplicates;
Expr];

MakeBulkAnsatz[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(IndexFree/@#)&;
	Expr//=(MakeContractionAnsatz[#1,
		ConstantPrefix->#2]&~MapThread~{#,
		(DeleteDuplicates@Flatten@Outer[(ToString@#1<>ToString@#2)&,
			Alphabet[],Alphabet[]])~Take~(Length@#)})&;
	Expr//=Total;
	Expr//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;
Expr];

MakeBoundaryCurrentAnsatz[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(#/.{SpecialPair->List})&;
	Expr//=({IndexFree@First@#,Last@#}&/@#)&;
	Expr//=((MakeContractionAnsatz[#1,IndexList@a,
		ConstantPrefix->#3]*#2)&~MapThread~{First/@#,Last/@#,
		("S"<>ToString@#)&/@(Range@Length@#)})&;
	Expr//=Total;
	Expr//=CollectTensors;
Expr];

MakeSchematicBoundaryCurrent[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=({Flatten@First@#,Last@#}&/@#)&;
	Expr//=({Sort@First@#,Last@#}&/@#)&;
	Expr//=(#~Cases~(_?(((First@#)~MemberQ~CD)&)))&;
	Expr//=({((First@#)~Delete~(First@Flatten@((First@#)~Position~CD))),Last@#}&/@#)&;
	Expr//=({PermuteAnsatz@First@#,Last@#}&/@#)&;
	Expr//=({(List@@(First@#)),Last@#}&/@#)&;
	Expr//=(MapThread[SpecialPair[#1,#2]&,{First@#,(Last@#)~ConstantArray~(Length@First@#)}]&/@#)&;
	Expr//=Flatten;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
	Expr//=MakeBoundaryCurrentAnsatz;
Expr];

Options@Repartition={ExpandAll->True};
Repartition[InputExpr_List,PartitionLength_Integer,OptionsPattern[]]~Y~Module[{
	Expr=InputExpr},
	Expr//=Flatten;
	Expr//=Total;
	If[OptionValue@ExpandAll,Expr//=Expand];
	Expr=(If[Head@#===Plus,List@@#,List@#])&@(Expr);
	Expr//=Flatten;
	Expr//=RandomSample;
	Expr//=Partition[#,UpTo@PartitionLength]&;
	Expr//=(Total/@#)&;	
Expr];

ToSymmetrizedCanonical[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=ContractMetric;
	Expr//=ToCanonical;
	Expr//=SymmetrizeCovDs;
	Expr//=(#/.CurvatureRelationsBianchi[CD,Ricci])&;
	Expr//=ContractMetric;
	Expr//=ToCanonical;
Expr];

ToExpandedCanonical[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=ContractMetric;
	Expr//=ToCanonical;
	Expr//=ExpandSymCovDs;
	Expr//=(#/.CurvatureRelationsBianchi[CD,Ricci])&;
	Expr//=ContractMetric;
	Expr//=ToCanonical;
Expr];

ComputeDivergence[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=CD[-a];
	Expr//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;
Expr];

BoundaryCurrentToBoundary[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(If[Head@#===Plus,List@@#,List@#])&;
	Expr//=(#~Repartition~10)&;
	CacheContexts[];
	Expr//=Map[(xAct`Hamilcar`Private`NewParallelSubmit@(xAct`Hamilcar`Private`ComputeDivergence[#]))&,#]&;
	Expr//=MonitorParallel;
	Expr//=Total;
	Expr//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;
Expr];

(*Apparently the version only with derivatives was never working*)
(*MakeCurvatureReduction[InputExpr_]~Y~Module[{Expr,ReturnExpr={}},*)
(**)MakeCurvatureReduction[InputExpr_]~Y~Module[{Expr,ExprDenominator,ReturnExpr={InputExpr}},(**)
	{Expr,ExprDenominator}=InputExpr;
	While[
		(*Apparently the loop was never working*)
		(**)ReducibleQ@{Expr,ExprDenominator}(**)
		(*ReducibleQ@Expr*)
	,
		Expr//=(#~Delete~(First@Flatten@(#~Position~CD)))&;
		Expr//=(#~Delete~(First@Flatten@(#~Position~CD)))&;
		Expr~AppendTo~RicciCD;
		Expr//=Sort;
		ReturnExpr~AppendTo~{Expr,ExprDenominator};
	];
ReturnExpr];

ReducibleQ[InputExpr_]~Y~(((First@InputExpr)~Count~CD)>1);

CurvatureReduction[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(#/.{RicciCD->{CD,CD}})&;
	Expr//=(#/.{RicciScalarCD->{CD,CD}})&;
	Expr//=({Flatten@First@#,Last@#}&/@#)&;
	Expr//=(#~Cases~(_?ReducibleQ))&;
	Expr//=(MakeCurvatureReduction/@#)&;
	Expr//=(#~Flatten~1)&;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
	Expr//=(#~Join~InputExpr)&;
Expr];

CleanInputBracket[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Expand;
	Expr//=SymmetrizeCovDs;
	Expr//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;
Expr];

ExtractParameters[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Variables;
	Expr//=Cases[#,_?ConstantSymbolQ]&;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
Expr];

MinimiseExpr[InputExpr_,InputBulkAnsatzParameters_]~Y~Module[{Expr=InputExpr},
	Expr//=(InputBulkAnsatzParameters/.#)&;
	Expr//=Variables;
	Expr//=(InputBulkAnsatzParameters~Intersection~#)&;
	Expr//=((#->0)&/@#)&;
	Expr//=(#~Join~(InputExpr/.#))&;
Expr];

ListRescaledVariables[InputExpr_,
		InputRescalingRules_,
		InputBulkAnsatzParameters_,
		InputBoundaryAnsatzParameters_]~Y~Module[{Expr=InputRescalingRules,
	RescaledVariables,
	PristineVariables},
	RescaledVariables=Sort@DeleteDuplicates@(First/@InputRescalingRules);
	PristineVariables=(InputBulkAnsatzParameters~Join~InputBoundaryAnsatzParameters)~Complement~RescaledVariables;
	RescaledVariables//=(#~Intersection~(Variables@InputExpr))&;
	PristineVariables//=(#~Intersection~(Variables@InputExpr))&;
{RescaledVariables,PristineVariables}];

LeverageDimensionality[InputExpr_,
	InputRescalingRules_,
	InputBulkAnsatzParameters_,
	InputBoundaryAnsatzParameters_]~Y~Module[{Expr=InputExpr,
		ReducedEquation=InputExpr,
		RescaledVariables,
		PristineVariables,
		RescalingRules=InputRescalingRules},
	Expr//=(#/.InputRescalingRules)&;
	Expr//=(#/.{(LHS_==RHS_)->LHS-RHS})&;
	{RescaledVariables,PristineVariables}=ListRescaledVariables[
		Expr,
		InputRescalingRules,
		InputBulkAnsatzParameters,
		InputBoundaryAnsatzParameters];
	If[!(Length@RescaledVariables===0),
		Expr//=Module[{Expr=#},(Expr~Coefficient~#)&/@RescaledVariables]&;
		Expr//=PolynomialGCD@@#&;
		Expr//=FactorList;
		Expr//=(Power@@#&/@#)&;
		Expr//=DeleteCases[#,_?NumericQ]&;
		Expr//=Times@@#&;
		RescalingRules~AppendTo~Map[(#->Expr*#)&,PristineVariables];
		RescalingRules//=Flatten;
		RescalingRules//=DeleteDuplicates;
		RescalingRules//=Sort;	
	];
RescalingRules];

ImposeRescaling[InputExpr_,
		InputRescalingRules_,
		InputBulkAnsatzParameters_,
		InputBoundaryAnsatzParameters_]~Y~Module[{Expr=InputExpr,TotalFactor},
	Expr//=(#/.InputRescalingRules)&;
	Expr//=(#/.{(LHS_==RHS_)->LHS-RHS})&;
	TotalFactor=Expr;
	TotalFactor//=Module[{Expr=#},
		(Expr~Coefficient~#)&/@(InputBulkAnsatzParameters~Join~InputBoundaryAnsatzParameters)]&;
	TotalFactor//=PolynomialGCD@@#&;
	TotalFactor//=FactorList;
	TotalFactor//=(Power@@#&/@#)&;
	TotalFactor//=DeleteCases[#,_?NumericQ]&;
	TotalFactor//=Times@@#&;
	Expr/=TotalFactor;
	Expr//=(#==0)&;
	Expr//=Simplify;
Expr];

RescaleFullSystem[InputExpr_,
		InputBulkAnsatzParameters_,
		InputBoundaryAnsatzParameters_]~Y~Module[{Expr=InputExpr,
		RescalingRules,OldRescalingRules,$KeepRescaling},
	Expr//=(#/.{And->List})&;
	Expr//=Sort;
	RescalingRules=MapThread[(#1->#2)&,
		{InputBulkAnsatzParameters,
		InputBulkAnsatzParameters}];
	$KeepRescaling=True;
	While[$KeepRescaling,
		OldRescalingRules=RescalingRules;
		(RescalingRules=LeverageDimensionality[#,
			RescalingRules,
			InputBulkAnsatzParameters,
			InputBoundaryAnsatzParameters])&/@Expr;
		If[(Length@RescalingRules)===(Length@OldRescalingRules),
			$KeepRescaling=False,
			$KeepRescaling=True];
	];
	Expr//=(ImposeRescaling[#,
		RescalingRules,
		InputBulkAnsatzParameters,
		InputBoundaryAnsatzParameters]&/@#)&;
Expr];

FindAlgebra::NoSolution="No solution could be found. Try a different schematic ansatz or a different \"Method\".";
SolveWithSolve[InputExpr_,InputAnsatzParameters_]~Y~Module[{Expr=InputExpr},
	(*Expr//=(#~Reduce~InputAnsatzParameters)&;*)
	(*Expr//=Quiet[(#~Solve~InputAnsatzParameters)]&;*)
	Expr//=Solve;
	(Expr//=First)~Check~(Throw@Message@FindAlgebra::NoSolution);
Expr];

SolveWithLinearSolve[InputExpr_,
	InputBulkAnsatzParameters_,
	InputBoundaryAnsatzParameters_]~Y~Module[{Expr=InputExpr},
	Expr//=(#~CoefficientArrays~(InputBulkAnsatzParameters~Join~InputBoundaryAnsatzParameters))&;
	Expr//=Normal;
	(Expr//=((Last@#)~LinearSolve~(First@#))&)~Check~(Throw@Message@FindAlgebra::NoSolution);
	Expr//=MapThread[(#1->-#2)&,{(InputBulkAnsatzParameters~Join~InputBoundaryAnsatzParameters),#}]&;
Expr];

Options@ObtainSolution={Method->Solve};
ObtainSolution[InputExpr_,
	InputBulkAnsatzParameters_,
	InputBoundaryAnsatzParameters_,
	OptionsPattern[]]~Y~Module[{
	Expr=InputExpr,
	BulkAnsatzParameters=InputBulkAnsatzParameters,
	BoundaryAnsatzParameters=InputBoundaryAnsatzParameters},
	(*Expr//Print;*)
	(*Print/@(List@@Expr);*)
	Expr//=ToConstantSymbolEquations[#==0]&;
	(*Expr//=RescaleFullSystem[#,
			InputBulkAnsatzParameters,
			InputBoundaryAnsatzParameters]&;*)
	Switch[OptionValue@Method,
		Solve,
		Expr//=(#~SolveWithSolve~(BulkAnsatzParameters~Join~BoundaryAnsatzParameters))&,
		LinearSolve,
		Expr//=SolveWithLinearSolve[#,
			BulkAnsatzParameters,
			BoundaryAnsatzParameters]&];
	Expr//=(#~MinimiseExpr~(BulkAnsatzParameters~Join~BoundaryAnsatzParameters))&;
Expr];

ObtainEffectiveSmearingFunctions[InputBulkBracket_]~Y~Module[{Expr=InputBulkBracket,
		AllVariables,
		EffectiveSmearingFunctions},
	Expr//=Expand;
	Expr//=(If[Head@#===Plus,List@@#,List@#])&;
	Expr//=Block[{CD,Expr=#},
		CD[AnyInd___]@AnyVar_:=AnyVar;
		Expr//=Variables;
		Expr//=(#~Complement~Cases[#,_?ConstantSymbolQ])&;
		Expr//=(Head/@#)&;
		Expr//=Sort;
		Expr]&/@#&;
	AllVariables=Expr;
	AllVariables//=Flatten;
	AllVariables//=DeleteDuplicates;
	AllVariables//=Sort;
	EffectiveSmearingFunctions={};
	If[(DeleteDuplicates@(Count[#,SpecVar]&/@Expr)==={1}),EffectiveSmearingFunctions~AppendTo~SpecVar]~Table~{SpecVar,AllVariables};
	EffectiveSmearingFunctions//=(IndexFree/@#)&;
	EffectiveSmearingFunctions//=(FromIndexFree/@#)&;
EffectiveSmearingFunctions];

SmearingVarD[InputExpr_,InputEffectiveSmearingFunction_]~Y~Module[{Expr=InputExpr},
	Expr//=VarD[InputEffectiveSmearingFunction,CD];
	Expr//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;
	Expr//=ScreenDollarIndices;
Expr];

FindAlgebra::Unverified="Unverified with respect to the effective smearing function `1`.";
VerifyWithRespectToEffectiveSmearingFunction[InputBulkBracket_,
	InputBulkAnsatz_,
	InputEffectiveSmearingFunction_]~Y~Module[{BulkBracket=InputBulkBracket,
		BulkAnsatz=InputBulkAnsatz,TotalDifference},
	BulkBracket//=(#~SmearingVarD~InputEffectiveSmearingFunction)&;
	BulkAnsatz//=(#~SmearingVarD~InputEffectiveSmearingFunction)&;
	TotalDifference=BulkBracket-BulkAnsatz;
	TotalDifference//=CollectTensors[#,CollectMethod->ToSymmetrizedCanonical]&;
	(*TotalDifference//Print;*)
	If[TotalDifference===0,
		Print@("** Verified with respect to the effective smearing function "<>ToString@InputEffectiveSmearingFunction<>".");
	,
		(FindAlgebra::Unverified)~Message~(InputEffectiveSmearingFunction);
	];
];

VerifyResult[InputBulkBracket_,
	InputBulkAnsatz_]~Y~Module[{BulkBracket=InputBulkBracket,
		BulkAnsatz=InputBulkAnsatz,
		EffectiveSmearingFunctions=InputBulkBracket},

	EffectiveSmearingFunctions//=ObtainEffectiveSmearingFunctions;
	VerifyWithRespectToEffectiveSmearingFunction[BulkBracket,
		BulkAnsatz,#]&/@EffectiveSmearingFunctions;
];

ConstantCoefficientQ[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Variables;
	Expr//=(ConstantSymbolQ/@#)&;
	Expr//=(And@@#)&;
Expr];

MakeSchematic[InputExpr_]~Y~Module[{Expr=InputExpr,Denominators},
	Expr//=FactorList;
	Denominators=Expr~Cases~(_?PartOfDenominatorQ);
	If[Denominators==={},
		Denominators=1;
	,
		Denominators//=(Power@@#&/@#)&;
		Denominators//=Times@@#&;
	];
	Expr//=(#~DeleteCases~(_?PartOfDenominatorQ))&;
	Expr//=(Power@@#&/@#)&;
	Expr//=DeleteCases[#,_?NumericQ]&;
	Expr//=DeleteCases[#,_?ConstantCoefficientQ]&;
	(*May be necessary to stiffen this up for other constant coefficients*)
	Expr//=Times@@#&;
	Expr//=ToIndexFree;
	Expr//=(#/.{IndexFree->Identity})&;
	Expr//=FactorList;
	Expr//=((First@#)~ConstantArray~(Last@#))&/@#&;
	Expr//=DeleteCases[#,{1}]&;
	Expr//=Block[{CD,Expr=#},
		CD[AnyHead_]:={CD,AnyHead};Expr//=Flatten;Expr]&/@#&;
{Expr,Denominators}];

(*MakeBasicSchematic[InputExpr_]~Y~Module[{Expr=InputExpr,Denominators},
	Expr//=FactorList;
	Denominators=Expr~Cases~(_?PartOfDenominatorQ);
	If[Denominators==={},
		Denominators=1;
	,
		Denominators//=(Power@@#&/@#)&;
		Denominators//=Times@@#&;
	];
	Expr//=(#~DeleteCases~(_?PartOfDenominatorQ))&;
	Expr//=(Power@@#&/@#)&;
	Expr//=DeleteCases[#,_?NumericQ]&;
	Expr//=DeleteCases[#,_?ConstantCoefficientQ]&;
	(*May be necessary to stiffen this up for other constant coefficients*)
	Expr//=Times@@#&;
	Expr//=ToIndexFree;
	Expr//=(#/.{IndexFree->Identity})&;
{Expr,Denominators}];

RecoverBasicSchematicAnsatz[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Expand;
	Expr//=(If[Head@#===Plus,List@@#,List@#])&;
	Expr//=(MakeBasicSchematic/@#)&;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
Expr];*)

RecoverSchematicAnsatz[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Expand;
	Expr//=(If[Head@#===Plus,List@@#,List@#])&;
	Expr//=(MakeSchematic/@#)&;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
Expr];

PartOfDenominatorQ[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Last;
	Expr//=(#<0)&;
Expr];

MakeBasicSchematic[InputExpr_]~Y~Module[{Expr=InputExpr,Denominators},
	Expr//=FactorList;
	Denominators=Expr~Cases~(_?PartOfDenominatorQ);
	If[Denominators==={},
		Denominators=1;
	,
		Denominators//=(Power@@#&/@#)&;
		Denominators//=Times@@#&;
	];
	Expr//=(#~DeleteCases~(_?PartOfDenominatorQ))&;
	Expr//=(Power@@#&/@#)&;
	Expr//=DeleteCases[#,_?NumericQ]&;
	Expr//=DeleteCases[#,_?ConstantCoefficientQ]&;
	(*May be necessary to stiffen this up for other constant coefficients*)
	Expr//=Times@@#&;
	Expr//=ToIndexFree;
	Expr//=(#/.{IndexFree->Identity})&;
{Expr,Denominators}];

RecoverBasicSchematicAnsatz[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=Expand;
	Expr//=(If[Head@#===Plus,List@@#,List@#])&;
	Expr//=(MakeBasicSchematic/@#)&;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
Expr];

SplitConstructDDIs[InputExpr_]:=Module[{Expr,ExprDenominator,ExprNumerator},
	{ExprNumerator,ExprDenominator}=InputExpr;
	Expr=ExprNumerator;
	Expr//=IndexFree;
	Expr//=ConstructDDIs;
	Expr*=ExprDenominator;
Expr];

MakeBasicDDIs[InputExpr_]~Y~Module[{Expr=InputExpr},
	CacheContexts[];
	Expr//=Map[(xAct`Hamilcar`Private`NewParallelSubmit@(SplitConstructDDIs[#]))&,#]&;
	Expr//=MonitorParallel;	
	Expr//=Flatten;
	Expr//=DeleteDuplicates;
	Expr//=Sort;
	Expr//=MakeAnsatz[#,ConstantPrefix->"K"]&;
Expr];

NumFreeIndices[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=IndexFree;
	Expr//=FromIndexFree;
	Expr//=(List@@#)&;
	Expr//=Length;
Expr];

MakeReduction[InputList_,TargetVariable_,ExprDenominator_]~Y~Module[{
		Expr=InputList,
		VarNumber,
		IndNumber,
		MaxIndNumber},

	VarNumber=Expr[[1]]~Count~TargetVariable;
	IndNumber=TargetVariable;
	IndNumber//=NumFreeIndices;
	If[VarNumber>=1,
		VarNumber+=1;
		VarNumber//=(#~Min~$MaxPowerNumber)&;
		Expr//=Table[
			MaxIndNumber=#;
			MaxIndNumber[[1]]//=(#~DeleteCases~
				TargetVariable)&;
			MaxIndNumber[[2]]//=(#~DeleteCases~
				TargetVariable)&;
			MaxIndNumber[[1]]//=(NumFreeIndices/@#)&;
			MaxIndNumber[[2]]//=(NumFreeIndices/@#)&;
			MaxIndNumber~AppendTo~(Length@MaxIndNumber[[2]]);
			MaxIndNumber//=Flatten;
			MaxIndNumber//=Total;
			MaxIndNumber+=1;
			MaxIndNumber+=IndNumber*FreeNumber;
			Table[
				Module[{ReducedExpr=#,MultiTensor},
					ReducedExpr[[1]]//=(#~DeleteCases~
						TargetVariable)&;
					ReducedExpr[[1]]~AppendTo~
						(TargetVariable~ConstantArray~
							FreeNumber);
					ReducedExpr[[1]]//=Flatten;
					MultiTensor=ToExpression@(ToString@TargetVariable<>
							ToString@(VarNumber-
								FreeNumber)<>
							ToString@ReducedIndNumber);	
					$RequiredMultiTensors~AppendTo~MultiTensor;
					ReducedExpr[[2]]//=(#/.{TargetVariable->
						MultiTensor})&;	
					ReducedExpr[[2]]//=(CD/@#)&;
					ReducedExpr//=Flatten;
					ReducedExpr//=Sort;
					ReducedExpr//=(Times@@#)&;
					ReducedExpr//=IndexFree;
					ReducedExpr//={#,ExprDenominator}&;
				ReducedExpr]
			,
				{ReducedIndNumber,MaxIndNumber~Min~
					(IndNumber*(VarNumber-FreeNumber)),0,-2}
			]
		,
			{FreeNumber,0,VarNumber-2}
		]&;
		Expr//Return;
	];
];

ProcessTerm[InputExpr_]~Y~Module[{Expr,ExprDenominator},
	(**){Expr,ExprDenominator}=InputExpr;(**)
	(*InputExpr//Print;*)
	(*Expr=InputExpr;*)
	Expr//=(#/.{Times->List})&;
	Derivs=Select[Expr,Head@#===CD&];
	Expr//=DeleteCases[#,_?((Head@#===CD)&)]&;
	Expr//={#,Derivs}&;
	If[Length@Last@Expr>0,
		Expr[[1]]//=(#/.{Power->ConstantArray})&;
		Expr[[1]]//=Flatten;
		Expr[[1]]//=Sort;
		Expr[[2]]//=(#/.{CD->Identity})&;
		Expr[[2]]//=Sort;
		Expr=MakeReduction[Expr,#,ExprDenominator]&/@Expr[[2]];
		(*Expr//=({#,ExprDenominator}&/@#)&;*)
		Expr//Return;
	];
];

RemoveHigherDerivatives[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(#/.{CD@CD@AnyExpr___->0})&;
Expr];

ExtractPowerGradients[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=(RemoveHigherDerivatives/@#)&;
	Expr//=(#~Cases~(_?(((Head@First@#)===Times)&)))&;
	$RequiredMultiTensors={};
	(*Expr//=(First/@#)&;*)
	Expr//=(ProcessTerm/@#)&;
	$RequiredMultiTensors//=DeleteDuplicates;
	$RequiredMultiTensors//=Sort;
	Expr//=(#~Flatten~3)&;
	Expr//=(#~DeleteCases~Null)&;
Expr];

SplitAllContractions[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=First;
	Expr//=AllContractions;
	Expr//=((#*Last@InputExpr)&/@#)&;
Expr];

DevelopAllScalars[InputExpr_]~Y~Module[{Expr=InputExpr},
	CacheContexts[];
	Expr//=Map[(xAct`Hamilcar`Private`NewParallelSubmit@(SplitAllContractions[#]))&,#]&;
	Expr//=MonitorParallel;
Expr];

DevelopDDIs[InputExpr_]:=Module[{Expr=InputExpr,
	OriginalHead,PowerNumber,IndNumber,IndExample},
	{OriginalHead,PowerNumber,IndNumber}=$RegisteredPowers@Expr;
	Expr=OriginalHead^PowerNumber;
	Expr//=IndexFree;
	IndExample=Alphabet[];
	IndExample//=(ToExpression/@#)&;
	IndExample//=(#~Take~(-IndNumber))&;
	IndExample//=(IndexList@@#)&;
	Expr//=(#~ConstructDDIs~IndExample)&;
	Expr//=ContractMetric;
	Expr//=ToCanonical;
	Expr//=ScreenDollarIndices;
Expr];

DevelopAllDDIs[InputExpr_]~Y~Module[{Expr=InputExpr},
	CacheContexts[];
	Expr//=Map[(xAct`Hamilcar`Private`NewParallelSubmit@(xAct`Hamilcar`Private`DevelopDDIs[#]))&,#]&;
	Expr//=MonitorParallel;
	Expr//=(#/.{{}->{0}})&;
Expr];

DDIsToMultiTensorRules[InputTensorPower_,InputExpr_]:=Module[{
	TensorPower=InputExpr,
	Expr=InputExpr},
	TensorPower//=FindFreeIndices;
	If[TensorPower===IndexList@AnyIndices,
		TensorPower=FromIndexFree@IndexFree@InputTensorPower;
	,
		TensorPower//=(InputTensorPower@@#)&;
	];
	Expr//=MakeRule[{Evaluate@TensorPower,
		Evaluate@#},MetricOn->All,ContractMetrics->True]&;	
Expr];

AllDDIsToMultiTensorRules[InputExpr_]~Y~Module[{Expr=InputExpr,
	AllRules},
	CacheContexts[];
	Expr//=MapThread[
		MapThread[
			(xAct`Hamilcar`Private`NewParallelSubmit@(xAct`Hamilcar`Private`DDIsToMultiTensorRules[#1,#2]))&,
			{#1,#2}]&,
		{MapThread[(#1~ConstantArray~(Length@#2))&,
			{$RequiredMultiTensors,#}],#}]&;
	Expr//=MonitorParallel;
	AllRules=<||>;
	MapThread[(AllRules@#1=#2)&,{$RequiredMultiTensors,Expr}];
AllRules];

WhichTensorPower[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=First;
	Expr//=Variables;
	Block[{CD},
		CD[AnyInd___]@AnyVar_:=AnyVar;
		Expr//=(Head/@#)&;
	];
	Expr//=(#~Intersection~$RequiredMultiTensors)&;
	Expr//=First;
Expr];

EnforceRule[InputExpr_,InputRule_]:=Module[{Expr=InputExpr},
	Expr//=(#/.InputRule)&;
	Expr//=ContractMetric;
	Expr//=ToCanonical;
	Expr//=ScreenDollarIndices;
Expr];

OuterRules[InputExpr_,InputRules_]~Y~Module[{FullAnsatz,
	AllRules=InputExpr},
	AllRules//=(WhichTensorPower/@#)&;
	AllRules//=(InputRules/@#)&;
	CacheContexts[];
	FullAnsatz=MapThread[
		Outer[
			(xAct`Hamilcar`Private`NewParallelSubmit@(xAct`Hamilcar`Private`EnforceRule[#1,#2]))&,
			#1,#2,1
		]&
	,
		{InputExpr,AllRules}
	];
	FullAnsatz//=MonitorParallel;
	FullAnsatz//=Flatten;
	FullAnsatz//=DeleteDuplicates;
	FullAnsatz//=(#~DeleteCases~0)&;
	FullAnsatz//=Sort;
	FullAnsatz//=MakeAnsatz[#,ConstantPrefix->"J"]&;
FullAnsatz];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra/SchematicForm/ToNonNumericIndexFree.m`:

```m
(*=========================*)
(*  ToNonNumericIndexFree  *)
(*=========================*)

ToNonNumericIndexFree[InputExpr_]~Y~Module[{Expr=InputExpr},
	(*ConstantSymbolQ does seem defined in xAct*)
	Expr//=ToIndexFree;
	Expr//=Identity@@#&;
	Expr//=FactorList;
	Expr//=(Power@@#&/@#)&;
	Expr//=DeleteCases[#,_?NumericQ]&;
	Expr//=Times@@#&;
	Block[{CD},
		CD[AnyExpr_]:=DummyCD*AnyExpr;
		Expr//=FullSimplify;
	];
	Expr//=ToIndexFree;
Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/FindAlgebra/ToHigherDerivativeCanonical.m`:

```m
(*===============================*)
(*  ToHigherDerivativeCanonical  *)
(*===============================*)

ToHigherDerivativeCanonical[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
	Expr//=SymmetrizeCovDs;
	Expr//=ExpandSymCovDs;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
	(*Expr//=FullSimplification[];*)
	Expr//=(#/.CurvatureRelationsBianchi@CD)&;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket.m`:

```m
(*==================*)
(*  PoissonBracket  *)
(*==================*)

IncludeHeader@"DefSmearingTensor";
IncludeHeader@"CacheContexts";
IncludeHeader@"MonomialPoissonBracket";
IncludeHeader@"../ReloadPackage/MonitorParallel";

Options@PoissonBracket={Parallel->True};

PoissonBracket[InputOperatorOne_,InputOperatorTwo_,OptionsPattern[]]~Y~Module[{
	Expr,
	SmearingTwo,
	SmearingOne,
	OperatorOne=InputOperatorOne,
	OperatorTwo=InputOperatorTwo,
	CallStack,
	ParallelValue=OptionValue@Parallel},
	
	If[!xAct`Hamilcar`Private`$CLI,
		CallStack=PrintTemporary@Dynamic@Refresh[
			GUICallStack@$CallStack,
			TrackedSymbols->{$CallStack}];
	];
	
	If[!$ManualSmearing,
		SmearingOne="SmearingOne"<>(ResourceFunction@"RandomString")@5;
		SmearingOne//=(#~DefSmearingOneTensor~OperatorOne)&;
		OperatorOne*=SmearingOne;
	];
	OperatorOne//=ReplaceDummies;
	OperatorOne//=TotalFrom;

	If[!$ManualSmearing,
		SmearingTwo="SmearingTwo"<>(ResourceFunction@"RandomString")@5;
		SmearingTwo//=(#~DefSmearingTwoTensor~OperatorTwo)&;
		OperatorTwo*=SmearingTwo;
	];
	OperatorTwo//=ReplaceDummies;	
	OperatorTwo//=TotalFrom;
	
	If[ParallelValue,
		CacheContexts[];
	];
	(*If[ParallelValue && !ContextsCachedQ[],
		CacheContexts[];
	];*)

	Module[{LeibnizArray,ExpandedOperatorOne,ExpandedOperatorTwo},
		ExpandedOperatorOne=Expand[OperatorOne];
		ExpandedOperatorOne=(If[Head@#===Plus,List@@#,List@#])&@ExpandedOperatorOne;
		
		ExpandedOperatorTwo=Expand[OperatorTwo];
		ExpandedOperatorTwo=(If[Head@#===Plus,List@@#,List@#])&@ExpandedOperatorTwo;
	
		If[ParallelValue,
			LeibnizArray=Outer[
				(xAct`Hamilcar`Private`NewParallelSubmit@(xAct`Hamilcar`Private`MonomialPoissonBracket[#1,#2]))&,
				ExpandedOperatorOne,ExpandedOperatorTwo,1
			];
			LeibnizArray//=MonitorParallel;
		,
			LeibnizArray=Outer[
				MonomialPoissonBracket[#1,#2]&,
				ExpandedOperatorOne,ExpandedOperatorTwo,1
			];
		];
		
		If[LeibnizArray==={{0}},
			Expr=0,
			Expr=Total[LeibnizArray~Flatten~1];
		];
	];
	Expr//=Recanonicalize;
	If[!xAct`Hamilcar`Private`$CLI,
		FinishDynamic[];
		NotebookDelete@CallStack;
	];
Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/CacheContexts.m`:

```m
(*=================*)
(*  CacheContexts  *)
(*=================*)

CacheContexts[]:=Module[{NewContextList={
	"Global`",
	"xAct`Hamilcar`",
	"xAct`Hamilcar`Private`",
	"xAct`xTensor`",
	"xAct`xTensor`Private`",
	"xAct`xCore`",
	"xAct`xPerm`",
	"xAct`SymManipulator`",
	"TangentM3`"},
	LoadContexts,
	NewContextFileList},

	NewContextFileList=Module[{FileName=CreateFile[]},
		DumpSave[FileName,#];FileName]&/@NewContextList;

	$KernelsLaunched=False;
	While[!$KernelsLaunched,
		TimeConstrained[
			CloseKernels[];
			Off[LaunchKernels::nodef];
			LaunchKernels[$ProcessorCount];
			On[LaunchKernels::nodef];

			LoadContexts=({NewContextFileList}~NewParallelSubmit~(Off@(RuleDelayed::rhs);Get/@NewContextFileList;On@(RuleDelayed::rhs);))~Table~{TheKernel,$KernelCount};
			LoadContexts//=MonitorParallel;	
			DeleteFile/@NewContextFileList;
			$KernelsLaunched=True;
		,
			360
		];
	];
];

(* Function to check if contexts are cached *)
ContextsCachedQ[] ~Y~ Module[{TestResult},
	(* Check if kernels exist *)
	If[Length[Kernels[]] == 0, Return[False]];
	
	(* Test if Hamilcar context exists on all kernels *)
	TestResult = ParallelEvaluate[
		MemberQ[$Packages, "xAct`Hamilcar`"]
	];
	And @@ TestResult
];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/DefSmearingTensor.m`:

```m
(*=====================*)
(*  DefSmearingTensor  *)
(*=====================*)

$SmearingSymbols={"\[Alpha]","\[Beta]"};
$SmearScalars=True;
DefSmearingOneTensor[InputSmearing_,InputOperand_]~Y~Module[{FreeIndices},
	FreeIndices=(-#)&/@(FindFreeIndices@(Evaluate@InputOperand));
	If[!$SmearScalars&&Length@FreeIndices==0,Return@1];
	DefTensor[((Symbol@InputSmearing)@@FreeIndices),M3,PrintAs->First@$SmearingSymbols];
(Symbol@InputSmearing)@@FreeIndices];

DefSmearingTwoTensor[InputSmearing_,InputOperand_]~Y~Module[{FreeIndices},
	FreeIndices=(-#)&/@(FindFreeIndices@(Evaluate@InputOperand));
	If[!$SmearScalars&&Length@FreeIndices==0,Return@1];
	DefTensor[((Symbol@InputSmearing)@@FreeIndices),M3,PrintAs->Last@$SmearingSymbols];
(Symbol@InputSmearing)@@FreeIndices];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/MonomialPoissonBracket.m`:

```m
(*==========================*)
(*  MonomialPoissonBracket  *)
(*==========================*)

IncludeHeader@"ToDensities";

MonomialPoissonBracket[OperatorOne_,OperatorTwo_]~Y~Module[{
	Expr=0,
	GExpr=0},

	(* Field-momentum cross-terms *)
	Module[{RegisteredMomentum=#1,RegisteredField=#2},
		RegisteredMomentum//=ToIndexFree;
		RegisteredMomentum//=FromIndexFree;
		RegisteredField//=ToIndexFree;
		RegisteredField//=FromIndexFree;

		Expr+=VarD[#1,CD][OperatorOne]*VarD[#2,CD][OperatorTwo];
		Expr-=VarD[#1,CD][OperatorTwo]*VarD[#2,CD][OperatorOne];
	]&~MapThread~{$RegisteredFields,$RegisteredMomenta};

	(* Metric sector contributions *)
	If[$DynamicalMetric,
		GExpr+=TensorsToDensities@Times[VarD[G[-a,-b],
			CD][OperatorOne//DensitiesToTensors],
			VarD[ConjugateMomentumG[a,b],CD][OperatorTwo]];
		GExpr-=TensorsToDensities@Times[VarD[G[-a,-b],
			CD][OperatorTwo//DensitiesToTensors],
			VarD[ConjugateMomentumG[a,b],CD][OperatorOne]];
		Module[{ConjugateTensorMomentum=RegisteredTensorMomentum},
			ConjugateTensorMomentum//=ToIndexFree;
			ConjugateTensorMomentum//=FromIndexFree;
			GExpr+=TensorsToDensities@Times[ConjugateTensorMomentum,
				-VarD[G[-x,-y],CD][Sqrt[DetG[]]]/Sqrt[DetG[]],
				VarD[ConjugateTensorMomentum,
					CD][OperatorOne//DensitiesToTensors],
				VarD[ConjugateMomentumG[x,y],CD][OperatorTwo]];
			GExpr-=TensorsToDensities@Times[ConjugateTensorMomentum,
				-VarD[G[-x,-y],CD][Sqrt[DetG[]]]/Sqrt[DetG[]],
				VarD[ConjugateTensorMomentum,
					CD][OperatorTwo//DensitiesToTensors],
				VarD[ConjugateMomentumG[x,y],CD][OperatorOne]];
		]~Table~{RegisteredTensorMomentum,
			$RegisteredTensorMomenta~Append~TensorConjugateMomentumG};
	];

	(* Combine and recanonicalise *)
	Expr+=GExpr;
	Expr//=Recanonicalize;

Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/MonomialPoissonBracket/ToDensities.m`:

```m
(*===============*)
(*  ToDensities  *)
(*===============*)

DensitiesToTensors[InputMyExpr_]~Y~Module[{
	MyExpr=InputMyExpr,
	DensitiesToTensorsRules},

	DensitiesToTensorsRules=Module[
		{ConjugateMomentum=#1,
		ConjugateTensorMomentum=#2},

		ConjugateMomentum//=ToIndexFree;
		ConjugateMomentum//=FromIndexFree;
		ConjugateTensorMomentum//=ToIndexFree;
		ConjugateTensorMomentum//=FromIndexFree;
		MakeRule[{Evaluate@ConjugateMomentum,
			Evaluate@(Sqrt[DetG[]]*ConjugateTensorMomentum)},
			MetricOn->All,
			ContractMetrics->True
		]
	]&~MapThread~{$RegisteredMomenta~Append~ConjugateMomentumG,
		$RegisteredTensorMomenta~Append~TensorConjugateMomentumG};
	DensitiesToTensorsRules//=Flatten;
	MyExpr//=(#/.DensitiesToTensorsRules)&;
	MyExpr//=ToCanonical;
	MyExpr//=ContractMetric;
	MyExpr//=ScreenDollarIndices;
MyExpr];

TensorsToDensities[InputMyExpr_]~Y~Module[{
	MyExpr=InputMyExpr,
	TensorsToDensitiesRules},

	TensorsToDensitiesRules=Module[
		{ConjugateMomentum=#1,
		ConjugateTensorMomentum=#2},

		ConjugateMomentum//=ToIndexFree;
		ConjugateMomentum//=FromIndexFree;
		ConjugateTensorMomentum//=ToIndexFree;
		ConjugateTensorMomentum//=FromIndexFree;
		MakeRule[{Evaluate@ConjugateTensorMomentum,
			Evaluate@(ConjugateMomentum/Sqrt[DetG[]])},
			MetricOn->All,
			ContractMetrics->True
		]
	]&~MapThread~{$RegisteredMomenta~Append~ConjugateMomentumG,
		$RegisteredTensorMomenta~Append~TensorConjugateMomentumG};
	TensorsToDensitiesRules//=Flatten;
	MyExpr//=(#/.TensorsToDensitiesRules)&;
	MyExpr//=ToCanonical;
	MyExpr//=ContractMetric;
	MyExpr//=ScreenDollarIndices;
MyExpr];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/MultiCD.m`:

```m
(*===========*)
(*  MultiCD  *)
(*===========*)

MultiCD[Inds___][InputExpr_]:=Module[{
	Expr=InputExpr},	
	(Expr//=CD[#])&/@(Reverse@List@Inds);
Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/SemiD.m`:

```m
(*=========*)
(*  SemiD  *)
(*=========*)

SemiD[Inds___][InputOperand_,DerOrd_,InputTensor_]:=Module[{
	InputTensorHead=Head@InputTensor,
	FreInd=List@Inds,
	TenInd,
	DerInd,
	IneExp,
	DerExp=InputOperand},

	TenInd=InputTensor/.{InputTensorHead->List};
	DerInd=(ToExpression/@(Alphabet[]~RotateLeft~13))~Take~(-(DerOrd-Length@FreInd));
	IneExp=("CD"~StringRepeat~DerOrd)<>ToString@InputTensorHead;
	IneExp//=ToExpression;
	IneExp//=((#)@@(DerInd~Join~(Minus/@FreInd)~Join~TenInd))&;
	DerExp//=VarD[IneExp,CD];	
	(DerExp//=CD[#])&/@(Reverse@DerInd);
	DerExp*=(-1)^DerOrd;
	DerExp//=ReplaceDummies;
DerExp];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/ToDensities.m`:

```m
(*===============*)
(*  ToDensities  *)
(*===============*)

DensitiesToTensors[InputMyExpr_]:=Module[{
	MyExpr=InputMyExpr,
	DensitiesToTensorsRules},

	DensitiesToTensorsRules=Module[
		{ConjugateMomentum=#1,
		ConjugateTensorMomentum=#2},

		ConjugateMomentum//=ToIndexFree;
		ConjugateMomentum//=FromIndexFree;
		ConjugateTensorMomentum//=ToIndexFree;
		ConjugateTensorMomentum//=FromIndexFree;
		MakeRule[{Evaluate@ConjugateMomentum,
			Evaluate@(Sqrt[DetG[]]*ConjugateTensorMomentum)},
			MetricOn->All,
			ContractMetrics->True
		]
	]&~MapThread~{$RegisteredMomenta~Append~ConjugateMomentumG,
		$RegisteredTensorMomenta~Append~TensorConjugateMomentumG};
	DensitiesToTensorsRules//=Flatten;
	MyExpr//=(#/.DensitiesToTensorsRules)&;
	MyExpr//=ToCanonical;
	MyExpr//=ContractMetric;
	MyExpr//=ScreenDollarIndices;
MyExpr];

TensorsToDensities[InputMyExpr_]:=Module[{
	MyExpr=InputMyExpr,
	TensorsToDensitiesRules},

	TensorsToDensitiesRules=Module[
		{ConjugateMomentum=#1,
		ConjugateTensorMomentum=#2},

		ConjugateMomentum//=ToIndexFree;
		ConjugateMomentum//=FromIndexFree;
		ConjugateTensorMomentum//=ToIndexFree;
		ConjugateTensorMomentum//=FromIndexFree;
		MakeRule[{Evaluate@ConjugateTensorMomentum,
			Evaluate@(ConjugateMomentum/Sqrt[DetG[]])},
			MetricOn->All,
			ContractMetrics->True
		]
	]&~MapThread~{$RegisteredMomenta~Append~ConjugateMomentumG,
		$RegisteredTensorMomenta~Append~TensorConjugateMomentumG};
	TensorsToDensitiesRules//=Flatten;
	MyExpr//=(#/.TensorsToDensitiesRules)&;
	MyExpr//=ToCanonical;
	MyExpr//=ContractMetric;
	MyExpr//=ScreenDollarIndices;
MyExpr];

```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage.m`:

```m
(*=================*)
(*  ReloadPackage  *)
(*=================*)

ReadAtRuntime@"DefGeometry";
IncludeHeader@"NewParallelSubmit";
IncludeHeader@"MonitorParallel";
IncludeHeader@"StackSetDelayed";
IncludeHeader@"CallStackBegin";
IncludeHeader@"CallStackEnd";
IncludeHeader@"CLICallStack";

ReloadPackage[]:=Module[{},
	If[$NotLoaded,
		DefGeometry[];
		Begin@"xAct`Hamilcar`Private`";
			RereadSources[];
		End[];
		$NotLoaded=False;,Null,
		DefGeometry[];
		Begin@"xAct`Hamilcar`Private`";
			RereadSources[];
		End[];
		$NotLoaded=False;
	];
];

```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/CLICallStack.m`:

```m
(*================*)
(*  CLICallStack  *)
(*================*)

IncludeHeader@"Status";
IncludeHeader@"GUICallStack";

(*Do **not** use ~Y~ here*)
CLICallStack[]:=Module[{},
	(* Use explicit private context reference like PSALTer might be doing *)
	If[xAct`Hamilcar`Private`$CLI,
		Run@("echo -e \""<>Status@StringReplace[ToString@$CallStack,"`"->"\`"]<>"\"");
	];
];
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/CLICallStack/GUICallStack.m`:

```m
(*================*)
(*  GUICallStack  *)
(*================*)

(*Do **not** use ~Y~ here*)
TheProgressIndicator[]:=ProgressIndicator[Appearance->"Necklace",ImageSize->Small];
GUICallStack[CallStack_]:=Row[{TheProgressIndicator[],CallStack},
		Invisible@TheProgressIndicator[],
		Alignment->{Left,Center}];
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/CLICallStack/Status.m`:

```m
(*==========*)
(*  Status  *)
(*==========*)

(*Do **not** use ~Y~ here*)
Status[InputExpr_]:=Module[{OutputString},
	OutputString="\e[1;34;40m"<>InputExpr<>"\e[0m";
OutputString];
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/CallStackBegin.m`:

```m
(*==================*)
(*  CallStackBegin  *)
(*==================*)

$CallStackTrace=False;
CallStackBegin[]:=Module[{},
	$CallStackTrace=True;
	If[$CallStackTrace,
		DeleteFile[$CallStackTraceFileName];	
		$StackStream=List@OpenWrite[$CallStackTraceFileName,PageWidth->1000];
	];
];
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/CallStackEnd.m`:

```m
(*================*)
(*  CallStackEnd  *)
(*================*)
CallStackEnd[]:=Module[{Expr},
	If[$CallStackTrace,
		Close@First@$StackStream;
		Run@("sed -i 's/}/},/' \""<>$CallStackTraceFileName<>"\"");
		Run@("sed -i 's/^>> /\"{/' \""<>$CallStackTraceFileName<>"\"");
		Run@("sed -i 's/$/}\"/' \""<>$CallStackTraceFileName<>"\"");
		Run@("sed -i 's/\\$[0-9]*//g' \""<>$CallStackTraceFileName<>"\"");
		Expr=ReadList@$CallStackTraceFileName;
		Expr//=ToExpression/@#&;
		Expr//=(#~GroupBy~First)&;
		MapThread[(Expr@#1={(Last/@#2),Total@(Last/@#2)})&,
			{Keys@Expr,Values@Expr}];
		Expr//=(#~SortBy~Last)&;
		Expr//=Reverse;
		If[Length@Expr>$NumberOfCriticalPoints,
			Expr//=(#~Take~$NumberOfCriticalPoints)&];
		DataLength=Length@Expr;
		Expr//=Last/@#&;
		Expr=ListLogPlot[Values@Expr,
			Filling->Axis,
			ImageSize->Large,
			PlotStyle->Directive[PointSize[Large],Black],
			Background->White,
			PlotLabel->Style["Critical points in call stack trace (seconds)",
				FontColor->Black,FontSize->16],
			Ticks->{Transpose[{Range@DataLength,
				Column/@Transpose[{Range@DataLength,
					Rotate[ToString@Last@#,Pi/2]&/@(Keys@Expr)}]}],
			Automatic}
		];
		UsingFrontEnd@Export["call-stack-trace.pdf",Expr];
	];
	$CallStackTrace=False;
];
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/DefGeometry.m`:

```m
(*===============*)
(*  DefGeometry  *)
(*===============*)
DefManifold[M3,3,IndexRange[{a,z}]];
GSymb="\[ScriptH]";
(*Quiet@DefMetric[1,G[-a,-b],CD,{";","\!\(\*OverscriptBox[\(\[Del]\),\(_\)]\)"},*)
Quiet@DefMetric[1,G[-a,-b],CD,{";","\[Del]"},
	PrintAs->GSymb,SymCovDQ->True];
PrintAs@Evaluate@DetG^="\[ScriptH]";
DefCovD[CDT[-a],SymbolOfCovD->{"#","D"},FromMetric->G];

StandardIndices=ToString/@Alphabet[];
(*StandardIndicesSymb=(ToString@#)&/@Evaluate@((#[[2]])&/@{	
	{a,"\(\*OverscriptBox[\(\[Alpha]\),\(_\)]\)"},
	{b,"\(\*OverscriptBox[\(\[Beta]\),\(_\)]\)"},
	{c,"\(\*OverscriptBox[\(\[Chi]\),\(_\)]\)"},
	{d,"\(\*OverscriptBox[\(\[Delta]\),\(_\)]\)"},
	{e,"\(\*OverscriptBox[\(\[Epsilon]\),\(_\)]\)"},
	{f,"\(\*OverscriptBox[\(\[Phi]\),\(_\)]\)"},
	{g,"\(\*OverscriptBox[\(\[Gamma]\),\(_\)]\)"},
	{h,"\(\*OverscriptBox[\(\[Eta]\),\(_\)]\)"},
	{i,"\(\*OverscriptBox[\(\[Iota]\),\(_\)]\)"},
	{j,"\(\*OverscriptBox[\(\[Theta]\),\(_\)]\)"},
	{k,"\(\*OverscriptBox[\(\[Kappa]\),\(_\)]\)"},
	{l,"\(\*OverscriptBox[\(\[Lambda]\),\(_\)]\)"},
	{m,"\(\*OverscriptBox[\(\[Mu]\),\(_\)]\)"},
	{n,"\(\*OverscriptBox[\(\[Nu]\),\(_\)]\)"},
	{o,"\(\*OverscriptBox[\(\[Omicron]\),\(_\)]\)"},
	{p,"\(\*OverscriptBox[\(\[Pi]\),\(_\)]\)"},
	{q,"\(\*OverscriptBox[\(\[Omega]\),\(_\)]\)"},
	{r,"\(\*OverscriptBox[\(\[Rho]\),\(_\)]\)"},
	{s,"\(\*OverscriptBox[\(\[Sigma]\),\(_\)]\)"},
	{t,"\(\*OverscriptBox[\(\[Tau]\),\(_\)]\)"},
	{u,"\(\*OverscriptBox[\(\[Upsilon]\),\(_\)]\)"},
	{v,"\(\*OverscriptBox[\(\[Psi]\),\(_\)]\)"},
	{w,"\(\*OverscriptBox[\(\[Omega]\),\(_\)]\)"},
	{x,"\(\*OverscriptBox[\(\[Xi]\),\(_\)]\)"},
	{y,"\(\*OverscriptBox[\(\[CurlyPhi]\),\(_\)]\)"},
	{z,"\(\*OverscriptBox[\(\[Zeta]\),\(_\)]\)"}});*)

StandardIndicesSymb=(ToString@#)&/@Evaluate@((#[[2]])&/@{	
	{a,"\[ScriptA]"},{b,"\[ScriptB]"},{c,"\[ScriptC]"},{d,"\[ScriptD]"},{e,"\[ScriptE]"},{f,"\[ScriptF]"},{g,"\[ScriptG]"},{h,"\[ScriptH]"},{i,"\[ScriptI]"},{j,"\[ScriptJ]"},{k,"\[ScriptK]"},{l,"\[ScriptL]"},{m,"\[ScriptM]"},{n,"\[ScriptN]"},{o,"\[ScriptO]"},{p,"\[ScriptP]"},{q,"\[ScriptQ]"},{r,"\[ScriptR]"},{s,"\[ScriptS]"},{t,"\[ScriptT]"},{u,"\[ScriptU]"},{v,"\[ScriptV]"},{w,"\[ScriptW]"},{x,"\[ScriptX]"},{y,"\[ScriptY]"},{z,"\[ScriptZ]"}});

(PrintAs@Evaluate@#1^=Evaluate@#2)&~MapThread~{ToExpression/@StandardIndices,
	StandardIndicesSymb};

(*Define the momentum conjugate to the metric on the foliation*)
DefTimeTensor[ConjugateMomentumG[a,b],M3,
	Symmetric[{a,b}],PrintAs->"\[Pi]"];
DefTensor[TensorConjugateMomentumG[a,b],M3,
	Symmetric[{a,b}],PrintAs->"\[GothicCapitalT]\[Pi]"];

(*Define the powers of these canonical fields*)
xAct`Hamilcar`Private`DefPower[G,
	xAct`Hamilcar`Private`QuantitySymbol->"\[ScriptH]"];
xAct`Hamilcar`Private`DefPower[ConjugateMomentumG,
	xAct`Hamilcar`Private`QuantitySymbol->"\[Pi]"];

(*Define the time coordinate orthogonal to the foliation*)
DefConstantSymbol[Time,PrintAs->"\[ScriptT]"];
(*Define the time-dependent metric*)
DefTimeTensor[GTime[-a,-b],M3,
	Symmetric[{-a,-b}],PrintAs->GSymb];
(*Define the inverse of the time-dependent metric*)
DefTimeTensor[GTimeInverse[a,b],M3,
	Symmetric[{a,b}],PrintAs->"\[GothicH]"];
xAct`Hamilcar`Private`GToGTime=MakeRule[{G[-a,-b],GTime[-a,-b]},
	MetricOn->None,ContractMetrics->False];
xAct`Hamilcar`Private`GTimeToG=MakeRule[{GTime[-a,-b],G[-a,-b]},
	MetricOn->None,ContractMetrics->False];
xAct`Hamilcar`Private`GToGTimeInverse=MakeRule[{G[a,b],GTimeInverse[a,b]},
	MetricOn->All,ContractMetrics->True];
xAct`Hamilcar`Private`GTimeInverseToG=MakeRule[{GTimeInverse[a,b],G[a,b]},
	MetricOn->All,ContractMetrics->True];
AutomaticRules[GTimeInversep,
	MakeRule[{GTimeInversep[a,b],-GTimep[a,b]},
	MetricOn->All,ContractMetrics->True]];
(*Define a dummy covariant derivative for use in `FindAlgebra`*)
DefTensor[FloatingCD[-i],M3,PrintAs->"\[Del]"];
(*Simplify the Riemann curvature tensor in three dimensions*)
(*AutomaticRules[RiemannCD,*)
(*RiemannCDToRicciCD=*)
AutomaticRules[RiemannCD,MakeRule[{RiemannCD[-r,-s,-m,-n],G[-r,-m]*RicciCD[-s,-n]-G[-r,-n]*RicciCD[-s,-m]-G[-s,-m]*RicciCD[-r,-n]+G[-s,-n]*RicciCD[-r,-m]-(1/2)*(G[-r,-m]*G[-s,-n]-G[-r,-n]*G[-s,-m])*RicciScalarCD[]},MetricOn->All,ContractMetrics->True]];(**)
(*Define a dummy constraint for `CollectConstraints`*)
DefTensor[DummyConstraint[AnyIndices@TangentM3],M3];
(*Define a dummy measure for use in `FindAlgebra`*)
DefTensor[Measure[],M3];
(*Define a dummy reciprocal for use in `FindAlgebra`*)
DefTensor[GeneralReciprocal[],M3];
(*Define a collection of parameters for the boundary ansatz*)
DefConstantSymbol[ToExpression["s"<>ToString[i]]]~Table~{i,1,1000};
$AnsatzCoefficients=ToExpression["s"<>ToString[i]]~Table~{i,1,1000};
(*Initialize the rules for abbreviations*)
$FromRulesTotal={DummyVar->DummyVar};
$ToRulesTotal={DummyVar->DummyVar};

```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/MonitorParallel.m`:

```m
(*===================*)
(*  MonitorParallel  *)
(*===================*)

MonitorParallel[ParallelisedArray_]:=Module[{
	ParallelisedArrayValue},
	ParallelisedArrayValue=WaitAll@ParallelisedArray;
ParallelisedArrayValue];

```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/NewParallelSubmit.m`:

```m
(*=========================*)
(*  NewParallelSubmit  *)
(*=========================*)

NewParallelSubmit~SetAttributes~HoldAll;

NewParallelSubmit[Expr_]:=NewParallelSubmit[{},Expr];
NewParallelSubmit[{Vars___},Expr_]:=({Vars}~ParallelSubmit~Block[{Print=Null&,PrintTemporary=Null&},Expr]);

```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/StackSetDelayed.m`:

```m
(*===================*)
(*  StackSetDelayed  *)
(*===================*)

IncludeHeader@"NameOfFunction";
IncludeHeader@"StackStrip";

$DefinedFunctions={};
StackSetDelayed~SetAttributes~HoldAll;
(*Do **not** use ~Y~ here*)
(LHS_~StackSetDelayed~RHS_):=Module[{FunctionName=NameOfFunction@Unevaluated@LHS},
	$DefinedFunctions~AppendTo~FunctionName;
	LHS:=StackInhibit@Block[
		{EvaluatedOutputRHS,
		$StandardOutput=$Output,
		$Output},
			If[$CallStackTrace&&($KernelID==0),
				$Output=$StackStream;
				$CallStack=FunctionName;
				CLICallStack[];
				EvaluatedOutputRHS=EchoTiming[
					{$Output=$StandardOutput}~Block~RHS,
					StackStrip@(Stack[]~Append~FunctionName)
				];
			,
				$CallStack=FunctionName;
				CLICallStack[];
				EvaluatedOutputRHS={$Output=$StandardOutput}~Block~RHS;
			,
				$CallStack=FunctionName;
				CLICallStack[];
				EvaluatedOutputRHS={$Output=$StandardOutput}~Block~RHS;
			];
		EvaluatedOutputRHS];
];
Y=StackSetDelayed;
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/StackSetDelayed/NameOfFunction.m`:

```m
(*==================*)
(*  NameOfFunction  *)
(*==================*)

NameOfFunction[FunctionName_[___][___]]:=FunctionName;
NameOfFunction[FunctionName_[___]]:=FunctionName;
```

`Hamilcar/xAct/Hamilcar/Sources/ReloadPackage/StackSetDelayed/StackStrip.m`:

```m
(*==============*)
(*  StackStrip  *)
(*==============*)

StackStrip[RawStack_]:=Module[{Expr},
	Expr=(If[(Head@#===Symbol),#,(Head@#)]&/@RawStack);
	Expr=DeleteElements[Expr,Complement[Expr,$DefinedFunctions]];
Expr];
```

`Hamilcar/xAct/Hamilcar/Sources/RulesTotal.m`:

```m
(*==============*)
(*  RulesTotal  *)
(*==============*)

IncludeHeader@"Recanonicalize";

TotalFrom[InputExpr_]~Y~Module[{Expr=InputExpr},
	(Expr=Expr/.#;Expr//=Recanonicalize;)&/@$FromRulesTotal;
Expr];
TotalTo[InputExpr_]~Y~Module[{Expr=InputExpr},
	(Expr=Expr/.#;Expr//=Recanonicalize)&/@$ToRulesTotal;
Expr];
PrependTotalFrom[InputRule_]~Y~($FromRulesTotal~PrependTo~InputRule);
PrependTotalTo[InputRule_]~Y~($ToRulesTotal~PrependTo~InputRule);

```

`Hamilcar/xAct/Hamilcar/Sources/RulesTotal/Recanonicalize.m`:

```m
(*==================*)
(*  Recanonicalize  *)
(*==================*)

Recanonicalize[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=CollectTensors;
	If[!$DynamicalMetric,
		Expr//=SortCovDs;
		Expr//=(#/.RiemannCD->Zero)&;
		Expr//=(#/.RicciCD->Zero)&;
		Expr//=(#/.RicciScalarCD->Zero)&;
		Expr//=SymmetrizeCovDs;
		Expr//=ToCanonical;
		Expr//=(#/.RiemannCD->Zero)&;
		Expr//=(#/.RicciCD->Zero)&;
		Expr//=(#/.RicciScalarCD->Zero)&;
		Expr//=ExpandSymCovDs;
	];	
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=CollectTensors;
	Expr//=ScreenDollarIndices;
Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/TimeD.m`:

```m
(*=========*)
(*  TimeD  *)
(*=========*)

Options@DefTimeTensor={PrintAs->"\[Zeta]",Dagger->False};
DefTimeTensor[InputField_[Inds___],Manifold_,Opts___?OptionQ]:=DefTimeTensor[InputField[Inds],Manifold,GenSet[],Opts];
DefTimeTensor[InputField_[Inds___],Manifold_,SymmExpr_,OptionsPattern[]]:=Module[{},
	(*Print@(" ** DefTimeTensor: defining a Time-dependent tensor "<>ToString@InputField<>" Timeith Time-velocity "<>ToString@InputField<>"p"<>", Time-acceleration "<>ToString@InputField<>"pp"<>", Time-jerk "<>ToString@InputField<>"ppp"<>", Time-snap "<>ToString@InputField<>"pppp"<>", Time-crackle "<>ToString@InputField<>"ppppp"<>" and Time-pop "<>ToString@InputField<>"pppppp"<>"...");*)
	DefTensor[(Symbol@(ToString@InputField<>"p"))[Inds],
		M3,SymmExpr,PrintAs->(OptionValue@PrintAs<>"'")];
	DefTensor[(Symbol@(ToString@InputField<>"pp"))[Inds],
		M3,SymmExpr,PrintAs->(OptionValue@PrintAs<>"''")];
	DefTensor[(Symbol@(ToString@InputField<>"ppp"))[Inds],
		M3,SymmExpr,PrintAs->(OptionValue@PrintAs<>"'''")];
	DefTensor[(Symbol@(ToString@InputField<>"pppp"))[Inds],
		M3,SymmExpr,PrintAs->(OptionValue@PrintAs<>"''''")];
	DefTensor[(Symbol@(ToString@InputField<>"ppppp"))[Inds],
		M3,SymmExpr,PrintAs->(OptionValue@PrintAs<>"'''''")];
	DefTensor[InputField[Inds],M3,SymmExpr,PrintAs->OptionValue@PrintAs];
	$FromInert//=(#~Join~{
		InputField->(Symbol@(ToString@InputField<>"x"))[Time],
		Symbol@(ToString@InputField<>"p")->(Symbol@(ToString@InputField<>"xp"))[Time],
		Symbol@(ToString@InputField<>"pp")->(Symbol@(ToString@InputField<>"xpp"))[Time],
		Symbol@(ToString@InputField<>"ppp")->(Symbol@(ToString@InputField<>"xppp"))[Time],
		Symbol@(ToString@InputField<>"pppp")->(Symbol@(ToString@InputField<>"xpppp"))[Time],
		Symbol@(ToString@InputField<>"ppppp")->(Symbol@(ToString@InputField<>"xppppp"))[Time]})&;
	(Symbol@(ToString@InputField<>"x"))'[Time_]:=(Symbol@(ToString@InputField<>"xp"))[Time];
	(Symbol@(ToString@InputField<>"xp"))'[Time_]:=(Symbol@(ToString@InputField<>"xpp"))[Time];
	(Symbol@(ToString@InputField<>"xpp"))'[Time_]:=(Symbol@(ToString@InputField<>"xppp"))[Time];
	(Symbol@(ToString@InputField<>"xppp"))'[Time_]:=(Symbol@(ToString@InputField<>"xpppp"))[Time];
	(Symbol@(ToString@InputField<>"xpppp"))'[Time_]:=(Symbol@(ToString@InputField<>"xppppp"))[Time];
	$ToInert//=(#~Join~{
		(Symbol@(ToString@InputField<>"x"))[Time]->InputField,
		(Symbol@(ToString@InputField<>"xp"))[Time]->(Symbol@(ToString@InputField<>"p")),
		(Symbol@(ToString@InputField<>"xpp"))[Time]->(Symbol@(ToString@InputField<>"pp")),
		(Symbol@(ToString@InputField<>"xppp"))[Time]->(Symbol@(ToString@InputField<>"ppp")),
		(Symbol@(ToString@InputField<>"xpppp"))[Time]->(Symbol@(ToString@InputField<>"pppp")),
		(Symbol@(ToString@InputField<>"xppppp"))[Time]->(Symbol@(ToString@InputField<>"ppppp"))})&;
];

TimeD[InputExpr_]~Y~Module[{Expr=InputExpr},
	Expr//=TotalFrom;
	Expr//=SeparateMetric[G];
	Expr//=ScreenDollarIndices;
	Expr//=(#/.GToGTime)&;
	Expr//=(#/.GToGTimeInverse)&;
	Expr//=ScreenDollarIndices;
	Expr//=(#/.$FromInert)&;
	Expr//=D[#,Time]&;
	Block[{Derivative},
		Derivative//Unprotect;
		Derivative[1][CD[m_]][Anything_]:=CD[m][D[Anything,Time]]/D[Anything,Time];
		Expr//=Simplify;
		Derivative//Protect;
	];
	Expr//=(#/.$ToInert)&;
	Expr//=ToCanonical;
	Expr//ScreenDollarIndices;
	Expr//CollectTensors;
	Expr//=(#/.GTimeToG)&;
	Expr//=(#/.GTimeInverseToG)&;
	Expr//=ToCanonical;
	Expr//ScreenDollarIndices;
	Expr//CollectTensors;
Expr];

TimeD[InputExpr_,Ord_]~Y~Module[{Expr=InputExpr},
	Do[Expr//=TimeD,{Ord}];
Expr];

```
========================================


# Section 2: Model Catalogue

Each model includes a canonical formulation (Hamiltonian, fields, momenta, multipliers) followed by a walkthrough of the Dirac-Bergmann constraint analysis if available.

## KalbRamondTheory - Canonical Formulation

This prompt provides all the information needed to implement the Dirac-Bergman Hamiltonian constraint algorithm for a specific theory. Once you have read the information below, you should proceed directly with the algorithm.

Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not.

```mathematica
-1/8*(ConjugateMomentumCanonicalFielda5962efc[-a, -b]*ConjugateMomentumCanonicalFielda5962efc[a, b])/CouplingConstant750dbd1c + ConjugateMomentumCanonicalField640262b4[-a]*LagrangeMultiplier640262b4[a] + 2*ConjugateMomentumCanonicalFielda5962efc[-a, -b]*CD[b][CanonicalField640262b4[a]] + 4*CouplingConstant750dbd1c*CD[-b][CanonicalFielda5962efc[-a, -c]]*CD[c][CanonicalFielda5962efc[a, b]] - 2*CouplingConstant750dbd1c*CD[-c][CanonicalFielda5962efc[-a, -b]]*CD[c][CanonicalFielda5962efc[a, b]]
```

Here is a Wolfram Language statement of all the constant symbols that appear in the total Hamiltonian above.

```mathematica
{CouplingConstant750dbd1c}
```

Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above.

```mathematica
{CanonicalFielda5962efc[-a, -b], CanonicalField640262b4[-a]}
```

Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above.

```mathematica
{ConjugateMomentumCanonicalFielda5962efc[a, b], ConjugateMomentumCanonicalField640262b4[a]}
```

Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above.

```mathematica
{LagrangeMultipliera5962efc[-a, -b], LagrangeMultiplier640262b4[-a]}
```

This is the end of the provided information; you should tell me when you've read it, and then propose the first step to start implementing the Dirac-Bergmann algorithm, in line with your earlier instructions about workflow. Wait for the user to confirm whether you should proceed with that step, and then continue step-by-step from there.


## KalbRamondTheory - Dirac-Bergmann Constraint Analysis Walkthrough

Project Path: hasdrubal_tests

Source Tree:

```txt
hasdrubal_tests
└── KalbRamondTheoryWalkthrough.m

```

`hasdrubal_tests/KalbRamondTheoryWalkthrough.m`:

```m
Print@"OK, so we are going to analyse the Kalb-Ramond theory now. The first step is to load the Hamilcar package.";
<<xAct`Hamilcar`;
Print@"The next step is to disable the dynamical metric, since we are working on Minkowski spacetime.";
$DynamicalMetric=False;
Print@"When we work with Poisson brackets, we smear the operands manually.";
$ManualSmearing=True;
Print@"Next, we need to define a bunch of things based on what we've been told. Firstly we will define the constant symbols in the theory.";
DefConstantSymbol[CouplingConstant750dbd1c];
Print@"Next we define the canonical fields in the theory. Note that the conjugate momenta are defined automatically alongside the fields.";
DefCanonicalField[CanonicalFielda5962efc[-a,-b],Antisymmetric[{-a,-b}]];
DefCanonicalField[CanonicalField640262b4[-a]];
Print@"Next we define the multipliers in the theory.";
DefTensor[LagrangeMultipliera5962efc[-a,-b],M3,Antisymmetric[{-a,-b}]];
DefTensor[LagrangeMultiplier640262b4[-a],M3];
Print@"Now we want to define two smearing functions for each of the canonical fields, whose index structure matches those fields.";
DefTensor[SmearingOnea5962efc[-a,-b],M3,Antisymmetric[{-a,-b}]];
DefTensor[SmearingOne640262b4[-a],M3];
DefTensor[SmearingTwoa5962efc[-a,-b],M3,Antisymmetric[{-a,-b}]];
DefTensor[SmearingTwo640262b4[-a],M3];
Print@"Now we define the total Hamiltonian density for the theory.";
TotalHamiltonianDensity=-1/8*(ConjugateMomentumCanonicalFielda5962efc[-a, -b]*ConjugateMomentumCanonicalFielda5962efc[a, b])/CouplingConstant750dbd1c + ConjugateMomentumCanonicalField640262b4[-a]*LagrangeMultiplier640262b4[a] + 2*ConjugateMomentumCanonicalFielda5962efc[-a, -b]*CD[b][CanonicalField640262b4[a]] + 4*CouplingConstant750dbd1c*CD[-b][CanonicalFielda5962efc[-a, -c]]*CD[c][CanonicalFielda5962efc[a, b]] - 2*CouplingConstant750dbd1c*CD[-c][CanonicalFielda5962efc[-a, -b]]*CD[c][CanonicalFielda5962efc[a, b]];
TotalHamiltonianDensity//=Recanonicalize;
TotalHamiltonianDensity//Print;
Print@"The first step is to find all the primary constraints. Having been provided with the total Hamiltonian density, we could recover these by reading them off directly. It is safer, however, to proceed systematically, by taking variations with respect to the multipliers.";
Expr=VarD[LagrangeMultipliera5962efc[-a,-b],CD][TotalHamiltonianDensity];
Expr//=Recanonicalize;
Expr//Print;
Print@"So that is zero, and hence no primary constraint from this field. Now let's check the other one.";
Expr=VarD[LagrangeMultiplier640262b4[-a],CD][TotalHamiltonianDensity];
Expr//=Recanonicalize;
Expr//Print;
Print@"Ah, so that is non-zero, and hence there are three primary constraints associated with that multiplier. Let's define a tensor to represent that those constraints.";
DefTensor[PrimaryConstraint640262b4[a],M3];
FromPrimaryConstraint640262b4=MakeRule[{PrimaryConstraint640262b4[a],Evaluate@Expr},MetricOn->All,ContractMetrics->True];
FromPrimaryConstraint640262b4//PrependTotalFrom;
Print@"So, the theory has three primary constraints in total. Now we need to check whether these constraints are preserved in time. We smear them with appropriate smearing functions before taking Poisson brackets with the total Hamiltonian. To compute the secondaries as (potentially indexed) tensor expressions, we then take variations with respect to the smearing functions.";
Expr=PoissonBracket[SmearingOne640262b4[-a]*PrimaryConstraint640262b4[a],TotalHamiltonianDensity];
Expr//=VarD[SmearingOne640262b4[-a],CD][#]&;
Expr//=Recanonicalize;
Expr//Print;
Print@"Ah, so the velocities of these primaries don't vanish identically, nor is it equal to a combination of any other constraints (there are none), nor is it equal to an expression which can be set to zero for appropriate values of the multipliers. Hence we have found some secondary constraints. Specifically, we have found two secondary constraints, because the expression is the spatial divergence of a two-form in three dimensions, which is the curl of a vector (i.e. the vector to which the two-form is dual). let's define a tensor to represent those secondary constraints.";
DefTensor[SecondaryConstraint640262b4[a],M3];
FromSecondaryConstraint640262b4=MakeRule[{SecondaryConstraint640262b4[a],Evaluate@Expr},MetricOn->All,ContractMetrics->True];
FromSecondaryConstraint640262b4//PrependTotalFrom;
Print@"We now need to check whether the secondaries are preserved in time. We proceed as before, smearing with an appropriate smearing function and taking the Poisson bracket with the total Hamiltonian, before taking variations with respect to the smearing function to recover the indexed tensor expression.";
Expr=PoissonBracket[SmearingOne640262b4[-a]*SecondaryConstraint640262b4[a],TotalHamiltonianDensity];
Expr//=VarD[SmearingOne640262b4[-a],CD][#]&;
Expr//=Recanonicalize;
Expr//Print;
Print@"Ah, so the velocities of the secondaries vanish identically, and hence there are no further constraints, and we have found all the constraints in the theory. Now we need to classify the constraints into first and second class. To do this, we need to compute the Poisson brackets between all pairs of constraints.";
Expr=PoissonBracket[SmearingOne640262b4[-a]*PrimaryConstraint640262b4[a],SmearingTwo640262b4[-a]*SecondaryConstraint640262b4[a]];
Expr//Print;
Print@"Ah, so the Poisson bracket between the primaries and secondaries is vanishing. This means that both constraints are first class. We have now found and classified all the constraints in the theory. To summarise, the theory has five constraints in total: three primary and two secondary. Both constraints are first class. The total number of canonical degrees of freedom in the theory is 2*(3+3), where the 2 is from the field-momentum pairs, and the (3+3) is from the three-dimensional vector and three-dimensional two-form components of the four-dimensional two-form field. From this we subtract 2*3 degrees of freedom for the primary first class constraints, and another 2*2 degrees of freedom for the secondary first-class constraint, leaving us with 2*(3+3)-2*3-2*2=2 canonical degrees of freedom, or equivalently 1 physical degrees of freedom.";
Quit[];

```
----------------------------------------

## ProcaTheory - Canonical Formulation

This prompt provides all the information needed to implement the Dirac-Bergman Hamiltonian constraint algorithm for a specific theory. Once you have read the information below, you should proceed directly with the algorithm.

Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not.

```mathematica
-(CouplingConstant83fc4bdd*CanonicalField2a3728e5[]^2) + ConjugateMomentumCanonicalField2a3728e5[]*LagrangeMultiplier2a3728e5[] + CouplingConstant83fc4bdd*CanonicalField37d48fd1[-a]*CanonicalField37d48fd1[a] + (ConjugateMomentumCanonicalField37d48fd1[-a]*ConjugateMomentumCanonicalField37d48fd1[a])/(2*CouplingConstant750dbd1c) + ConjugateMomentumCanonicalField37d48fd1[a]*CD[-a][CanonicalField2a3728e5[]] - (CouplingConstant750dbd1c*CD[-a][CanonicalField37d48fd1[-b]]*CD[b][CanonicalField37d48fd1[a]])/2 + (CouplingConstant750dbd1c*CD[-b][CanonicalField37d48fd1[-a]]*CD[b][CanonicalField37d48fd1[a]])/2
```

Here is a Wolfram Language statement of all the constant symbols that appear in the total Hamiltonian above.

```mathematica
{CouplingConstant750dbd1c, CouplingConstant83fc4bdd}
```

Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above.

```mathematica
{CanonicalField2a3728e5[], CanonicalField37d48fd1[-a]}
```

Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above.

```mathematica
{ConjugateMomentumCanonicalField2a3728e5[], ConjugateMomentumCanonicalField37d48fd1[a]}
```

Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above.

```mathematica
{LagrangeMultiplier2a3728e5[], LagrangeMultiplier37d48fd1[-a]}
```

This is the end of the provided information; you should tell me when you've read it, and then propose the first step to start implementing the Dirac-Bergmann algorithm, in line with your earlier instructions about workflow. Wait for the user to confirm whether you should proceed with that step, and then continue step-by-step from there.


## ProcaTheory - Dirac-Bergmann Constraint Analysis Walkthrough

Project Path: hasdrubal_tests

Source Tree:

```txt
hasdrubal_tests
└── ProcaTheoryWalkthrough.m

```

`hasdrubal_tests/ProcaTheoryWalkthrough.m`:

```m
Print@"OK, so we are going to analyse the Maxwell theory now. The first step is to load the Hamilcar package.";
<<xAct`Hamilcar`;
Print@"The next step is to disable the dynamical metric, since we are working on Minkowski spacetime.";
$DynamicalMetric=False;
Print@"When we work with Poisson brackets, we smear the operands manually.";
$ManualSmearing=True;
Print@"Next, we need to define a bunch of things based on what we've been told. Firstly we will define the constant symbols in the theory.";
DefConstantSymbol[CouplingConstant750dbd1c];
DefConstantSymbol[CouplingConstant83fc4bdd];
Print@"Next we define the canonical fields in the theory. Note that the conjugate momenta are defined automatically alongside the fields.";
DefCanonicalField[CanonicalField2a3728e5[]];
DefCanonicalField[CanonicalField37d48fd1[-a]];
Print@"Next we define the multipliers in the theory.";
DefTensor[LagrangeMultiplier2a3728e5[],M3];
DefTensor[LagrangeMultiplier37d48fd1[-a],M3];
Print@"Now we want to define two smearing functions for each of the canonical fields, whose index structure matches those fields.";
DefTensor[SmearingOne2a3728e5[],M3];
DefTensor[SmearingOne37d48fd1[-a],M3];
DefTensor[SmearingTwo2a3728e5[],M3];
DefTensor[SmearingTwo37d48fd1[-a],M3];
Print@"Now we define the total Hamiltonian density for the theory.";
TotalHamiltonianDensity=-(CouplingConstant83fc4bdd*CanonicalField2a3728e5[]^2) + ConjugateMomentumCanonicalField2a3728e5[]*LagrangeMultiplier2a3728e5[] + CouplingConstant83fc4bdd*CanonicalField37d48fd1[-a]*CanonicalField37d48fd1[a] + (ConjugateMomentumCanonicalField37d48fd1[-a]*ConjugateMomentumCanonicalField37d48fd1[a])/(2*CouplingConstant750dbd1c) + ConjugateMomentumCanonicalField37d48fd1[a]*CD[-a][CanonicalField2a3728e5[]] - (CouplingConstant750dbd1c*CD[-a][CanonicalField37d48fd1[-b]]*CD[b][CanonicalField37d48fd1[a]])/2 + (CouplingConstant750dbd1c*CD[-b][CanonicalField37d48fd1[-a]]*CD[b][CanonicalField37d48fd1[a]])/2;
TotalHamiltonianDensity//Recanonicalize;
TotalHamiltonianDensity//Print;
Print@"The first step is to find all the primary constraints. Having been provided with the total Hamiltonian density, we could recover these by reading them off directly. It is safer, however, to proceed systematically, by taking variations with respect to the multipliers.";
Expr=VarD[LagrangeMultiplier2a3728e5[],CD][TotalHamiltonianDensity];
Expr//Recanonicalize;
Expr//Print;
Print@"So that is non-zero, and hence the theory has at least one primary constraint. let's define a tensor to represent that constraint.";
DefTensor[PrimaryConstraint2a3728e5[],M3];
FromPrimaryConstraint2a3728e5=MakeRule[{PrimaryConstraint2a3728e5[],Evaluate@Expr},MetricOn->All,ContractMetrics->True];
FromPrimaryConstraint2a3728e5//PrependTotalFrom;
Print@"Let's check the other one.";
Expr=VarD[LagrangeMultiplier37d48fd1[-a],CD][TotalHamiltonianDensity];
Expr//Recanonicalize;
Expr//Print;
Print@"Ah, so that vanishes identically, and hence there is no primary constraint associated with that multiplier. So, the theory has one primary constraint in total. Now we need to check whether it is preserved in time. Generally, the primaries might not be scalars, so we stick to the routine of smearing them with appropriate smearing functions before taking Poisson brackets with the total Hamiltonian. To compute the secondaries as (potentially indexed) tensor expressions, we then take variations with respect to the smearing functions.";
Expr=PoissonBracket[SmearingOne2a3728e5[]*PrimaryConstraint2a3728e5[],TotalHamiltonianDensity];
Expr//=VarD[SmearingOne2a3728e5[],CD][#]&;
Expr//=Recanonicalize;
Expr//Print;
Print@"Ah, so the velocity of the primary doesn't vanish identically, nor is it equal to a combination of any other constraints (there are none), nor is it equal to an expression which can be set to zero for appropriate values of the multipliers. Hence we have found a secondary constraint. Let's define a tensor to represent that secondary constraint.";
DefTensor[SecondaryConstraint2a3728e5[],M3];
FromSecondaryConstraint2a3728e5=MakeRule[{SecondaryConstraint2a3728e5[],Evaluate@Expr},MetricOn->All,ContractMetrics->True];
FromSecondaryConstraint2a3728e5//PrependTotalFrom;
Print@"We now have two constraints in total. Next we need to check whether the secondary is preserved in time. We proceed as before, smearing with an appropriate smearing function and taking the Poisson bracket with the total Hamiltonian, before taking variations with respect to the smearing function to recover the indexed tensor expression.";
Expr=PoissonBracket[SmearingOne2a3728e5[]*SecondaryConstraint2a3728e5[],TotalHamiltonianDensity];
Expr//=VarD[SmearingOne2a3728e5[],CD][#]&;
Expr//=Recanonicalize;
Expr//Print;
Print@"Ah, so the velocity of the secondary doesn't vanish identically, nor is it equal to a combination of any other constraints, but it is equal to an expression which can be set to zero for appropriate values of the multipliers. Hence there are no further constraints, and we have found all the constraints in the theory. Now we need to classify the constraints into first and second class. To do this, we need to compute the Poisson brackets between all pairs of constraints.";
Expr=PoissonBracket[SmearingOne2a3728e5[]*PrimaryConstraint2a3728e5[],SmearingTwo2a3728e5[]*SecondaryConstraint2a3728e5[]];
Expr//Recanonicalize;
Expr//Print;
Print@"Ah, so the Poisson bracket between the primary and secondary constraints is non-vanishing. Since there are only two constraints in total, this means that both constraints are second class. We have now found and classified all the constraints in the theory. To summarise, the theory has two constraints in total: one primary and one secondary. Both constraints are second class. The total number of canonical degrees of freedom in the theory is 2*(1+3), where the 2 is from the field-momentum pairs, and the (1+3) is from the 0p and 1m components of the vector field. From this we subtract 1 degree of freedom for the primary constraint, and another degree of freedom for the secondary constraint, leaving us with 2*(1+3)-2=6 canonical degrees of freedom, or equivalently 3 physical degrees of freedom.";
Quit[];

```
----------------------------------------


========================================

========================================
# Token Summary
Hamilcar: 21956 tokens
Model Catalogue: 4476 tokens
Total: 26432 tokens
========================================
