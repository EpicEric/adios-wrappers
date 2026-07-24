import hljs, { type HLJSApi } from 'highlight.js';
import { Marked } from 'marked';
import { markedHighlight } from 'marked-highlight';

function kororaHighlighter(hljs: HLJSApi) {
  return {
    name: 'Korora Types',
    aliases: ['korora', 'adios'],
    contains: [
      {
        className: 'built_in',
        begin: '[a-zA-Z]+(?=<)',
        relevance: 1,
      },
      {
        className: 'literal',
        begin: '[a-zA-Z]+',
        relevance: 0,
        keywords: {
          // Types from
          // https://github.com/llakala/lladios/blob/main/korora/default.nix

          // Primitive types
          keyword:
            'string str any never int float number bool null attrs list function path pathLike derivation type',
        }
      },
      {
        className: 'punctuation',
        begin: '>|,|<',
        relevance: 0,
      }
    ]
  };
}

hljs.registerLanguage('korora', kororaHighlighter)

export let highlighter = hljs;

export const marked = new Marked(markedHighlight({
  emptyLangClass: 'hljs',
  langPrefix: 'hljs language-',
  highlight(code: string, lang: string) {
    const language = hljs.getLanguage(lang) ? lang : 'nix';
    return hljs.highlight(code, { language }).value;
  }
}));