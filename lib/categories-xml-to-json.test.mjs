import { describe, it, expect } from "vitest";
import {
  entriesToObject,
  categoriesToObject,
} from "./categories-xml-to-json.mjs";

describe("Categories XML to JSON convertion", () => {
  let entries;

  it("should find and expand all entries", async () => {
    entries = await entriesToObject();

    expect(entries).toMatchSnapshot();
  });

  it("should find and expand all categories", async () => {
    const categories = await categoriesToObject(entries);

    expect(categories).toMatchSnapshot();
  });
});
