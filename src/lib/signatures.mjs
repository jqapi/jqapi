export function getReturnType($entry) {
  let returnType = $entry.attr("return");

  if ($entry.attr("type") === "selector") {
    return "Selector";
  }

  return returnType;
}

export function getReturnTypeHtml($entry, expandArguments = true) {
  const entryName = $entry.attr("name");
  const isSelector = $entry.attr("type") === "selector";
  const prefix = isSelector ? ":" : ".";
  const name = entryName.includes("jQuery.")
    ? entryName
    : `${prefix}${entryName}`;
  const returnType = getReturnType($entry);
  const returnHtml = isSelector
    ? ""
    : ` <span class="return">&#129122; ${returnType}</span>`;
  let args = isSelector ? "" : `()`;

  if (expandArguments) {
    args = "todo";
  }

  return `${name}${args}${returnHtml}`;
}
