import $ from "jquery";

$(() => {
  const $content = $("#content");

  window.onpopstate = (event) => {
    // on back button
    console.log(event);
  };

  $(".category").click(function () {
    $(this).toggleClass("active").next().toggle();
  });
});
