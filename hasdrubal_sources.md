# Hasdrubal Source Context
# Generated Mathematica sources for in-context learning

This document contains the complete source code for:
1. Hamilcar - Canonical field theory package
2. project-glavan/Private - Additional field theory computations
3. project-dalet/ReproductionOfResults - Reproduction results

Sat Nov 22 11:59:22 PM CET 2025

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
            │   │   ├── Recanonicalise.m
            │   │   └── ToDensities.m
            │   ├── MonomialPoissonBracket.m
            │   ├── MultiCD.m
            │   ├── Recanonicalise.m
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
If[xAct`Hamilcar`Private`$CLI,	
	Print@Import@FileNameJoin@{xAct`Hamilcar`Private`$InstallDirectory,
				"Logos","ASCIILogo.txt"},
	Print@Magnify[Import@FileNameJoin@{xAct`Hamilcar`Private`$InstallDirectory,
				"Logos","GitLabLogo.png"},0.3]];

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
	Expr//=Recanonicalise;
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

IncludeHeader@"Recanonicalise";
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
	Expr//=Recanonicalise;

Expr];

```

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/MonomialPoissonBracket/Recanonicalise.m`:

```m
(*==================*)
(*  Recanonicalise  *)
(*==================*)

Recanonicalise@InputExpr_:=Module[{Expr=InputExpr},
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
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

`Hamilcar/xAct/Hamilcar/Sources/PoissonBracket/Recanonicalise.m`:

```m
(*==================*)
(*  Recanonicalise  *)
(*==================*)

Recanonicalise@InputExpr_:=Module[{Expr=InputExpr},
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
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
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
	Expr//=ScreenDollarIndices;
	Expr
];

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


# Section 3: project-dalet/ReproductionOfResults Sources

Project Path: ReproductionOfResults

Source Tree:

```txt
ReproductionOfResults
├── HamiltonianAnalysis
│   ├── BracketComputation.m
│   ├── DefineQuantities.m
│   ├── EquationsOfMotion.m
│   ├── FirstOrder.m
│   ├── InitialSetup.m
│   ├── LegacyCode.m
│   ├── ReducedConstraints.m
│   ├── ScienceDefinitions.m
│   ├── SecondOrder.m
│   ├── ShorthandNotation.m
│   └── ZerothOrder.m
└── HamiltonianAnalysis.m

```

`ReproductionOfResults/HamiltonianAnalysis.m`:

```m
(*=======================*)
(*  HamiltonianAnalysis  *)
(*=======================*)


<<xAct`xPlain`;

$Listings=True;
$ListingsBackground=RGBColor[0.96,0.96,0.96];

Title@"Pure gravity at two loops";

Comment@"We wish to use arXiv:2409.15989 to calibrate the Hamilcar package. The four Hamilcar functions that we will be showcasing are \"DefCanonicalField\", \"PrependToFunction\", \"PoissonBracket\" and \"FindAlgebra\".";

Section@"Initial definitions";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","InitialSetup.m"};
Section@"Science definitions";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ScienceDefinitions.m"};
Section@"Reduced constraint algebra";
Subsection@"Define shorthand notation";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ShorthandNotation.m"};
Subsection@"Define the reduced constraints";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ReducedConstraints.m"};
Subsection@"Computation of the brackets";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","BracketComputation.m"};
Subsection@"The part zeroth-order in the cosmological constant";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrder.m"};
Subsection@"The part first-order in the cosmological constant";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","FirstOrder.m"};
Subsection@"The part second-order in the cosmological constant";
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","SecondOrder.m"};

Quit[];

```

`ReproductionOfResults/HamiltonianAnalysis/BracketComputation.m`:

```m
(*======================*)
(*  BracketComputation  *)
(*======================*)

Comment@"We will focus only on the auto-commutator of the reduced Hamiltonian constraint, since this is the only Poisson bracket whose structure is not entirely trivial. We only care about the parts of this bracket which are zeroth-order or first-order in the Wilson coefficient. Accordingly, it is efficient to decompose the reduced Hamiltonian constraint into its zeroth-order and first-order parts, and then compute the auto-commutator of the zeroth-order part and add to it the subleading corrections, the cross-terms between the zeroth-order part and the first-order part, and vice versa.";

Comment@"The Hamilcar function that we use to compute Poisson brackets is \"PoissonBracket\". This has various features, such as the automatic introduction of smearing functions. However, for this project, we want to use our own smearing functions as defined above. We accordingly set manual smearing via a global variable so as to control the bracket calculations explicitly.";
Code[$ManualSmearing=True;,LineLabel->"EnableManualSmearing"];

Comment@{"Define the order-unity (leading order) part of the reduced Hamiltonian constraint from",Cref@"FromReducedHamiltonianConstraint",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ReducedHamiltonianOrderUnity[], M3, PrintAs->"\!\(\*SubscriptBox[\(\*OverscriptBox[\(\[ScriptCapitalH]\),\((0)\)]\),\(red\)]\)"];
	Expr=ReducedHamiltonianConstraint[];
	Expr//=(#/.FromReducedHamiltonianConstraint)&;
	Expr//=Coefficient[#,WilsonCoefficient,0]&;
	FromReducedHamiltonianOrderUnity = MakeRule[{
	    ReducedHamiltonianOrderUnity[],
		Evaluate@Expr},
	 MetricOn->All, ContractMetrics->True];
	FromReducedHamiltonianOrderUnity//PrependTotalFrom;
	,
	LineLabel->"DefineReducedHamiltonianOrderUnity"
];
ReducedHamiltonianOrderUnity[]~DisplayRule~FromReducedHamiltonianOrderUnity;

Comment@{"Define the order-one (subleading order) part of the reduced Hamiltonian constraint from",Cref@"FromReducedHamiltonianConstraint",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ReducedHamiltonianOrderWilsonCoefficient[], M3, PrintAs->"\!\(\*SubscriptBox[\(\*OverscriptBox[\(\[ScriptCapitalH]\),\((1)\)]\),\(red\)]\)"];
	Expr=ReducedHamiltonianConstraint[];
	Expr//=(#/.FromReducedHamiltonianConstraint)&;
	Expr//=Coefficient[#,WilsonCoefficient,1]&;
	Expr*= WilsonCoefficient;
	FromReducedHamiltonianOrderWilsonCoefficient = MakeRule[{
	    ReducedHamiltonianOrderWilsonCoefficient[],
		Evaluate@Expr},
	 MetricOn->All, ContractMetrics->True];
	FromReducedHamiltonianOrderWilsonCoefficient//PrependTotalFrom;
	,
	LineLabel->"DefineReducedHamiltonianOrderWilsonCoefficient"
];
ReducedHamiltonianOrderWilsonCoefficient[]~DisplayRule~FromReducedHamiltonianOrderWilsonCoefficient;

Comment@{"Prepare the leading contribution using",Cref@"FromReducedHamiltonianOrderUnity"," and the smearing functions",Cref@{"ScalarSmearingF","ScalarSmearingS"},"."};
Code[
	Expr={ScalarSmearingF[]*ReducedHamiltonianOrderUnity[],ScalarSmearingS[]*ReducedHamiltonianOrderUnity[]};
	,
	LineLabel->"SetupOrderUnityBracket"
];
DisplayExpression[Expr,EqnLabel->"OrderUnityBracketSetup"];

Comment@"Use \"PoissonBracket\" to compute the leading contribution.";
Code[
	Expr//=((PoissonBracket[#1,#2,Parallel->True])&@@#)&;
	OrderUnityBracketValue=Expr;
	,
	Execute->False,
	LineLabel->"ComputeOrderUnityBracket"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"OrderUnityBracket.mx"},OrderUnityBracketValue];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"OrderUnityBracket.mx"};
DisplayExpression[OrderUnityBracketValue,EqnLabel->"OrderUnityBracketResult"];

Comment@{"Prepare the first cross-term using",Cref@{"FromReducedHamiltonianOrderUnity","FromReducedHamiltonianOrderWilsonCoefficient"}," and the smearing functions",Cref@{"ScalarSmearingF","ScalarSmearingS"},"."};
Code[
	Expr={ScalarSmearingF[]*ReducedHamiltonianOrderUnity[],ScalarSmearingS[]*ReducedHamiltonianOrderWilsonCoefficient[]};
	,
	LineLabel->"SetupCrossBracket01"
];
DisplayExpression[Expr,EqnLabel->"CrossBracket01Setup"];

Comment@"Use \"PoissonBracket\" to compute the first cross-term.";
Code[
	Expr//=((PoissonBracket[#1,#2,Parallel->True])&@@#)&;
	CrossBracket01Value=Expr;
	,
	Execute->False,
	LineLabel->"ComputeCrossBracket01"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"CrossBracket01.mx"},CrossBracket01Value];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"CrossBracket01.mx"};
DisplayExpression[CrossBracket01Value,EqnLabel->"CrossBracket01Result"];

Comment@{"Prepare the second cross-term using",Cref@{"FromReducedHamiltonianOrderWilsonCoefficient","FromReducedHamiltonianOrderUnity"}," and the smearing functions",Cref@{"ScalarSmearingF","ScalarSmearingS"},"."};
Code[
	Expr={ScalarSmearingF[]*ReducedHamiltonianOrderWilsonCoefficient[],ScalarSmearingS[]*ReducedHamiltonianOrderUnity[]};
	,
	LineLabel->"SetupCrossBracket10"
];
DisplayExpression[Expr,EqnLabel->"CrossBracket10Setup"];

Comment@"Use \"PoissonBracket\" to compute the second cross-term.";
Code[
	Expr//=((PoissonBracket[#1,#2,Parallel->True])&@@#)&;
	CrossBracket10Value=Expr;
	,
	Execute->False,
	LineLabel->"ComputeCrossBracket10"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"CrossBracket10.mx"},CrossBracket10Value];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"CrossBracket10.mx"};
DisplayExpression[CrossBracket10Value,EqnLabel->"CrossBracket10Result"];

Comment@"Combine the three brackets to get the total auto-commutator.";
Code[
	Expr=OrderUnityBracketValue+CrossBracket01Value+CrossBracket10Value;
	Expr//=StandardSimplify;
	BracketKValue=Expr;
	,
	Execute->False,
	LineLabel->"CombineBrackets"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"BracketK.mx"},BracketKValue];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"BracketK.mx"};
BracketKValue//=StandardSimplify;
(*DisplayExpression[BracketKValue,EqnLabel->"ReducedHamiltonianSelfBracketToOrderWilsonCoefficient"];*)

(*Hidden*)
TestSkew[InputExpr_]:=Module[{Expr=InputExpr,ExprSave},
	Expr//=CollectTensors[#,
		CollectMethod->xAct`Hamilcar`Private`DerivativeCanonical]&;
	ExprSave=Expr;
	Expr//=(#/.{ScalarSmearingF[]->ScalarSmearingS[],
		ScalarSmearingS[]->ScalarSmearingF[]})&;
	Expr+=ExprSave;
	Expr//=CollectTensors[#,
		CollectMethod->xAct`Hamilcar`Private`DerivativeCanonical]&;
Expr];

Comment@"It will be helpful for our work in the next section to build a simple utility function that allows us to pick out parts of the whole bracket which are at various orders with respect to the cosmological constant and Wilson coefficient. This will allow us to focus on the parts of the bracket that are relevant for our work, without having to manually extract them each time.";
Code[
	Options@ExtractBracketAnatomy={CosmologicalConstantOrder->All,
		WilsonCoefficientOrder->All};
	ExtractBracketAnatomy[OptionsPattern[]]:=Module[{Expr=BracketKValue},
		If[!(OptionValue@CosmologicalConstantOrder===All),
			Expr//=Series[#,{CosmologicalConstant,0,10}]&;
			Expr//=Normal;
			Expr=((Coefficient[Expr,CosmologicalConstant,#]*
				CosmologicalConstant^#)&~
				Map~(OptionValue@CosmologicalConstantOrder));
			Expr//=Total;
		];
		If[!(OptionValue@WilsonCoefficientOrder===All),
			Expr//=Series[#,{WilsonCoefficientOrder,0,10}]&;
			Expr//=Normal;
			Expr=((Coefficient[Expr,WilsonCoefficient,#]*
				WilsonCoefficient^#)&~
				Map~(OptionValue@WilsonCoefficientOrder));
			Expr//=Total;
		];
		Expr//=StandardSimplify;
	Expr];
	,
	LineLabel->"DefineExtractBracketAnatomy"
];

```

`ReproductionOfResults/HamiltonianAnalysis/DefineQuantities.m`:

```m
(*====================*)
(*  DefineQuantities  *)
(*====================*)

Comment@"Define the auxiliary velocity field.";
Code[
	DefTensor[AuxiliaryVelocityField[-i,-j],M3,Symmetric[{-i,-j}],PrintAs->"\[ScriptCapitalF]"];
	,
	LineLabel->"DefineAuxiliaryVelocityField"
];
DisplayExpression[AuxiliaryVelocityField[-i,-j],EqnLabel->"AuxiliaryVelocityField"];

Comment@"Define the auxiliary field for the antisymmetric gradient of the extrinsic curvature. Note the use of \"PrependTotalFrom\".";
Code[
	DefTensor[AuxiliaryTensorL[i,-j,-k],M3,Antisymmetric[{-j,-k}],PrintAs->"\[ScriptCapitalL]"];
	FromAuxiliaryTensorL=MakeRule[{AuxiliaryTensorL[i,-j,-k],
		CD[-k]@AuxiliaryExtrinsicCurvature[i,-j]-CD[-j]@AuxiliaryExtrinsicCurvature[i,-k]},
		MetricOn->All,ContractMetrics->True];
	FromAuxiliaryTensorL//PrependTotalFrom;
	,
	LineLabel->"DefineAuxiliaryTensorL"
];
AuxiliaryTensorL[i,-j,-k]~DisplayRule~FromAuxiliaryTensorL;

Comment@"Define the auxiliary field for the Riemann-like quantity. Note the use of \"PrependTotalFrom\".";
Code[
	DefTensor[AuxiliaryTensorQ[i,j,-k,-l],M3,
		{Antisymmetric[{i,j}],Antisymmetric[{-k,-l}]},
		PrintAs->"\[ScriptCapitalQ]"];
	FromAuxiliaryTensorQ=MakeRule[{AuxiliaryTensorQ[i,j,-k,-l],
		AuxiliaryExtrinsicCurvature[i,-k]*AuxiliaryExtrinsicCurvature[j,-l]-AuxiliaryExtrinsicCurvature[i,-l]*AuxiliaryExtrinsicCurvature[j,-k]
		+RiemannCD[i,j,-k,-l]},
		MetricOn->All,ContractMetrics->True];
	FromAuxiliaryTensorQ//PrependTotalFrom;
	,
	LineLabel->"DefineAuxiliaryTensorQ"
];
AuxiliaryTensorQ[i,j,-k,-l]~DisplayRule~FromAuxiliaryTensorQ;

Comment@"Define the lapse function.";
Code[
	DefTensor[Lapse[],M3,PrintAs->"N"];
	,
	LineLabel->"DefineLapse"
];
DisplayExpression[Lapse[],EqnLabel->"Lapse"];

Comment@"Define the shift vector.";
Code[
	DefTensor[Shift[-i],M3,PrintAs->"N"];
	,
	LineLabel->"DefineShift"
];
DisplayExpression[Shift[i],EqnLabel->"Shift"];

Comment@"Form the auxiliary extended Lagrangian density.";
Code[
AuxiliaryExtendedLagrangianDensity = Lapse[] * Sqrt[DetG[]] * (
    (* Einstein-Hilbert + cosmological constant term *)
    (1/EinsteinConstant) * (AuxiliaryExtrinsicCurvature[-i,-j]*AuxiliaryExtrinsicCurvature[i,j] - TraceAuxiliaryExtrinsicCurvature[]^2
                     + RicciScalarCD[] - 2*CosmologicalConstant) +

    (* Cubic F terms: 4WilsonCoefficient EinsteinConstant^2 F^i_j (2F^j_k F^k_i - 3L_i^{kl}L^j_{kl}) *)
    4*WilsonCoefficient*EinsteinConstant * AuxiliaryVelocityField[i,-j] * (
        2*AuxiliaryVelocityField[j,-k]*AuxiliaryVelocityField[k,-i] -
        3*AuxiliaryTensorL[-i,k,l]*AuxiliaryTensorL[j,-k,-l]
    ) +

    (* Cubic Q terms: WilsonCoefficient EinsteinConstant^2 Q^{ij}_{kl} (Q^{kl}_{mn} Q^{mn}_{ij} - 6L_m^{kl}L^m_{ij}) *)
    WilsonCoefficient*EinsteinConstant * AuxiliaryTensorQ[i,j,-k,-l] * (
        AuxiliaryTensorQ[k,l,-m,-n]*AuxiliaryTensorQ[m,n,-i,-j] -
        6*AuxiliaryTensorL[-m,k,l]*AuxiliaryTensorL[m,-i,-j]
    )
);
	,
	LineLabel->"DefineAuxiliaryExtendedLagrangianDensity"
];
DisplayExpression[AuxiliaryExtendedLagrangianDensity, EqnLabel->"AuxiliaryExtendedLagrangianDensity"];

Comment@"Form the first Lagrange multiplier term.";
Code[
	PiConstraintTerms=ConjugateMomentumG[i,j]*(
		GTimep[-i,-j]-(CD[-i]@Shift[-j]+CD[-j]@Shift[-i])+2*Lapse[]*AuxiliaryExtrinsicCurvature[-i,-j]
	);
	,
	LineLabel->"DefinePiConstraintTerms"
];
DisplayExpression[PiConstraintTerms,EqnLabel->"PiConstraintTerms"];

Comment@"Form the second Lagrange multiplier term.";
Code[
	RhoConstraintTerms = ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j] * (
	    AuxiliaryExtrinsicCurvaturep[-i,-j]
	    + Lapse[]*AuxiliaryExtrinsicCurvature[-i,-k]*AuxiliaryExtrinsicCurvature[k,-j]
	    - Shift[k]*CD[-k]@AuxiliaryExtrinsicCurvature[-i,-j]
	    - AuxiliaryExtrinsicCurvature[-k,-i]*CD[-j]@Shift[k]
	    - AuxiliaryExtrinsicCurvature[-k,-j]*CD[-i]@Shift[k]
	    + CD[-i]@CD[-j]@Lapse[]
	    + Lapse[]*AuxiliaryVelocityField[-i,-j]
	);
	,
	LineLabel->"DefineRhoConstraintTerms"
];
DisplayExpression[RhoConstraintTerms, EqnLabel->"RhoConstraintTerms"];

Comment@"The extended Lagrangian density. Note the use of \"PrependTotalFrom\".";
Code[
	DefTensor[ExtendedLagrangianDensity[],M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalL]\),\(ext\)]\)"];
	FromExtendedLagrangianDensity=MakeRule[{ExtendedLagrangianDensity[],
		AuxiliaryExtendedLagrangianDensity+PiConstraintTerms+RhoConstraintTerms},
		MetricOn->All,ContractMetrics->True];
	FromExtendedLagrangianDensity//PrependTotalFrom;
	,
	LineLabel->"DefineExtendedLagrangianDensity"
];
ExtendedLagrangianDensity[]~DisplayRule~FromExtendedLagrangianDensity;

