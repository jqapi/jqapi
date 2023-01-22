export default function (href) {
  if (href.charAt(href.length - 1) === "/") {
    href = href.substr(0, href.length - 1);
  }

  return href;
}
