(*===============*)
(*  ProcaTheory  *)
(*===============*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];
Code[DefConstantSymbol[SecondKineticCoupling,PrintAs->"\[Beta]"]];
Code[DefConstantSymbol[SquareMassCoupling,PrintAs->"\[Gamma]"]];

Comment@"Set up a vector field.";
Code[DefField[VectorField[a],PrintAs->"\[ScriptCapitalA]",
	PrintSourceAs->"\[ScriptCapitalJ]"];];
Expr=VectorField[a];
Expr//DisplayExpression;

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=-(FirstKineticCoupling/4)*(CD[a]@VectorField[b]-CD[b]@VectorField[a])*(CD[-a]@VectorField[-b]-CD[-b]@VectorField[-a])+SquareMassCoupling*VectorField[-a]*VectorField[a];
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"ProcaTheory"];
