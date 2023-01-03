import { readdir } from "node:fs/promises";
import getFullPath from "./get-full-path.mjs";

export default async function getEntries(
  entriesPath = "api.jquery.com/entries"
) {
  const entriesFullPath = getFullPath(entriesPath);
  const entriesFiles = await readdir(entriesFullPath);
  const entriesObj = entriesFiles.map((entryFile) => {
    const path = getFullPath(`${entriesPath}/${entryFile}`);
    const name = entryFile.replace(".xml", "");

    return { path, name };
  });

  return entriesObj;
}
