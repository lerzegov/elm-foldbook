import { MathfieldElement } from 'mathlive';
// import * as MathLive from 'mathlive';
// import { latexToMathML } from 'mathlive';
import { ComputeEngine, SemiBoxedExpression } from '@cortex-js/compute-engine';

import {
  customMacros,
  customInlineShortcuts,
  customLatexDictionary,
  FINANCE_LIBRARY,
} from './customMathLiveConfig.js';

import SRE from 'speech-rule-engine';
import 'speech-rule-engine/sre-latex'; // Include the LaTeX extension

// Make SRE available globally for debugging purposes
window.SRE = SRE;

// NB SRE is added to mathlive-bundle, mathmaps are not
// copied them from node_modules/speech-rule-engine/lib/mathmaps to public/mathmaps
// // Load and configure SRE for locale settings
SRE.setupEngine({
  locale: 'it', // Set to the desired locale, e.g., 'it' for Italian
  speech: 'deep', // Option for more descriptive speech
  json: 'mathmaps',
});

// // Function to convert LaTeX to MathML and get spoken text
// MOVED TO index.html
// function getSpokenTextFromLatex(latexInput: string) {
//   try {
//     // Convert LaTeX to MathML
//     const mathMl = latexToMathML(latexInput);

//     if (mathMl) {
//       // Use SRE to get spoken text from MathML
//       const spokenText = SRE.toSpeech(mathMl);
//       console.log('Spoken text:', spokenText);
//       return spokenText;
//     } else {
//       console.error('Failed to convert LaTeX to MathML.');
//       return 'Conversion error';
//     }
//   } catch (error) {
//     console.error('Error during LaTeX conversion or SRE processing:', error);
//     return 'Processing error';
//   }
// }

// // Make the function available globally
// window.getSpokenTextFromLatex = getSpokenTextFromLatex;

// Custom element extending MathfieldElement
class MathliveDisplayElement extends MathfieldElement {
  private _mathJson: SemiBoxedExpression | null = null;

  constructor() {
    super();
  }

  connectedCallback(): void {
    super.connectedCallback();
    // Initialize MathLive properties
    this.virtualKeyboardMode = 'off';
    this.popoverPolicy = 'off';
    this.smartMode = true;
    this.contentEditable = 'false';
    this.style.display = 'inline-block';
    this.textToSpeechRules = 'sre';
    this.textToSpeechRulesOptions = {
      //overridden in index.html
      domain: 'mathspeak',
      style: 'brief',
      locale: 'it',
      modality: 'speech',
      markup: 'ssml',
    };
    // see tutorial https://www.seewritehear.com/accessible-mathml/mathspeak/examples/settings-tutorial/
    /*
    domain	Domain or subject area of speech rules (e.g., mathspeak, clearspeak).
    style	Style or preference setting of speech rules (e.g., brief).
    In case of clearspeak, multiple preferences can be chosen using : as separator.
    locale	Language locale in 639-1.
    subiso	More fine grained specification of locale. E.g., for French fr, be, or ch
    markup	Set output markup for speech: none, ssml, sable, voicexml, acss
    modality	Set the modality SRE returns. E.g., speech, braille, prefix, summary
    */

    const latex: string | null = this.getAttribute('value');
    const parentId: string = this.getValidParentId();
    this.setAttribute('parent-id', parentId);

    if (latex) {
      this.value = latex;
    }
  }

  // Helper function to find the valid parent ID
  private getValidParentId(): string {
    let element = this.parentElement;

    // Traverse the DOM to find a parent with a valid ID attribute
    while (element) {
      if (element.id && element.id.trim() !== '') {
        return element.id;
      }
      element = element.parentElement;
    }

    // Fallback to an empty string if no valid parent ID is found
    return '';
  }

  static get observedAttributes(): string[] {
    return ['value', ...MathfieldElement.observedAttributes];
  }
}

// Custom element extending MathfieldElement
class MathliveEditElement extends MathfieldElement {
  private _mathJson: SemiBoxedExpression | null = null;
  private _result: string | null = null;

