// For use with the Nocodeseg pipeline (Pettersen et al, 2022). 
// This macro identifies tiles with > 5% of a particular class and 
// duplicates them to resolve class imbalance; it first duplicates the tiles and then the 
// corresponding TIF images

//part 1: duplicate PNG labels and create a list of corresponding TIFs

Dialog.create("Select Options");
Dialog.addDirectory("Labels folder", "");
Dialog.show();
dir1 = Dialog.getString();
list_dir1 = getFileList(dir1);
setBatchMode(true);
for (i=0; i<list_dir1.length; i++) {
showProgress(i+1, list_dir1.length);
open(dir1+list_dir1[i]);
	setThreshold(2, 2); //select the class requiring balancing
	threshold = 1.5; // threshold = (class minus 1) + 0.5
	w = getWidth();
	h = getHeight();
	count = 0;
	for (x = 0; x < w; x++) {
		for(y = 0; y < h; y++) {
			v = getPixel(x, y);
			if (v > threshold)
			count++;
	}
	}
	if (count/(w*h) > 0.05) { //i.e. if image has >5% of the class
		labels_dir = getInfo("image.directory");
		path_list = getInfo("image.directory") + getInfo("image.filename");
		path = getInfo("image.directory") + getInfo("image.filename") + "copy";
		run("Duplicate...", " ");
		saveAs("png", path);
		close("*");
		print(File.getNameWithoutExtension(path_list) + ".tif");
	} else {
		close();
	}
}

//part 2: duplicate corresponding TIFs

Dialog.create("Select Options");
Dialog.addDirectory("Images folder", "");
Dialog.show();
img_dir = Dialog.getString();
img_list = img_dir + "list.txt";
selectWindow("Log");
saveAs("Text", img_list);
selectWindow("Log");
contents = getInfo();
close("Log");
if (indexOf(contents, "Title: ")>=0)
        exit("Log file should list atleast one TIF file");
    list = split(contents, "\n");
    for (i=0; i<list.length; i++) {
    	open(list[i]);
    	pathtif = img_dir + getInfo("image.filename") + "copy";
    	run("Duplicate...", " ");
		saveAs("tif", pathtif);
		close("*");
    }
    
Dialog.create("");
Dialog.addMessage("Script has completed running")
Dialog.show();