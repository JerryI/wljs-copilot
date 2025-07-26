const codemirror = window.SupportedCells['codemirror'].context; 
const originFacet = codemirror.originFacet;

import { inlineSuggestion } from './../lib/inline.js';

const fetchSuggestion = async (state, view) => {
    // or make an async API call here based on editor state
    const cell = state.facet(originFacet)[0].origin;
    const cursor = state.selection.ranges[0];

    if (cursor.from == cursor.to) return false;

    const result = await server.io.fetch('Notebook`Editor`Copilot`Private`gen', [cursor.from+1, cursor.to+1, cell.uid ]);
    if (!result) return false;

    return result.slice(1, -1);
};

codemirror.EditorExtensions.push(() => {
    return inlineSuggestion({
        fetchFn: fetchSuggestion,
        delay: 1000,
      });
});