  constructor() {
    super();
    // console.log("MathliveEditElement constructor called.");
    //console.log("Init compute engine", MathfieldElement.computeEngine); => new not needed, done in super()?

    // Set the fontsDirectory globally on the MathfieldElement class relative to the bundle folder
    MathfieldElement.fontsDirectory = 'fonts/';

    // Initialize the static ComputeEngine and configure it once
    if (
      !MathfieldElement.computeEngine.latexDictionary.includes(
        ...customLatexDictionary
      )
    ) {
      MathfieldElement.computeEngine = new ComputeEngine();
      console.log('ComputeEngine initialized.');

      // Add custom latexDictionary to the ComputeEngine
      MathfieldElement.computeEngine.latexDictionary = [
        ...MathfieldElement.computeEngine.latexDictionary,
        ...customLatexDictionary,
      ] as const;
      console.log('Latex dictionary extended with custom entries.');

      // Declare custom identifiers in the ComputeEngine
      FINANCE_LIBRARY.forEach((item) => {
        for (const [name, definition] of Object.entries(item)) {
          if (
            typeof definition === 'object' &&
            'domain' in definition &&
            'constant' in definition &&
            !('signature' in definition)
          ) {
            MathfieldElement.computeEngine.declare(name, {
              domain: definition.domain,
              constant: definition.constant,
            });
          } else if (
            typeof definition === 'object' &&
            'signature' in definition
          ) {
            MathfieldElement.computeEngine.declare(name, {
              signature: {
                domain: definition.signature.domain,
                evaluate: definition.signature.evaluate,
              },
            });
          } else {
            console.warn(`Unexpected definition type for ${name}`, definition);
          }
        }
      });

      // Test quick declaration of functions
      MathfieldElement.computeEngine.assign('f(x)', '$$ x^2 $$');
      MathfieldElement.computeEngine.assign('g(x,y)', '$$ xy $$');
      MathfieldElement.computeEngine.assign('d(y,n)', '$$ (1+y)^{-n} $$'); // discount factor
      MathfieldElement.computeEngine.assign('Testval', 8.88);
      // strctured declaration of a function
      // in latex content (, , ) are needed to match the function signature
      // no macro definition for multichar id, but must be wrapped in \operatorname{...}!!
      MathfieldElement.computeEngine.assign(
        'prezzo',
        (ce: ComputeEngine, [maturity, CPN, FV, ytm]: Array<number>) => {
          // Compute PV for CPN and FV
          const pvCpn = (CPN / ytm) * (1 - 1 / (1 + ytm) ** maturity);
          const pvFv = FV / (1 + ytm) ** maturity;

          // Return the sum of pvCpn and pvFv as a boxed number
          return ce.number(pvCpn + pvFv);
        }
      );
      // shorthand declaration of a function, using latex for evaluation
      // latex must be well formed, use {} on single char exponents,
      // don't use var names conflicting with latex standard commands, avoid capital letters
      // can be set semi-automatically from latex content of the element
      MathfieldElement.computeEngine.assign(
        'prlatex(n,c,v,y)',
        '$$ \\frac{c}{y} \\left(1 - \\frac{1}{(1+y)^{n}} \\right) + \\frac{v}{(1+y)^{n}} $$'
      );

      console.log('Custom identifiers declared in ComputeEngine.');
    }
  }

  connectedCallback(): void {
    super.connectedCallback();

    this.virtualKeyboardMode = 'manual';
    this.popoverPolicy = 'auto';
    this.smartMode = true;
    this.macros = { ...this.macros, ...customMacros };
    this.inlineShortcuts = {
      ...this.inlineShortcuts,
      ...customInlineShortcuts,
    };

    const latex: string | null = this.getAttribute('value');
    const parentId: string = this.getValidParentId();
    this.setAttribute('parent-id', parentId);

    if (latex) {
      this.value = latex;
    }
    this.updateMathJson();

    this.handleContentChange(parentId); // Handle the initial content change

    this.addEventListener('change', () => {
      this.handleContentChange(parentId);
    });
  }

  // Helper function to find the valid parent ID
  private getValidParentId(): string {
    let element = this.parentElement;

    // Traverse the DOM to find a parent with a valid ID attribute
    while (element) {
      if (element.id && element.id.trim() !== '') {
        return element.id;
      }
      element = element.parentElement;
    }

    // Fallback to an empty string if no valid parent ID is found
    return '';
  }

  static get observedAttributes(): string[] {
    return ['value', ...MathfieldElement.observedAttributes];
  }

  attributeChangedCallback(
    name: string,
    oldValue: string,
    newValue: string
  ): void {
    super.attributeChangedCallback(name, oldValue, newValue);

    if (name === 'value' && newValue !== oldValue) {
      this.value = newValue || '';
      // this.updateMathJson();

      // const parentId = this.getAttribute('parent-id');
      // if (!this.assignFunction()) {
      //     this.evaluateAndDispatch(parentId);
      // }
    }
  }

  get mathJson(): SemiBoxedExpression | null {
    return this._mathJson;
  }

  set mathJson(value: SemiBoxedExpression | null) {
    if (value !== this._mathJson) {
      this._mathJson = value;
    }
  }

