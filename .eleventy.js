const Image = require("@11ty/eleventy-img");
const eleventyNavigationPlugin = require("@11ty/eleventy-navigation");

function eleventyImage(className, path, imagePath, widths) {
  let outputFormat = "jpeg";
  return Image(`${imagePath}`, {
    widths: widths,
    formats: [outputFormat],
    urlPath: `img/${path}`,
    outputDir: `_site/dist/img/${path}`,
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
  // Shortcodes
  eleventyConfig.addLiquidShortcode("galleryThumbnailImage", function (
    type,
    year,
    imagePath
  ) {
    return eleventyImage(
      "gallery__thumbnailimage",
      `${type}/${year}`,
      imagePath,
      [300]
    );
  });

  eleventyConfig.addLiquidShortcode("imageDetail", function (
    type,
    year,
    imagePath
  ) {
    return eleventyImage("image-detail__image", `${type}/${year}`, imagePath, [
      null,
      1280,
      1040,
      800,
    ]);
  });

  eleventyConfig.addLiquidShortcode("assets", function (imageName, className) {
    return eleventyImage(
      className,
      "assets",
      `./img/assets/${imageName}.jpeg`,
      [300]
    );
  });

  // Navigation
  eleventyConfig.addPlugin(eleventyNavigationPlugin);

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
