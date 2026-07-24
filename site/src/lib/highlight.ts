import hljs, { type HLJSApi } from 'highlight.js';
import { Marked } from 'marked';
import { markedHighlight } from 'marked-highlight';

export let highlighter = hljs;

export const marked = new Marked(markedHighlight({
  emptyLangClass: 'hljs',
  langPrefix: 'hljs language-',
  highlight(code: string, lang: string) {
    const language = hljs.getLanguage(lang) ? lang : 'nix';
    return hljs.highlight(code, { language }).value;
  }
}));