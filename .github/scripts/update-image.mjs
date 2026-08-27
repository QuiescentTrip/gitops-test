import fs from "node:fs";

const [image, tag] = process.argv.slice(2);

if (!image || !tag) {
  console.error("Usage: node .github/scripts/update-image.mjs IMAGE TAG");
  process.exit(1);
}

const file = "environments/dev/kustomization.yaml";
const input = fs.readFileSync(file, "utf8");
const output = input.replace(
  /(- name: hopeful-api\n\s+newName: ).*(\n\s+newTag: ).*/m,
  `$1${image}$2${tag}`
);

if (input === output) {
  console.error(`Did not find hopeful-api image block in ${file}`);
  process.exit(1);
}

fs.writeFileSync(file, output);
