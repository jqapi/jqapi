import { readdir, writeFile } from "node:fs/promises";
import parseXML from "../src/lib/parse-xml.mjs";
import $ from "../src/lib/jquery.mjs";

function expandCategory(el, categories, slugPrefix) {
  const $el = $(el);
  const name = $el.attr("name");
  const slug = $el.attr("slug");
  const slugFull = slugPrefix ? `${slugPrefix}/${slug}` : slug;
  const entries = categories[slugFull] ? categories[slugFull].entries : [];

  return { name, slug, entries };
}

async function main() {
  const entriesPath = new URL(`../api.jquery.com/entries`, import.meta.url);
  const entriesFiles = await readdir(entriesPath);
  const categories = {};

  for (let i = 0; i < entriesFiles.length; i++) {
    const fullPath = `${entriesPath.pathname}/${entriesFiles[i]}`;
    const $xml = await parseXML(fullPath);
    const name = $xml.find("entry").attr("name");
    const categoriesArr = $xml
      .find("category")
      .map(function () {
        return this.attributes[0].value;
      })
      .get();

    for (let y = 0; y < categoriesArr.length; y++) {
      const category = categoriesArr[y];

      if (!categories[category]) {
        categories[category] = {
          entries: [],
        };
      }

      const matchesCount = categories[category].entries.filter(
        (entry) => entry.name === name
      ).length;

      if (!matchesCount) {
        categories[category].entries.push({
          name,
          desc: $xml.find("desc").html().trim(),
        });
      }
    }

    console.log(name);
  }

  const categoriesPath = new URL(
    `../api.jquery.com/categories.xml`,
    import.meta.url
  );
  const $categories = await parseXML(categoriesPath.pathname);
  const categoriesObj = $categories
    .find("categories > category")
    .map(function () {
      const catObj = expandCategory(this, categories);
      const subCats = $(this)
        .children("category")
        .map(function () {
          return expandCategory(this, categories, catObj.slug);
        })
        .get();

      return { ...catObj, categories: subCats };
    })
    .get();

  const outPath = new URL(`../categories-generated.json`, import.meta.url);
  const categoriesJSON = JSON.stringify(categoriesObj, null, 2);

  await writeFile(outPath, categoriesJSON, "utf-8");
  console.log("Done.");
}

main();
