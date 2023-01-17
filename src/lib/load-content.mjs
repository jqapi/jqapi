import $ from "jquery";
import cleanHref from "./clean-href.mjs";
import enrichContent from "./enrich-content.mjs";

export default function (href, pushState = true) {
  href = cleanHref(href);

  $("#content").load(`${href}[ajax] #content > *`, () => {
    if (pushState) {
      window.history.pushState({}, "", href);
    }

    $("#entry-content").scrollTop(0);
    enrichContent(false);
  });
}
