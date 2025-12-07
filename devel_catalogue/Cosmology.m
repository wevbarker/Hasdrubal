(*===============================*)
(*  PostRiemannianDecomposition  *)
(*===============================*)

<<xAct`xPlain`;
Title@"Quadratic theory on a flat cosmological background";

Get@FileNameJoin[{"Cosmology","Setup.m"}];
Get@FileNameJoin[{"Cosmology","DefGeometry.m"}];
Get@FileNameJoin[{"Cosmology","PostRiemannianDecomposition.m"}];
Get@FileNameJoin[{"Cosmology","GetParts.m"}];
Get@FileNameJoin[{"Cosmology","xPand.m"}];
Get@FileNameJoin[{"Cosmology","TotalToCosmology.m"}];
Get@FileNameJoin[{"Cosmology","ProcessLagrangian.m"}];

DefConstantSymbol[EinsteinConstant,PrintAs->"\[Kappa]"];
DefConstantSymbol[CosmologicalConstant,PrintAs->"\[CapitalLambda]"];
NonlinearLagrangian=Sqrt[-DetG[]]*(
	-(1/(2*EinsteinConstant))FakeRiemannCDT[i,m,-i,-m]
	-(1/EinsteinConstant)*CosmologicalConstant
);
NonlinearLagrangian//ProcessLagrangian[#,"EinsteinCartanTheory"]&;

(*DefConstantSymbol[Mu,PrintAs->"\[Mu]"];
DefConstantSymbol[Nu,PrintAs->"\[Nu]"];
DefConstantSymbol[MuLambda,PrintAs->"(\[Mu]\[Lambda])"];
DefConstantSymbol[Lambda,PrintAs->"\[Lambda]"];
DefConstantSymbol[MPlanck2,PrintAs->"\!\((\*SuperscriptBox[\(\*SubscriptBox[\(\[ScriptCapitalM]\), \(Pl\)]\), \(2\)])\)"];
NonlinearLagrangian=Sqrt[-DetG[]]*(
	-(4/9)*MPlanck2*TorsionCDT[a,-m,-a]*TorsionCDT[b,m,-b]
	-(1/6)*MuLambda*TorsionCDT[-m,-n,-s]*(TorsionCDT[m,n,s]-2*TorsionCDT[n,m,s])
	-(1/6)*Mu*(
		12*FakeRiemannCDT[i,-m,-i,-n]*((1/2)*(FakeRiemannCDT[j,m,-j,n]-FakeRiemannCDT[j,n,-j,m])-FakeRiemannCDT[j,n,-j,m])
		-2FakeRiemannCDT[-m,-n,-s,-r]*(FakeRiemannCDT[m,n,s,r]-4*FakeRiemannCDT[m,s,n,r]-5*FakeRiemannCDT[s,r,m,n])
	)
	+2*Nu*FakeRiemannCDT[i,-m,-i,-n]*(1/2)*(FakeRiemannCDT[j,m,-j,n]-FakeRiemannCDT[j,n,-j,m])
);*)

(*Comment@"Next we test massless Klein-Gordon on the FLRW background:";
DefTensor[Phi[],M,PrintAs->"\[Phi]"];
Expr=Sqrt[-DetG[]]*CD[-c]@Phi[]*CD[-b]@Phi[]*G[c,b];
Expr//=ToCosmology;*)

Quit[];
