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
    const path = entriesFiles[i].replace(".xml", "");
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
          path,
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
      let categories = $(this)
        .children("category")
        .map(function () {
          return expandCategory(this, entries, catObj.slug);
        })
        .get();

      if (categories.length === 0) {
        categories = undefined;
      }

      return { ...catObj, categories };
    })
    .get();

  return categories;
}

export function fixCategories(categories) {
  // some categories have sub-categories and single entries
  // instead of having this edge case for the keyboard navigation,
  // put these single entries in the "Other" sub-category
  // the "Uncategorized" category doesn't have any subs or entries, so remove it
  // remove the "Version" category to make the output a lot smaller
  // also remove some other glitches

  return categories
    .map((category) => {
      if (category.categories && category.entries) {
        category.categories.push({
          name: "Other",
          slug: "other",
          entries: category.entries,
        });

        delete category.entries;

        if (!TEST) {
          console.log("fixed ->", category.name);
        }
      }

      if (["Deprecated", "Manipulation", "Version"].includes(category.name)) {
        category.categories = category.categories.filter((category) => {
          return !["Deprecated 1.4", "DOM Insertion", "All"].includes(
            category.name
          );
        });

        if (!TEST) {
          console.log(
            "fixed -> Deprecated/Deprecated 1.4, Version/All, Manipulation/DOM Insertion"
          );
        }
      }

      return category;
    })
    .filter((category) => {
      if (category.name === "Uncategorized") {
        if (!TEST) {
          console.log("fixed -> Removed 'Uncategorized' category");
        }

        return false;
      }

      if (category.name === "Version") {
        if (!TEST) {
          console.log("fixed -> Removed 'Version' category");
        }

        return false;
      }

      return true;
    });
}

async function main() {
  const entries = await entriesToObject();
  const categories = await categoriesToObject(entries);
  const categoriesFixed = fixCategories(categories);
  const outPath = new URL(`../categories-generated.json`, import.meta.url);
  const categoriesJSON = JSON.stringify(categoriesFixed, null, 2);

  await writeFile(outPath, categoriesJSON, "utf-8");
  console.log("Done.");
}

if (!TEST) {
  main().catch((err) => {
    console.error(err);
  });
}
