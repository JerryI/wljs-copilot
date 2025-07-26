BeginPackage["CoffeeLiqueur`Extensions`Copilot`", {
    "JerryI`Notebook`", 
    "JerryI`Misc`Events`",
    "JerryI`Misc`Async`",
    "JerryI`Misc`Events`Promise`"
}]


Begin["`Private`"]


gen[from_, to_, cellHash_] := With[{
    cell = CellObj`HashMap[ cellHash ],
    promise = Promise[]
},
    Print[StringTake[cell["Data"], {from, to}] ];

    SetTimeout[
        EventFire[promise, Resolve, RandomWord[] ];
    , 300];

    promise
]

End[]

EndPackage[]