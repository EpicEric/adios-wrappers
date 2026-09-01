export type JSONType =
  string | number | boolean | { [key: string]: JSONType } | JSONType[] | null;

function makeIndent(depth: number): string { return '  '.repeat(depth) }

function formatString(string: string, depth: number):
  string {
  if (string.includes('\n')) {
    let lines =
      string.split('\n').map((line) => `${makeIndent(depth + 1)}${line}`);

    return `''\n${lines.join('\n')}\n${makeIndent(depth)}''`;
  }

  return `"${string}"`;
}

function formatMap(map: { [key: string]: JSONType }, depth: number):
  string {
  if (Object.entries(map).length === 0) {
    return '{}';
  }

  let lines = Object.entries(map).map(
    ([key, value]) => {
      return `${makeIndent(depth + 1)}${key} = ${jsonValueToNix(value, depth + 1)};`
    });

  return `{\n${lines.join('\n')}\n${makeIndent(depth)}}`;
}

function formatList(list: JSONType[], depth: number):
  string {
  if (list.length === 0) {
    return '[]';
  }

  let lines = list.map(
    (item) => {
      return `${makeIndent(depth + 1)}${jsonValueToNix(item, depth + 1)}`
    });

  return `[\n${lines.join('\n')}\n${makeIndent(depth)}]`;
}

export function jsonValueToNix(value: JSONType, depth: number = 0): string {
  if (value == null) {
    return 'null';
  }

  switch (typeof value) {
    case 'string':
      return formatString(value, depth);
    case 'number':
      return JSON.stringify(value);
    case 'boolean':
      return JSON.stringify(value);
    case 'object':
      if (value.length !== undefined) {
        return formatList(value as JSONType[], depth);
      } else {
        return formatMap(value as { [key: string]: JSONType }, depth);
      }
  }
}
