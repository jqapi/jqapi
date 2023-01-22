import $ from "jquery";
import cleanHref from "./clean-href.mjs";
import enrichContent from "./enrich-content.mjs";

export default function (href, pushState = true) {
  const $content = $("#content");
  const $spinner = $("#search .spinner");
  href = cleanHref(href);

  $spinner.fadeIn(100);

  $content.load(`${href}[ajax] #content > *`, () => {
    const title = `${$("h1.title", $content).text()} - jQAPI`;

    if (pushState) {
      window.history.pushState({}, "", href);
    }

    enrichContent();
    $("#entry-content", $content).scrollTop(0);
    $("head title").text(title);
    $spinner.fadeOut(100);
  });
}
