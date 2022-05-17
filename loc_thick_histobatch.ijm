// Dialog for selecting local-thickness images folder and downsample factor
Dialog.create("Select Options");
Dialog.addDirectory("Folder to process", "");
Dialog.show();
dir1 = Dialog.getString();
ds_fac = Dialog.getNumber();
list_dir1 = getFileList(dir1);

//get histograms for local thickness images in batch
setBatchMode(true);
for (i=0; i<list_dir1.length; i++) {
	showProgress(i+1, list_dir1.length);
	open(dir1+list_dir1[i]);
	fil_name = File.getNameWithoutExtension(getInfo("image.filename"));
	csv_name = fil_name + "local thickness histogram";
	pathtif = getInfo("image.directory") + fil_name;
	pathcsv = pathtif + " local thickness histogram" + ".txt";
	run("Set Scale...", "unit=pixel global");
	original = getImageID();
	selectImage(original);
	run("Set Measurements...", "area limit display redirect=None decimal=3");
	getMinAndMax(min, max);
	histMax = round(max);
	histMin = min;
	nBins = histMax;
	getHistogram(values, counts, nBins, histMin, histMax);
	selectImage(original);
	getDimensions(width, height, channels, slices, frames);
	hist_points = (width*height) - counts[0];
	run("Clear Results");
	row = 0;
	for (b=1; b<nBins; b++) {
		setResult("Value", row, values[b]);
      	setResult("Count", row, counts[b]);
      	row++;
	}
    updateResults();
    row = 0;
    for (c=0; c<nResults; c++) {
    	setResult("Local thickness (micron)", row, (0.3454/0.125)*values[c+1]);
    	setResult("Layer percentage", row, (counts[c+1])*(1/hist_points)*100);
    	row++;
    }
    updateResults();
    selectWindow("Results");
    save(pathcsv);
    run("Close");
	close();
}

// Done!
  showMessage("5/5", "<html>"
     +"<h1><font color=blue><i>Done!</i></h1>");