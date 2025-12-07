(*========================*)
(*  EinsteinCartanTheory  *)
(*========================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[EinsteinConstant,
	PrintAs->"\[Kappa]"]];
Code[DefConstantSymbol[CosmologicalConstant,
	PrintAs->"\[CapitalLambda]"]];

Comment@"Set up the metric perturbation.";
Code[DefField[MetricPerturbation[-a,-b],
	Symmetric[{-a,-b}],
	PrintAs->"\[ScriptH]",
	PrintSourceAs->"\[Tau]"]];

(*Comment@"Set up the torsion perturbation.";
Code[DefField[TPerturbation[a,-b,-c],
	Antisymmetric[{-b,-c}],
	PrintAs->"\[Delta]\[ScriptCapitalT]",
	PrintSourceAs->"\[Sigma]"]];*)

TPerturbation=Zero;
CosmologicalConstant=0;
ScaleFactor[]=1;
ConformalHubble[]=0;
ConformalHubblePrime[]=0;
ConformalHubblePrimePrime[]=0;

(*
Comment@"Set up the cosmological background tensors.";
DefTensor[ScaleFactor[],M4,PrintAs->"\[ScriptA]"];
DefConstantSymbol[ScaleFactorConstant,PrintAs->"\[ScriptA]0"];
DefTensor[ConformalHubble[],M4,PrintAs->"\[ScriptCapitalH]"];
DefConstantSymbol[ConformalHubbleConstant,PrintAs->"\[ScriptCapitalH]0"];
DefTensor[ConformalHubblePrime[],M4,PrintAs->"\[ScriptCapitalH]'"];
DefConstantSymbol[ConformalHubblePrimeConstant,
	PrintAs->"\[ScriptCapitalH]'0"];
DefTensor[ConformalHubblePrimePrime[],M4,PrintAs->"\[ScriptCapitalH]''"];
DefConstantSymbol[ConformalHubblePrimePrimeConstant,
	PrintAs->"\[ScriptCapitalH]''0"];

AutomaticRules[ScaleFactor,MakeRule[{CD[-b]@ScaleFactor[],
	V[-b]*ScaleFactor[]*ConformalHubble[]},
	MetricOn->All,ContractMetrics->True]];

AutomaticRules[ConformalHubble,MakeRule[{CD[-b]@ConformalHubble[],
	V[-b]*ConformalHubblePrime[]},
	MetricOn->All,ContractMetrics->True]];

MakeRule[{CD[-b]@ConformalHubblePrime[],
	V[-b]*ConformalHubblePrimePrime[]},
	MetricOn->All,ContractMetrics->True];
*)

Comment@"We construct a Lagrangian density.";
Get@"EinsteinCartanTheory.mx";
LagrangianAnsatz=ExportedLagrangianString;
LagrangianAnsatz//=ToExpression;
LagrangianAnsatz//DisplayExpression;

DefTensor[xAct`PSALTer`MetricPerturbation`TensorMode[-a,-b],
	M4,Symmetric[{-a,-b}],
	PrintAs->"\[Phi]",OrthogonalTo->{V[a],V[b]}];
DefTensor[xAct`PSALTer`MetricPerturbation`VectorMode[-a],
	M4,PrintAs->"\[Phi]",OrthogonalTo->{V[a]}];
DefTensor[xAct`PSALTer`MetricPerturbation`ScalarMode[],
	M4,PrintAs->"\[Phi]"];
MetricPerturbationDecomposeFieldsRule=MakeRule[
	{MetricPerturbation[-a,-b],
		xAct`PSALTer`MetricPerturbation`TensorMode[-a,-b]+
		V[-a]*xAct`PSALTer`MetricPerturbation`VectorMode[-b]+
		V[-b]*xAct`PSALTer`MetricPerturbation`VectorMode[-a]+
		V[-a]*V[-b]*xAct`PSALTer`MetricPerturbation`ScalarMode[]},
	MetricOn->All,ContractMetrics->True];
MetricPerturbationDecomposeFields[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=(#/.(MetricPerturbationDecomposeFieldsRule))&;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
Expr];

(*
LagrangianAnsatz//=(#/.ScaleFactor[]->ScaleFactorConstant)&;
LagrangianAnsatz//=(#/.ConformalHubble[]->ConformalHubbleConstant)&;
LagrangianAnsatz//=(#/.ConformalHubblePrime[]->ConformalHubblePrimeConstant)&;
LagrangianAnsatz//=(#/.ConformalHubblePrimePrime[]->ConformalHubblePrimePrimeConstant)&;
LagrangianAnsatz//=ToCanonical;
LagrangianAnsatz//=ContractMetric;
LagrangianAnsatz//=ScreenDollarIndices;
*)

(*
Comment@"Attempt to symmetrize using total derivatives.";
LagrangianAnsatz//=(#/.{CD[Ind1_]@MetricPerturbation[Ind2_,Ind3_]*CD[Ind4_]@MetricPerturbation[Ind5_,Ind6_]->
	(1/2)*CD[Ind1]@MetricPerturbation[Ind2,Ind3]*CD[Ind4]@MetricPerturbation[Ind5,Ind6]+
	(1/2)*CD[Ind4]@MetricPerturbation[Ind2,Ind3]*CD[Ind1]@MetricPerturbation[Ind5,Ind6]
})&;
LagrangianAnsatz//=ToCanonical;
LagrangianAnsatz//=ContractMetric;
LagrangianAnsatz//=ScreenDollarIndices;
LagrangianAnsatz//DisplayExpression;
*)

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"EinsteinCartanTheory",
	DeclaredFieldNames->
		{"xAct`PSALTer`MetricPerturbation`"(*,"xAct`PSALTer`TPerturbation`"*)},
	DeclaredFieldSpinParityTensorHeads->
		<|"xAct`PSALTer`MetricPerturbation`"->
			{xAct`PSALTer`MetricPerturbation`TensorMode,
			xAct`PSALTer`MetricPerturbation`VectorMode,
			xAct`PSALTer`MetricPerturbation`ScalarMode}|>,
	DeclaredDecomposeFields->
		<|"xAct`PSALTer`MetricPerturbation`"->
			MetricPerturbationDecomposeFields|>
];
