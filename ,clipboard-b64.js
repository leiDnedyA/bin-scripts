#!/usr/bin/env node

// clipboard-decode.js
// Reads clipboard via xclip, assumes it's base64, decodes, and prints.

const { execSync } = require("child_process");

try {
  // Get clipboard contents using xclip
  const clipboard = execSync("xclip -selection clipboard -o", {
    encoding: "utf8",
  }).trim();

  if (!clipboard) {
    console.error("Clipboard is empty.");
    process.exit(1);
  }

  // Decode from base64
  let decoded;
  try {
    decoded = Buffer.from(clipboard, "base64").toString("utf8");
  } catch (e) {
    console.error("Failed to decode clipboard contents as base64.");
    process.exit(1);
  }

  console.log(decoded);
} catch (err) {
  console.error("Error reading clipboard with xclip. Is xclip installed?");
  console.error(err.message);
  process.exit(1);
}

