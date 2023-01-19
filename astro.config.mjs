import { defineConfig } from "astro/config";
import purgecss from "astro-purgecss";
import minifyHtml from "astro-html-minifier";

// https://astro.build/config
export default defineConfig({
  integrations: [
    purgecss({
      safelist: [
        "html",
        "body",
        "selected",
        "active",
        "notfound",
        "type",
        "return",
      ],
    }),
    minifyHtml(),
  ],
});
