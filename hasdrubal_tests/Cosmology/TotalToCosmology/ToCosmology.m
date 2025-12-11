(*===============*)
(*  ToCosmology  *)
(*===============*)

ToCosmology[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=Conformal[G,GaHh2];
	Expr//=ForceWeightless;
	Expr//=(#/.aHh[Anything___]->ScaleFactor[])&;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=(#/.{RiemannCD->Zero})&;
	Expr//=(#/.{RicciCD->Zero})&;
	Expr//=(#/.{RicciScalarCD->Zero})&;
	Expr//=(#/.{DetG[]->-1})&;
	Expr//=PowerExpand;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
Expr];
