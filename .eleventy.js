const fs = require("fs");
const fg = require("fast-glob");
const imagesResponsiver = require("eleventy-plugin-images-responsiver");

const Image = require("@11ty/eleventy-img");
function eleventyImage(className, type, year, imagePath, widths) {
  var outputFormat = "jpg";
  // returns Promise
  return Image(`${imagePath}`, {
    widths: widths,
    formats: [outputFormat],
    urlPath: `img/${type}/${year}`,
    outputDir: `_site/dist/img/${type}/${year}`,
  }).then(function (props) {
    let lowestSrc = props[outputFormat][0];
    let sizes = "100vw";
    console.log(lowestSrc);

    // Iterate over formats and widths
    let sources = Object.values(props)
      .map((imageFormat) => {
        console.log(imageFormat);
        return `<source
        type="image/${imageFormat[0].format}"
        srcset="${imageFormat
          .map((entry) => `/dist/${entry.url} ${entry.width}w`)
          .join(", ")}"
        sizes="${sizes}">`;
      })
      .join("\n");

    return `<picture>
      ${sources}
        <img src="/dist/${lowestSrc.url}"
          width="${lowestSrc.width}"
          height="${lowestSrc.height}"
          alt="${imagePath}"
          class="${className}"> 
      </picture>`;
  });
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
    return eleventyImage("image-detail__image", type, year, fileName, [
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
