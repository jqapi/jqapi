import $ from "./jquery.mjs";
import formatHighlightCode from "./format-highlight-code.mjs";

export default function (content) {
  const $content = $(`<div>${content}</div>`);

  $content.find("pre code").each(function () {
    const $code = $(this);
    const code = $code.html();
    const formatted = formatHighlightCode(code);

    $code.html(formatted);
    $code.parent().addClass(`language-custom`);
  });

  return $content.html();
}
