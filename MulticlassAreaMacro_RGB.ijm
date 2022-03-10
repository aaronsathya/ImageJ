// IMPORTANT: BEFORE running this macro, please install class_x_RGB_threshold.ijm macros 
// where (x = class number), into the macros folder in the ImageJ/Fiji folder

// This imageJ macro measures area of class labels from a multiclass image
// It is assumed that the images have classes labeled and that each class
// has a distinct RGB value. It is also assumed that there are 5 classes
// including background (dark blue), EGL (light blue), ML (green),
// IGL (orange), and WM (strong red). Individual class RGB threshold macros
// have been tuned to these colors. Adjust these to fit your particular colors.

close("*");
run("Clear Results");

// Dialog for mapping class labels and color
// --Modify below based on number of classes and color--
Dialog.create("Map pixel value to class label and color");
Dialog.addString("class with color = dark blue", "background");
Dialog.addString("class with color = light blue", "EGL");
Dialog.addString("class with color = green", "ML");
Dialog.addString("class with color = orange", "IGL");
Dialog.addString("class with color = strong red", "WM");
Dialog.show();
c0 = Dialog.getString();
c1 = Dialog.getString();;
c2 = Dialog.getString();;;
c3 = Dialog.getString();;;;
c4 = Dialog.getString();;;;;
a1 = newArray(c0, c1, c2, c3, c4);
List.set(c1, "class1_RGB_threshold");
List.set(c2, "class2_RGB_threshold");
List.set(c3, "class3_RGB_threshold");
List.set(c4, "class4_RGB_threshold");
//--Modify above based on number of classes and color--

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
	for (n=1; n <= lengthOf(a1)-1; n++) {
		selectImage(original);
		run("Duplicate...", "title=source_labels.png");
		rename(fil_name + "_" + a1[n]);
		runMacro(List.get(a1[n]));
		setThreshold(255, 255);
		ID = getImageID();
		selectImage(ID);
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