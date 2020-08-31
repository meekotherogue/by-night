const fg = require("fast-glob");

module.exports = function () {
  const images = fg.sync(["./img/art/2017/*", "!**/_site"]);
  return images.map(function (file, index) {
    return {
      id: "art-2017-" + index,
      index: index,
      file: file,
    };
  });
};
