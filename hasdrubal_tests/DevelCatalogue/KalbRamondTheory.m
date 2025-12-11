(*====================*)
(*  KalbRamondTheory  *)
(*====================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];

Comment@"Set up a two-form field.";
Code[DefField[FirstTwoFormField[-a,-b],Antisymmetric[{-a,-b}],PrintAs->"\[ScriptCapitalB]",
	PrintSourceAs->"\[ScriptCapitalJ]",TableWidth->35];];
Expr=FirstTwoFormField[-a,-b];
Expr//DisplayExpression;

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=FirstKineticCoupling*epsilonG[a,b,c,d]*CD[-a]@FirstTwoFormField[-b,-c]*epsilonG[e,f,g,-d]*CD[-e]@FirstTwoFormField[-f,-g];
LagrangianAnsatz//=ToCanonical;
LagrangianAnsatz//=ContractMetric;
LagrangianAnsatz//=ScreenDollarIndices;
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"KalbRamondTheory"];
