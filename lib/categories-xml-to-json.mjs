import { readdir, writeFile } from "node:fs/promises";
import parseXML from "../src/lib/parse-xml.mjs";
import $ from "../src/lib/jquery.mjs";

const APIROOT = "../api.jquery.com";
const TEST = process.env.NODE_ENV === "test";

export async function entriesToObject() {
  const entriesPath = new URL(`${APIROOT}/entries`, import.meta.url);
  const entriesFiles = await readdir(entriesPath);
  const entries = {};

  for (let i = 0; i < entriesFiles.length; i++) {
    const fullPath = `${entriesPath.pathname}/${entriesFiles[i]}`;
    const $xml = await parseXML(fullPath);
    const name = $xml.find("entry").attr("name");
    const categoriesArr = $xml
      .find("category")
      .map(function () {
        return $(this).attr("slug");
      })
      .get();

    for (let y = 0; y < categoriesArr.length; y++) {
      const category = categoriesArr[y];

      if (!entries[category]) {
        entries[category] = {
          entries: [],
        };
      }

      const matchesCount = entries[category].entries.filter(
        (entry) => entry.name === name
      ).length;

      if (!matchesCount) {
        entries[category].entries.push({
          name,
          desc: $xml.find("desc").html().trim(),
        });
      }
    }

    if (!TEST) {
      console.log("->", name);
    }
  }

  return entries;
}

function expandCategory(el, categories, slugPrefix) {
  const $el = $(el);
  const name = $el.attr("name");
  const slug = $el.attr("slug");
  const slugFull = slugPrefix ? `${slugPrefix}/${slug}` : slug;
  const entries = categories[slugFull]
    ? categories[slugFull].entries
    : undefined;

  return { name, slug, entries };
}

export async function categoriesToObject(entries) {
  const categoriesPath = new URL(`${APIROOT}/categories.xml`, import.meta.url);
  const $categories = await parseXML(categoriesPath.pathname);
  const categories = $categories
    .find("categories > category")
    .map(function () {
      const catObj = expandCategory(this, entries);
      const categories = $(this)
        .children("category")
        .map(function () {
          return expandCategory(this, entries, catObj.slug);
        })
        .get();

      return { ...catObj, categories };
    })
    .get();

  return categories;
}

async function main() {
  const entries = await entriesToObject();
  const categories = await categoriesToObject(entries);
  const outPath = new URL(`../categories-generated.json`, import.meta.url);
  const categoriesJSON = JSON.stringify(categories, null, 2);

  await writeFile(outPath, categoriesJSON, "utf-8");
  console.log("Done.");
}

if (!TEST) {
  main().catch((err) => {
    console.error(err);
  });
}
