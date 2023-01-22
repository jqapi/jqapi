export default function ($toScroll, $next) {
  $toScroll.scrollTop(0);

  const offset = 81; // search box height and spacing to see previous entry
  const scrollTop =
    $next.length === 0 ? 0 : Math.floor($next.offset().top) - offset;

  $toScroll.scrollTop(scrollTop);
}
