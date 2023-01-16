import $ from "jquery";

export default function (href, pushState = true) {
  $("#content").load(`${href}[ajax] #content > *`, () => {
    if (pushState) {
      window.history.pushState({}, "", href);
    }

    window.scrollTo(0, 0);
  });
}
