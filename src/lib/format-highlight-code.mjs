import { format } from "prettier";
import Prism from "prismjs";
import stripCdata from "./strip-cdata.mjs";

export default function (code, lang) {
  const parser = lang === "javascript" ? "babel" : lang;
  code = stripCdata(code);
  code = code
    .split("&lt;")
    .join("<")
    .split("&gt;")
    .join(">")
    .split("&amp;")
    .join("&");

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
