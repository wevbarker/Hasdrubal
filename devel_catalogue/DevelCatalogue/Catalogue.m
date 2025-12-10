(*=============*)
(*  Catalogue  *)
(*=============*)

Comment@"Set up a collection of fields.";
Code[DefField[VectorField[a],PrintAs->"\[ScriptCapitalA]",PrintSourceAs->"\[ScriptCapitalJ]"];];
Code[DefField[SecondVectorField[a],PrintAs->"\[ScriptCapitalB]",PrintSourceAs->"\[ScriptCapitalJ]"];];
Code[DefField[ScalarField[],PrintAs->"\[Phi]",PrintSourceAs->"\[Rho]"];];

Comment@"We construct a suitably general ansatz.";
Code[
LagrangianAnsatz=MakeContractionAnsatz[{
	IndexFree[CD@VectorField*CD@VectorField],
	IndexFree[CD@VectorField*CD@SecondVectorField],
	IndexFree[CD@SecondVectorField*CD@SecondVectorField],
	IndexFree[CD@ScalarField*CD@ScalarField],
	IndexFree[CD@ScalarField*VectorField],
	IndexFree[CD@ScalarField*SecondVectorField]
}];
];
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
LagrangianAnsatz//=ThreePlusOne;
