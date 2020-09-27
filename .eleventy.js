const fs = require("fs");
const fg = require("fast-glob");
const imagesResponsiver = require("eleventy-plugin-images-responsiver");

const Image = require("@11ty/eleventy-img");
function eleventyImage(className, type, year, fileName, widths) {
  var outputFormat = "jpg";
  // returns Promise
  var stats = Image(`${fileName}`, {
    widths: widths,
    formats: [outputFormat],
    urlPath: `img/${type}/${year}`,
    outputDir: `_site/dist/img/${type}/${year}`,
  });
  let props = stats[outputFormat].pop();

  return `<img src="${props.url}"
          width="${props.width}"
          height="${props.height}"
          alt="${fileName}"
          class="${className}">`;
}

module.exports = function (eleventyConfig) {
  // Plugins
  // eleventyConfig.addPlugin(imagesResponsiver);

  // Javascript
  eleventyConfig.addLiquidShortcode("galleryThumbnailImage", function (
    type,
    year,
    fileName
  ) {
    return eleventyImage("gallery__thumbnailimage", type, year, fileName, [
      300,
    ]);
  });

  eleventyConfig.addLiquidShortcode("imageDetail", function (
    type,
    year,
    fileName
  ) {
    return eleventyImage("detail__image", type, year, fileName, [
      null,
      1280,
      1040,
      800,
    ]);
  });

  // Passthrough Copy
  eleventyConfig.addPassthroughCopy("css");
  return {
    passthroughFileCopy: true,
  };
};
