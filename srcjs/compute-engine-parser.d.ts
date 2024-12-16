// compute-engine-parser.d.ts

export interface Parser {
    readonly options: any; // Customize this type based on your needs
  
    getIdentifierType(id: string): 'symbol' | 'function' | 'unknown';
  
    pushSymbolTable(): void;
  
    popSymbolTable(): void;
  
    addSymbol(id: string, type: 'symbol' | 'function' | 'unknown'): void;
  
    /** The index of the current token */
    index: number;
  
    /** True if the last token has been reached.
     * Consider also `atTerminator()`.
     */
    readonly atEnd: boolean;
  
    /** Return true if the terminator condition is met or if the last token
     * has been reached.
     */
    atTerminator(t: any): boolean;
  
    /** Return the next token, without advancing the index */
    readonly peek: string;
  
    /** Return the next token and advance the index */
    nextToken(): string;
  
    /** Return a string representation of the expression
     * between `start` and `end` (default: the whole expression)
     */
    latex(start: number, end?: number): string;
  
    /** Return an error expression with the specified code and arguments */
    error(code: string | [string, ...any[]], fromToken: number): any;
  
    /** If there are any spaces, advance the index until a non-space is encountered */
    skipSpace(): boolean;
  
    /** Skip over "visual space" which
     * includes space tokens, empty groups `{}`, and commands such as `\,` and `\!`
     */
    skipVisualSpace(): void;
  
    /** If the next token matches the target, advance and return true. Otherwise
     * return false
     */
    match(token: string): boolean;
  
    /** Return true if the next tokens match the argument, an array of tokens, or null otherwise
     */
    matchAll(tokens: string[]): boolean;
  
    /** Return the next token if it matches any of the tokens in the argument, or null otherwise
     */
    matchAny(tokens: string[]): string | null;
  
    /** If the next token is a character, return it and advance the index */
    matchChar(): string | null;
  
    parseGroup(): any;
  
    parseExpression(until?: any): any;
  
    // Other methods as needed...
  }
  