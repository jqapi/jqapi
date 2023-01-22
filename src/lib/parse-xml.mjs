import { readFile } from "node:fs/promises";
import $ from "./jquery.mjs";
import getFullPath from "../lib/get-full-path.mjs";

export default async function parseXML(xmlPath) {
  const xml = await readFile(xmlPath, "utf-8");
  const xmlDoc = $.parseXML(xml);
  const $xml = $(xmlDoc);
  const $includes = $xml.find("xi\\:include");

  for (let i = 0; i < $includes.length; i++) {
    const $include = $($includes[i]);
    const href = $include.attr("href");
    const incPath = getFullPath(`api.jquery.com/includes/${href}`);
    const incXML = await readFile(incPath, "utf-8");
    const incDoc = $.parseXML(incXML);
    const $argument = $(incDoc).find("> argument");

    $include.replaceWith($argument);
  }

  return $xml;
}
