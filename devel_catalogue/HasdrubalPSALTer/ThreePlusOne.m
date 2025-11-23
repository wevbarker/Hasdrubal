(*================*)
(*  ThreePlusOne  *)
(*================*)

Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","ExtractFields.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","PrepareAutomaticRules.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","FieldThreePlusOne.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","ActivateTimeD.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","ProjectMetric.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","ApplyDerivativeRules.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","DefineMomenta.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","SolveVelocities.m"}];
Get@FileNameJoin[{"HasdrubalPSALTer","ThreePlusOne","ConstructCanonicalHamiltonian.m"}];

DefTensor[InverseInducedMetric[a,b],M4,Symmetric[{a,b}],PrintAs->"H"];
GToInverseInducedMetric=MakeRule[{G[a,b],InverseInducedMetric[a,b]+V[a]V[b]},
	MetricOn->All,ContractMetrics->True];
AutomaticRules[V,MakeRule[{InverseInducedMetric[a,b]*V[-b],0},
	MetricOn->All,ContractMetrics->True]];
AutomaticRules[V,MakeRule[{CD[a]@V[b],0},
	MetricOn->All,ContractMetrics->True]];
InverseInducedMetricToGHack=MakeRule[{InverseInducedMetric[a,b],-G[a,b]},
	MetricOn->All,ContractMetrics->True];

ThreePlusOne[InputExpr_,ModelName_]:=Module[{
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
	Block[{xAct`PSALTer`Private`$Disabled=True},
		Catch@xAct`xPlain`Code[InputExprVar,ModelNameVar,
			ParticleSpectrum[InputExpr,
				TheoryName->ModelName,
				Method->"Hard",
				ShowPropagator->True,
				AspectRatio->Portrait,
				MaxLaurentDepth->1];
		];
	];

	FieldNames//=ExtractFields;

	$DerivativeRules={};
	$CanonicalFields={};
	$ConjugateMomenta={};
	$LagrangeMultipliers={};
	$Velocities={};
	Do[
		PrepareAutomaticRules[FieldName],
		{FieldName,FieldNames}
	];	
	Do[
		ThreePlusOneLagrangian//=FieldThreePlusOne[#,FieldName]&,
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
	ThreePlusOneLagrangian//=(#/.InverseInducedMetricToGHack)&;
	ThreePlusOneLagrangian//=ToCanonical;
	ThreePlusOneLagrangian//=ContractMetric;
	ThreePlusOneLagrangian//=ScreenDollarIndices;
	ThreePlusOneLagrangian//=(#/.{V->Zero})&;
	ThreePlusOneLagrangian//=ToCanonical;
	ThreePlusOneLagrangian//=ContractMetric;
	ThreePlusOneLagrangian//=ScreenDollarIndices;
	ThreePlusOneLagrangian//DisplayExpression;

	Comment@"The total Hamiltonian.";
	$Velocities//=((FromIndexFree@ToIndexFree@#)&/@#)&;
	$VelocitiesUp=$Velocities/.{SomeIndex_?TangentM4`Q->-SomeIndex};
	$ConjugateMomenta//=((FromIndexFree@ToIndexFree@#)&/@#)&;
	Expr=ThreePlusOneLagrangian;
	Expr//=DefineMomenta;
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

	Comment@"Producing output in string form.";

	CanonicalHamiltonian//DisplayExpression;
	CanonicalHamiltonian//=InputForm;
	CanonicalHamiltonian//=ToString;
	CanonicalHamiltonian//Print;

	$FieldSpinParityTensors={};
	Do[
		Class=FieldName;
		Class//=xAct`PSALTer`Private`FieldAssociation;
		Expr=Flatten@Values@(Flatten/@(Values/@(Values/@(Class@xAct`PSALTer`Private`FieldSpinParityTensorHeads))));
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


	WriteString[OutputFile,"Here is a Wolfram Language statement of the total Hamiltonian. That is, the Legendre-transformed Lagrangian, plus multiplier fields times constraints, in which the field velocities have been replaced by momenta where possible, and by Lagrange multipliers where not."];
	WriteString[OutputFile,"\n"];
	WriteString[OutputFile,CanonicalHamiltonian];
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
	Close@OutputFile;

	Run["bash "<>FileNameJoin@{DirectoryName[$InputFileName],"txt2md.sh"}<>" "<>FileNameJoin@{$xPlainWorkingDirectory,ModelName<>".txt"}];

Expr];
