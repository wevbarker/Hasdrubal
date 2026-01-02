(*=================*)
(*  ZlosnikTheory  *)
(*=================*)

Comment@"Set up the coupling coefficients.";
Code[DefConstantSymbol[B3,PrintAs->"\[Beta]3"]];
Code[DefConstantSymbol[G3,PrintAs->"\[Gamma]3"]];
Code[DefConstantSymbol[A3,PrintAs->"\[Alpha]3"]];
Code[DefConstantSymbol[C43,PrintAs->"\[ScriptC]4,3"]];
Code[DefConstantSymbol[C44,PrintAs->"\[ScriptC]4,4"]];
Code[DefConstantSymbol[C45,PrintAs->"\[ScriptC]4,5"]];

Comment@"Set up a vector field.";
Code[DefField[VectorField[a],PrintAs->"\[ScriptCapitalA]",
	PrintSourceAs->"\[ScriptCapitalJ]",TableWidth->20];];
Expr=VectorField[a];
Expr//DisplayExpression;

Comment@"We construct a Lagrangian density.";

DefTensor[Ai[-i],M4];
DefTensor[A0[],M4];
ExpandAi=MakeRule[{Ai[-i],VectorField[-i]-V[-i]*V[j]*VectorField[-j]},MetricOn->All,ContractMetrics->True];
ExpandA0=MakeRule[{A0[],V[i]*VectorField[-i]},MetricOn->All,ContractMetrics->True];

LagrangianAnsatz=(B3+G3)*V[k]*CD[-k]@Ai[-i]*CD[i]@A0[]+A3*V[k]*CD[-k]@Ai[-i]*V[l]*CD[-l]@Ai[i]+(((B3+G3)^2-B3*G3)/(4*A3))*(G[i,j]-V[i]*V[j])*CD[-i]@A0[]*CD[-j]@A0[]+(C43+C45)*CD[-i]@Ai[-j]*CD[j]@Ai[i]+C44*(G[i,k]-V[i]*V[k])*CD[-i]@Ai[-j]*CD[-k]@Ai[j];
LagrangianAnsatz//DisplayExpression;
LagrangianAnsatz//=(#/.ExpandAi)&;
LagrangianAnsatz//=(#/.ExpandA0)&;
LagrangianAnsatz//=ToCanonical;
LagrangianAnsatz//=ContractMetric;
LagrangianAnsatz//=ScreenDollarIndices;
LagrangianAnsatz//DisplayExpression;

Comment@"Perform automated processing.";
ThreePlusOne[LagrangianAnsatz,"ZlosnikTheory"];