  get result(): string | null {
    return this._result;
  }

  set result(value: string | null) {
    if (value !== this._result) {
      this._result = value;
    }
  }
  assignFunctionDummy(): boolean {
    return false;
  }

  // Method to assign a function from LaTeX input
  // NB: arg symbols must be single lowercase letters (excluding 'i', 'j', 'k') in alphabetical order
  assignFunction(): boolean {
    if (!this._mathJson) {
      console.error('Invalid MathJSON');
      return false;
    }

    // Convert the SemiBoxedExpression to a boxed expression to access its JSON structure
    let expr = MathfieldElement.computeEngine.box(this._mathJson);
    const json = expr.json;
    const [operation, lhs, rhs] = json;
    // console.log("Operation:", operation);
    // console.log("LHS:", lhs); // \operatorname{..} automatically removed by ComputeEngine parser
    // console.log("RHS:", rhs);

    // Check if the JSON is an assignment operation
    if (
      !Array.isArray(json) ||
      operation !== 'Assign' ||
      typeof lhs !== 'string' ||
      !Array.isArray(rhs)
    ) {
      // console.log("Not an assignment of a function or incorrect format", json);
      return false;
    }

    // The LHS should be the function name as a string (e.g., 'f')
    const funcName = lhs;

    // Extract variables from the RHS JSON
    const variables = this.extractVariables(rhs);

    // Create function header: funcname(x, y, ...)
    const funcHeader = `${funcName}(${variables.join(',')})`;
    const rhsExpr = MathfieldElement.computeEngine.box(rhs);
    // Serialize the RHS back to LaTeX
    const originalLatexRHS = this.extractOriginalLatex(rhs);
    const rhsLatex = originalLatexRHS.replace(/"/g, '\\"');
    const wrappedRhsLatex = `$$ ${rhsLatex} $$`;

    // Assign the function to ComputeEngine
    MathfieldElement.computeEngine.assign(funcHeader, wrappedRhsLatex);

    console.log(`Assigned function: ${funcHeader} = ${wrappedRhsLatex}`);
    return true;
  }

  private extractOriginalLatex(rhs: any): string {
    const rhsExpr = MathfieldElement.computeEngine.box(rhs);
    return rhsExpr.latex;
  }

  private extractVariables(expr: SemiBoxedExpression): string[] {
    const variables = new Set<string>();

    function traverse(node: SemiBoxedExpression) {
      if (typeof node === 'string') {
        // Only add single lowercase letters (excluding 'i', 'j', 'k') as variables
        if (/^[a-hl-z]$/.test(node)) {
          variables.add(node);
        }
      } else if (Array.isArray(node)) {
        // If it's an array, recursively traverse its elements
        for (const child of node) {
          traverse(child);
        }
      }
      // Numbers or other types are ignored
    }

    traverse(expr);
    return Array.from(variables).sort();
  }

  // New method to handle content change
  private handleContentChange(parentId: string | null): void {
    this.updateMathJson();

    if (!this.assignFunction()) {
      this.evaluateAndDispatch(parentId);
    }
  }

  // Refactor evaluate method to include event dispatch
  private evaluateAndDispatch(parentId: string | null): void {
    try {
      if (!this.mathJson) {
        console.error('No MathJSON to evaluate.');
        return;
      }

      const expr = MathfieldElement.computeEngine.box(this.mathJson);
      const json = expr.json;

      if (Array.isArray(json) && json[0] === 'Assign') {
        const [operation, variable, value] = json;

        if (operation === 'Assign' && typeof variable === 'string') {
          MathfieldElement.computeEngine.assign(variable, value);
        }
      }

      const result = expr.evaluate().N();
      this.result = Number(result).toString();

      // Dispatch custom event with result, value, and mathJson
      const event = new CustomEvent('mathliveContentChanged', {
        detail: {
          id: parentId,
          value: this.value,
          mathJson: expr.json, // Send JSON structure
          result: this.result,
        },
        bubbles: true,
        composed: true,
      });
      this.dispatchEvent(event);
    } catch (err) {
      console.error('Evaluation error:', err);
    }
  }

  private updateMathJson() {
    const latex = this.getValue();
    // console.log("Converting LaTeX to MathJSON:", latex);

    this.mathJson = MathfieldElement.computeEngine.parse(
      latex
    ) as SemiBoxedExpression;
    // console.log("mathJson updated from LaTeX value:", this.mathJson);
  }
}

// Define the custom elements, e.g., <math-live-edit>
customElements.define('math-live-display', MathliveDisplayElement);
customElements.define('math-live-edit', MathliveEditElement);
