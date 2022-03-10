// To run local thickness measurements (https://www.optinav.info/LocalThicknessEd.pdf)
// on 2D files with multiple labels, each corresponding to a particular
// segmentation class.
// Takes a while to run since local thickness measurements can be intensive 

close("*");
run("Clear Results");

// Dialog for mapping class label value
// --Modify below based on number of classes and description--
Dialog.create("Map pixel value to class label");
Dialog.addString("class with pixel value = 0", "background");
Dialog.addString("class with pixel value = 1", "EGL");
Dialog.addString("class with pixel value = 2", "ML");
Dialog.addString("class with pixel value = 3", "IGL");
Dialog.addString("class with pixel value = 4", "WM");
Dialog.show();
c0 = Dialog.getString();
c1 = Dialog.getString();;
c2 = Dialog.getString();;;
c3 = Dialog.getString();;;;
c4 = Dialog.getString();;;;;
a1 = newArray(c0, c1, c2, c3, c4);
//--Modify above based on number of classes and description--

// Dialog for selecting label-images folder and downsample factor
Dialog.create("Select Options");
Dialog.addDirectory("Folder to process", "");
Dialog.addNumber("Downsample", 4);
Dialog.show();
dir1 = Dialog.getString();
ds_fac = Dialog.getNumber();
list_dir1 = getFileList(dir1);

//batch process all files in selected folder
setBatchMode(true);
for (i=0; i<list_dir1.length; i++) {
	showProgress(i+1, list_dir1.length);
	open(dir1+list_dir1[i]);
	fil_name = File.getNameWithoutExtension(getInfo("image.filename"));
	pathtif = getInfo("image.directory") + fil_name;
	run("Set Scale...", "unit=pixel global");
	original = getImageID();
	selectImage(original);
	pathtif = getInfo("image.directory") + File.getNameWithoutExtension(getInfo("image.filename"));
	run("Duplicate...", "title=source_labels.png");
	ID = getImageID();

	// split labeled classes based on thresholds
	// calculate local thickness for each class
	// save thickness images for each class in same folder as original image
	max_val = getValue("Max");
	for (i=1; i <= max_val; i++) {
		selectImage(ID);
		run("Duplicate...", "temp.png");
		ID_temp = getImageID();
		selectImage(ID_temp);
		setThreshold(i, i); //select the class
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Local Thickness (complete process)", "threshold=255");
		ID_temp1 = getImageID();
		selectImage(ID_temp1);
		run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=0 font=12 zoom=8 overlay");
		saveAs("tif", pathtif + "_class_" + a1[i]);
		saveAs("png", pathtif + "_class_" + a1[i]);
		selectImage(ID_temp1);
		close();
		selectImage(ID_temp);
		close();
	}
	close("source_labels.png");
}

// Done!
  showMessage("5/5", "<html>"
     +"<h1><font color=blue><i>Done!</i></h1>");