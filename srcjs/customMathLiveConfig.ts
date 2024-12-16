// customMathLiveConfig.ts
import {
  IComputeEngine,
  IdentifierDefinitions,
} from '@cortex-js/compute-engine'; // Import necessary types

export const customMacros = {
  // bond evaluation
  ytm: {
    args: 0,
    captureSelection: true,
    def: '\\mathit{ytm}',
    expand: true,
  },
  FV: {
    args: 0,
    captureSelection: true,
    def: '\\mathit{FV}',
    expand: true,
  },
  CPN: {
    args: 0,
    captureSelection: true,
    def: '\\mathit{CPN}',
    expand: true,
  },
  maturity: {
    args: 0,
    captureSelection: true,
    def: '\\mathit{N}',
    expand: true,
  },
  // created for function declared in library and dictionary at startup
  // commented out in favor of shorthand declaration with ce.assign
  // left to show the latex rendering
  // it had to be called \PV {10}{5}{100}{0.035} with literal numbers (no spaces!)
  //    and \PV \maturity\CPN\FV\ytm with symbolic identifiers
  // lot of work on the parser to get the four arguments as separate entities in two cases
  // also evaluate needed lot of pre-processing, ce.assign is much simpler with numbers
  PV: {
    args: 4,
    captureSelection: true,
    def: '\\operatorname{PV}\\left(#1, #2, #3, #4 \\right)',
    expand: true,
  },
  Pzero: {
    args: 0,
    captureSelection: true,
    def: '\\mathit{P_{0}}', // for rendering, using Pzero as parsable identifier
    expand: true,
  },
  Testval: {
    args: 0,
    captureSelection: true,
    def: '\\mathit{Testval}',
    expand: true,
  },
  // site example inline fraction
  smallfrac: {
    args: 2,
    def: '{}^{#1}\\!\\!/\\!{}_{#2}',
    captureSelection: false,
  },
};
// Define a basic structure for Expression
type Expression =
  | string // for simple identifiers like variables
  | number // for numeric literals
  | [string, ...any[]]; // for function calls, sequences, etc.

// or a more specific example, depending on your needs:
// type Expression = string | number | [string, Expression[], ...any[]];

export const customInlineShortcuts = {
  // Add custom inline shortcuts as needed
  frc: '\\smallfrac{#@}{#?}', // The #@ token represents the argument to the left of the shortcut, and the #? token represents a placeholder to be filled by the user.
};

type CustomLatexDictionaryEntry = {
  name: string;
  kind: 'symbol' | 'function' | 'environment';
  latexTrigger?: string;
  identifierTrigger?: string;
  parse?: (parser: any) => any[];
};

export const customLatexDictionary: CustomLatexDictionaryEntry[] = [
  {
    name: 'ytm',
    kind: 'symbol',
    latexTrigger: '\\ytm',
  },
  {
    name: 'FV',
    kind: 'symbol',
    latexTrigger: '\\FV',
  },
  {
    name: 'CPN',
    kind: 'symbol',
    latexTrigger: '\\CPN',
  },
  {
    name: 'maturity',
    kind: 'symbol',
    latexTrigger: '\\maturity',
  },
  {
    name: 'Pzero',
    kind: 'symbol',
    latexTrigger: '\\Pzero',
  },
  {
    name: 'Testval',
    kind: 'symbol',
    latexTrigger: '\\Testval',
  },
  // { // previous implementation in customDictionary
  //     name: 'PV',
  //     kind: 'function',
  //     latexTrigger: '\\PV',
  //     // needed to parse four numeric arguments as separate entities
  //     // with this evaluation ok
  //     // error on symbolic call
  //     parse: (parser: any) => {
  //       // Explicitly parse four arguments as separate entities
  //       const args = [];
  //       for (let i = 0; i < 4; i++) {
  //         const argToken = parser.parseToken();
  //         const argGroup = parser.parseGroup();
  //         const arg = argGroup ? argGroup : argToken;
  //          // Use parseGroup to ensure each argument is treated as a block
  //         // console.log("PV arg", arg);
  //         if (arg) {
  //           args.push(arg);
  //         } else {
  //           args.push(["Error", "missing"]);
  //         }
  //       }
  //       return ["PV", ...args];
  //   },
  // },
  {
    name: 'smallfrac',
    kind: 'function',
    latexTrigger: '\\smallfrac',
  },
  // {
  //   name: 'aligned',
  //   kind: 'environment', // aborted attempt to use aligned environment for multiline expressions
  //   identifierTrigger: 'aligned',
  // },
];

export const FINANCE_LIBRARY: IdentifierDefinitions[] = [
  { maturity: { domain: 'Numbers', constant: false, value: 99 } },
  { ytm: { domain: 'Numbers', constant: false, value: 0.099 } },
  { FV: { domain: 'Numbers', constant: false, value: 99.99 } },
  { CPN: { domain: 'Numbers', constant: false, value: 9.99 } },
  { Pzero: { domain: 'Numbers', constant: false, value: undefined } },
  { Testval: { domain: 'Numbers', constant: false, value: undefined } },

  // { // previous implementation in library
  //   PV: {
  //     signature: {
  //       domain: ['FunctionOf', 'Numbers', 'Numbers', 'Numbers', 'Numbers', 'Numbers'],
  //       evaluate: (ce: IComputeEngine, [maturity, CPN, FV, ytm]) => {

  //         // Convert BoxedExpression to JavaScript numbers using Number()
  //         const maturityValue = maturity.isNumber?  Number(maturity) : Number(maturity.evaluate().N()? maturity.evaluate().N() : maturity.value);
  //         const CPNValue = CPN.isNumber?  Number(CPN) : Number(CPN.evaluate().N());
  //         const FVValue = FV.isNumber?  Number(FV) : Number(FV.evaluate().N())
  //         const ytmValue = ytm.isNumber?  Number(ytm) : Number(ytm.evaluate().N())
  //         console.log("PV arg values", maturityValue, CPNValue, FVValue, ytmValue);

  //         // Compute PV for CPN and FV
  //         const pvCpn = CPNValue / ytmValue * (1 - 1 / (1 + ytmValue) ** maturityValue);
  //         const pvFv = FVValue / (1 + ytmValue) ** maturityValue;

  //         // Return the sum of pvCpn and pvFv as a boxed number
  //         return ce.number(pvCpn + pvFv);
  //       },
  //     },
  //   },
  // },
];
