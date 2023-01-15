const Image = require("@11ty/eleventy-img");

function eleventyImage(className, type, year, imagePath, widths) {
  let outputFormat = "jpeg";
  return Image(`${imagePath}`, {
    widths: widths,
    formats: [outputFormat],
    urlPath: `img/${type}/${year}`,
    outputDir: `_site/dist/img/${type}/${year}`,
  }).then(function (props) {
    let lowestSrc = props[outputFormat][0];

    // Iterate over formats and widths
    let sources = `<source
      type="image/${lowestSrc.format}"
      srcset="${Object.values(props).map((imageFormat) => {
        return imageFormat
          .map((image) => {
            return `/dist/${image.url} ${image.width}w`;
          })
          .join(", ");
      })}"
      sizes="100vw">`;

    return `<picture>
      ${sources}
        <img src="/dist/${lowestSrc.url}"
          alt="${lowestSrc.url}"
          class="${className}">
      </picture>`;
  });
}

module.exports = function (eleventyConfig) {
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

  eleventyConfig.addLiquidShortcode("assets", function (imagePath, className) {
    let outputFormat = "jpeg";
    return Image(`img/assets/${imagePath}.${outputFormat}`, {
      widths: [300],
      formats: [outputFormat],
      urlPath: `img/assets`,
      outputDir: `_site/dist/img/assets`,
    }).then(function (props) {
      let lowestSrc = props[outputFormat][0];

      // Iterate over formats and widths
      let sources = `<source
        type="image/${lowestSrc.format}"
        srcset="${Object.values(props).map((imageFormat) => {
          return imageFormat
            .map((image) => {
              return `/dist/${image.url} ${image.width}w`;
            })
            .join(", ");
        })}"
        sizes="100vw">`;

      return `<picture>
        ${sources}
          <img src="/dist/${lowestSrc.url}"
            alt="${lowestSrc.url}"
            class="${className}">
        </picture>`;
    });
  });

  // Eleventy Options
  eleventyConfig.setLiquidOptions({
    dynamicPartials: false,
    strictFilters: false,
    root: ["_includes"],
  });

  // Passthrough Copy
  eleventyConfig.addPassthroughCopy("css");
  return {
    passthroughFileCopy: true,
  };
};
