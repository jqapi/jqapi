import $ from "jquery";
import cleanHref from "./clean-href.mjs";

export default function (href, pushState = true) {
  href = cleanHref(href);

  $("#content").load(`${href}[ajax] #content > *`, () => {
    if (pushState) {
      window.history.pushState({}, "", href);
    }

    window.scrollTo(0, 0);
  });
}
