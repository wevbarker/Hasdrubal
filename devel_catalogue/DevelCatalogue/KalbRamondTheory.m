(*====================*)
(*  KalbRamondTheory  *)
(*====================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];

Comment@"Set up a two-form field.";
Code[DefField[TwoFormField[-a,-b],Antisymmetric[{-a,-b}],PrintAs->"\[ScriptCapitalB]",
	PrintSourceAs->"\[ScriptCapitalJ]",TableWidth->35];];
Expr=TwoFormField[-a,-b];
Expr//DisplayExpression;

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=FirstKineticCoupling*epsilonG[a,b,c,d]*CD[-a]@TwoFormField[-b,-c]*epsilonG[e,f,g,-d]*CD[-e]@TwoFormField[-f,-g];
LagrangianAnsatz//=ToCanonical;
LagrangianAnsatz//=ContractMetric;
LagrangianAnsatz//=ScreenDollarIndices;
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"KalbRamondTheory"];
