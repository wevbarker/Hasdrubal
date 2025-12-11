(*=========*)
(*  Setup  *)
(*=========*)

Off@ValidateSymbol::used;
$ThisDirectory=If[NotebookDirectory[]==$Failed,
	Directory[],
	NotebookDirectory[],
	NotebookDirectory[]];
<<xAct`xTensor`;
<<xAct`xTras`;
<<xAct`xCoba`;
<<xAct`xPert`;
On@ValidateSymbol::used;
Off@PrintAsCharacter::argx;
$DefInfoQ=False;
Unprotect@AutomaticRules;
Options[AutomaticRules]={Verbose->False};
Protect@AutomaticRules;
