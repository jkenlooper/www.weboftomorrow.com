# Non-clever Makefile

.PHONY : all clean

small_pngs = source-media/favicon/.favicon-32x32.png source-media/favicon/.favicon-48x48.png source-media/favicon/.favicon-64x46.png

objects = $(shell cat source-media/favicon/_favicon.manifest) $(small_pngs)

all : $(objects)

clean :
	echo $(objects) | xargs rm -f

source-media/favicon/.favicon-32x32.png : media/WoT.svg
	convert +antialias $< -background white -resize 32x32 $@;

source-media/favicon/.favicon-48x48.png : media/WoT.svg
	convert +antialias $< -background white -resize 48x48 $@;

source-media/favicon/.favicon-64x46.png : media/WoT.svg
	convert +antialias $< -background white -resize 64x46 $@;

root/favicon.ico : source-media/favicon/WoT-16x16.png $(small_pngs)
	convert $^ $@;
