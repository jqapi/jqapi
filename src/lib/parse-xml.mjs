import { readFile } from "node:fs/promises";
import $ from "./jquery.mjs";

export default async function parseXML(xmlPath) {
  const xml = await readFile(xmlPath, "utf-8");
  const xmlDoc = $.parseXML(xml);

  return $(xmlDoc);
}
