(*===============*)
(*  DefGeometry  *)
(*===============*)

DefManifold[M,4,IndexRange[{b,z}]]; 
StandardIndices=ToString/@Alphabet[];
StandardIndices//=DeleteCases["a"];
StandardIndicesSymb=(ToString@#)&/@Evaluate@((#[[2]])&/@{	
(*{a,"\[Alpha]"},*)
	{b,"\[Beta]"},
	{c,"\[Chi]"},
	{d,"\[Delta]"},
	{e,"\[Epsilon]"},
	{f,"\[Phi]"},
	{g,"\[Gamma]"},
	{h,"\[Eta]"},
	{i,"\[Iota]"},
	{j,"\[Theta]"},
	{k,"\[Kappa]"},
	{l,"\[Lambda]"},
	{m,"\[Mu]"},
	{n,"\[Nu]"},
	{o,"\[Omicron]"},
	{p,"\[Pi]"},
	{q,"\[Omega]"},
	{r,"\[Rho]"},
	{s,"\[Sigma]"},
	{t,"\[Tau]"},
	{u,"\[Upsilon]"},
	{v,"\[Psi]"},
	{w,"\[Omega]"},
	{x,"\[Xi]"},
	{y,"\[CurlyPhi]"},
	{z,"\[Zeta]"}});
(PrintAs@Evaluate@#1^=Evaluate@#2)&~MapThread~{ToExpression/@StandardIndices,
	StandardIndicesSymb};
DefMetric[-1,G[-c,-b],CD,{";","\[Del]"},PrintAs->"\[ScriptG]",SymCovDQ->True];
DefCovD[CDT[-c],Torsion->True,SymbolOfCovD->{"#","\[ScriptCapitalD]"},FromMetric->G];

DefTensor[FakeRiemannCDT[-z,-b,-c,-d],M,PrintAs->"\[ScriptCapitalR]"];
FakeRiemannToRiemann=MakeRule[{FakeRiemannCDT[-z,-b,-c,-d],RiemannCDT[-c,-d,-z,-b]},
	MetricOn->All,ContractMetrics->True];

DefTensor[RealT[z,-b,-c],M,Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalT]"];
ConvertTorsion=MakeRule[{TorsionCDT[z,-b,-c],RealT[z,-b,-c]},
	MetricOn->All,ContractMetrics->True];

DefConstantSymbol[Eps,PrintAs->"\[Epsilon]"];

(*Initialise the perturbations*)
(ExpandPerturbation@Perturbation[#,2])&/@{Sqrt[-DetG[]],RealT[z,-b,-c]};
DefTensor[MetricPerturbation[-z,-b],M,Symmetric[{-z,-b}],PrintAs->"\[ScriptH]"];
PerturbationG[LI[n_],___]/;n>1:=0
ToMetricPerturbation=MakeRule[{PerturbationG[LI[1],-z,-b],MetricPerturbation[-z,-b]},
	MetricOn->All,ContractMetrics->True];
DefTensor[TPerturbation[z,-b,-c],M,Antisymmetric[{-b,-c}],
	PrintAs->"\[Delta]\[ScriptCapitalT]"];
(T~AutomaticRules~MakeRule[{Perturbation[RealT[z,-b,-c],PerturbationOrder],0},
	MetricOn->All,ContractMetrics->True])~Table~{PerturbationOrder,2,10};
ToTPerturbation=Join[
		MakeRule[{Perturbation[RealT[z,-b,-c],1],
			TPerturbation[z,-b,-c]},MetricOn->All,ContractMetrics->True],
		MakeRule[{Perturbation[RealT[z,-b,-c]],
			TPerturbation[z,-b,-c]},MetricOn->All,ContractMetrics->True]
];
