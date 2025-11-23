(*===================*)
(*  SolveVelocities  *)
(*===================*)

VariablesOfEquation[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=(#/.Equal->List)&;
	Expr//=Flatten;
	Expr//=(Variables/@#)&;
	Expr//=Flatten;
	Expr//=DeleteDuplicates;
Expr];


ObtainSolution[InputExpr_,InputParams_]:=Module[{Expr=InputExpr},
	Expr//=(#~CoefficientArrays~InputParams)&;
	Expr//=Normal;
	Quiet[
		Check[
			Catch[
				(Expr//=((Last@#)~LinearSolve~
					(First@#))&)~Check~(Throw@Message@FindAlgebra::NoSolution);
				Expr//=MapThread[(#1->-#2)&,{InputParams,#}]&;
			]
		,
			Expr=Null;
		];
	];
Expr];

GetBestSolution[InputSystem_,InputMomenta_,InputVelocities_]:=Module[{Expr,
	Momenta=InputMomenta,
	Velocities=InputVelocities,
	GetRanking},

	Expr=Subsets[Velocities~Join~Momenta,{Length@(InputSystem/.{And->List})}];
	GetRanking[InputParams_]:=Length@Velocities-Length@Intersection[Velocities,InputParams];
	Expr//=SortBy[#,GetRanking]&;
	Expr//=(ObtainSolution[InputSystem,#]&/@#)&;
	Expr//=DeleteCases[#,Null]&;
	Expr//=First;
Expr];

StandardSimplify[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
Expr];

Scalify[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=StandardSimplify;
	If[Length@(List@@(FindFreeIndices@InputExpr))==0,
	Expr//=Scalar];
Expr];

SolveVelocities[InputExpr_]:=Module[{Expr=InputExpr,ConstantSymbols,
	Constraints,VelocitySolutions,OtherVariables},

	(*Comment@"Solving for velocities...";*)

	ConstantSymbols=InputExpr;
	ConstantSymbols//=(VariablesOfEquation/@#)&;
	ConstantSymbols//=Flatten;
	ConstantSymbols//=DeleteDuplicates;
	ConstantSymbols//=Cases[#,_?ConstantSymbolQ]&;
	(*ConstantSymbols//DisplayExpression;*)

	MadeOfConstantsQ[expr_]:=And[!(expr===0),SubsetQ[ConstantSymbols,Variables[expr]]];

	(*
	Expr//=Reduce[#,$VelocitiesUp]&;
	Expr//=LogicalExpand;
	Expr//Print;
	Expr//=(#/.{Equal[_?MadeOfConstantsQ,_]->False})&;
	Expr//=(#/.{(_?MadeOfConstantsQ==_)->False})&;
	Expr//Print;
	Expr//=(#/.{Equal[_,_?MadeOfConstantsQ]->False})&;
	Expr//=(#/.{(_==_?MadeOfConstantsQ)->False})&;
	Expr//Print;
	Expr//=(#/.{NotEqual[_?MadeOfConstantsQ,_]->True})&;
	Expr//=(#/.{(_?MadeOfConstantsQ!=_)->True})&;
	VelocityQ[var_]:=MemberQ[$VelocitiesUp,var];
	Expr//=(#/.{Equal[LHS_,RHS_?VelocityQ]->Equal[RHS,LHS]})&;
	Expr//=(#/.Equal->Rule)&;
	Expr//=(#/.And->List)&;
	(**)Expr//DisplayExpression;(**)
	*)

	Expr//=GetBestSolution[#,$ConjugateMomenta,$VelocitiesUp]&;

	Constraints=Expr;
	Constraints//=DeleteCases[#,Alternatives@@(Rule[#, _]&/@$VelocitiesUp)]&;
	Constraints//=((First@#-Last@#)&/@#)&;
	(*Constraints//DisplayExpression;*)

	OtherVariables=InputExpr;
	OtherVariables//=(VariablesOfEquation/@#)&;
	OtherVariables//=Flatten;
	OtherVariables//=DeleteDuplicates;
	OtherVariables//=Complement[#,$VelocitiesUp]&;
	OtherVariables//=DeleteCases[#,_?ConstantSymbolQ]&;
	(**)OtherVariables//DisplayExpression;(**)

	VelocitySolutions=Expr;
	VelocitySolutions//=DeleteCases[#,Alternatives@@(Rule[#, _]&/@OtherVariables)]&;
	VelocitySolutions//=(MakeRule[
			Evaluate@(({Evaluate@First@#,Scalify@Evaluate@Last@#})&@(List@@#)),
		MetricOn->All,ContractMetrics->True]&/@#)&;
	VelocitySolutions//=Flatten;
	(*VelocitySolutions//DisplayExpression;*)
(*Quit[];*)
{VelocitySolutions,Constraints}];
