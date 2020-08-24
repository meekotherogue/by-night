const fs = require("fs");
const fg = require('fast-glob');

const imgs = fg.sync(['**/img/*', '!**/_site']);

module.exports = (function(eleventyConfig) {
  eleventyConfig.addCollection('imgs', function(collection) {
    return imgs;
  });
});