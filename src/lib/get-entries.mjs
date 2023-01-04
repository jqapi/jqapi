import { readdir } from "node:fs/promises";
import getFullPath from "./get-full-path.mjs";
import parseXML from "./parse-xml.mjs";

export default async function getEntries(
  entriesPath = "api.jquery.com/entries"
) {
  const entriesFullPath = getFullPath(entriesPath);
  const entriesFiles = await readdir(entriesFullPath);

  const entriesPromises = entriesFiles.map(async (entryFile) => {
    const path = getFullPath(`${entriesPath}/${entryFile}`);
    const name = entryFile.replace(".xml", "");
    const $xml = await parseXML(path);
    const categories = $xml
      .find("category")
      .map(function () {
        const slug = this.attributes[0].value;
        return slug;
      })
      .get();

    const entries = await Promise.all(entriesPromises);

    return { path, name, categories };
  });

  return entriesObj;
}
