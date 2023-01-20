import { describe, it, expect } from "vitest";
import {
  entriesToObject,
  categoriesToObject,
  fixCategories,
} from "./categories-xml-to-json.mjs";

describe("Categories XML to JSON convertion", () => {
  let entries;
  let categories;

  it("should find and expand all entries", async () => {
    entries = await entriesToObject();

    expect(entries).toMatchSnapshot();
  });

  it("should find and expand all categories", async () => {
    categories = await categoriesToObject(entries);

    expect(categories).toMatchSnapshot();
  });

  it("should fix various categories", () => {
    const fixedCategories = fixCategories(categories);

    expect(fixedCategories).toMatchSnapshot();
  });
});
