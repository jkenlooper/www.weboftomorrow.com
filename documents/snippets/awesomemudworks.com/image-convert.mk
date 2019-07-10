media/gallery/test/FullSizeRender-3-2.jpg : source-media/artist/neale/gallery/FullSizeRender.jpg
	convert $< -format jpg -crop 1635x1090+411+582 +repage $@;
