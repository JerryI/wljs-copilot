const codemirror = window.SupportedCells['codemirror'].context; 
const originFacet = codemirror.originFacet;

import { inlineSuggestion } from './../lib/inline.js';

const fetchSuggestion = async (state, view) => {
    // or make an async API call here based on editor state
    const cell = state.facet(originFacet)[0].origin;
    const cursor = state.selection.ranges[0];

    const payload = `<|"Cursor"->{${cursor.from+1}, ${cursor.to+1}}, "Hash"->"${cell.uid}"|>`;

    const result = await server.ask('Notebook`Editor`Copilot`Private`gen['+payload+']', 'callback');
    if (result == 'False') return false;

    return result.slice(1, -1);
};

codemirror.EditorExtensions.push(() => {
    return inlineSuggestion({
        fetchFn: fetchSuggestion,
        delay: 1000,
      });
});
