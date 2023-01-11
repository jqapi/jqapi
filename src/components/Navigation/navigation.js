import $ from "jquery";

$(() => {
  const $content = $("#content");

  window.onpopstate = (event) => {
    // on back button
    console.log(event);
  };

  $(".category").click(function () {
    $(this).next().toggle();
  });

  $(".entries a").click(function () {
    const href = $(this).attr("href");

    $content.load(`${href} #content > *`, () => {
      window.history.pushState({}, "", href);
      window.scrollTo(0, 0);
    });

    return false;
  });
});
