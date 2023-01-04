import { readFile } from "node:fs/promises";
import jsdom from "jsdom";
import jQuery from "jquery";

export default async function parseXML(xmlPath) {
  const window = new jsdom.JSDOM().window;
  const $ = jQuery(window);
  const xml = await readFile(xmlPath, "utf-8");
  const xmlDoc = $.parseXML(xml);

  return $(xmlDoc);
}
// leute in docus diedinge zwar beschreiben aber nicht so dolle rübergeben, enriched with ai
