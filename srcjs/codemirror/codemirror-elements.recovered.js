// Recovered verbatim from public/codemirror-bundle.js of elm-foldbook v0.7 (2024-12-16), lines 28782-28954.
// Custom elements <code-mirror-formula-editor> and <code-mirror-markup-editor> (author: Luca Erzegovesi).
// Transpiled from TypeScript by Rollup; the original .ts sources of the v0.7 state were not preserved.

  /// ============== elm-formula editor =======================
  class CodeMirrorFormulaElement extends HTMLElement {
      constructor() {
          super(...arguments);
          this.elmCompletionSource = (context) => __awaiter(this, void 0, void 0, function* () {
              var _a, _b;
              const editorId = this.id;
              const word = (_b = (_a = context.matchBefore(/\w*/)) === null || _a === void 0 ? void 0 : _a.text) !== null && _b !== void 0 ? _b : "";
              if (!this.app) {
                  console.error('App instance is not set');
                  return null;
              }
              return new Promise((resolve) => {
                  const handler = (payload) => {
                      if (payload.editorId === editorId) {
                          const options = payload.hints.map(hint => ({
                              label: hint.label,
                              type: "keyword"
                          }));
                          resolve({
                              from: context.pos - word.length,
                              to: context.pos,
                              options: options.length > 0 ? options : [{ label: "No suggestions", type: "text" }]
                          });
                          // Unsubscribe after receiving the hints
                          this.app.ports.receiveHints.unsubscribe(handler);
                      }
                  };
                  this.app.ports.receiveHints.subscribe(handler);
                  this.app.ports.requestHints.send({ editorId: editorId, word: word });
              });
          });
      }
      static get observedAttributes() {
          return ['data-initial-value'];
      }
      setAppInstance(appInstance) {
          this.app = appInstance;
      }
      connectedCallback() {
          this.initCodeMirror();
      }
      attributeChangedCallback(name, oldValue, newValue) {
          if (name === 'data-initial-value' && this.editorView) {
              this.updateCodeMirrorContent(newValue);
          }
      }
      initCodeMirror() {
          const editorId = this.getAttribute('id');
          if (!editorId) {
              console.error('CodeMirrorElement requires an id attribute.');
              return;
          }
          const initialValue = this.getAttribute('data-initial-value') || '';
          //console.log('Initial value:', initialValue);
          try {
              const startState = EditorState.create({
                  doc: initialValue,
                  extensions: [
                      basicSetup,
                      ayuLight,
                      StreamLanguage.define(elm),
                      autocompletion({ override: [this.elmCompletionSource.bind(this)] }),
                      keymap.of([]), // Add keybindings if necessary
                      EditorView.updateListener.of((update) => {
                          var _a;
                          if (update.docChanged) {
                              const event = new CustomEvent('formulaContentChanged', { detail: (_a = this.editorView) === null || _a === void 0 ? void 0 : _a.state.doc.toString() });
                              // console.log('Dispatching formulaContentChanged event:', event.detail);
                              this.dispatchEvent(event);
                          }
                      })
                  ]
              });
              this.editorView = new EditorView({
                  state: startState,
                  parent: this
              });
              // console.log('Editor initialized successfully');
          }
          catch (error) {
              console.error('Error initializing CodeMirror:', error);
          }
      }
      updateCodeMirrorContent(newValue) {
          if (this.editorView) {
              const currentDoc = this.editorView.state.doc.toString();
              if (currentDoc !== newValue) {
                  this.editorView.dispatch({
                      changes: { from: 0, to: currentDoc.length, insert: newValue }
                  });
              }
          }
      }
      disconnectedCallback() {
          if (this.editorView) {
              this.editorView.destroy();
              this.editorView = undefined;
          }
      }
  }
  customElements.define('code-mirror-formula-editor', CodeMirrorFormulaElement);
  /// ============== elm-markup editor =======================
  class CodeMirrorMarkupElement extends HTMLElement {
      static get observedAttributes() {
          return ['data-initial-value'];
      }
      setAppInstance(appInstance) {
          this.app = appInstance;
      }
      connectedCallback() {
          this.initCodeMirror();
      }
      attributeChangedCallback(name, oldValue, newValue) {
          if (name === 'data-initial-value' && this.editorView) {
              this.updateCodeMirrorContent(newValue);
          }
      }
      initCodeMirror() {
          const editorId = this.getAttribute('id');
          if (!editorId) {
              console.error('CodeMirrorElement requires an id attribute.');
              return;
          }
          const initialValue = this.getAttribute('data-initial-value') || '';
          // console.log('Initial value:', initialValue);
          try {
              const startState = EditorState.create({
                  doc: initialValue,
                  extensions: [
                      elmMarkup(), // Ensure this is correctly imported and configured
                      //yamlOnly(),
                      basicSetup,
                      keymap.of([]), // Add keybindings if necessary
                      EditorView.lineWrapping, // Enable word wrapping
                      EditorView.updateListener.of((update) => {
                          var _a;
                          if (update.docChanged) {
                              const event = new CustomEvent('markupContentChanged', { detail: (_a = this.editorView) === null || _a === void 0 ? void 0 : _a.state.doc.toString() });
                              // console.log('Dispatching contentChanged event:', event.detail);
                              this.dispatchEvent(event);
                          }
                      })
                  ]
              });
              this.editorView = new EditorView({
                  state: startState,
                  parent: this
              });
              // console.log('Markup editor initialized successfully');
          }
          catch (error) {
              console.error('Error initializing CodeMirror markup edito:', error);
          }
      }
      updateCodeMirrorContent(newValue) {
          if (this.editorView) {
              const currentDoc = this.editorView.state.doc.toString();
              if (currentDoc !== newValue) {
                  this.editorView.dispatch({
                      changes: { from: 0, to: currentDoc.length, insert: newValue }
                  });
              }
          }
      }
      disconnectedCallback() {
          if (this.editorView) {
              this.editorView.destroy();
              this.editorView = undefined;
          }
      }
  }
  customElements.define('code-mirror-markup-editor', CodeMirrorMarkupElement);
