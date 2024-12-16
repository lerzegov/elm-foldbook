// customMathLiveConfig.d.ts

export declare const customMacros: Record<string, {
    args: number;
    captureSelection: boolean;
    def: string;
    expand: boolean;
}>;

export declare const customInlineShortcuts: Record<string, string>;

export declare const customLatexDictionary:  Array<{
    kind: 'expression';
    latexTrigger: string;
    parse: (parser: any) => readonly [string, any, any];
    name: string;
}>;
