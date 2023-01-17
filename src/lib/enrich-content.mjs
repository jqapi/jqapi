import $ from "jquery";
import highlightCode from "../lib/highlight-code.mjs";
import loadContent from "./load-content.mjs";

export default function (animateCode = true) {
  const $content = $("#entry-content");
  const $codes = $("pre code", $content);

  $codes.each(function () {
    const $code = $(this);

    highlightCode($code);

    if (animateCode) {
      $code.parent().slideDown(200);
    } else {
      $code.parent().show();
    }
  });

  $('a[href^="/"]', $content).click(function () {
    const href = $(this).attr("href");

    loadContent(href);
    return false;
  });
}
