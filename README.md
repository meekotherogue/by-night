# By Night

A small image gallery site to display my artwork

## Getting started

- Requires node version v12.16.0
- Install dependencies: `npm install`
- Run server: `npm run-script serve`
- Build project: `npm run-script build`

## Adding photos

This is an 11ty statically generated site. It's pages are generated based on photo metadata that correlates to the type of artwork and year that it's from.

To add more photos at the top level:
- Create new directory in `img`
    - This will represent the new section of art, i.e. drawings, commissions, etc.
    - Example: `mkdir img/commissions`
- Create subdirectories in this new directory to represent each year there is art for
    - Example: `mkdir img/commissions/2022`
    - You can have mulitple years per section
- Copy images you want to upload into this new directory

### Optimizing images

I have a lot of art! So I've got a script to optimise the images to reduce overhead. Might not be totally necessary in all cases, use your discretion. I have set up with an API key from [Tiny PNG](https://tinypng.com/developers) to do this optimisation

To optimize images for the example directory above, you would run:
```
sh ./scripts/optimize_images.bash ./img/commissions/2022/
```

### Generating metadata

As mentined this is a data-driven website. You need to generate some JSON metadata so the site knows how to find the images and generate the proper pages.

Once your images are ready and in the correct directory, you can run the `generate_meta_json` script:
```
sh ./scripts/generate_meta_json.bash <new images path> <description> <year> <out json file>
```
For example:
```
sh ./scripts/generate_meta_json.bash ./img/commissions/2022/ "Commissioned art from 2022" 2022 ./_data/commissionsMeta2022.json
```

The result will have to go into the `_data` directory, and right now the "Meta" in the file name is needed due to some hardcoding I should probably fix. But technically you can output the file anywhere, so long as you move it to `_data` and rename it to the structure `<section>Meta<year>.json`

### Add templates

Now that you have your metadata, you can add the markdown files to render each new page from for this new section:
- Add respective parsing script into `_data`
    - This is a simple script that tells eleventy what data it should read for a specific template
    - For our commissions example above, create file `_data/commissions2022.js`:
```
const imageParser = require("../util/imageParser");

module.exports = function () {
  return imageParser("commissions", "2022");
};
```
  - This will set up this metadata you generated into a `commissions2022` variable that we can use, shown below
- Add new directory for new section to hold the markdown
  - Our section is `commissions`, and these go in the top-level directory, so this is simply `mkdir commissions`
- Create base markdown file for section `touch commissions/commissions.md`
- Add year directory(ies) for the section, `mkdir commissions/2022`
- Create gallery and image detail markdowns for each year
  - `touch commissions/2022/image-detail.md`
  - `touch commissions/2022/gallery.md`

You should be able to copy/paste existing markdowns and update with relevant information.

### Important notes
- Set up your `gallery.md` to have the Front Matter contain `layout: commissions/gallery2022.liquid`, so that it points to the right gallery template
- Set up your `image-detail.md` to have `data: commissions2022` under the `pagination` so that it pulls the right data for pagination

### Adding template

Finally now you can add the gallery template!
- `_includes/commissions/gallery2022.liquid`
- Copy existing template over into this file

### Important notes
- The line `{% assign images = ??? %}` is where the data gets set into the `images` variable that's used by the generic `gallery.liquid` template. This needs to be set up to align with the metadata we parsed into the variable described above
- For example: `{% assign images = commissions2022 %}`
