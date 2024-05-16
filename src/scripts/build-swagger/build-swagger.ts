import fs from 'fs';
import path from 'path';
import yaml from 'js-yaml';

function readYamlFile(filePath: string) {
  try {
    const fileContents = fs.readFileSync(filePath, 'utf8');
    return yaml.load(fileContents);
  } catch (err) {
    // tslint:disable-next-line:no-console
    console.error(`Error reading YAML file ${filePath}: ${err}`);
    process.exit(1);
  }
}

function findYamlFiles(dir: string) {
  let results: string[] = [];
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      results = results.concat(findYamlFiles(filePath));
    } else if (filePath.includes('swagger.yaml')) {
      results.push(filePath);
    }
  }
  return results;
}

function mergeYamlFiles(filePaths: string[]) {
  const merged: { [key: string]: any } = {};
  for (const filePath of filePaths) {
    const content = readYamlFile(filePath);
    Object.keys(content).forEach((k) => {
      if (!Array.isArray(content[k]) && typeof content[k] === 'object' && typeof content[k] !== 'string') {
        merged[k] = { ...merged[k], ...content[k] };
      } else if (Array.isArray(content[k])) {
        if (merged[k]) {
          merged[k] = Array.from(new Set([...merged[k], ...content[k]]));
        } else {
          merged[k] = [...content[k]];
        }
      } else {
        merged[k] = content[k];
      }
    });
  }
  return merged;
}

function buildSwagger() {
  const srcDir = path.join(process.cwd(), 'src');
  const yamlFiles = findYamlFiles(srcDir);
  const mergedYaml = mergeYamlFiles(yamlFiles);
  const outputFilePath = path.join(process.cwd(), 'swagger/swagger.yaml');
  fs.writeFileSync(outputFilePath, yaml.dump(mergedYaml));

  const jsonPath = path.join(process.cwd(), 'swagger/swagger.json');
  fs.writeFileSync(jsonPath, JSON.stringify(mergedYaml));
}

(async () => {
  await buildSwagger();
})();
