(*===============*)
(*  MarzoTheory  *)
(*===============*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];

Comment@"Set up a vector field.";
Code[DefField[FirstVectorField[a],PrintAs->"\[ScriptCapitalA]",
	PrintSourceAs->"\[ScriptCapitalJ]",TableWidth->20];];
Expr=FirstVectorField[a];
Expr//DisplayExpression;

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=-(FirstKineticCoupling/4)*CD[-a]@FirstVectorField[a]*CD[-b]@FirstVectorField[b];
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"MarzoTheory"];
