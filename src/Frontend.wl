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

    With[{payload = truncateString[StringInsert[cell["Data"]<>" ", "^^", from+1], from+1, 1000]},
        GPTChatCompleteAsync[bot, payload, Function[Null, 
            EventFire[promise, Resolve, bot["Messages"][[-1, "content"]] ];
        ] ];
    ];

    promise
]


truncateString[str_String, center_Integer, max_Integer] := Module[
  {l = StringLength[str],
   contentLen, leftLen, rightLen, start, end, prefix, suffix, interior},
  
  (* If it's already short enough, just return it. *)
  If[l <= max,
    Return[str]
  ];
  
  (* How many chars we can show between the two “…” *)
  contentLen = max - 6;            (* 3 dots + content + 3 dots = max *)
  leftLen    = Floor[contentLen/2]; 
  rightLen   = contentLen - leftLen;
  
  (* Center that window on the requested index *)
  start = center - leftLen;
  end   = center + rightLen - 1;
  
  (* If we ran off the left edge, shift right *)
  If[start < 1,
    end   += 1 - start;
    start  = 1;
  ];
  (* If we ran off the right edge, shift left *)
  If[end > l,
    start -= end - l;
    end     = l;
  ];
  
  prefix = If[start > 1, "...", ""];
  suffix = If[end   < l, "...", ""];
  
  (* Build it *)
  prefix <> StringTake[str, {start, end}] <> suffix
]

End[]

EndPackage[]