(*====================*)
(*  TotalToCosmology  *)
(*====================*)

Get@FileNameJoin[{"Cosmology","TotalToCosmology","MakeSquareDerivative.m"}];
Get@FileNameJoin[{"Cosmology","TotalToCosmology","ToCosmology.m"}];
Get@FileNameJoin[{"Cosmology","TotalToCosmology","ForceWeightless.m"}];

TotalToCosmology[InputExpr_,ModelName_]:=Module[{Expr=InputExpr},

	Comment@"It looks like this if the background is cosmology.";
	Expr//=ToCosmology;
	Expr//=(List@@#)&;
	Expr//=(MakeSquareDerivative/@#)&;
	Expr//=Total;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//DisplayExpression;

	Expr//=InputForm;
	Expr//=ToString;
	ExportedLagrangianString=Expr;
	DumpSave[FileNameJoin@{$ThisDirectory,ModelName<>".mx"},
		ExportedLagrangianString];
];

(*Comment@"Testing the action of the conformal transformation:";
Expr=RealT[z,-b,-c];
Expr//=ToCosmology;
Expr=RealT[-z,-b,-c];
Expr//=ToCosmology;
Expr=Sqrt[-DetG[]];
Expr//=ToCosmology;
Expr=RiemannCD[-z,-b,-c,-d];
Expr//=ToCosmology;
Expr=RicciCD[-z,-b];
Expr//=ToCosmology;
Expr=RicciScalarCD[];
Expr//=ToCosmology;*)
