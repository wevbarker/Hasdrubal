(*===============================*)
(*  PostRiemannianDecomposition  *)
(*===============================*)

PostRiemannianDecomposition[InputExpr_] := Module[
	{Expr = InputExpr},

	Comment@"Here is the full non-linear Lagrangian density.";
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=FullSimplify;
	Expr//=CollectTensors;
	Expr=Expr/.FakeRiemannToRiemann;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=FullSimplify;
	Expr//=CollectTensors;
	DisplayExpression[CollectTensors@ToCanonical[Expr],
		EqnLabel->"ScalarParityViolatingPGT"];

	Comment@"Now we perform the post-Riemannian decomposition.";
	Expr//=ChangeCurvature[#,CDT,CD]&;
	Expr//=ChristoffelToGradMetric;
	Expr//=ContractMetric;
	Expr//=ToCanonical;
	Expr//=ScreenDollarIndices;
	Expr//=(#/.ConvertTorsion)&;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
	Expr//=ScreenDollarIndices;
	DisplayExpression[Expr,EqnLabel->"ScalarParityViolatingPGTPostRiemannian"];
Expr];
