// speech-rule-engine.d.ts
// used to set mathlive's textToSpeechRulesOptions
declare module 'speech-rule-engine' {
  interface EngineSetupOptions {
    locale?: string; // Language locale (e.g., 'en', 'it', etc.)
    json?: string; // Path to the JSON file for the speech rules
    speech?: 'deep' | 'shallow'; // Speech depth for descriptions
    mode?: 'sync' | 'async'; // Whether to run in synchronous or asynchronous mode
    domain?: 'mathspeak' | 'clearspeak'; // Speech domain to use
    markup?: 'none' | 'ssml'; // Whether to include SSML markup in output
    strict?: boolean; // If true, the engine runs in strict mode
  }

  // Setup function for configuring the engine
  export function setupEngine(options: EngineSetupOptions): void;

  // Function to clear the engine settings
  export function clear(): void;

  // Function to process math and return spoken text
  export function toSpeech(input: string): string;

  // Other exported members as needed
}

// global.d.ts
interface Window {
  SRE: typeof import('speech-rule-engine');
  // getSpokenTextFromLatex: (latexInput: string) => string;
}
