export default function getFullPath(subPath = "") {
  // in DEV mode we need to go up two directories to get to the root folder of the project
  const rootPath = import.meta.env.DEV ? "../.." : "..";

  // import.meta.url is the file:// URL of the current file
  return new URL(`${rootPath}/${subPath}`, import.meta.url);
}
