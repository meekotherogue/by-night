const fs = require("fs");
const fg = require("fast-glob");
// const ampPlugin = require("@ampproject/eleventy-plugin-amp");

const art2017 = fg.sync(["./img/art/2017/*", "!**/_site"]);
const art2018 = fg.sync(["./img/art/2018/*", "!**/_site"]);

module.exports = function (eleventyConfig) {
  // Plugins
  // eleventyConfig.addPlugin(ampPlugin);

  // Passthrough Copy
  eleventyConfig.addPassthroughCopy("css");
  return {
    passthroughFileCopy: true,
  };
};
