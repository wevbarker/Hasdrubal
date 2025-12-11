(*=====================*)
(*  FieldThreePlusOne  *)
(*=====================*)

Options[FieldThreePlusOne]={DeclaredDecomposeFields-><||>};
FieldThreePlusOne[InputExpr_,FieldName_,OptionsPattern[]]:=Module[{Class,Expr=InputExpr},

	If[Length@OptionValue@DeclaredDecomposeFields>0,
		Expr//=((OptionValue@DeclaredDecomposeFields)@FieldName);
	,
		Class=FieldName;
		Class//=xAct`PSALTer`Private`FieldAssociation;
		Expr//=(#/.(Class@xAct`PSALTer`Private`FieldToFiducialField))&;
		Expr//=(Class@xAct`PSALTer`Private`DecomposeFields);
	];

	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
Expr];
