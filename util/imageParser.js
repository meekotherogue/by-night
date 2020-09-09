module.exports = function (type, year) {
  const images = require(`../_data/${type}Meta${year}.json`);
  return images.map(function (image, index) {
    return {
      type: type,
      year: year,
      index: index,
      file: image.file,
      name: image.name,
      description: image.description,
    };
  });
};
