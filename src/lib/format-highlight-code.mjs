import { format } from "prettier";
import Prism from "prismjs";
import stripCdata from "./strip-cdata.mjs";

export default function (code, lang) {
  const parser = lang === "javascript" ? "babel" : lang;
  code = stripCdata(code);

  try {
    code = format(code, { parser });
  } catch (error) {
    console.error("Malformed Code");
  }

  try {
    code = Prism.highlight(code, Prism.languages[lang], lang);
  } catch (error) {}

  return code;
}