Comment@"The symplectic term. Note the use of \"PrependTotalFrom\".";
Code[
	DefTensor[SymplecticTerm[],M3,PrintAs->"\[Theta]"];
	FromSymplecticTerm=MakeRule[{SymplecticTerm[],
		ConjugateMomentumG[i,j]*GTimep[-i,-j]+ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j]*AuxiliaryExtrinsicCurvaturep[-i,-j]},
		MetricOn->All,ContractMetrics->True];
	FromSymplecticTerm//PrependTotalFrom;
	,
	LineLabel->"DefineSymplecticTerm"
];
 SymplecticTerm[]~DisplayRule~FromSymplecticTerm;

Comment@"The canonical Hamiltonian density is the difference between the symplectic term and the extended Lagrangian density. Note the use of \"PrependTotalFrom\".";
Code[
	DefTensor[CanonicalHamiltonian[],M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalH]\),\(C\)]\)"];
	FromCanonicalHamiltonian=MakeRule[{CanonicalHamiltonian[],
		SymplecticTerm[]-ExtendedLagrangianDensity[]},
		MetricOn->All,ContractMetrics->True];
	FromCanonicalHamiltonian//PrependTotalFrom;
	,
	LineLabel->"DefineCanonicalHamiltonian"
];
 CanonicalHamiltonian[]~DisplayRule~FromCanonicalHamiltonian;

```

`ReproductionOfResults/HamiltonianAnalysis/EquationsOfMotion.m`:

```m
(*=====================*)
(*  EquationsOfMotion  *)
(*=====================*)

Supercomment@"Work in progress!";

```

`ReproductionOfResults/HamiltonianAnalysis/FirstOrder.m`:

```m
(*==============*)
(*  FirstOrder  *)
(*==============*)

Comment@{"Let's have a look at the part of the raw Poisson bracket which is first-order in the cosmological constant. This comes from the sum of the three brackets computed in the previous section:",Cref@{"OrderUnityBracketResult","CrossBracket01Result","CrossBracket10Result"},"."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{1},
		WilsonCoefficientOrder->All];
	,
	LineLabel->"ExtractFirstOrderBracket"
];
DisplayExpression[Expr,EqnLabel->"FirstOrderRawBracket"];

Comment@{"Due to the fact that the reduced Hamiltonian constraint has both zeroth-order and first-order parts in the cosmological constant, the first-order part of the raw bracket in",Cref@"FirstOrderRawBracket"," cannot be cleanly expressed in terms of the reduced constraints, so we give it instead in terms of the shorthand variables."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{1},
		WilsonCoefficientOrder->All];
	Expr//=FindAlgebra[#,
		{{{ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,ScriptQSingleContraction},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{CD,CD,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{RicciCD,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{RicciScalarCD,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}}},
		Method->Solve,Verify->True,DDIs->True]&;
	,
	Execute->False,
	LineLabel->"FindAlgebraFirstOrder"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","FirstOrderA.mx"},Expr];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","FirstOrderA.mx"};
DisplayExpression[Expr,EqnLabel->"FirstOrderResult"];
Supercomment@{"The first-order result in",Cref@"FirstOrderResult"," needs to be checked against the paper."};

```

`ReproductionOfResults/HamiltonianAnalysis/InitialSetup.m`:

```m
(*================*)
(*  InitialSetup  *)
(*================*)

Comment@"Load the Hamilcar package.";
Code[
	<<xAct`Hamilcar`;
	,
	LineLabel->"LoadHamilcar"
];

Comment@"Set xAct preferences (personal choice).";
Code[
	SetOptions[$FrontEndSession,EvaluationCompletionAction->"ScrollToOutput"];
	$DefInfoQ=False;
	Unprotect@AutomaticRules;
	Options[AutomaticRules]={Verbose->False};
	Protect@AutomaticRules;
	,
	LineLabel->"SetXActPreferences"
];

(*Hidden*)
Code[
	CompareExpressions[InputExpr1_,InputExpr2_]:=Module[{
		Expr,Expr1=InputExpr1,Expr2=InputExpr2},
		Expr=Expr1-Expr2;
		Expr//=TotalFrom;
		Expr//=TotalFrom;
		Expr//=StandardSimplify;
		Expr//DisplayExpression;
	Expr];
];

Comment@"Define a simple utility function for simplifying expressions to a canonical form.";
Code[
	StandardSimplify[Expr_]:=Module[{Result=Expr},
		Result//=ToCanonical;
		Result//=ContractMetric;
		Result//=ScreenDollarIndices;
		Result//=CollectTensors;
	Result];
	,
	LineLabel->"DefineStandardSimplify"
];

(*Hidden*)
CompareExpressionsWithConstant[InputExpr1_,InputExpr2_]:=Module[{
	Expr,Expr1=InputExpr1,Expr2=InputExpr2},
	Expr=Expr1-SomeConst*Expr2;
	Expr//=TotalFrom;
	Expr//=TotalFrom;
	Expr//=StandardSimplify;
	Expr//=xAct`Hamilcar`Private`ToHigherDerivativeCanonical;
	Expr//DisplayExpression;
Expr];

(*Hidden*)
DisplayRule~SetAttributes~HoldAll;
DisplayRule[InputExpr_,InputRule_]:=Module[{Expr=Evaluate@InputExpr,EqnLabelValue=ToString@Defer@InputRule},
	EqnLabelValue//=StringDelete[#,"Defer["]&;
	EqnLabelValue//=StringDelete[#,"]"]&;
	Expr=Expr/.Evaluate@InputRule;
	Expr//=StandardSimplify;
	Expr//=ScreenDollarIndices;
	Expr//=FullSimplify;
	DisplayExpression[(InputExpr->Expr),EqnLabel->EqnLabelValue];
Expr];

```

`ReproductionOfResults/HamiltonianAnalysis/LegacyCode.m`:

```m
(*==============*)
(*  LegacyCode  *)
(*==============*)

Get@FileNameJoin@{NotebookDirectory[],"ScriptLConversion.mx"};
Expr//DisplayExpression;

