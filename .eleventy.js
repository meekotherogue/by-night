const fs = require("fs");
const fg = require("fast-glob");
const imagesResponsiver = require("eleventy-plugin-images-responsiver");

module.exports = function (eleventyConfig) {
  // Plugins
  eleventyConfig.addPlugin(imagesResponsiver);

  // Passthrough Copy
  eleventyConfig.addPassthroughCopy("css");
  return {
    passthroughFileCopy: true,
  };
};
