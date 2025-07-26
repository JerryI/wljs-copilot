BeginPackage["CoffeeLiqueur`Extensions`Copilot`", {
    "JerryI`Misc`Events`",
    "JerryI`Misc`Async`",
    "JerryI`Misc`Events`Promise`",
    "JerryI`LPM`"
}]


Begin["`Private`"]

PacletRepositories[{
    Github -> "https://github.com/JerryI/GPTLink"
}, "Directory"-> ParentDirectory[DirectoryName[$InputFileName] ] ];

Needs["KirillBelov`GPTLink`"];
Needs["CoffeeLiqueur`Notebook`Cells`" -> "cell`"];

bot = Null;

gen[from_, to_, cellHash_] := With[{
    cell = cell`HashMap[ cellHash ],
    promise = Promise[]
},

    If[bot === Null, bot = GPTChatObject["Works as autocomplete bar. User sends prompts with code snippents, ^^ indicates the cursor positions. Reply only with this completion expression where the cursor or empty string if completion is not needed. Most used languages: Wolfram, JS, MD, HTML"] ];

    If[StringLength[StringTrim[cell["Data"] ] ] < 3,
        EventFire[promise, Resolve, False];
        Return[promise];
    ];

    With[{payload = StringInsert[cell["Data"]<>" ", "^^", from+1]},
        GPTChatCompleteAsync[bot, payload, Function[Null, 
            EventFire[promise, Resolve, bot["Messages"][[-1, "content"]] ];
        ] ];
    ];

    promise
]

End[]

EndPackage[]