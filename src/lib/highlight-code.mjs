import Prism from "prismjs";
import "prism-themes/themes/prism-one-dark.css";

export default function ($code) {
  // set correct css class so the theme will work
  $code.addClass("language-custom", "");

  const trimmed = $code.text().trim();
  let language = Prism.languages.javascript;

  if (trimmed.includes("</") && !trimmed.includes("$")) {
    language = Prism.languages.html;
  }

  const highlighted = Prism.highlight(trimmed, language);

  $code.html(highlighted);
}
