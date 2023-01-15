import $ from "jquery";

export default function ($parent) {
  $("a", $parent).click(function () {
    const $a = $(this);
    const href = $a.attr("href");

    $(".entries li.active").removeClass("active");
    $(".selected", $parent).removeClass("selected");
    $a.parent().addClass("active selected");

    $("#content").load(`${href} #content > *`, () => {
      window.history.pushState({}, "", href);
      window.scrollTo(0, 0);
    });

    return false;
  });
}
