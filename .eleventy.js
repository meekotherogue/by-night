const fs = require("fs");
const fg = require("fast-glob");
// const ampPlugin = require("@ampproject/eleventy-plugin-amp");

const art2017 = fg.sync(["./img/art/2017/*", "!**/_site"]);
const art2018 = fg.sync(["./img/art/2018/*", "!**/_site"]);

module.exports = function (eleventyConfig) {
  // Plugins
  // eleventyConfig.addPlugin(ampPlugin);

  // Collections
  eleventyConfig.addCollection("art2017", function (collection) {
    return art2017.map(function (file, index) {
      return {
        id: "art-2017-" + index,
        index: index,
        file: file,
      };
    });
  });
  eleventyConfig.addCollection("art2018", function (collection) {
    return art2018.map(function (file, index) {
      return {
        id: "art-2018-" + index,
        index: index,
        file: file,
      };
    });
  });

  // Passthrough Copy
  eleventyConfig.addPassthroughCopy("css");
  return {
    passthroughFileCopy: true,
  };
};
