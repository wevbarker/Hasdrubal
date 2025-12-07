(*=========*)
(*  xPand  *)
(*=========*)

<<xAct`xPand`;

SetSlicing[G,Nn,Hh,cd,{"|","\[PartialD]"},"FLFlat"];
Expr=$Metrics;

DefTensor[V[-b],M,PrintAs->"\[ScriptN]"];
AutomaticRules[V,MakeRule[{CD[-b]@V[-c],
	0},
	MetricOn->All,ContractMetrics->True]];
AutomaticRules[V,MakeRule[{V[b]*V[-b],
	1},
	MetricOn->All,ContractMetrics->True]];

Get@FileNameJoin[{"Cosmology","xPand","DefineBackgroundTensors.m"}];

AutomaticRules[ScaleFactor,MakeRule[{CD[-b]@ScaleFactor[],
	V[-b]*ScaleFactor[]*ConformalHubble[]},
	MetricOn->All,ContractMetrics->True]];

AutomaticRules[ConformalHubble,MakeRule[{CD[-b]@ConformalHubble[],
	V[-b]*ConformalHubblePrime[]},
	MetricOn->All,ContractMetrics->True]];

MakeRule[{CD[-b]@ConformalHubblePrime[],
	V[-b]*ConformalHubblePrimePrime[]},
	MetricOn->All,ContractMetrics->True];
