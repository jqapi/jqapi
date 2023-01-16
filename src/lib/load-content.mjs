import $ from "jquery";

export default function (href, pushState = true) {
  if (href.charAt(href.length - 1) === "/") {
    href = href.substr(0, href.length - 1);
  }

  $("#content").load(`${href}[ajax] #content > *`, () => {
    if (pushState) {
      window.history.pushState({}, "", href);
    }

    window.scrollTo(0, 0);
  });
}
