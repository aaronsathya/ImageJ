// This imageJ macro measures area of class labels from a multiclass image
// It is assumed that the images have classes labeled and that each class
// has a distinct integer value. It is also assumed that there are 5 classes
// including background with pixel values from 0 to 4.

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

//measure threshold-restricted area measurement per class label in batch
setBatchMode(true);
for (i=0; i<list_dir1.length; i++) {
	showProgress(i+1, list_dir1.length);
	open(dir1+list_dir1[i]);
	fil_name = File.getNameWithoutExtension(getInfo("image.filename"));
	pathtif = getInfo("image.directory") + fil_name;
	run("Set Scale...", "unit=pixel global");
	original = getImageID();
	max_val = getValue("Max");
	for (n=1; n <= max_val; n++) {
		selectImage(original);
		run("Duplicate...", "title=source_labels.png");
		ID = getImageID();
		rename(fil_name + "_" + a1[n]);
		setThreshold(n, n); //select the class
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Set Measurements...", "area limit display redirect=None decimal=3");
		run("Measure");
		adj_area = ds_fac*ds_fac*getResult("Area", nResults-1);
		setResult("Area*(downsample^2) [in pixel^2]", nResults-1, adj_area);
		setResult("Class", nResults-1, a1[n]);
		selectImage(ID);
		close();
	}
	selectImage(original);
	close();
}

// Done!
  showMessage("5/5", "<html>"
     +"<h1><font color=blue><i>Done!</i></h1>");
