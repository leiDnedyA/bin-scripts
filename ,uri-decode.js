#!/usr/bin/env node

const { execSync } = require("child_process");

function getInput() {
  // If something is passed via argv, use it
  if (process.argv.length > 2) {
    // Join in case the input contains spaces
    return process.argv.slice(2).join(" ");
  }

  // Otherwise, try to read from clipboard via xclip
  try {
    return execSync("xclip -selection clipboard -o", {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch (err) {
    console.error("Error: No argv provided and failed to read clipboard via xclip.");
    process.exit(1);
  }
}

function main() {
  const input = getInput();

  if (!input) {
    console.error("Error: Input is empty.");
    process.exit(1);
  }

  try {
    const decoded = decodeURIComponent(input);
    process.stdout.write(decoded);
  } catch (err) {
    console.error("Error: Failed to decode URI component.");
    console.error(err.message);
    process.exit(1);
  }
}

main();
