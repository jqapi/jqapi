import $ from "jquery";
import cleanHref from "./clean-href.mjs";
import enrichContent from "./enrich-content.mjs";

export default function (href, pushState = true) {
  const $content = $("#content");
  href = cleanHref(href);

  $content.load(`${href}[ajax] #content > *`, () => {
    const title = `${$("h1.title", $content).text()} - jQAPI`;

    if (pushState) {
      window.history.pushState({}, "", href);
    }

    $("#entry-content", $content).scrollTop(0);
    enrichContent(false);
    $("head title").text(title);
  });
}
