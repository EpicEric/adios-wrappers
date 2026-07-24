export function shouldFold(content: string, maxLength: number = 60): boolean {
  if (content.length > maxLength) {
    return false;
  }

  if (content.split('\n').length > 1) {
    return false;
  }

  return true;
}