import { format } from "prettier";
import Prism from "prismjs";
import stripCdata from "./strip-cdata.mjs";

export default function (code, lang) {
  code = stripCdata(code);
  code = code
    .split("&lt;")
    .join("<")
    .split("&gt;")
    .join(">")
    .split("&amp;")
    .join("&")
    .split("&nbsp;")
    .join(" ");

  if (!lang) {
    lang = "css";

    if (
      code.includes("$(") ||
      code.includes("$.") ||
      code.includes("jQuery") ||
      code.includes("[")
    ) {
      lang = "javascript";
    } else if (code.includes("</") || code.includes("<img")) {
      lang = "html";
    }
  }

  const parser = lang === "javascript" ? "babel" : lang;

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
