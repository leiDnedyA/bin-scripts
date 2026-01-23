#!/usr/bin/env node

let input = '';

process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => { input += chunk; });

process.stdin.on('end', () => {
  input = input.trim();

  try {
    // 1) Decode the outer JS/JSON string literal into a real string.
    //    Example input: "{\n  \"ok\": true\n}"
    //    After JSON.parse: "{\n  "ok": true\n}"
    const jsonText = JSON.parse(input);

    if (typeof jsonText !== 'string') {
      throw new Error('Expected a quoted string literal containing JSON.');
    }

    // 2) Parse the decoded JSON text into an object.
    const obj = JSON.parse(jsonText);

    // 3) Pretty print the object.
    process.stdout.write(JSON.stringify(obj, null, 2) + '\n');
  } catch (err) {
    console.error('Failed to decode/parse input:', err.message);

    // Helpful hint if they accidentally piped raw JSON (not quoted)
    // e.g. { "ok": true } instead of "{ \"ok\": true }"
    try {
      const obj = JSON.parse(input);
      console.error('Hint: Your stdin looks like raw JSON, not a quoted string. Pretty-printing it:');
      process.stdout.write(JSON.stringify(obj, null, 2) + '\n');
      process.exitCode = 0;
      return;
    } catch (_) {
      process.exitCode = 1;
    }
  }
});

process.stdin.resume();
