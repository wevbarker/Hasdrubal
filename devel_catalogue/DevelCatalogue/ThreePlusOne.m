(*================*)
(*  ThreePlusOne  *)
(*================*)

Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","TimeD.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","ExtractFields.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","PrepareAutomaticRules.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","FieldThreePlusOne.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","ActivateTimeD.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","ProjectMetric.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","ApplyDerivativeRules.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","DefineMomenta.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","SolveVelocities.m"}];
Get@FileNameJoin[{"DevelCatalogue","ThreePlusOne","ConstructCanonicalHamiltonian.m"}];

DefTensor[InverseInducedMetric[a,b],M4,Symmetric[{a,b}],PrintAs->"H"];
GToInverseInducedMetric=MakeRule[{G[a,b],InverseInducedMetric[a,b]+V[a]V[b]},
	MetricOn->All,ContractMetrics->True];
AutomaticRules[V,MakeRule[{InverseInducedMetric[a,b]*V[-b],0},
	MetricOn->All,ContractMetrics->True]];
AutomaticRules[V,MakeRule[{CD[a]@V[b],0},
	MetricOn->All,ContractMetrics->True]];
InverseInducedMetricToGHack=MakeRule[{InverseInducedMetric[a,b],-G[a,b]},
	MetricOn->All,ContractMetrics->True];

Options[ThreePlusOne]={DeclaredFieldNames->{},
	DeclaredFieldSpinParityTensorHeads-><||>,
	DeclaredDecomposeFields-><||>};
