const fg = require("fast-glob");

module.exports = function (type, year) {
  const images = fg.sync([`./img/${type}/${year}/*`, "!**/_site"]);
  return images.map(function (file, index) {
    return {
      type: type,
      year: year,
      index: index,
      file: file,
    };
  });
};
