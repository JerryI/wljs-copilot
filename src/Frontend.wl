BeginPackage["Notebook`Editor`Copilot`", {
    "JerryI`Notebook`", 
    "JerryI`Misc`Events`",
    "JerryI`Misc`Events`Promise`"
}]

Begin["`Private`"]

gen[assoc_][callback_] := With[{
    cell = CellObj`HashMap[assoc["Hash"]]
},
    Print[cell];

    callback[RandomWord[]];
]

End[]

EndPackage[]