(*======================*)
(*  MassiveMarzoTheory  *)
(*======================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];
Code[DefConstantSymbol[SquareMassCoupling,PrintAs->"\[Beta]"]];

Comment@"Set up a vector field.";
Code[DefField[VectorField[a],PrintAs->"\[ScriptCapitalA]",
	PrintSourceAs->"\[ScriptCapitalJ]"];];
Expr=VectorField[a];
Expr//DisplayExpression;

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=-(FirstKineticCoupling/4)*CD[-a]@VectorField[a]*CD[-b]@VectorField[b]-(SquareMassCoupling/2)*VectorField[-a]*VectorField[a];
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"MassiveMarzoTheory"];
