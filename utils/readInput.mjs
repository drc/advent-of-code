import path from 'path';
import { readFileSync } from 'fs';
import getCallerFile from 'get-caller-file';

export default function() {
  const file = path.join(path.dirname(getCallerFile()), 'input.txt').replace(/file:/, "");
  return readFileSync(file).toString();
}

export function readSampleInput() {
  const file = path.join(path.dirname(getCallerFile()), 'sampleInput.txt').replace(/file:/, "");
  return readFileSync(file).toString();
}