ThreePlusOne[InputExpr_,ModelName_,OptionsPattern[]]:=Module[{
	FieldNames=InputExpr,
	VelocitiesToMultipliersRules,
	ThreePlusOneLagrangian=InputExpr,
	Expr,
	CanonicalHamiltonian,
	VelocitySolutions,
	Constraints},

	Comment@"Here is the linear theory for export to PSALTer.";
	InputExprVar=InputExpr;
	ModelNameVar=ModelName;
	Block[{(*xAct`PSALTer`Private`$Disabled=True*)},
		Catch@xAct`xPlain`Code[InputExprVar,ModelNameVar,
			ParticleSpectrum[InputExpr,
				TheoryName->ModelName,
				Method->"Hard",
				ShowPropagator->True,
				AspectRatio->Portrait,
				MaxLaurentDepth->1];
		];
	];

	If[OptionValue[DeclaredFieldNames]=!={},
		FieldNames=OptionValue@DeclaredFieldNames;,
		FieldNames//=ExtractFields;
	];

	$DerivativeRules={};
	$CanonicalFields={};
	$ConjugateMomenta={};
	$LagrangeMultipliers={};
	$Velocities={};
	Do[
		PrepareAutomaticRules[FieldName,DeclaredFieldSpinParityTensorHeads->OptionValue@DeclaredFieldSpinParityTensorHeads];,
		{FieldName,FieldNames}
	];	
	Do[
		ThreePlusOneLagrangian//=FieldThreePlusOne[#,FieldName,DeclaredDecomposeFields->OptionValue@DeclaredDecomposeFields]&,
		{FieldName,FieldNames}
	];	

	VelocitiesToMultipliersRules=MapThread[MakeRule[
		{Evaluate@#1,Evaluate@#2},
		MetricOn->All,ContractMetrics->True]&,
		{(FromIndexFree@ToIndexFree@#)&/@$Velocities,
		(FromIndexFree@ToIndexFree@#)&/@$LagrangeMultipliers}];
	VelocitiesToMultipliersRules//=Flatten;

	Comment@"The Lagrangian after 3+1 decomposition.";
	ThreePlusOneLagrangian//=ActivateTimeD;
	ThreePlusOneLagrangian//=ProjectMetric;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//=ApplyDerivativeRules;
	ThreePlusOneLagrangian//DisplayExpression;
	ThreePlusOneLagrangian//=(#/.InverseInducedMetricToGHack)&;
	ThreePlusOneLagrangian//=ToCanonical;
	ThreePlusOneLagrangian//=ContractMetric;
	ThreePlusOneLagrangian//=ScreenDollarIndices;
	ThreePlusOneLagrangian//DisplayExpression;
	ThreePlusOneLagrangian//=(#/.{V->Zero})&;
	ThreePlusOneLagrangian//=ToCanonical;
	ThreePlusOneLagrangian//=ContractMetric;
	ThreePlusOneLagrangian//=ScreenDollarIndices;
	ThreePlusOneLagrangian//DisplayExpression;

	(*xAct`PSALTer`MetricPerturbation`Rank2SymmetricPara0pCanonicalFieldp=Zero;
	xAct`PSALTer`MetricPerturbation`Rank2SymmetricPara0pCanonicalField=Zero;
	ThreePlusOneLagrangian//=ToCanonical;
	ThreePlusOneLagrangian//=ContractMetric;
	ThreePlusOneLagrangian//=ScreenDollarIndices;
	ThreePlusOneLagrangian//DisplayExpression;
	ThreePlusOneLagrangian//Together;
	ThreePlusOneLagrangian//Numerator;
	Quit[];*)


	Comment@"The total Hamiltonian.";
	$Velocities//=((FromIndexFree@ToIndexFree@#)&/@#)&;
	$VelocitiesUp=$Velocities/.{SomeIndex_?TangentM4`Q->-SomeIndex};
	$ConjugateMomenta//=((FromIndexFree@ToIndexFree@#)&/@#)&;

	Expr=ThreePlusOneLagrangian;
	Expr//=DefineMomenta;
	Expr//DisplayExpression;
	{VelocitySolutions,Constraints}=Expr//SolveVelocities;
	CanonicalHamiltonian=ThreePlusOneLagrangian;
	CanonicalHamiltonian//=ConstructCanonicalHamiltonian;
	CanonicalHamiltonian//=(#/.VelocitySolutions)&;
	CanonicalHamiltonian//=NoScalar;
	CanonicalHamiltonian//=ToCanonical;
	CanonicalHamiltonian//=ContractMetric;
	CanonicalHamiltonian//=ScreenDollarIndices;
	CanonicalHamiltonian//=(#/.VelocitiesToMultipliersRules)&;
	CanonicalHamiltonian//DisplayExpression;

	Comment@"Collecting constant symbols.";
	ConstantSymbols=CanonicalHamiltonian;
	ConstantSymbols//=ListOfConstants;
	ConstantSymbols//DisplayExpression;
	ConstantSymbols//=InputForm;
	ConstantSymbols//=ToString;
	ConstantSymbols//Print;

	Comment@"Producing output in string form.";
	CanonicalHamiltonian//DisplayExpression;
	CanonicalHamiltonian//=InputForm;
	CanonicalHamiltonian//=ToString;
	CanonicalHamiltonian//Print;

	$FieldSpinParityTensors={};
	Do[
		If[Length@OptionValue@DeclaredFieldSpinParityTensorHeads>0,
			Expr=(OptionValue@DeclaredFieldSpinParityTensorHeads)[FieldName];
		,
			Class=FieldName;
			Class//=xAct`PSALTer`Private`FieldAssociation;
			Expr=Flatten@Values@(Flatten/@(Values/@(Values/@(Class@xAct`PSALTer`Private`FieldSpinParityTensorHeads))));
		];
		Expr//=((FromIndexFree@ToIndexFree@#)&/@#)&;
		$FieldSpinParityTensors=$FieldSpinParityTensors~Join~Expr;
		,
		{FieldName,FieldNames}
	];	
	$FieldSpinParityTensors//DisplayExpression;
	$FieldSpinParityTensors//=InputForm;
	$FieldSpinParityTensors//=ToString;
	$FieldSpinParityTensors//Print;

	$ConjugateMomenta//DisplayExpression;
	$ConjugateMomenta//=InputForm;
	$ConjugateMomenta//=ToString;
	$ConjugateMomenta//Print;

	$Multipliers=$Velocities/.VelocitiesToMultipliersRules;
	$Multipliers//DisplayExpression;
	$Multipliers//=InputForm;
	$Multipliers//=ToString;
	$Multipliers//Print;

	Run@("rm -rf "<>FileNameJoin@{$xPlainWorkingDirectory,
			ModelName<>".txt"});
	OutputFile=OpenAppend[
			FileNameJoin@{$xPlainWorkingDirectory,ModelName<>".txt"},
			PageWidth->Infinity];

	WriteString[OutputFile,"This prompt provides all the information needed to implement the Dirac-Bergman Hamiltonian constraint algorithm for a specific theory. Once you have read the information below, you should proceed directly with the algorithm."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,"Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,CanonicalHamiltonian];
	WriteString[OutputFile,"\n"];

	WriteString[OutputFile,"Here is a Wolfram Language statement of all the constant symbols that appear in the total Hamiltonian above."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,ConstantSymbols];
	WriteString[OutputFile,"\n"];

	WriteString[OutputFile,"Here is a Wolfram Language list of the canonical fields used in the Hamiltonian formulation. Some of these fields may not appear in the total Hamiltonian above."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,$FieldSpinParityTensors];
	WriteString[OutputFile,"\n"];

	WriteString[OutputFile,"Here is a Wolfram Language list of the conjugate momenta corresponding to the canonical fields above. Some of these momenta may not appear in the total Hamiltonian above."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,$ConjugateMomenta];
	WriteString[OutputFile,"\n"];

	WriteString[OutputFile,"Here is a Wolfram Language list of the Lagrange multiplier fields introduced to enforce the primary constraints in the Hamiltonian formulation. Some of these multipliers may not appear in the total Hamiltonian above."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,$Multipliers];
	WriteString[OutputFile,"\n"];

	WriteString[OutputFile,"This is the end of the provided information; you should tell me when you've read it, and then propose the first step to start implementing the Dirac-Bergmann algorithm, in line with your earlier instructions about workflow. Wait for the user to confirm whether you should proceed with that step, and then continue step-by-step from there."];
	WriteString[OutputFile,"\n"];

	Close@OutputFile;

	Run["bash "<>FileNameJoin@{DirectoryName[$InputFileName],"txt2md.sh"}<>" "<>FileNameJoin@{$xPlainWorkingDirectory,ModelName<>".txt"}];

Expr];
