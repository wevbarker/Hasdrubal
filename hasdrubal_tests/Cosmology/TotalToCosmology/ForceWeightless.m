(*===================*)
(*  ForceWeightless  *)
(*===================*)

ForceWeightless[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=(#/.{RealT[AnyInds___]->
		RealT[AnyInds]/ScaleFactor[]^3})&;
	Expr//=(#/.{TPerturbation[AnyInds___]->
		TPerturbation[AnyInds]/ScaleFactor[]^3})&;
	Expr//=(#/.{MetricPerturbation[AnyInds___]->
		MetricPerturbation[AnyInds]/ScaleFactor[]^2})&;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
Expr];
