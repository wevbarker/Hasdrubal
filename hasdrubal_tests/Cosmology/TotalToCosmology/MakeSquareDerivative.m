(*========================*)
(*  MakeSquareDerivative  *)
(*========================*)

MakeSquareDerivative[InputTerm_]:=Module[{Expr=InputTerm,
	HigherDerivTerms,LowerDerivTerms},

	Expr//=FactorList;
	HigherDerivTerms=Cases[Expr,{CD[Ind1_]@CD[Ind2_]@Tens_,_},Infinity];
	LowerDerivTerms=DeleteCases[Expr,{CD[Ind1_]@CD[Ind2_]@Tens_,_},Infinity];
	LowerDerivTerms//=((Power@@#)&/@#)&;
	LowerDerivTerms//=Times@@#&;
	Expr=LowerDerivTerms;
	If[!(HigherDerivTerms=={}),
		Expr//={-#,First@First@HigherDerivTerms}&;
		Expr//=(#/.{OtherTens_,CD[Ind1_]@CD[Ind2_]@Tens_}->
			{CD[Ind1]@OtherTens,CD[Ind2]@Tens})&;
		Expr//=(Times@@#)&;
		Expr//=ToCanonical;
		Expr//=ContractMetric;
		Expr//=ScreenDollarIndices;
	];
Expr];
