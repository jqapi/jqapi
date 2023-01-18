import $ from "jquery";
import loadContent from "./load-content.mjs";

export default function () {
  const $content = $("#entry-content");

  $('a[href^="/"]', $content).click(function () {
    const href = $(this).attr("href");

    loadContent(href);
    return false;
  });
}
