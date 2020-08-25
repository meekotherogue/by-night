const fs = require("fs");
const fg = require("fast-glob");

const art2017 = fg.sync(["./img/art/2017/*", "!**/_site"]);
const art2018 = fg.sync(["./img/art/2018/*", "!**/_site"]);

module.exports = function (eleventyConfig) {
  eleventyConfig.addCollection("art2017", function (collection) {
    return art2017;
  });
  eleventyConfig.addCollection("art2018", function (collection) {
    return art2018;
  });
};
