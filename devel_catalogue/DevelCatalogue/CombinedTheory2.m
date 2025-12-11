(*===================*)
(*  CombinedTheory2  *)
(*===================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[FirstKineticCoupling,PrintAs->"\[Alpha]"]];
Code[DefConstantSymbol[SecondKineticCoupling,PrintAs->"\[Beta]"]];
Code[DefConstantSymbol[ThirdKineticCoupling,PrintAs->"\[Gamma]"]];
Code[DefConstantSymbol[FourthKineticCoupling,PrintAs->"\[Delta]"]];
Code[DefConstantSymbol[FirstMassCoupling,PrintAs->"\[Epsilon]"]];
Code[DefConstantSymbol[FirstSquareMassCoupling,PrintAs->"\[Zeta]"]];

Comment@"Set up a vector field.";
Code[DefField[FirstScalarField[],PrintAs->"\[Phi]",
	PrintSourceAs->"\[Rho]",TableWidth->35];];
Code[DefField[FirstVectorField[-a],PrintAs->"\[ScriptCapitalA]",
	PrintSourceAs->"\[ScriptCapitalJ]",TableWidth->35];];
Code[DefField[SecondVectorField[-a],PrintAs->"\[ScriptCapitalB]",
	PrintSourceAs->"\[ScriptCapitalK]",TableWidth->35];];
Code[DefField[ThirdVectorField[-a],PrintAs->"\[ScriptCapitalC]",
	PrintSourceAs->"\[ScriptCapitalK]",TableWidth->35];];

Comment@"We construct a Lagrangian density.";
LagrangianAnsatz=(
	FirstKineticCoupling*CD[-a]@FirstVectorField[a]*CD[-b]@FirstVectorField[b]
	+SecondKineticCoupling*CD[-a]@SecondVectorField[-b]*CD[a]@SecondVectorField[b]
	-SecondKineticCoupling*CD[-a]@SecondVectorField[-b]*CD[b]@SecondVectorField[a]
	+ThirdKineticCoupling*CD[-a]@SecondVectorField[-b]*CD[a]@ThirdVectorField[b]
	-ThirdKineticCoupling*CD[-a]@SecondVectorField[-b]*CD[b]@ThirdVectorField[a]
	+FourthKineticCoupling*CD[-a]@ThirdVectorField[-b]*CD[a]@ThirdVectorField[b]
	-FourthKineticCoupling*CD[-a]@ThirdVectorField[-b]*CD[b]@ThirdVectorField[a]
	+FourthKineticCoupling*CD[-a]@FirstScalarField[]*CD[a]@FirstScalarField[]
	+FirstMassCoupling*CD[-a]@FirstVectorField[a]*FirstScalarField[]
	+FirstSquareMassCoupling*FirstScalarField[]*FirstScalarField[]
);
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"CombinedTheory2"];