(**)Comment@"Reduce to the quartic part.";
Expr//=(#/.{ScriptL[AnyInds___]->ScriptL[AnyInds]*SomeConst})&;
(*Expr//=(#/.{RicciCD[AnyInds___]->RicciCD[AnyInds]*SomeConst})&;
Expr//=(#/.{RicciScalarCD[]->RicciScalarCD[]*SomeConst})&;*)
Expr//=StandardSimplify;
Expr//=Series[#,{SomeConst,0,10}]&;
Expr//=Normal;
Expr=((Expr~Coefficient~(SomeConst^#))&~Map~{1});
Expr//=Total;
Expr//DisplayExpression;(**)
Expr//=D[#,WilsonCoefficient]&;
Expr//DisplayExpression;

Comment@"Abbreviate the smearing functions.";
Expr//=(#/.{CD[AnyInd_]@ScalarSmearingF[]->0})&;
Expr//=(#/.{CD[AnyInd_]@ScalarSmearingS[]->VectorSmearingS[AnyInd]/ScalarSmearingF[]})&;
Expr//=StandardSimplify;
Expr//DisplayExpression;
ActualQuartic=Expr;

(*AutomaticRules[ScriptK,MakeRule[{
	ScriptK[a,-b]*ScriptK[b,-c]*ScriptK[c,-d]*ScriptK[d,-a],
	(4/3)*ScriptK[a,-b]*ScriptK[b,-c]*ScriptK[c,-a]*ScriptK[d,-d]
	+(1/2)*ScriptK[a,-b]*ScriptK[b,-a]*ScriptK[c,-d]*ScriptK[d,-c]
	-ScriptK[a,-b]*ScriptK[b,-a]*ScriptK[c,-c]*ScriptK[d,-d]
	+(1/6)*ScriptK[a,-a]*ScriptK[b,-b]*ScriptK[c,-c]*ScriptK[d,-d]},
	MetricOn->All,ContractMetrics->True]];*)

(*Automate Cayley-Hamilton*)
CayleyHamiltonScriptK=MakeRule[{
	ScriptK[a,-b]*ScriptK[b,-c]*ScriptK[c,-d],
	ScriptK[a,-b]*ScriptK[b,-d]*ScriptK[c,-c]
	+(1/2)*ScriptK[a,-d]*ScriptK[b,-c]*ScriptK[c,-b]
	-(1/2)*ScriptK[a,-d]*ScriptK[b,-b]*ScriptK[c,-c]
	+(1/6)*(
		2*ScriptK[e,-b]*ScriptK[b,-c]*ScriptK[c,-e]
		-3*ScriptK[e,-b]*ScriptK[b,-e]*ScriptK[c,-c]
		+ScriptK[e,-e]*ScriptK[b,-b]*ScriptK[c,-c]
	)*G[a,-d]},
	MetricOn->All,ContractMetrics->True];

Comment@"Construct the DDIs";

(*DefTensor[FourIndexTriScriptK[-i,-j,-k,-l],M3,PrintAs->"\[GothicCapitalK]"];
DefTensor[TwoIndexTriScriptK[-i,-j],M3,PrintAs->"\[GothicCapitalK]"];
SchFourTri=AllContractions[IndexFree[RicciCD*VectorSmearingS*CD@FourIndexTriScriptK]];
SchFourTri//DisplayExpression;
SchFourTri//Length//DisplayExpression;
SchTwoTri=AllContractions[IndexFree[RicciCD*VectorSmearingS*CD@TwoIndexTriScriptK]];
SchTwoTri//DisplayExpression;
SchTwoTri//Length//DisplayExpression;
DDIFourTri=ConstructDDIs[ScriptK[-i,-j]*ScriptK[-k,-l]*ScriptK[-m,-n],IndexList[a,b,c,d]];
DDIFourTri//DisplayExpression;
DDIFourTri//Length//DisplayExpression;
DDITwoTri=ConstructDDIs[ScriptK[-i,-j]*ScriptK[-k,-l]*ScriptK[-m,-n],IndexList[a,b]];
DDITwoTri//DisplayExpression;
DDITwoTri//Length//DisplayExpression;
Comment@"Define the rules for the DDIs";
RulFourTri=MakeRule[{FourIndexTriScriptK[a,b,c,d],Evaluate@#},
		MetricOn->All,ContractMetrics->True]&/@DDIFourTri;
RulTwoTri=MakeRule[{TwoIndexTriScriptK[a,b],Evaluate@#},
		MetricOn->All,ContractMetrics->True]&/@DDITwoTri;
Comment@"Construct the ansatz.";
AnsFourTri=Outer[((#2/.#1)//ContractMetric//ToCanonical)&,
	RulFourTri,SchFourTri];
AnsFourTri//=Flatten;
AnsFourTri//Length//DisplayExpression;
AnsTwoTri=Outer[((#2/.#1)//ContractMetric//ToCanonical)&,
	RulTwoTri,SchTwoTri];
AnsTwoTri//=Flatten;
AnsTwoTri//Length//DisplayExpression;
Comment@"Tidy the ansatz.";
AnsFourTri//=(ScreenDollarIndices/@#)&;
AnsFourTri//=MakeAnsatz[#,ConstantPrefix->"U"]&;
AnsTwoTri//=(ScreenDollarIndices/@#)&;
AnsTwoTri//=MakeAnsatz[#,ConstantPrefix->"V"]&;
DumpSave[FileNameJoin@{NotebookDirectory[],"AnsFourTri.mx"},AnsFourTri];
DumpSave[FileNameJoin@{NotebookDirectory[],"AnsTwoTri.mx"},AnsTwoTri];*)

Get@FileNameJoin@{NotebookDirectory[],"AnsFourTri.mx"};
Get@FileNameJoin@{NotebookDirectory[],"AnsTwoTri.mx"};
ZeroAnsatz=AnsFourTri+AnsTwoTri;

Expr=ConstructDDIs[ScriptK[-i,-j]*ScriptK[-k,-l]*RicciCD[-m,-n]*ScriptL[-o,-p,-s]*VectorSmearingS[-t]];
Expr//=MakeAnsatz[#,ConstantPrefix->"X"]&;
ZeroAnsatz+=Expr;

Expr=ConstructDDIs[ScriptK[-i,-j]*ScriptK[-k,-l]*RicciCD[-m,-n]*CD[-p]@ScriptK[-o,-s]*VectorSmearingS[-t]];
Expr//=MakeAnsatz[#,ConstantPrefix->"Y"]&;
ZeroAnsatz+=Expr;



Expr=ConstructDDIs[ScriptK[-i,-j]*ScriptK[-k,-l]*ScriptK[-m,-n]*ScriptK[-u,-v]*ScriptL[-o,-p,-s]*VectorSmearingS[-t]];
Expr//=MakeAnsatz[#,ConstantPrefix->"Q"]&;
ZeroAnsatz+=Expr;

Expr=ConstructDDIs[RicciCD[-i,-j]*RicciCD[-k,-l]*ScriptL[-o,-p,-s]*VectorSmearingS[-t]];
Expr//=MakeAnsatz[#,ConstantPrefix->"S"]&;
ZeroAnsatz+=Expr;

(*
Comment@"Define the antisymmetric projector for the quartic term.";
DefTensor[AntisymmetricProjector[i,j,k,l,r,-m,-n,-o,-p,-s],M3,
	{Antisymmetric[{i,j,k,l,r}],
	Antisymmetric[{-m,-n,-o,-p,-s}]},PrintAs->"\[ScriptCapitalP]"];
ExpandAntisymmetricProjector=MakeRule[{AntisymmetricProjector[i,j,k,l,r,-m,-n,-o,-p,-s],
	Evaluate@Antisymmetrize[G[i,-m]*G[j,-n]*G[k,-o]*G[l,-p]*G[r,-s],{-m,-n,-o,-p,-s}]},
	MetricOn->All, ContractMetrics->True];
AntisymmetricProjector[i,j,k,l,r,-m,-n,-o,-p,-s]~DisplayRule~ExpandAntisymmetricProjector;

DefTensor[AntisymmetricProjector4[i,j,k,l,-m,-n,-o,-p],M3,
	{Antisymmetric[{i,j,k,l}],
	Antisymmetric[{-m,-n,-o,-p}]},PrintAs->"\[ScriptCapitalP]"];
ExpandAntisymmetricProjector=MakeRule[{AntisymmetricProjector4[i,j,k,l,-m,-n,-o,-p],
	Evaluate@Antisymmetrize[G[i,-m]*G[j,-n]*G[k,-o]*G[l,-p],{-m,-n,-o,-p}]},
	MetricOn->All, ContractMetrics->True];
AntisymmetricProjector4[i,j,k,l,-m,-n,-o,-p]~DisplayRule~ExpandAntisymmetricProjector;

Comment@"Construct relevant zeros.";
ZeroAnsatz=0;
(*Expr=MakeContractionAnsatz[
	IndexFree[AntisymmetricProjector*ScriptK^4*ScriptL*VectorSmearingS],
	ConstantPrefix->"X"];
Expr//=(#/.ExpandAntisymmetricProjector)&;
Expr//=StandardSimplify;
Expr//=CollectTensors;
Expr//DisplayExpression;
ZeroAnsatz+=Expr;*)

Expr=MakeContractionAnsatz[
	IndexFree[AntisymmetricProjector*RicciCD*ScriptK^2*ScriptL*VectorSmearingS],
	ConstantPrefix->"Y"];
Expr//=(#/.ExpandAntisymmetricProjector)&;
Expr//=StandardSimplify;
Expr//=CollectTensors;
Expr//DisplayExpression;
ZeroAnsatz+=Expr;(**)

Expr=MakeContractionAnsatz[
	IndexFree[AntisymmetricProjector4*RicciCD*ScriptK^2*ScriptL*VectorSmearingS],
	ConstantPrefix->"V"];
Expr//=(#/.ExpandAntisymmetricProjector)&;
Expr//=StandardSimplify;
Expr//=CollectTensors;
Expr//DisplayExpression;
ZeroAnsatz+=Expr;(**)

(*Expr=MakeContractionAnsatz[
	IndexFree[AntisymmetricProjector*RicciCD^2*ScriptL*VectorSmearingS],
	ConstantPrefix->"Z"];
Expr//=(#/.ExpandAntisymmetricProjector)&;
Expr//=StandardSimplify;
Expr//=CollectTensors;
Expr//DisplayExpression;
*)
ZeroAnsatz+=Expr;*)
(*ZeroAnsatz=0;*)

Comment@"Construct the naive Butler-Portugal ansatz.";
Expr=MakeContractionAnsatz@IndexFree[ScriptQSingleContraction^2*ScriptL*VectorSmearingS];
SaveExpr=Expr;
Expr//=(#/.FromScriptQSingleContraction)&;
Expr//=(#/.FromScriptQ)&;
Expr//=StandardSimplify;
(*Expr//=(#/.{RicciCD->Zero,RicciScalarCD->Zero})&;*)
(*Expr//=(#/.{ScriptK->Zero})&;
Expr//DisplayExpression;*)
(*Expr//=(#/.{RicciCD[AnyInds___]->RicciCD[AnyInds]*SomeConst})&;
Expr//=(#/.{RicciScalarCD[]->RicciScalarCD[]*SomeConst})&;
Expr//=StandardSimplify;
Expr//=Series[#,{SomeConst,0,10}]&;
Expr//=Normal;
Expr=((Expr~Coefficient~(SomeConst^#))&~Map~{1});
Expr//=Total;
Expr//DisplayExpression;*)
NaiveAnsatz=Expr;

Comment@"Combine the actual quartic term with the zeros and naive ansatz.";
Expr=ZeroAnsatz+NaiveAnsatz;
SolubleParams=Expr;
SolubleParams//=Variables;
SolubleParams//=Cases[#,_?ConstantSymbolQ]&;
SolubleParams//=DeleteDuplicates;
SolubleParams//=Sort;
SolubleParams//DisplayExpression;
Expr+=ActualQuartic;
(*Expr//=(#/.{RicciCD->Zero,RicciScalarCD->Zero})&;*)
(*Expr//=(#/.{ScriptK->Zero})&;*)
Expr//=(#/.FromScriptL)&;
(*Expr//=(#/.CayleyHamiltonScriptK)&;*)
Expr//=StandardSimplify;
Expr//=CollectTensors;
Expr//DisplayExpression;
Expr//=ToConstantSymbolEquations[#==0]&;
Expr//=Solve[#,SolubleParams]&;
Expr//=First;
Expr//DisplayExpression;

Comment@"Study the original ansatz in terms of the solution.";
SaveExpr//=(#/.Expr)&;
SaveExpr//=(#/.Map[(#->0)&,SolubleParams])&;
SaveExpr//=StandardSimplify;
SaveExpr//DisplayExpression;

Quit[];

CayleyHamilton=MakeRule[{
	ScriptK[a,-b]*ScriptK[b,-c]*ScriptK[c,-d]*ScriptK[d,-a],
	(4/3)*ScriptK[a,-b]*ScriptK[b,-c]*ScriptK[c,-a]*ScriptK[d,-d]
	+(1/2)*ScriptK[a,-b]*ScriptK[b,-a]*ScriptK[c,-d]*ScriptK[d,-c]
	-ScriptK[a,-b]*ScriptK[b,-a]*ScriptK[c,-c]*ScriptK[d,-d]
	+(1/6)*ScriptK[a,-a]*ScriptK[b,-b]*ScriptK[c,-c]*ScriptK[d,-d]
}, MetricOn->All, ContractMetrics->True];

OpenCayleyHamilton=MakeRule[{
	ScriptK[a,-b]*ScriptK[b,-c]*ScriptK[c,-d],
	ScriptK[a,-b]*ScriptK[b,-d]*ScriptK[c,-c]
	+(1/2)*ScriptK[a,-d]*ScriptK[b,-c]*ScriptK[c,-b]
	-(1/2)*ScriptK[a,-d]*ScriptK[b,-b]*ScriptK[c,-c]
	+(1/6)*(
		2*ScriptK[e,-b]*ScriptK[b,-c]*ScriptK[c,-e]
		-3*ScriptK[e,-b]*ScriptK[b,-e]*ScriptK[c,-c]
		+ScriptK[e,-e]*ScriptK[b,-b]*ScriptK[c,-c]
	)*G[a,-d]}, MetricOn->All, ContractMetrics->True];

AntiExpr=ScriptK[x,-i]*ScriptK[y,-j]*ScriptL[z,-k,-l];
AntiExpr//=Antisymmetrize[#,{-i,-j,-k,-l}]&;
AntiExpr*=G[-x,i]*G[-y,j]*G[-z,k];
AntiExpr*=MakeContractionAnsatz[IndexFree[ScriptK^2*VectorSmearingS],
	IndexList[l],
	ConstantPrefix->"\[ScriptCapitalA]"];
AntiExpr//=StandardSimplify;
AntiExpr//DisplayExpression;

Anti2Expr=ScriptK[x,-v]*ScriptK[v,-i]*ScriptK[y,-j]*ScriptL[z,-k,-l];
Anti2Expr//=Antisymmetrize[#,{-i,-j,-k,-l}]&;
Anti2Expr*=G[-x,i]*G[-y,j]*G[-z,k];
Anti2Expr*=MakeContractionAnsatz[IndexFree[ScriptK*VectorSmearingS],
	IndexList[l],
	ConstantPrefix->"\[ScriptCapitalB]"];
Anti2Expr//=StandardSimplify;
Anti2Expr//DisplayExpression;

Anti3Expr=ScriptK[z,-v]*ScriptK[x,-i]*ScriptK[y,-j]*ScriptL[v,-k,-l];
Anti3Expr//=Antisymmetrize[#,{-i,-j,-k,-l}]&;
Anti3Expr*=G[-x,i]*G[-y,j]*G[-z,k];
Anti3Expr*=MakeContractionAnsatz[IndexFree[ScriptK*VectorSmearingS],
	IndexList[l],
	ConstantPrefix->"\[ScriptCapitalB]"];
Anti3Expr//=StandardSimplify;
Anti3Expr//DisplayExpression;

SecondaryExpr=MakeContractionAnsatz@IndexFree[ScriptQSingleContraction^2*ScriptL*VectorSmearingS];
SecondaryExpr//=(#/.FromScriptQSingleContraction)&;
SecondaryExpr//=(#/.FromScriptQ)&;
SecondaryExpr//=StandardSimplify;
SecondaryExpr//=(#/.{RicciCD->Zero,RicciScalarCD->Zero})&;
SecondaryExpr//=StandardSimplify;
SecondaryExpr//DisplayExpression;

SecondaryExpr-=Expr;
SecondaryExpr-=AntiExpr;
SecondaryExpr-=Anti2Expr;
SecondaryExpr-=Anti3Expr;
SecondaryExpr//=StandardSimplify;
SecondaryExpr//=CollectTensors;
SecondaryExpr//DisplayExpression;
SecondaryExpr//=(#/.CayleyHamilton)&;
SecondaryExpr//=StandardSimplify;
SecondaryExpr//=CollectTensors;
SecondaryExpr//DisplayExpression;
SecondaryExpr//=(#/.OpenCayleyHamilton)&;
SecondaryExpr//=StandardSimplify;
SecondaryExpr//=CollectTensors;
SecondaryExpr//DisplayExpression;
SecondaryExpr//=ToConstantSymbolEquations[#==0]&;
SecondaryExpr//=Solve;
SecondaryExpr//DisplayExpression;

Quit[];

Expr//=FindAlgebra[#,{
{{ScriptL},{CD,ScalarSmearingF,ScalarSmearingS}},
{{ScriptL,ScriptL,ScriptL},
	{CD,ScalarSmearingF,ScalarSmearingS}},
{{ScriptL,ScriptQSingleContraction,ScriptQSingleContraction},
	{CD,ScalarSmearingF,ScalarSmearingS}},
{{ScriptL,RicciCD,ScriptQSingleContraction},
	{CD,ScalarSmearingF,ScalarSmearingS}},
{{ScriptL,RicciCD,RicciCD},
	{CD,ScalarSmearingF,ScalarSmearingS}}
	},Method->LinearSolve,Verify->True]&;
Expr//DisplayExpression;
DisplayExpression@TestSkew@Expr;


Quit[];

(*Comment@"Create reverse rule to convert ConjugateMomentumG back to ScriptK expressions";
ConjugateMomentumGToScriptK = MakeRule[{
    ConjugateMomentumG[-i,-j],
    Sqrt[DetG[]]*(-ScriptK[-i,-j]/EinsteinConstant + G[-i,-j]*ScriptK[k,-k]/EinsteinConstant)
}, MetricOn->All, ContractMetrics->True];
ConjugateMomentumG[-i,-j]~DisplayRule~ConjugateMomentumGToScriptK;*)

(*Comment@"Reverse rule for trace part - using explicit trace expression to avoid undefined tensor";
TraceConjugateMomentumGToTraceScriptK = MakeRule[{
    TraceConjugateMomentumG[],
    -2*Sqrt[DetG[]]*G[i,j]*ScriptK[-i,-j]/EinsteinConstant
}, MetricOn->All, ContractMetrics->True];
TraceConjugateMomentumG[]~DisplayRule~TraceConjugateMomentumGToTraceScriptK;*)
(*Comment@"Create reverse rule for ScriptL: convert CD@ScriptK to ScriptL plus symmetric part";
Comment@"Since ScriptL[i,-j,-k] = CD[-k]@ScriptK[i,-j] - CD[-j]@ScriptK[i,-k], we can solve for CD[-k]@ScriptK[i,-j]";
CDScriptKToScriptL = MakeRule[{
    CD[-k]@ScriptK[i,-j],
    (1/2)*(ScriptL[i,-j,-k] + CD[-k]@ScriptK[i,-j] + CD[-j]@ScriptK[i,-k])
}, MetricOn->All, ContractMetrics->True];
CD[-k]@ScriptK[i,-j]~DisplayRule~CDScriptKToScriptL;*)
(*Comment@"Create reverse rule for ScriptQ: convert ScriptK products to ScriptQ plus symmetric part";*)
(*Comment@"Since ScriptQ[i,j,-k,-l] = ScriptK[i,-k]*ScriptK[j,-l] - ScriptK[i,-l]*ScriptK[j,-k] + RiemannCD[i,j,-k,-l], we can solve for ScriptK[i,-k]*ScriptK[j,-l]";
ScriptKProductToScriptQ = MakeRule[{
    ScriptK[i,-k]*ScriptK[j,-l],
    (1/2)*(ScriptQ[i,j,-k,-l] - RiemannCD[i,j,-k,-l] + ScriptK[i,-k]*ScriptK[j,-l] + ScriptK[i,-l]*ScriptK[j,-k])
}, MetricOn->All, ContractMetrics->True];
(ScriptK[i,-k]*ScriptK[j,-l])~DisplayRule~ScriptKProductToScriptQ;*)

(*Comment@"Alternative reverse rule: convert RiemannCD to ScriptQ minus ScriptK products";
Comment@"From ScriptQ[i,j,-k,-l] = ScriptK[i,-k]*ScriptK[j,-l] - ScriptK[i,-l]*ScriptK[j,-k] + RiemannCD[i,j,-k,-l]";
RiemannCDToScriptQ = MakeRule[{
    RiemannCD[i,j,-k,-l],
    ScriptQ[i,j,-k,-l] - ScriptK[i,-k]*ScriptK[j,-l] + ScriptK[i,-l]*ScriptK[j,-k]
}, MetricOn->All, ContractMetrics->True];
RiemannCD[i,j,-k,-l]~DisplayRule~RiemannCDToScriptQ;*)

(*Comment@"Inverse of uncontraction: G[i,j]*ScriptK[-i,-j] back to TraceScriptK[]";
ScriptKToTraceScriptK = MakeRule[{
    G[i,j]*ScriptK[-i,-j],
    TraceScriptK[]
}, MetricOn->All, ContractMetrics->True];
(G[i,j]*ScriptK[-i,-j])~DisplayRule~ScriptKToTraceScriptK;

Comment@"Inverse of uncontraction: ScriptQ[i,k,-j,-k] back to ScriptQSingleContraction[i,-j]";
ScriptQToScriptQSingleContraction = MakeRule[{
    ScriptQ[i,k,-j,-k],
    ScriptQSingleContraction[i,-j]
}, MetricOn->All, ContractMetrics->True];
(ScriptQ[i,k,-j,-k])~DisplayRule~ScriptQToScriptQSingleContraction;

Comment@"Inverse of uncontraction: ScriptL[j,-j,-i] back to ScriptLContraction[-i]";
ScriptLToScriptLContraction = MakeRule[{
    ScriptL[j,-j,-i],
    ScriptLContraction[-i]
}, MetricOn->All, ContractMetrics->True];
(ScriptL[j,-j,-i])~DisplayRule~ScriptLToScriptLContraction;

Comment@"Inverse of uncontraction: ScriptQ[i,j,-i,-j] back to TraceScriptQ[]";
ScriptQToTraceScriptQ = MakeRule[{
    ScriptQ[i,j,-i,-j],
    TraceScriptQ[]
}, MetricOn->All, ContractMetrics->True];
(ScriptQ[i,j,-i,-j])~DisplayRule~ScriptQToTraceScriptQ;

Comment@"Barred quantities for reduced canonical action defined. These represent the reduced forms of auxiliary fields after solving constraint equations.";

Subsection@"Reduced Hamiltonian and Momentum Constraints";

Comment@"Now define the reduced Hamiltonian and momentum constraints using the barred quantities. These are the constraints that survive after eliminating spurious degrees of freedom.";*)


(**)
Get@FileNameJoin@{NotebookDirectory[], "FinalAutoCommutator.mx"};

Expr//DisplayExpression;
Comment@"Symmetr";
Expr//=TestSkew;
Expr//DisplayExpression;
Expr//=VarD[ScalarSmearingS[],CD];
Expr//=CollectTensors[#,CollectMethod->xAct`Hamilcar`Private`DerivativeCanonical]&;
Expr//=ContractMetric;
Expr//=ToCanonical;
Expr//=ScreenDollarIndices;
Expr//=CollectTensors[#,CollectMethod->xAct`Hamilcar`Private`DerivativeCanonical]&;
Expr//DisplayExpression;

Quit[];

Comment@"8. Define BarK_{ij} (reduced extrinsic curvature) = ScriptK_{ij} + alpha * DeltaK_{ij}";
DefTensor[BarExtrinsicCurvature[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\!\(\*OverscriptBox[\(\[ScriptCapitalK]\), \(_\)]\)"];
DefTensor[DeltaExtrinsicCurvature[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\[CapitalDelta]\[ScriptCapitalK]"];
FromBarExtrinsicCurvature = MakeRule[{
    BarExtrinsicCurvature[-i,-j],
    ScriptK[-i,-j] + WilsonCoefficient*DeltaExtrinsicCurvature[-i,-j]
}, MetricOn->All, ContractMetrics->True];
BarExtrinsicCurvature[-i,-j]~DisplayRule~FromBarExtrinsicCurvature;
FromBarExtrinsicCurvature//PrependTotalFrom;

Comment@"9. Define BarRho^{ij} (reduced auxiliary density) = -6*alpha*kappa^2*sqrt(g)*[4*ScriptQ^{ik}*ScriptQ_k^j - 4*ScriptQ^{ij}*ScriptQ + g^{ij}*ScriptQ^2 - 2*ScriptL^{ikl}*ScriptL^j_{kl}]";
DefTensor[BarAuxiliaryDensity[i,j], M3, Symmetric[{i,j}], PrintAs->"\!\(\*OverscriptBox[\(\[Rho]\), \(_\)]\)"];
FromBarAuxiliaryDensity = MakeRule[{
    BarAuxiliaryDensity[i,j],
    -6*WilsonCoefficient*EinsteinConstant*Sqrt[DetG[]]*(
        4*ScriptQSingleContraction[i,-k]*ScriptQSingleContraction[k,j] - 
        4*ScriptQSingleContraction[i,j]*TraceScriptQ[] +
        G[i,j]*TraceScriptQ[]^2 - 
        2*ScriptL[i,-k,-l]*ScriptL[j,k,l]
    )
}, MetricOn->All, ContractMetrics->True];
BarAuxiliaryDensity[i,j]~DisplayRule~FromBarAuxiliaryDensity;
FromBarAuxiliaryDensity//PrependTotalFrom;

Comment@"10. Define BarF_{ij} (reduced multiplier field) = -(ScriptQ_{ij} - g_{ij}/2 * ScriptQ) + alpha * DeltaF_{ij}";
DefTensor[BarMultiplierField[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\!\(\*OverscriptBox[\(\[ScriptCapitalF]\), \(_\)]\)"];
DefTensor[DeltaMultiplierField[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\[CapitalDelta]\[ScriptCapitalF]"];
FromBarMultiplierField = MakeRule[{
    BarMultiplierField[-i,-j],
    -(ScriptQSingleContraction[-i,-j] - G[-i,-j]/2*TraceScriptQ[]) + WilsonCoefficient*DeltaMultiplierField[-i,-j]
}, MetricOn->All, ContractMetrics->True];
BarMultiplierField[-i,-j]~DisplayRule~FromBarMultiplierField;
FromBarMultiplierField//PrependTotalFrom;


Expr//=VarD[ScalarSmearingS[],CD];
Expr*=ScalarSmearingS[];
Expr//=StandardSimplify;

Comment@"Implementing the ToCrossedSmearingF rule";
Expr//=CollectTensors;
Expr//=(#/.ToCrossedSmearingF)&;
Expr//=StandardSimplify;

Expr//=(#/.{CrossedSmearingF->Zero})&;
Expr//=StandardSimplify;

Expr//=D[#,CosmologicalConstant]&;
Expr//=StandardSimplify;

(*
Comment@"Implementing the ToCrossedSmearingF rule again";
Expr//=CollectTensors;
Expr//=(#/.ToCrossedSmearingF)&;
Expr//=StandardSimplify;
*)

Expr//DisplayExpression;
Quit[];

Comment@"Variations of the smearing functions";

Expr//=VarD[CrossedSmearingF[-i],CD];
Expr//=StandardSimplify;

Comment@"Higher derivative canonical form";

Expr//=xAct`Hamilcar`Private`ToHigherDerivativeCanonical;
Expr//=CollectTensors;

Expr//DisplayExpression;
FinalAutoCommutatorValue = Expr;
DumpSave[FileNameJoin@{NotebookDirectory[], "FinalAutoCommutator.mx"}, FinalAutoCommutatorValue];
Quit[];
(**)
Get@FileNameJoin@{NotebookDirectory[], "FinalAutoCommutator.mx"};
(*DisplayExpression[FinalAutoCommutatorValue, EqnLabel->"FinalAutoCommutatorValue"];*)

Expr=FinalAutoCommutatorValue;
(*
Expr//=(#/.CDScriptKToScriptL)&;
Expr//=StandardSimplify;
(*Expr//=xAct`Hamilcar`Private`ToHigherDerivativeCanonical;*)

Expr//=(#/.CDScriptKToScriptL)&;
Expr//=StandardSimplify;
(*Expr//=xAct`Hamilcar`Private`ToHigherDerivativeCanonical;*)

Expr//=(#/.CDScriptKToScriptL)&;
Expr//=StandardSimplify;
(*Expr//=xAct`Hamilcar`Private`ToHigherDerivativeCanonical;*)
*)

Expr//=xAct`Hamilcar`Private`ToHigherDerivativeCanonical;
Expr//=CollectTensors;
Expr//DisplayExpression;

(*
=== AVAILABLE INVERSE RULES FOR CONSTRAINT ALGEBRA SIMPLIFICATION ===

Basic tensor inverse rules:
- ConjugateMomentumGToScriptK
- TraceConjugateMomentumGToTraceScriptK  
- CDScriptKToScriptL
- ScriptKProductToScriptQ
- RiemannCDToScriptQ

Uncontraction inverse rules:
- ScriptKToTraceScriptK
- ScriptQToScriptQSingleContraction
- ScriptLToScriptLContraction
- ScriptQToTraceScriptQ

Usage: Apply manually with expr //= (# /. RuleName)& for constraint algebra compactification
*)

Quit[];
Quit[];

Comment@"2. Compute the cross-bracket between reduced Hamiltonian and momentum constraints: {H_red, H_red^i}";
(*
ReducedHamiltonianMomentumBracket = {ScalarSmearingF[]*ReducedHamiltonianConstraint[], VectorSmearingS[-i]*ReducedMomentumConstraint[i]};
DisplayExpression[ReducedHamiltonianMomentumBracket, EqnLabel->"ReducedHamiltonianMomentumBracketSetup"];
ReducedHamiltonianMomentumBracket //= (TotalFrom/@#)&;
ReducedHamiltonianMomentumBracket //= (PoissonBracket@@#)&;
ReducedHamiltonianMomentumBracket //= TotalTo;
ReducedHamiltonianMomentumBracketValue = ReducedHamiltonianMomentumBracket;
DumpSave[FileNameJoin@{NotebookDirectory[], "ReducedHamiltonianMomentumBracket.mx"}, ReducedHamiltonianMomentumBracketValue];
*)
ReducedHamiltonianMomentumBracket = {ScalarSmearingF[]*ReducedHamiltonianConstraint[], VectorSmearingS[-i]*ReducedMomentumConstraint[i]};
DisplayExpression[ReducedHamiltonianMomentumBracket, EqnLabel->"ReducedHamiltonianMomentumBracketSetup"];
Get@FileNameJoin@{NotebookDirectory[], "ReducedHamiltonianMomentumBracket.mx"};
DisplayExpression[ReducedHamiltonianMomentumBracketValue, EqnLabel->"ReducedHamiltonianMomentumBracketResult"];
ReducedHamiltonianMomentumBracket = ReducedHamiltonianMomentumBracketValue;

Comment@"3. Compute the reduced momentum constraint self-bracket: {H_red^i, H_red^j}";
(*
ReducedMomentumSelfBracket = {VectorSmearingF[-i]*ReducedMomentumConstraint[i], VectorSmearingS[-j]*ReducedMomentumConstraint[j]};
DisplayExpression[ReducedMomentumSelfBracket, EqnLabel->"ReducedMomentumSelfBracketSetup"];
ReducedMomentumSelfBracket //= (TotalFrom/@#)&;
ReducedMomentumSelfBracket //= (PoissonBracket@@#)&;
ReducedMomentumSelfBracket //= TotalTo;
ReducedMomentumSelfBracketValue = ReducedMomentumSelfBracket;
DumpSave[FileNameJoin@{NotebookDirectory[], "ReducedMomentumSelfBracket.mx"}, ReducedMomentumSelfBracketValue];
*)
ReducedMomentumSelfBracket = {VectorSmearingF[-i]*ReducedMomentumConstraint[i], VectorSmearingS[-j]*ReducedMomentumConstraint[j]};
DisplayExpression[ReducedMomentumSelfBracket, EqnLabel->"ReducedMomentumSelfBracketSetup"];
Get@FileNameJoin@{NotebookDirectory[], "ReducedMomentumSelfBracket.mx"};
DisplayExpression[ReducedMomentumSelfBracketValue, EqnLabel->"ReducedMomentumSelfBracketResult"];
ReducedMomentumSelfBracket = ReducedMomentumSelfBracketValue;

Comment@"Compute the second cross-term {H1, H0} with parallel computation.";
CrossBracket10File = FileNameJoin@{NotebookDirectory[], "CrossBracket10.mx"};
If[!FileExistsQ[CrossBracket10File],
    Comment@"Computing {H1, H0} bracket with parallel computation...";
    CrossBracket10 = {H1, H0};
    CrossBracket10 //= ((PoissonBracket[#1,#2,Parallel->True])&@@#)&;
    DumpSave[CrossBracket10File, CrossBracket10];
    Comment@"Cross-term {H1, H0} computed and saved.";
,
    Comment@"Loading cached {H1, H0} bracket...";
];
Get[CrossBracket10File];
DisplayExpression[CrossBracket10, EqnLabel->"CrossBracket10"];

Comment@"(*TODO: Use FindAlgebra to determine the structure coefficients and verify first-class nature of the reduced constraint algebra*)";

Quit[];

(*
Subsection@"EOM1: Variation with respect to Rho^{ij}";

Comment@"From delta S/delta rho^{ij} = 0, excluding K_dot_{ij} time derivative";
DefTensor[EOM1[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\[ScriptCapitalE]1"];
EOM1Value=HoldForm@(
    Lapse[]*AuxiliaryExtrinsicCurvature[-i,-k]*AuxiliaryExtrinsicCurvature[k,-j]
    - Shift[k]*CD[-k]@AuxiliaryExtrinsicCurvature[-i,-j]
    - AuxiliaryExtrinsicCurvature[-k,-i]*CD[-j]@Shift[k]
    - AuxiliaryExtrinsicCurvature[-k,-j]*CD[-i]@Shift[k]
    + CD[-i]@CD[-j]@Lapse[]
    + Lapse[]*AuxiliaryVelocityField[-i,-j]
);
EOM1Value//DisplayExpression;
EOM1Value//=ReleaseHold;
FromEOM1 = MakeRule[{EOM1[-i,-j],
	Evaluate@EOM1Value
}, MetricOn->All, ContractMetrics->True];
EOM1[-i,-j]~DisplayRule~FromEOM1;
FromEOM1//PrependTotalFrom;
DisplayExpression[EOM1[-i,-j], EqnLabel->"EOM1"];
EOM1[-i,-j]//ToCanonical;

Comment@"Verify EOM1: Compute delta S/delta rho^{ij} using Poisson bracket with canonical Hamiltonian";

ComputedEOM1 = (TensorSmearingFUp[i,j]*AuxiliaryExtrinsicCurvature[-i,-j])~PoissonBracket~(CanonicalHamiltonian[]);
ComputedEOM1//=VarD[TensorSmearingFUp[i,j],CD];
ComputedEOM1//=TotalFrom;
ComputedEOM1//=TotalTo;
DisplayExpression[ComputedEOM1, EqnLabel->"ComputedEOM1"];

Comment@"Compare with our copied EOM1 expression (test for constant factor)";
CompareExpressionsWithConstant[ComputedEOM1,EOM1[-i,-j]];
*)

(*
Subsection@"EOM2: Variation with respect to K_{ij}";

Comment@"From delta S/delta K_{ij} = 0, including rho_dot^{ij} time derivative. This is a very complex equation with multiple terms.";
DefTensor[EOM2[i,j], M3, Symmetric[{i,j}], PrintAs->"\[ScriptCapitalE]2"];
EOM2Value=HoldForm@(
    (* Time derivative term *)
    -ConjugateMomentumAuxiliaryExtrinsicCurvaturep[i,j] +
    (* First line: metric terms with Rho, Pi, K - symmetrized over (i,j) *)
    Sqrt[DetG[]]*((Lapse[]*AuxiliaryExtrinsicCurvature[-k,i] - CD[-k]@Shift[i])*ConjugateMomentumAuxiliaryExtrinsicCurvature[j,k]/Sqrt[DetG[]]
                + (Lapse[]*AuxiliaryExtrinsicCurvature[-k,j] - CD[-k]@Shift[j])*ConjugateMomentumAuxiliaryExtrinsicCurvature[i,k]/Sqrt[DetG[]])
    + Sqrt[DetG[]]*CD[-k]@(Shift[k]*ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j]/Sqrt[DetG[]])
    + Sqrt[DetG[]]*2*Lapse[]*(ConjugateMomentumG[i,j]/Sqrt[DetG[]] + (AuxiliaryExtrinsicCurvature[i,j] - G[i,j]*TraceAuxiliaryExtrinsicCurvature[])/EinsteinConstant)
    (* Cubic correction terms with WilsonCoefficientEinsteinConstant^2 - all symmetrized over (i,j) *)
    - 12*WilsonCoefficient*EinsteinConstant*Lapse[]*Sqrt[DetG[]]*(
        (* 4Nabla_l L_k^{l(i} F^{j)k} symmetrized - NOTE: TYPO CORRECTED FROM ORIGINAL PAPER *)
        (* Original TeX has Nabla_l L_{kl}^i F^{jk} but should be (1/N)Nabla_l(N L_{kl}^i F^{jk}) *)
        (* This implements the correct covariant derivative of the product with proper lapse factor treatment *)
        2*(1/Lapse[])*(CD[-l]@(Lapse[]*AuxiliaryTensorL[-k,l,i]*AuxiliaryVelocityField[j,k]) + CD[-l]@(Lapse[]*AuxiliaryTensorL[-k,l,j]*AuxiliaryVelocityField[i,k]))
        (* Q^{klm(i} Q^{j)n}_{kl} K_{mn} symmetrized *)
        + (1/2)*(AuxiliaryTensorQ[k,l,m,i]*AuxiliaryTensorQ[j,n,-k,-l]*AuxiliaryExtrinsicCurvature[-m,-n] + AuxiliaryTensorQ[k,l,m,j]*AuxiliaryTensorQ[i,n,-k,-l]*AuxiliaryExtrinsicCurvature[-m,-n])
        (* -2 L^{mk(i} L_m^{j)l} K_{kl} symmetrized *)
        - (AuxiliaryTensorL[m,k,i]*AuxiliaryTensorL[-m,j,l]*AuxiliaryExtrinsicCurvature[-k,-l] + AuxiliaryTensorL[m,k,j]*AuxiliaryTensorL[-m,i,l]*AuxiliaryExtrinsicCurvature[-k,-l])
        (* (2/N)Nabla_m(N Q_{kl}^{m(i} L^{j)kl}) symmetrized *)
        + (1/Lapse[])*CD[-m]@(Lapse[]*AuxiliaryTensorQ[-k,-l,m,i]*AuxiliaryTensorL[j,k,l] + Lapse[]*AuxiliaryTensorQ[-k,-l,m,j]*AuxiliaryTensorL[i,k,l])
    )
);
EOM2Value//DisplayExpression;
EOM2Value//=ReleaseHold;
FromEOM2 = MakeRule[{EOM2[i,j],
	Evaluate@EOM2Value
}, MetricOn->All, ContractMetrics->True];
EOM2[i,j]~DisplayRule~FromEOM2;
FromEOM2//PrependTotalFrom;
DisplayExpression[EOM2[i,j], EqnLabel->"EOM2"];
EOM2[i,j]//ToCanonical;

Comment@"Verify EOM2: Compute DeltaS/DeltaK_{ij} using Poisson bracket with canonical Hamiltonian";
ComputedEOM2 = (TensorSmearingF[-i,-j]*ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j])~PoissonBracket~(CanonicalHamiltonian[]);
ComputedEOM2//=VarD[TensorSmearingF[-i,-j],CD];
ComputedEOM2//=TotalFrom;
ComputedEOM2//=TotalTo;
DisplayExpression[ComputedEOM2, EqnLabel->"ComputedEOM2"];

Comment@"Compare with our copied EOM2 expression (test for constant factor)";
CompareExpressionsWithConstant[ComputedEOM2, EOM2[i,j]];
Quit[];
*)

(*
Subsection@"EOM3: Variation with respect to Pi^{ij}";

Comment@"From delta S/delta pi^{ij} = 0, including g_dot_{ij} time derivative";
DefTensor[EOM3[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\[ScriptCapitalE]3"];
EOM3Value=HoldForm@(
    (* Time derivative term *)
    GTimep[-i,-j] +
    (* Constraint terms *)
    -(CD[-i]@Shift[-j] + CD[-j]@Shift[-i]) + 2*Lapse[]*AuxiliaryExtrinsicCurvature[-i,-j]
);
EOM3Value//DisplayExpression;
EOM3Value//=ReleaseHold;
FromEOM3 = MakeRule[{EOM3[-i,-j],
	Evaluate@EOM3Value
}, MetricOn->All, ContractMetrics->True];
EOM3[-i,-j]~DisplayRule~FromEOM3;
FromEOM3//PrependTotalFrom;
DisplayExpression[EOM3[-i,-j], EqnLabel->"EOM3"];
EOM3[-i,-j]//ToCanonical;

Comment@"Verify EOM3: Compute delta S/delta pi^{ij} using Poisson bracket with canonical Hamiltonian";
ComputedEOM3 = (TensorSmearingFUp[i,j]*G[-i,-j])~PoissonBracket~(CanonicalHamiltonian[]);
ComputedEOM3//=VarD[TensorSmearingFUp[i,j],CD];
ComputedEOM3//=TotalFrom;
ComputedEOM3//=TotalTo;
DisplayExpression[ComputedEOM3, EqnLabel->"ComputedEOM3"];

Comment@"Compare with our copied EOM3 expression (test for constant factor)";
CompareExpressionsWithConstant[ComputedEOM3, EOM3[-i,-j]];
*)
(*
Subsection@"EOM4: Variation with respect to g_{ij}";

Comment@"From delta S/delta g_{ij} = 0, including pi_dot^{ij} time derivative. This includes Einstein tensor terms and complex derivative expressions.";
DefTensor[EOM4[i,j], M3, Symmetric[{i,j}], PrintAs->"\[ScriptCapitalE]4"];
DefTensor[EinsteinTensor[i,j], M3, Symmetric[{i,j}], PrintAs->"G"];
FromEinsteinTensor = MakeRule[{EinsteinTensor[i,j],
    G[i,k]*G[j,l]*(RicciCD[-k,-l] - (1/2)*G[-k,-l]*RicciScalarCD[])
}, MetricOn->All, ContractMetrics->True];
EinsteinTensor[i,j]~DisplayRule~FromEinsteinTensor;
FromEinsteinTensor//PrependTotalFrom;

Comment@"Define the lengthy G^{ij} tensor from the LaTeX expression";
DefTensor[LengthyTensorGij[i,j], M3, Symmetric[{i,j}], PrintAs->"\[ScriptCapitalG]"];
LengthyTensorGijValue = HoldForm@(
    (* Section 1: 24 N sqrt(g) [ first line until \\ - LITERAL TRANSLATION ] *)
    (* LaTeX: F^{m(i} L^{j)}_{kl} L_m^{kl} - F_{kl} F^{k(i} F^{j)l} - F^{kl} L_{km}^{(i} L_l^{j)m} - (1/2) L^a_{mn} L_{al}^{(j} Q^{i)lmn} *)
    24*Lapse[]*Sqrt[DetG[]]*(
        (* Term 1: F^{m(i} L^{j)}_{kl} L_m^{kl} *)
        (1/2)*(AuxiliaryVelocityField[m,i]*AuxiliaryTensorL[j,-k,-l] + AuxiliaryVelocityField[m,j]*AuxiliaryTensorL[i,-k,-l])*AuxiliaryTensorL[-m,k,l] -
        (* Term 2: F_{kl} F^{k(i} F^{j)l} *)
        AuxiliaryVelocityField[-k,-l]*(1/2)*(AuxiliaryVelocityField[k,i]*AuxiliaryVelocityField[j,l] + AuxiliaryVelocityField[k,j]*AuxiliaryVelocityField[i,l]) -
        (* Term 3: F^{kl} L_{km}^{(i} L_l^{j)m} *)
        AuxiliaryVelocityField[k,l]*(1/2)*(AuxiliaryTensorL[-k,-m,i]*AuxiliaryTensorL[-l,j,m] + AuxiliaryTensorL[-k,-m,j]*AuxiliaryTensorL[-l,i,m]) -
        (* Term 4: (1/2) L^a_{mn} L_{al}^{(j} Q^{i)lmn} - LITERAL TRANSLATION *)
        (1/2)*AuxiliaryTensorL[a,-m,-n]*(1/2)*(AuxiliaryTensorL[-a,-l,j]*AuxiliaryTensorQ[i,l,m,n] + AuxiliaryTensorL[-a,-l,i]*AuxiliaryTensorQ[j,l,m,n])
    ) +
    (* Section 2: 3 N sqrt(g) terms *)
    3*Lapse[]*Sqrt[DetG[]]*(
        (* 2 Q^{klmn} L^{(i}_{kl} L^{j)}_{mn} *)
        2*AuxiliaryTensorQ[x,y,z,b]*(1/2)*(AuxiliaryTensorL[i,-x,-y]*AuxiliaryTensorL[j,-z,-b] + AuxiliaryTensorL[j,-x,-y]*AuxiliaryTensorL[i,-z,-b]) +
        (* (Q^{kl}_{mn} Q^{mna(i} - 2 L_m^{kl} L^{ma(i})(2 K^{j)}_k K_{la} + Q^{j)}_{akl}) *)
        (1/2)*(
            (AuxiliaryTensorQ[k,l,-m,-n]*AuxiliaryTensorQ[m,n,a,i] - 2*AuxiliaryTensorL[-m,k,l]*AuxiliaryTensorL[m,a,i])*
            (2*AuxiliaryExtrinsicCurvature[j,-k]*AuxiliaryExtrinsicCurvature[-l,-a] + AuxiliaryTensorQ[j,-a,-k,-l]) +
            (AuxiliaryTensorQ[p,q,-r,-s]*AuxiliaryTensorQ[r,s,c,j] - 2*AuxiliaryTensorL[-r,p,q]*AuxiliaryTensorL[r,c,j])*
            (2*AuxiliaryExtrinsicCurvature[i,-p]*AuxiliaryExtrinsicCurvature[-q,-c] + AuxiliaryTensorQ[i,-c,-p,-q])
        )
    ) +
    (* Section 3: N sqrt(g) g^{ij} terms *)
    Lapse[]*Sqrt[DetG[]]*G[i,j]*(
        (* 2 F^m_n (2 F^n_k F^k_m - 3 L_m^{kl} L^n_{kl}) *)
        2*AuxiliaryVelocityField[c,-d]*(2*AuxiliaryVelocityField[d,-e]*AuxiliaryVelocityField[e,-c] - 3*AuxiliaryTensorL[-c,f,g]*AuxiliaryTensorL[d,-f,-g]) +
        (* (1/2) Q^{mn}_{kl} (Q^{kl}_{ab} Q^{ab}_{mn} - 6 L_a^{kl} L^a_{mn}) *)
        (1/2)*AuxiliaryTensorQ[h,n,-o,p]*(AuxiliaryTensorQ[o,-p,-q,-r]*AuxiliaryTensorQ[q,r,-h,-n] - 6*AuxiliaryTensorL[-s,o,-p]*AuxiliaryTensorL[s,-h,-n])
    ) +
    (* Section 4-5: Fourth and Fifth lines - LITERAL TRANSLATION from LaTeX lines 2662-2696 *)
    (* LaTeX: 12Sqrtg Nabla_k [ N Q^{kl}_{ab} K_l^{(i} L^{j)ab} + N K_l^{(i} Q^{j)l}_{ab} L^{kab} + N Q^{l(i}_{ab} L^{j)ab} K^k_l + 2N F^{m(i} K^{j)}_l L_m^{kl} - 2N L_l^{m(i} K^{j)}_m F^{kl} + 2N L_l^{m(i} F^{j)l} K^k_m + (1/2)Nabla_l[N Q^{mnk(i} Q^{j)l}_{mn} - 2N L^{ml(i} L_m^{j)k}] ] *)
    12*Sqrt[DetG[]]*CD[-k]@(
        (* Term 1: N Q^{kl}_{ab} K_l^{(i} L^{j)ab} *)
        Lapse[]*AuxiliaryTensorQ[k,l,-a,-b]*(1/2)*(AuxiliaryExtrinsicCurvature[-l,i]*AuxiliaryTensorL[j,a,b] + AuxiliaryExtrinsicCurvature[-l,j]*AuxiliaryTensorL[i,a,b]) +
        (* Term 2: N K_l^{(i} Q^{j)l}_{ab} L^{kab} *)
        Lapse[]*(1/2)*(AuxiliaryExtrinsicCurvature[-l,i]*AuxiliaryTensorQ[j,l,-c,-d]*AuxiliaryTensorL[k,c,d] + AuxiliaryExtrinsicCurvature[-l,j]*AuxiliaryTensorQ[i,l,-c,-d]*AuxiliaryTensorL[k,c,d]) +
        (* Term 3: N Q^{l(i}_{ab} L^{j)ab} K^k_l *)
        Lapse[]*(1/2)*(AuxiliaryTensorQ[l,i,-e,-f]*AuxiliaryTensorL[j,e,f]*AuxiliaryExtrinsicCurvature[k,-l] + AuxiliaryTensorQ[l,j,-e,-f]*AuxiliaryTensorL[i,e,f]*AuxiliaryExtrinsicCurvature[k,-l]) +
        (* Term 4: 2N F^{m(i} K^{j)}_l L_m^{kl} *)
        2*Lapse[]*(1/2)*(AuxiliaryVelocityField[m,i]*AuxiliaryExtrinsicCurvature[j,-l]*AuxiliaryTensorL[-m,k,l] + AuxiliaryVelocityField[m,j]*AuxiliaryExtrinsicCurvature[i,-l]*AuxiliaryTensorL[-m,k,l]) +
        (* Term 5: -2N L_l^{m(i} K^{j)}_m F^{kl} *)
        -2*Lapse[]*(1/2)*(AuxiliaryTensorL[-l,m,i]*AuxiliaryExtrinsicCurvature[j,-m]*AuxiliaryVelocityField[k,l] + AuxiliaryTensorL[-l,m,j]*AuxiliaryExtrinsicCurvature[i,-m]*AuxiliaryVelocityField[k,l]) +
        (* Term 6: 2N L_l^{m(i} F^{j)l} K^k_m *)
        2*Lapse[]*(1/2)*(AuxiliaryTensorL[-l,m,i]*AuxiliaryVelocityField[j,l]*AuxiliaryExtrinsicCurvature[k,-m] + AuxiliaryTensorL[-l,m,j]*AuxiliaryVelocityField[i,l]*AuxiliaryExtrinsicCurvature[k,-m]) +
        (* Term 7: (1/2)Nabla_l[N Q^{mnk(i} Q^{j)l}_{mn} - 2N L^{ml(i} L_m^{j)k}] *)
        (1/2)*CD[-l]@(
            Lapse[]*(1/2)*(AuxiliaryTensorQ[m,n,k,i]*AuxiliaryTensorQ[j,l,-m,-n] + AuxiliaryTensorQ[m,n,k,j]*AuxiliaryTensorQ[i,l,-m,-n]) -
            2*Lapse[]*(1/2)*(AuxiliaryTensorL[m,l,i]*AuxiliaryTensorL[-m,j,k] + AuxiliaryTensorL[m,l,j]*AuxiliaryTensorL[-m,i,k])
        )
    )
);
LengthyTensorGijValue//DisplayExpression;
LengthyTensorGijValue//=ReleaseHold;
LengthyTensorGijValue//=ToCanonical;
FromLengthyTensorGij = MakeRule[{LengthyTensorGij[i,j],
    Evaluate@LengthyTensorGijValue
}, MetricOn->All, ContractMetrics->True];
LengthyTensorGij[i,j]~DisplayRule~FromLengthyTensorGij;
FromLengthyTensorGij//PrependTotalFrom;
DisplayExpression[EinsteinTensor[i,j], EqnLabel->"EinsteinTensor"];

EOM4Value=HoldForm@(
    (* Time derivative term - Pi^{ij} *)
    -ConjugateMomentumGp[i,j] +
    (* Einstein-Hilbert terms with consistent upstairs indices and symmetrization *)
    Lapse[]*Sqrt[DetG[]]/EinsteinConstant*(-2*(1/2)*(AuxiliaryExtrinsicCurvature[k,i]*AuxiliaryExtrinsicCurvature[j,-k] + AuxiliaryExtrinsicCurvature[k,j]*AuxiliaryExtrinsicCurvature[i,-k])
        + 2*AuxiliaryExtrinsicCurvature[i,j]*TraceAuxiliaryExtrinsicCurvature[]
        - EinsteinTensor[i,j]
        + G[i,j]/2*(AuxiliaryExtrinsicCurvature[k,l]*AuxiliaryExtrinsicCurvature[-k,-l] - TraceAuxiliaryExtrinsicCurvature[]^2 - 2*CosmologicalConstant))
    (* Derivative terms with upstairs indices - simplified *)
    + Sqrt[DetG[]]/EinsteinConstant*(CD[i]@CD[j]@Lapse[] - G[i,j]*CD[k]@CD[-k]@Lapse[])
    (* Complex constraint derivative terms - LITERAL TRANSLATION from LaTeX lines 771-788 *)
    (* Sqrtg Nabla_k [ N^k Pi^{ij}/Sqrtg - 2 Pi^{k(i}/Sqrtg N^{j)} + Rho^{k(i}/Sqrtg Nabla^{j)} N - (1/2) Rho^{ij}/Sqrtg Nabla^k N - 2 Rho^{kl}/Sqrtg K^{(i}_l N^{j)} ] *)
    + Sqrt[DetG[]]*CD[-m]@(
        Shift[m]*ConjugateMomentumG[i,j]/Sqrt[DetG[]]
        - (ConjugateMomentumG[m,i]*Shift[j] + ConjugateMomentumG[m,j]*Shift[i])/Sqrt[DetG[]]
        + (1/2)*(ConjugateMomentumAuxiliaryExtrinsicCurvature[m,i]*CD[j]@Lapse[] + ConjugateMomentumAuxiliaryExtrinsicCurvature[m,j]*CD[i]@Lapse[])/Sqrt[DetG[]]
        - (1/2)*ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j]*CD[m]@Lapse[]/Sqrt[DetG[]]
        - (ConjugateMomentumAuxiliaryExtrinsicCurvature[m,p]*AuxiliaryExtrinsicCurvature[i,-p]*Shift[j] + ConjugateMomentumAuxiliaryExtrinsicCurvature[m,q]*AuxiliaryExtrinsicCurvature[j,-q]*Shift[i])/Sqrt[DetG[]]
    )
    (* Additional constraint terms - LITERAL TRANSLATION from LaTeX lines 790-796 *)
    (* Rho^{kl} [ 2 K^{(i}_k Nabla_l N^{j)} + N^{(i} Nabla^{j)} K_{kl} - N K^{(i}_k K^{j)}_l ] *)
    + ConjugateMomentumAuxiliaryExtrinsicCurvature[k,l]*(
        2*(1/2)*(AuxiliaryExtrinsicCurvature[i,-k]*CD[-l]@Shift[j] + AuxiliaryExtrinsicCurvature[j,-k]*CD[-l]@Shift[i])
        + (1/2)*(Shift[i]*CD[j]@AuxiliaryExtrinsicCurvature[-k,-l] + Shift[j]*CD[i]@AuxiliaryExtrinsicCurvature[-k,-l])
        - Lapse[]*(1/2)*(AuxiliaryExtrinsicCurvature[i,-k]*AuxiliaryExtrinsicCurvature[j,-l] + AuxiliaryExtrinsicCurvature[j,-k]*AuxiliaryExtrinsicCurvature[i,-l])
    )
    (* WilsonCoefficientEinsteinConstant^2 G^{ij} lengthy tensor terms - CORRECTED FOR POSSIBLE TYPO *)
    (* NOTE: Original LaTeX EOM4 has "WilsonCoefficient EinsteinConstant^2 Sqrtg G^{ij}" but G^{ij} definition already includes Sqrtg factors.
       This would give weight-2 terms inconsistent with other EOM4 terms (weight-1). 
       Assuming typo in LaTeX and using "WilsonCoefficient EinsteinConstant^2 G^{ij}" for consistency. *)
    + WilsonCoefficient*EinsteinConstant*LengthyTensorGij[i,j]
);
EOM4Value//DisplayExpression;
EOM4Value//=ReleaseHold;
FromEOM4 = MakeRule[{EOM4[i,j],
	Evaluate@EOM4Value
}, MetricOn->All, ContractMetrics->True];
EOM4[i,j]~DisplayRule~FromEOM4;
FromEOM4//PrependTotalFrom;
DisplayExpression[EOM4[i,j], EqnLabel->"EOM4"];
EOM4[i,j]//ToCanonical;

Comment@"Verify EOM4: Compute DeltaS/Deltag_{ij} using Poisson bracket with canonical Hamiltonian";
ComputedEOM4 = (TensorSmearingF[-i,-j]*ConjugateMomentumG[i,j])~PoissonBracket~(CanonicalHamiltonian[]);
ComputedEOM4//=VarD[TensorSmearingF[-i,-j],CD];
ComputedEOM4//=TotalFrom;
ComputedEOM4//=TotalTo;
DisplayExpression[ComputedEOM4, EqnLabel->"ComputedEOM4"];

Comment@"Compare with our copied EOM4 expression (test for constant factor)";
Expr=CompareExpressionsWithConstant[ComputedEOM4, EOM4[i,j]];
Expr//=(#/.{SomeConst->1})&;
Expr//=StandardSimplify;
Expr//DisplayExpression;
Quit[];
*)
(**)
(*
Subsection@"EOM5: Variation with respect to N (Hamiltonian constraint)";

Comment@"From DeltaS/DeltaN = 0, this gives the Hamiltonian constraint";
DefTensor[EOM5[], M3, PrintAs->"\[ScriptCapitalE]5"];
EOM5Value=HoldForm@(
 Sqrt[DetG[]]*(2*AuxiliaryExtrinsicCurvature[-i,-j]*LagrangeMultiplierPi[i,j]/Sqrt[DetG[]]
        + (AuxiliaryExtrinsicCurvature[-i,-k]*AuxiliaryExtrinsicCurvature[k,-j] + AuxiliaryVelocityField[-i,-j])*ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j]/Sqrt[DetG[]]
        + CD[-i]@CD[-j]@(ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j]/Sqrt[DetG[]])
        + (1/EinsteinConstant)*(AuxiliaryExtrinsicCurvature[i,j]*AuxiliaryExtrinsicCurvature[-i,-j] - TraceAuxiliaryExtrinsicCurvature[]^2 + RicciScalarCD[] - 2*CosmologicalConstant)
        + 4*WilsonCoefficient*EinsteinConstant*AuxiliaryVelocityField[i,j]*(2*AuxiliaryVelocityField[-j,k]*AuxiliaryVelocityField[-k,-i] - 3*AuxiliaryTensorL[-i,-k,-l]*AuxiliaryTensorL[-j,k,l])
        + WilsonCoefficient*EinsteinConstant*AuxiliaryTensorQ[i,j,-k,-l]*(AuxiliaryTensorQ[k,l,-m,-n]*AuxiliaryTensorQ[m,n,-i,-j] - 6*AuxiliaryTensorL[-m,k,l]*AuxiliaryTensorL[m,-i,-j]))
);
EOM5Value//DisplayExpression;
EOM5Value//=ReleaseHold;
FromEOM5 = MakeRule[{EOM5[],
	Evaluate@EOM5Value
}, MetricOn->All, ContractMetrics->True];
EOM5[]~DisplayRule~FromEOM5;
FromEOM5//PrependTotalFrom;
DisplayExpression[EOM5[], EqnLabel->"EOM5"];
EOM5[]//ToCanonical;
*)

(*
Subsection@"EOM6: Variation with respect to N_i (Momentum constraint)";

Comment@"From DeltaS/DeltaN_i = 0, this gives the momentum constraint";
DefTensor[EOM6[-i], M3, PrintAs->"\[ScriptCapitalE]6"];
EOM6Value=HoldForm@(
    Sqrt[DetG[]]*(2*CD[-j]@(LagrangeMultiplierPi[-i,j]/Sqrt[DetG[]])
        + 2*CD[-j]@(AuxiliaryExtrinsicCurvature[-i,-k]*ConjugateMomentumAuxiliaryExtrinsicCurvature[j,k]/Sqrt[DetG[]])
        - ConjugateMomentumAuxiliaryExtrinsicCurvature[j,k]*CD[-i]@AuxiliaryExtrinsicCurvature[-j,-k]/Sqrt[DetG[]])
);
EOM6Value//DisplayExpression;
EOM6Value//=ReleaseHold;
FromEOM6 = MakeRule[{EOM6[-i],
	Evaluate@EOM6Value
}, MetricOn->All, ContractMetrics->True];
EOM6[-i]~DisplayRule~FromEOM6;
FromEOM6//PrependTotalFrom;
DisplayExpression[EOM6[-i], EqnLabel->"EOM6"];
EOM6[-i]//ToCanonical;
*)

(*
Subsection@"EOM7: Variation with respect to F_{ij} (Auxiliary field equation)";

Comment@"From DeltaS/DeltaF_{ij} = 0, this determines the auxiliary velocity field";
DefTensor[EOM7[-i,-j], M3, Symmetric[{-i,-j}], PrintAs->"\[ScriptCapitalE]7"];
EOM7Value=HoldForm@(
    Lapse[]*Sqrt[DetG[]]*(G[-i,-k]*G[-j,-l]*ConjugateMomentumAuxiliaryExtrinsicCurvature[k,l]/Sqrt[DetG[]]
        + 12*WilsonCoefficient*EinsteinConstant*(2*AuxiliaryVelocityField[-i,k]*AuxiliaryVelocityField[-k,-j] - AuxiliaryTensorL[-i,-k,-l]*AuxiliaryTensorL[-j,k,l]))
);
EOM7Value//DisplayExpression;
EOM7Value//=ReleaseHold;
FromEOM7 = MakeRule[{EOM7[-i,-j],
	Evaluate@EOM7Value
}, MetricOn->All, ContractMetrics->True];
EOM7[-i,-j]~DisplayRule~FromEOM7;
FromEOM7//PrependTotalFrom;
DisplayExpression[EOM7[-i,-j], EqnLabel->"EOM7"];
EOM7[-i,-j]//ToCanonical;
*)
Quit[];

```

`ReproductionOfResults/HamiltonianAnalysis/ReducedConstraints.m`:

```m
(*======================*)
(*  ReducedConstraints  *)
(*======================*)

Comment@{"Define the reduced Hamiltonian constraint in terms of the shorthand variables",Cref@{"FromTraceScriptQ","FromScriptQSingleContraction","FromScriptL"}," and the constants",Cref@{"EinsteinConstantConstant","WilsonCoefficientConstant","CosmologicalConstant"},". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ReducedHamiltonianConstraint[],M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalH]\),\(red\)]\)"];
	FromReducedHamiltonianConstraint=MakeRule[{
	    ReducedHamiltonianConstraint[],
	    Sqrt[DetG[]]*(
		-(TraceScriptQ[] - 2*CosmologicalConstant)/EinsteinConstant^2 +
		8*WilsonCoefficient*EinsteinConstant^2*ScriptQSingleContraction[i,-j]*(
		    2*ScriptQSingleContraction[j,-k]*ScriptQSingleContraction[k,-i] -
		    3*ScriptL[j,-k,-l]*ScriptL[-i,k,l]) -
		24*WilsonCoefficient*EinsteinConstant^2*CosmologicalConstant*(
		    2*ScriptQSingleContraction[i,-j]*ScriptQSingleContraction[j,-i] -
		    2*CosmologicalConstant^2 -
		    ScriptL[-k,i,j]*ScriptL[k,-i,-j])
	    )
	},MetricOn->All,ContractMetrics->True];
	FromReducedHamiltonianConstraint//PrependTotalFrom;
	,
	LineLabel->"DefineReducedHamiltonianConstraint"
];
ReducedHamiltonianConstraint[]~DisplayRule~FromReducedHamiltonianConstraint;

Comment@{"Define the reduced momentum constraint in terms of the shorthand variable",Cref@"FromScriptLContraction"," and the constant",Cref@"EinsteinConstantConstant",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ReducedMomentumConstraint[i],M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalH]\),\(red\)]\)"];
	FromReducedMomentumConstraint = MakeRule[{
		ReducedMomentumConstraint[i],
		Sqrt[DetG[]]*(-2*ScriptLContraction[i]/EinsteinConstant^2)},
		MetricOn->All, ContractMetrics->True];
	FromReducedMomentumConstraint//PrependTotalFrom;
	,
	LineLabel->"DefineReducedMomentumConstraint"
];
ReducedMomentumConstraint[i]~DisplayRule~FromReducedMomentumConstraint;

```

`ReproductionOfResults/HamiltonianAnalysis/ScienceDefinitions.m`:

```m
(*======================*)
(*  ScienceDefinitions  *)
(*======================*)

Comment@"Define the smearing functions needed for Poisson bracket calculations. It is important to pay attention to the default covariance/contravariance of the vector smearing functions, since failure to do so may result in implicit dependence of the functions on the spatial metric.";
Code[DefTensor[VectorSmearingF[-i],M3,PrintAs->"\[ScriptF]"];,LineLabel->"DefineVectorSmearingF"];
DisplayExpression[VectorSmearingF[-i],EqnLabel->"VectorSmearingF"];
Code[DefTensor[VectorSmearingS[-i],M3,PrintAs->"\[ScriptS]"];,LineLabel->"DefineVectorSmearingS"];
DisplayExpression[VectorSmearingS[-i],EqnLabel->"VectorSmearingS"];
Code[DefTensor[VectorSmearingFUp[i],M3,PrintAs->"\[ScriptF]"];,LineLabel->"DefineVectorSmearingFUp"];
DisplayExpression[VectorSmearingFUp[i],EqnLabel->"VectorSmearingFUp"];
Code[DefTensor[VectorSmearingSUp[i],M3,PrintAs->"\[ScriptS]"];,LineLabel->"DefineVectorSmearingSUp"];
DisplayExpression[VectorSmearingSUp[i],EqnLabel->"VectorSmearingSUp"];
Code[DefTensor[ScalarSmearingF[],M3,PrintAs->"\[ScriptF]"];,LineLabel->"DefineScalarSmearingF"];
DisplayExpression[ScalarSmearingF[],EqnLabel->"ScalarSmearingF"];
Code[DefTensor[ScalarSmearingS[],M3,PrintAs->"\[ScriptS]"];,LineLabel->"DefineScalarSmearingS"];
DisplayExpression[ScalarSmearingS[],EqnLabel->"ScalarSmearingS"];

(*Hidden*)
DefConstantSymbol[SomeConst,PrintAs->"C"];

Comment@"Define the Wilson coefficient for the cubic term in the action.";
Code[
	DefConstantSymbol[WilsonCoefficient,PrintAs->"\[Alpha]"];
	,
	LineLabel->"DefineWilsonCoefficient"
];
DisplayExpression[WilsonCoefficient,EqnLabel->"WilsonCoefficientConstant"];

Comment@"Define the Einstein constant.";
Code[
	DefConstantSymbol[EinsteinConstant,PrintAs->"\[Kappa]"];
	,
	LineLabel->"DefineEinsteinConstant"
];
DisplayExpression[EinsteinConstant,EqnLabel->"EinsteinConstantConstant"];

Comment@"Define the cosmological constant.";
Code[
	DefConstantSymbol[CosmologicalConstant,PrintAs->"\[CapitalLambda]"];
	,
	LineLabel->"DefineCosmologicalConstant"
];
DisplayExpression[CosmologicalConstant,EqnLabel->"CosmologicalConstant"];

Comment@"Define the extrinsic curvature and its conjugate momentum. Importantly, this will be a canonical field, which means we should use the Hamilcar function \"DefCanonicalField\" to define it. The conjugate momentum will be defined automatically.";
Code[
	DefCanonicalField[ExtrinsicCurvature[-i,-j],Symmetric[{-i,-j}],
		FieldSymbol->"K",MomentumSymbol->"\[Rho]"];
	,
	LineLabel->"DefineExtrinsicCurvature"
];
DisplayExpression[ExtrinsicCurvature[-i,-j],EqnLabel->"ExtrinsicCurvature"];
DisplayExpression[ConjugateMomentumExtrinsicCurvature[i,j],EqnLabel->"ConjugateMomentumExtrinsicCurvature"];

Comment@"Define the trace of the extrinsic curvature. This is not a canonical field, but is instead a tensor that can be expanded in terms of a canonical field by means of a rule. Let's say that an expression depends on this trace, and we try to use Hamilcar to compute some Poisson brackets with that expression: how will Hamilcar know that it needs to be expanded into a fundamental canonical variable? We use the Hamilcar function \"PrependTotalFrom\" to keep track of the rule for this expansion.";
Code[
	DefTensor[TraceExtrinsicCurvature[],M3,PrintAs->"K"];
	FromTraceExtrinsicCurvature=MakeRule[{
		TraceExtrinsicCurvature[],
		Scalar[ExtrinsicCurvature[a,-a]]},
		MetricOn->All,ContractMetrics->True];
	FromTraceExtrinsicCurvature//PrependTotalFrom;
	,
	LineLabel->"DefineTraceExtrinsicCurvature"
];
TraceExtrinsicCurvature[]~DisplayRule~FromTraceExtrinsicCurvature;

Comment@"More canonical fields (this time, ones which matter for our computations). We use \"DefCanonicalField\" to define the auxiliary extrinsic curvature and its conjugate momentum.";
Code[
	DefCanonicalField[AuxiliaryExtrinsicCurvature[-i,-j],Symmetric[{-i,-j}],
		FieldSymbol->"\[ScriptCapitalK]",MomentumSymbol->"\[Rho]"];
	,
	LineLabel->"DefineAuxiliaryExtrinsicCurvature"
];
DisplayExpression[AuxiliaryExtrinsicCurvature[-i,-j],EqnLabel->"AuxiliaryExtrinsicCurvature"];
DisplayExpression[ConjugateMomentumAuxiliaryExtrinsicCurvature[i,j],EqnLabel->"ConjugateMomentumAuxiliaryExtrinsicCurvature"];

Comment@"Define the trace of the auxiliary extrinsic curvature. Again, this is not a canonical field, but is a tensor that can be expanded in terms of a canonical field by means of a rule. Again, we register this rule by means of \"PrependTotalFrom\".";
Code[
	DefTensor[TraceAuxiliaryExtrinsicCurvature[],M3,PrintAs->"\[ScriptCapitalK]"];
	FromTraceAuxiliaryExtrinsicCurvature=MakeRule[{
		TraceAuxiliaryExtrinsicCurvature[],
		Scalar[AuxiliaryExtrinsicCurvature[a,-a]]},
		MetricOn->All,ContractMetrics->True];
	FromTraceAuxiliaryExtrinsicCurvature//PrependTotalFrom;
	,
	LineLabel->"DefineTraceAuxiliaryExtrinsicCurvature"
];
TraceAuxiliaryExtrinsicCurvature[]~DisplayRule~FromTraceAuxiliaryExtrinsicCurvature;

```

`ReproductionOfResults/HamiltonianAnalysis/SecondOrder.m`:

```m
(*===============*)
(*  SecondOrder  *)
(*===============*)

Comment@{"Let's have a look at the part of the raw Poisson bracket which is second-order in the cosmological constant. This comes from the sum of the three brackets computed in the previous section:",Cref@{"OrderUnityBracketResult","CrossBracket01Result","CrossBracket10Result"},"."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{2},
		WilsonCoefficientOrder->All];
	,
	LineLabel->"ExtractSecondOrderBracket"
];
DisplayExpression[Expr,EqnLabel->"SecondOrderRawBracket"];

Comment@{"With an application of \"FindAlgebra\" to simplify the raw bracket in",Cref@"SecondOrderRawBracket",", we find that there is only one such term, and it is very simple. Once again, we can use \"Constraints\" to factor out the reduced momentum constraint."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{2},
		WilsonCoefficientOrder->All];
	Expr//=FindAlgebra[#,
		{{{ReducedMomentumConstraint},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,ReducedHamiltonianOrderUnity},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptQSingleContraction,ReducedMomentumConstraint},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{CD,CD,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{RicciCD,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}}},
		Constraints->{ReducedMomentumConstraint[i],
			ReducedHamiltonianOrderUnity[]},
		Method->Solve,Verify->True]&;
	,
	Execute->False,
	LineLabel->"FindAlgebraSecondOrder"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","SecondOrder.mx"},Expr];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","SecondOrder.mx"};
DisplayExpression[Expr,EqnLabel->"SecondOrderResult"];
Supercomment@{"The second-order result in",Cref@"SecondOrderResult"," needs to be checked against the paper."};

```

`ReproductionOfResults/HamiltonianAnalysis/ShorthandNotation.m`:

```m
(*=====================*)
(*  ShorthandNotation  *)
(*=====================*)

Comment@{"First define the trace of the momentum conjugate to the spatial metric, which depends on the conjugate momentum and spatial metric tensors from the canonical formulation. Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[TraceConjugateMomentumG[],M3,PrintAs->"\[Pi]"];
	FromTraceConjugateMomentumG = MakeRule[{
	    TraceConjugateMomentumG[],
	    Scalar[ConjugateMomentumG[a,b]*G[-a,-b]]
	}, MetricOn->All, ContractMetrics->True];
	FromTraceConjugateMomentumG//PrependTotalFrom;
	,
	LineLabel->"DefineTraceConjugateMomentumG"
];
TraceConjugateMomentumG[]~DisplayRule~FromTraceConjugateMomentumG;

Comment@{"Define a (weightless) tensor that represents the trace-shifted momentum conjugate to the spatial metric, expressed in terms of the spatial metric momentum, its trace",Cref@"FromTraceConjugateMomentumG",", and the Einstein constant",Cref@"EinsteinConstantConstant",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ScriptK[-i,-j],M3,Symmetric[{-i,-j}],PrintAs->"\[GothicCapitalK]"];
	FromScriptK=MakeRule[{
	    ScriptK[-i,-j],
		-EinsteinConstant^2*(ConjugateMomentumG[-i,-j]/Sqrt[DetG[]]-G[-i,-j]/2*TraceConjugateMomentumG[]/Sqrt[DetG[]])
	},MetricOn->All,ContractMetrics->True];
	FromScriptK//PrependTotalFrom;
	,
	LineLabel->"DefineScriptK"
];
ScriptK[-i,-j]~DisplayRule~FromScriptK;

Comment@{"Define the antisymmetric gradient of the weightless momentum, constructed from covariant derivatives of",Cref@"FromScriptK",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ScriptL[i,-j,-k],M3,Antisymmetric[{-j,-k}],PrintAs->"\[GothicCapitalL]"];
	FromScriptL = MakeRule[{
	    ScriptL[i,-j,-k],
	    CD[-k]@ScriptK[-j,i] - CD[-j]@ScriptK[-k,i]
	},MetricOn->All,ContractMetrics->True];
	FromScriptL//PrependTotalFrom;
	,
	LineLabel->"DefineScriptL"
];
ScriptL[i,-j,-k]~DisplayRule~FromScriptL;

Comment@{"Define the Riemann-like quantity, combining products of",Cref@"FromScriptK"," with the spatial Riemann curvature tensor. Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ScriptQ[i,j,-k,-l],M3,{Antisymmetric[{i,j}],Antisymmetric[{-k,-l}]},PrintAs->"\[GothicCapitalQ]"];
	FromScriptQ = MakeRule[{
	    ScriptQ[i,j,-k,-l],
	    ScriptK[i,-k]*ScriptK[j,-l] - ScriptK[i,-l]*ScriptK[j,-k] + RiemannCD[i,j,-k,-l]
	},MetricOn->All,ContractMetrics->True];
	FromScriptQ//PrependTotalFrom;
	,
	LineLabel->"DefineScriptQ"
];
ScriptQ[i,j,-k,-l]~DisplayRule~FromScriptQ;

Comment@{"Define the trace of the weightless momentum, obtained by contracting",Cref@"FromScriptK"," with the spatial metric. Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[TraceScriptK[],M3,PrintAs->"\[GothicCapitalK]"];
	FromTraceScriptK = MakeRule[{
	    TraceScriptK[],
	    G[i,j]*ScriptK[-i,-j]
	},MetricOn->All,ContractMetrics->True];
	FromTraceScriptK//PrependTotalFrom;
	,
	LineLabel->"DefineTraceScriptK"
];
TraceScriptK[]~DisplayRule~FromTraceScriptK;

Comment@{"Define the single contraction of the Riemann-like quantity, obtained by contracting one pair of indices of",Cref@"FromScriptQ",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ScriptQSingleContraction[-i,-j],M3,Symmetric[{-i,-j}],PrintAs->"\[GothicCapitalQ]"];
	FromScriptQSingleContraction = MakeRule[{
	    ScriptQSingleContraction[i,-j],
	    ScriptQ[i,k,-j,-k]
	},MetricOn->All,ContractMetrics->True];
	FromScriptQSingleContraction//PrependTotalFrom;
	,
	LineLabel->"DefineScriptQSingleContraction"
];
ScriptQSingleContraction[i,-j]~DisplayRule~FromScriptQSingleContraction;

Comment@{"Define the contraction of the antisymmetric spatial gradient, obtained by contracting the first two indices of",Cref@"FromScriptL",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[ScriptLContraction[-i],M3,PrintAs->"\[GothicCapitalL]"];
	FromScriptLContraction = MakeRule[{
	    ScriptLContraction[-i],
	    ScriptL[j,-j,-i]
	},MetricOn->All,ContractMetrics->True];
	FromScriptLContraction//PrependTotalFrom;
	,
	LineLabel->"DefineScriptLContraction"
];
ScriptLContraction[-i]~DisplayRule~FromScriptLContraction;

Comment@{"Define the full trace of the Riemann-like quantity, obtained by contracting all indices of",Cref@"FromScriptQ",". Note the use of \"PrependTotalFrom\"."};
Code[
	DefTensor[TraceScriptQ[],M3,PrintAs->"\[GothicCapitalQ]"];
	FromTraceScriptQ = MakeRule[{
	    TraceScriptQ[],
	    ScriptQ[i,j,-i,-j]
	},MetricOn->All,ContractMetrics->True];
	FromTraceScriptQ//PrependTotalFrom;
	,
	LineLabel->"DefineTraceScriptQ"
];
TraceScriptQ[]~DisplayRule~FromTraceScriptQ;

```

`ReproductionOfResults/HamiltonianAnalysis/ZerothOrder.m`:

```m
(*===============*)
(*  ZerothOrder  *)
(*===============*)

Comment@{"The most complicated part of the bracket, which we have just computed, is surely the part which is zeroth-order in the cosmological constant, and which itself has parts which are zeroth-order and first-order in the Wilson coefficient. This comes from the sum of the three brackets computed in the previous section:",Cref@{"OrderUnityBracketResult","CrossBracket01Result","CrossBracket10Result"},"."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{0},
		WilsonCoefficientOrder->All];
	,
	LineLabel->"ExtractZerothOrderBracket"
];
DisplayExpression[Expr,EqnLabel->"ZerothOrderRawBracket"];

Comment@{"We will view the bracket in",Cref@"ZerothOrderRawBracket"," from several angles, using the Hamilcar function \"FindAlgebra\", which attempts to re-express brackets in terms of a given desired structural form. The \"FindAlgebra\" function works when the desired structural form can be reached through a finite number of changes to the boundary operators, in addition to a finite number of Cayley-Hamilton-like operations in three dimensions. These operations do not have to be specified by the user: \"FindAlgebra\" automatically determines which of them are necessary."}

Comment@{"We first use \"FindAlgebra\" to write the bracket in",Cref@"ZerothOrderRawBracket"," in terms of first-order gradients of the shorthand tensorial momentum. The ability to do this is reassuring, since it means that it is possible to put the whole bracket in terms of first derivatives generally. To use the function, we input the raw bracket as computed above, and then specify the rough format of our desired ansatz for the answer."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{0},
		WilsonCoefficientOrder->All];
	Expr//=FindAlgebra[#,
		{{{CD,ScriptK},{CD,ScalarSmearingF,ScalarSmearingS}},
		{{CD,ScriptK},{RicciCD,RicciCD},{CD,ScalarSmearingF,ScalarSmearingS}},
		{{CD,ScriptK},{CD,ScriptK},{CD,ScriptK},{CD,ScalarSmearingF,ScalarSmearingS}},
		{{CD,ScriptK},{RicciCD,ScriptK,ScriptK},{CD,ScalarSmearingF,ScalarSmearingS}},
		{{CD,ScriptK},{ScriptK,ScriptK,ScriptK,ScriptK},{CD,ScalarSmearingF,ScalarSmearingS}}},
		Method->Solve,Verify->False]&;
	,
	Execute->False,
	LineLabel->"FindAlgebraZerothOrderA"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderA.mx"},Expr];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderA.mx"};
Expr//DisplayExpression;
(*Expr//TestSkew//DisplayExpression;*)

EinsteinConstant=1;

Comment@{"The last output is obviously an improvement, but it is still too large. We next use \"FindAlgebra\" to express the bracket from",Cref@"ZerothOrderRawBracket"," in terms of shorthand tensorial momentum gradients, and the spatial curvature. This hides all the explicit gradients on non-smearing functions."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{0},
		WilsonCoefficientOrder->All];
	Expr//=FindAlgebra[#,
		{{{ScriptL},{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,ScriptL,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,RicciCD,ScriptK,ScriptK},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,ScriptK,ScriptK,ScriptK,ScriptK},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,RicciCD,RicciCD},
			{CD,ScalarSmearingF,ScalarSmearingS}}},
		Method->Solve,Verify->False]&;
	,
	Execute->False,
	LineLabel->"FindAlgebraZerothOrderB"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderB.mx"},Expr];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderB.mx"};
Expr//DisplayExpression;
(*Expr//TestSkew//DisplayExpression;*)

Comment@{"Once again, the last output was a big improvement, but once again we can do much better. Next we use \"FindAlgebra\" to express the bracket from",Cref@"ZerothOrderRawBracket"," entirely in terms of the shorthand functions."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{0},
		WilsonCoefficientOrder->All];
	EinsteinConstant=1;
	CosmologicalConstant=1;
	WilsonCoefficient=1;
	Expr//=FindAlgebra[#,
		{{{ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,ScriptL,ScriptL},
			{CD,ScalarSmearingF,ScalarSmearingS}},
		{{ScriptL,ScriptQSingleContraction,ScriptQSingleContraction},
			{CD,ScalarSmearingF,ScalarSmearingS}}},
		Method->Solve,Verify->False,DDIs->True]&;
	,
	Execute->False,
	LineLabel->"FindAlgebraZerothOrderC"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderC.mx"},Expr];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderC.mx"};
DisplayExpression[Expr,EqnLabel->"ZerothOrderPenultimateResult"];
(*Expr//TestSkew//DisplayExpression;*)
(*
Get@FileNameJoin@{NotebookDirectory[],"InputEqs.mx"};
InputEqs//DisplayExpression;
Get@FileNameJoin@{NotebookDirectory[],"AllParams.mx"};
AllParams//DisplayExpression;

Expr=InputEqs;
Expr//=(#~CoefficientArrays~(AllParams))&;
Expr//=Normal;
(Expr//=((Last@#)~LinearSolve~(First@#))&)~Check~(Throw@Message@FindAlgebra::NoSolution);
Expr//=MapThread[(#1->-#2)&,{(AllParams),#}]&;
Expr//DisplayExpression;

Quit[];
*)
Comment@{"The previous format begins to be human-readable. Finally we use \"FindAlgebra\" to express the bracket from",Cref@"ZerothOrderRawBracket"," in terms of the reduced momentum and Hamiltonian constraints. Importantly, the zeroth-order part of the reduced Hamiltonian constraint is itself linear in the cosmological constant, and since we're only feeding in the zeroth-order cosmological constant part of the bracket to \"FindAlgebra\", we can't expect it to find a solution when it tries to expand the reduced Hamiltonian constraint in the ansatz. Therefore, we need to wrap the whole computation in a \"Block\" command (a Wolfram Language built-in function) that locally sets the cosmological constant to equal zero. Another feature of \"FindAlgebra\" that we can now use is the \"Constraints\" option, which allows us to specify that the reduced momentum and Hamiltonian constraints should be used to collect the final answer. The result is moderately tidy (though not completely ideal; the difference of smearing gradients is only sometimes collected, and sometimes not), and this should help facilitate comparison with the paper."};
Code[
	Expr=ExtractBracketAnatomy[CosmologicalConstantOrder->{0},
		WilsonCoefficientOrder->All];
	Block[{CosmologicalConstant=0},
		Expr//=FindAlgebra[#,
			{{{ReducedMomentumConstraint},{CD,ScalarSmearingF,ScalarSmearingS}},
			{{ReducedMomentumConstraint,ScriptL,ScriptL},{CD,ScalarSmearingF,ScalarSmearingS}},
			{{ReducedMomentumConstraint,ScriptQSingleContraction,ScriptQSingleContraction},{CD,ScalarSmearingF,ScalarSmearingS}},
			{{ReducedHamiltonianOrderUnity,ScriptQSingleContraction,ScriptL},{CD,ScalarSmearingF,ScalarSmearingS}}},
			Constraints->{ReducedMomentumConstraint[i],
				ReducedHamiltonianOrderUnity[]},
			Method->Solve,Verify->False]&;
	];
	,
	Execute->False,
	LineLabel->"FindAlgebraZerothOrderD"
];
(*DumpSave[FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderD.mx"},Expr];
Quit[];*)
Get@FileNameJoin@{NotebookDirectory[],"HamiltonianAnalysis","ZerothOrderD.mx"};
DisplayExpression[Expr,EqnLabel->"ZerothOrderResult"];
(*Expr//TestSkew//DisplayExpression;*)
Supercomment@{"The zeroth-order result in",Cref@"ZerothOrderResult"," needs to be checked against the paper."};

```

# Section 4: Model Catalogue

Each model includes a canonical formulation (Hamiltonian, fields, momenta, multipliers) followed by a walkthrough of the Dirac-Bergmann constraint analysis if available.

## MaxwellTheory - Canonical Formulation

Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not.

```mathematica
ConjugateMomentumVectorFieldRank10p[]*VectorFieldRank10pLagrangeMultiplier[] + (ConjugateMomentumVectorFieldRank11m[-a]*ConjugateMomentumVectorFieldRank11m[a])/(2*FirstKineticCoupling) + ConjugateMomentumVectorFieldRank11m[a]*CD[-a][VectorFieldRank10p[]] - (FirstKineticCoupling*CD[-a][VectorFieldRank11m[-b]]*CD[b][VectorFieldRank11m[a]])/2 + (FirstKineticCoupling*CD[-b][VectorFieldRank11m[-a]]*CD[b][VectorFieldRank11m[a]])/2
```

Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above.

```mathematica
{VectorFieldRank10p[], VectorFieldRank11m[-a]}
```

Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above.

```mathematica
{ConjugateMomentumVectorFieldRank10p[], ConjugateMomentumVectorFieldRank11m[a]}
```

Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above.

```mathematica
{VectorFieldRank10pLagrangeMultiplier[], VectorFieldRank11mLagrangeMultiplier[-a]}
```


## MaxwellTheory - Constraint Analysis

The application of the Dirac-Bergmann algorithm for MaxwellTheory is left as an exercise. The user may request this analysis in the live session.

----------------------------------------

## ProcaTheory - Canonical Formulation

Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not.

```mathematica
-(SquareMassCoupling*VectorFieldRank10p[]^2) + ConjugateMomentumVectorFieldRank10p[]*VectorFieldRank10pLagrangeMultiplier[] + SquareMassCoupling*VectorFieldRank11m[-a]*VectorFieldRank11m[a] + (ConjugateMomentumVectorFieldRank11m[-a]*ConjugateMomentumVectorFieldRank11m[a])/(2*FirstKineticCoupling) + ConjugateMomentumVectorFieldRank11m[a]*CD[-a][VectorFieldRank10p[]] - (FirstKineticCoupling*CD[-a][VectorFieldRank11m[-b]]*CD[b][VectorFieldRank11m[a]])/2 + (FirstKineticCoupling*CD[-b][VectorFieldRank11m[-a]]*CD[b][VectorFieldRank11m[a]])/2
```

Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above.

```mathematica
{VectorFieldRank10p[], VectorFieldRank11m[-a]}
```

Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above.

```mathematica
{ConjugateMomentumVectorFieldRank10p[], ConjugateMomentumVectorFieldRank11m[a]}
```

Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above.

```mathematica
{VectorFieldRank10pLagrangeMultiplier[], VectorFieldRank11mLagrangeMultiplier[-a]}
```


## ProcaTheory - Dirac-Bergmann Constraint Analysis Walkthrough

Project Path: devel_catalogue

Source Tree:

```txt
devel_catalogue
└── ProcaTheoryWalkthrough.m

```

`devel_catalogue/ProcaTheoryWalkthrough.m`:

```m
Print@"OK, so we are going to analyse the Maxwell theory now.";

Print@"The first step is to load the Hamilcar package.";
<<xAct`Hamilcar`;

Print@"Next, we need to define a bunch of things based on what we've been told.";
Print@"Firstly we will define the constant symbols in the theory.";
DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"];
DefConstantSymbol[SecondKineticCoupling,PrintAs->"\[Beta]"];
DefConstantSymbol[SquareMassCoupling,PrintAs->"\[Gamma]"];

Print@"Next we define the canonical fields in the theory. Note that the conjugate momenta are defined automatically alongside the fields.";
DefCanonicalField[VectorFieldRank10p[],FieldSymbol->"\[ScriptCapitalA]0p",
	MomentumSymbol->"\[CapitalPi]\[ScriptCapitalA]0p"];
DefCanonicalField[VectorFieldRank11m[-a],FieldSymbol->"\[ScriptCapitalA]1m",
	MomentumSymbol->"\[CapitalPi]\[ScriptCapitalA]1m"];

Print@"Next we define the multipliers in the theory.";
DefTensor[VectorFieldRank10pLagrangeMultiplier[],M3,
	PrintAs->"\[Lambda]\[ScriptCapitalA]0p"];
DefTensor[VectorFieldRank11mLagrangeMultiplier[-a],M3,
	PrintAs->"\[Lambda]\[ScriptCapitalA]1m"];

Print@"Now we want to define two smearing functions for each of the canonical fields, whose index structure matches those fields.";
DefTensor[SmearingFVectorFieldRank10p[],M3,
	PrintAs->"\[ScriptF]"];
DefTensor[SmearingFVectorFieldRank11m[-a],M3,
	PrintAs->"\[ScriptF]"];
DefTensor[SmearingSVectorFieldRank10p[],M3,
	PrintAs->"\[ScriptS]"];
DefTensor[SmearingSVectorFieldRank11m[-a],M3,
	PrintAs->"\[ScriptS]"];

Print@"Now we define the total Hamiltonian density for the theory.";
TotalHamiltonianDensity=-(SquareMassCoupling*VectorFieldRank10p[]^2) + ConjugateMomentumVectorFieldRank10p[]*VectorFieldRank10pLagrangeMultiplier[] + SquareMassCoupling*VectorFieldRank11m[-a]*VectorFieldRank11m[a] + (ConjugateMomentumVectorFieldRank11m[-a]*ConjugateMomentumVectorFieldRank11m[a])/(2*FirstKineticCoupling) + ConjugateMomentumVectorFieldRank11m[a]*CD[-a][VectorFieldRank10p[]] - (FirstKineticCoupling*CD[-a][VectorFieldRank11m[-b]]*CD[b][VectorFieldRank11m[a]])/2 + (FirstKineticCoupling*CD[-b][VectorFieldRank11m[-a]]*CD[b][VectorFieldRank11m[a]])/2;
TotalHamiltonianDensity//ToCanonical;
TotalHamiltonianDensity//Print;

Print@"We will now be using Poisson brackets, and we smear these ourselves.";
$ManualSmearing=True;

Print@"Let's try to compute a velocity.";
Expr=PoissonBracket[SmearingFVectorFieldRank10p[]*VectorFieldRank10p[],
	TotalHamiltonianDensity,Parallel->True];
Expr//Print;

Print@"The first step is to find all the primary constraints. Having been provided with the total Hamiltonian density, we could recover these by reading them off directly. It is safer, however, to proceed systematically, by taking variations with respect to the multipliers.";
Expr=
	VarD[VectorFieldRank10pLagrangeMultiplier[],CD][TotalHamiltonianDensity];
Expr//Print;
Print@"So that is non-zero, and hence the theory has at least one primary constraint.";

Print@"Let's define a tensor to represent that constraint.";
DefTensor[PrimaryConstraintVectorFieldRank10p[],M3,
	PrintAs->"\[Phi]\[ScriptCapitalA]0p"];
FromPrimaryConstraintVectorFieldRank10p=MakeRule[{
	PrimaryConstraintVectorFieldRank10p[],
	Evaluate@Expr},MetricOn->All,ContractMetrics->True];
FromPrimaryConstraintVectorFieldRank10p//PrependTotalFrom;

Print@"Let's check the other one.";
PrimaryConstraintVectorFieldRank11m=
	VarD[VectorFieldRank11mLagrangeMultiplier[-a],CD][TotalHamiltonianDensity];
PrimaryConstraintVectorFieldRank11m//Print;
Print@"Ah, so that vanishes identically, and hence there is no primary constraint associated with that multiplier.";

Print@"So, the theory has one primary constraint in total. Now we need to check whether it is preserved in time. Generally, the primaries might not be scalars, so we stick to the routine of smearing them with appropriate smearing functions before taking Poisson brackets with the total Hamiltonian. To compute the secondaries as (potentiall indexed) tensor expressions, we then take variations with respect to the smearing functions.";
Expr=
	PoissonBracket[SmearingSVectorFieldRank10p[]*PrimaryConstraintVectorFieldRank10p[],
		TotalHamiltonianDensity,Parallel->True];
Expr//=VarD[SmearingSVectorFieldRank10p[],CD][#]&;
Expr//=ToCanonical;
Expr//=ContractMetric;
Expr//=ScreenDollarIndices;
Expr//Print;
Print@"Ah, so the velocity of the primary doesn't vanish identically, nor is it equal to a combination of any other constraints (there are none), nor is it equal to an expression which can be set to zero for appropriate values of the multipliers. Hence we have found a secondary constraint.";

Print@"Let's define a tensor to represent that secondary constraint.";
DefTensor[SecondaryConstraintVectorFieldRank10p[],M3,
	PrintAs->"\[Chi]\[ScriptCapitalA]0p"];
FromSecondaryConstraintVectorFieldRank10p=MakeRule[{
	SecondaryConstraintVectorFieldRank10p[],
	Evaluate@Expr},MetricOn->All,ContractMetrics->True];
FromSecondaryConstraintVectorFieldRank10p//PrependTotalFrom;

Print@"We now have two constraints in total. Next we need to check whether the secondary is preserved in time. We proceed as before, smearing with an appropriate smearing function and taking the Poisson bracket with the total Hamiltonian, before taking variations with respect to the smearing function to recover the indexed tensor expression.";
Expr=
	PoissonBracket[SmearingSVectorFieldRank10p[]*SecondaryConstraintVectorFieldRank10p[],
		TotalHamiltonianDensity,Parallel->True];
Expr//=VarD[SmearingSVectorFieldRank10p[],CD][#]&;
Expr//=ToCanonical;
Expr//=ContractMetric;
Expr//=ScreenDollarIndices;
Expr//Print;

Print@"Ah, so the velocity of the secondary doesn't vanish identically, nor is it equal to a combination of any other constraints, but it is equal to an expression which can be set to zero for appropriate values of the multipliers. Hence there are no further constraints, and we have found all the constraints in the theory.";

Print@"Now we need to classify the constraints into first and second class. To do this, we need to compute the Poisson brackets between all pairs of constraints.";
Expr=
	PoissonBracket[SmearingFVectorFieldRank10p[]*PrimaryConstraintVectorFieldRank10p[],
		SmearingSVectorFieldRank10p[]*SecondaryConstraintVectorFieldRank10p[],
		Parallel->True];
Expr//Print;
Print@"Ah, so the Poisson bracket between the primary and secondary constraints is non-vanishing. Since there are only two constraints in total, this means that both constraints are second class.";

Print@"We have now found and classified all the constraints in the theory. To summarise, the theory has two constraints in total: one primary and one secondary. Both constraints are second class. The total number of canonical degrees of freedom in the theory is 2*(1+3), where the 2 is from the field-momentum pairs, and the (1+3) is from the 0p and 1m components of the vector field. From this we subtract 1 degree of freedom for the primary constraint, and another degree of freedom for the secondary constraint, leaving us with 2*(1+3)-2=6 canonical degrees of freedom, or equivalently 3 physical degrees of freedom.";

Quit[];

```
----------------------------------------


========================================

========================================
# Token Summary
Hamilcar: 21992 tokens
project-glavan/Private: 0 tokens
project-dalet/ReproductionOfResults: 24745 tokens
Model Catalogue: 2627 tokens
Total: 49364 tokens
========================================
