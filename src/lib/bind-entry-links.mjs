import $ from "jquery";
import loadContent from "./load-content.mjs";

export default function ($parent) {
  $("a", $parent).click(function () {
    const $a = $(this);
    const href = $a.attr("href");

    $(".entries li.active").removeClass("active");
    $(".selected", $parent).removeClass("selected");
    $a.parent().addClass("active selected");
    loadContent(href);

    return false;
  });
}
