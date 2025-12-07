(*============*)
(*  GetParts  *)
(*============*)

PreProcess[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=(#/.{RealT[AnyInds___]->Eps*RealT[AnyInds]})&;
	Expr//=Series[#,{Eps,0,2}]&;
	Expr//=Normal;
	Expr//=(#/.{Eps->1})&;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
Expr];

GetParts[InputExpr_,InputOrd_]:=Module[{Expr=InputExpr},
	Expr//=PreProcess;
	Expr//=(1/(Factorial@InputOrd))*Perturbation[#,InputOrd]&;
	Expr//=ExpandPerturbation;
	Expr//=(#/.ToMetricPerturbation)&;
	Expr//=(#/.ToTPerturbation)&;
	Expr//=(#/.{RealT->Zero})&;
	(*Expr//=(#/.{TPerturbation->T})&;*)
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=NoScalar;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//DisplayExpression;
Expr];

ExtractQuadratic[InputExpr_]:=Module[{Expr=InputExpr},
	Comment@"Here is the first-order Lagrangian density.";
	Expr//=GetParts[#,1]&;

	Comment@"It looks like this if the background is cosmology.";
	Expr//=ToCosmology;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//DisplayExpression;

	Comment@"Now we take variations with respect to the metric perturbation. This offers a useful check to make sure that the background equations yield a trivial linear theory.";
	Expr//=VarD[MetricPerturbation[-b,-c],CD];
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//DisplayExpression;

	Comment@"Here is the second-order Lagrangian density.";
	Expr=InputExpr;
	Expr//=GetParts[#,2]&;
Expr];
