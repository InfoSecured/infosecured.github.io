# Example script to generate HTML and push to local gh-pages directory.

#build site from markdown
jekyll build

# remove old files
rm -R ../infosecured.github.io/about/*

# re-add new
cp _site/index.html ../infosecured.github.io/about/.
cp -R _site/media ../infosecured.github.io/about/.
