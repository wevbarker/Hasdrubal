(*===================*)
(*  CombinedTheory1  *)
(*===================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];
Code[DefConstantSymbol[SecondKineticCoupling,PrintAs->"\[Beta]"]];
Code[DefConstantSymbol[ThirdKineticCoupling,PrintAs->"\[Gamma]"]];
Code[DefConstantSymbol[FourthKineticCoupling,PrintAs->"\[Delta]"]];
Code[DefConstantSymbol[FirstMassCoupling,PrintAs->"\[Epsilon]"]];
Code[DefConstantSymbol[FirstSquareMassCoupling,PrintAs->"\[Zeta]"]];
Code[DefConstantSymbol[SecondSquareMassCoupling,PrintAs->"\[Eta]"]];

Comment@"Set up a vector field.";
Code[DefField[FirstScalarField[],PrintAs->"\[Phi]",
	PrintSourceAs->"\[Rho]",TableWidth->35];];
Code[DefField[FirstVectorField[-a],PrintAs->"\[ScriptCapitalA]",
	PrintSourceAs->"\[ScriptCapitalJ]",TableWidth->35];];
Code[DefField[SecondVectorField[-a],PrintAs->"\[ScriptCapitalB]",
	PrintSourceAs->"\[ScriptCapitalK]",TableWidth->35];];

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=(
	FirstKineticCoupling*CD[-a]@FirstVectorField[a]*CD[-b]@FirstVectorField[b]
	+SecondKineticCoupling*CD[-a]@SecondVectorField[a]*CD[-b]@SecondVectorField[b]
	+ThirdKineticCoupling*CD[-a]@SecondVectorField[b]*CD[a]@SecondVectorField[-b]
	+FourthKineticCoupling*CD[-a]@FirstScalarField[]*CD[a]@FirstScalarField[]
	+FirstMassCoupling*CD[-a]@FirstVectorField[a]*FirstScalarField[]
	+FirstSquareMassCoupling*SecondVectorField[-a]*SecondVectorField[a]
	+SecondSquareMassCoupling*FirstScalarField[]*FirstScalarField[]
);
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"CombinedTheory1"];
