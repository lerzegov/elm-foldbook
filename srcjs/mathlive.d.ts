// src/mathlive.d.ts
declare module 'mathlive' {
  // export function latexToMathML(string): string;
  export class MathfieldElement extends HTMLElement {
    // Lifecycle methods
    connectedCallback(): void;
    attributeChangedCallback(
      name: string,
      oldValue: string | null,
      newValue: string | null
    ): void;

    // Properties
    value: string;
    fontsDirectory: string;
    popoverPolicy: 'auto' | 'off';
    virtualKeyboardMode: 'manual' | 'onfocus' | 'off';
    virtualKeyboardLayout:
      | 'auto'
      | 'qwerty'
      | 'azerty'
      | 'qwertz'
      | 'dvorak'
      | 'colemak';
    virtualKeyboardTheme: 'material' | 'apple' | 'default';
    smartMode: boolean;
    smartFence: boolean;
    smartSuperscript: boolean;
    smartSubscript: boolean;
    smartMath: boolean;
    smartText: boolean;
    smartDecimalSeparator: boolean;
    mathModeSpace: string;
    textToSpeechRules: string;
    textToSpeechRulesOptions: object;
    textToSpeechMarkup: string;
    speechEngine: 'amazon' | 'google' | 'local' | null;
    speechEngineVoice: string;
    speechEngineRate: string;
    mathUndoMode: 'all' | 'latex' | 'segments';
    macros: object;
    inlineShortcuts: object;

    // Methods
    setOptions(options: object): void;
    getValue(): string;
    setValue(latex: string): void;
    focus(): void;
    blur(): void;
    select(): void;
    insert(latex: string, options?: object): void;
    insertText(text: string, options?: object): void;
    delete(): void;
    perform(command: string): void;

    // Static properties and methods
    static get observedAttributes(): string[];
    static get fontsDirectory(): string;
    static set fontsDirectory(): string;
    static get computeEngine(): ComputeEngine;
    static set computeEngine(): ComputeEngine;
    static get soundsDirectory(): string;
    static set soundsDirectory(): string;
  }
}
