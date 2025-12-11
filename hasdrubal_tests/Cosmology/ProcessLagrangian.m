(*=====================*)
(*  ProcessLagrangian  *)
(*=====================*)

ProcessLagrangian[InputExpr_,ModelName_]:=Module[{Expr=InputExpr},
	Expr//=PostRiemannianDecomposition;
	Expr//=ExtractQuadratic;
	Expr//=TotalToCosmology[#,ModelName]&;
];
