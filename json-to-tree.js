#!/usr/bin/env node
// json-to-tree.js
// Usage: node json-to-tree.js input.json output-dir

const fs = require("fs");
const path = require("path");

const [,, inputFile, outputDir] = process.argv;

if (!inputFile || !outputDir) {
  console.error("Usage: node json-to-tree.js input.json output-dir");
  process.exit(1);
}

const data = JSON.parse(fs.readFileSync(inputFile, "utf8"));

function safeName(name) {
  return String(name).replace(/[<>:"/\\|?*\x00-\x1F]/g, "_");
}

function writeNode(node, targetPath) {
  if (Array.isArray(node)) {
    fs.mkdirSync(targetPath, { recursive: true });

    node.forEach((child, index) => {
      writeNode(child, path.join(targetPath, safeName(index)));
    });

    return;
  }

  if (node !== null && typeof node === "object") {
    fs.mkdirSync(targetPath, { recursive: true });

    for (const [key, value] of Object.entries(node)) {
      writeNode(value, path.join(targetPath, safeName(key)));
    }

    return;
  }

  fs.mkdirSync(path.dirname(targetPath), { recursive: true });
  fs.writeFileSync(targetPath, String(node ?? ""), "utf8");
}

writeNode(data, outputDir);

console.log(`Wrote JSON tree to ${outputDir}`);
