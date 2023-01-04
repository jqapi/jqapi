import { readdir, writeFile } from "node:fs/promises";
import parseXML from "../src/lib/parse-xml.mjs";

async function main() {
  const entriesPath = new URL(`../api.jquery.com/entries`, import.meta.url);
  const entriesFiles = await readdir(entriesPath);
  const categories = {};

  for (let i = 0; i < entriesFiles.length; i++) {
    const fullPath = `${entriesPath}/${entriesFiles[i]}`;
    const $xml = await parseXML(fullPath.replace("file://", ""));
    const name = $xml.find("entry").attr("name");
    const categoriesArr = $xml
      .find("category")
      .map(function () {
        return this.attributes[0].value;
      })
      .get();

    for (let y = 0; y < categoriesArr.length; y++) {
      const category = categoriesArr[y];
      const mat = categories.filter((c) => c.name === category);

      console.log(mat);

      if (!categories[category]) {
        categories[category] = {
          entries: [],
        };
      }

      const matches = categories[category].entries.filter(
        (c) => c.name === name
      );

      if (!matches.length) {
        categories[category].entries.push({
          name,
          desc: $xml.find("desc").html(),
        });
      }
    }
  }

  const outPath = new URL(`../nav.json`, import.meta.url);
  await writeFile(outPath, JSON.stringify(categories, null, 2), "utf-8");

  console.log(categories);
}

main();
