// IMPORTANT: BEFORE running this macro, please copy class_x_RGB_threshold.ijm macros 
// where (x = class number), into the macros folder in the ImageJ/Fiji folder

// This imageJ macro measures local thickness(https://www.optinav.info/LocalThicknessEd.pdf) 
// on a multiclass 2D RGB image. It is assumed that the images have classes labeled and 
// that each class has a distinct RGB value. It is also assumed that there are 5 classes
// including background (dark blue), EGL (light blue), ML (green),
// IGL (orange), and WM (strong red). Individual class RGB threshold macros
// have been tuned to these colors. Adjust these to fit your particular colors.
// Takes a while to run since local thickness measurements can be intensive. 

close("*");
run("Clear Results");

// Dialog for mapping class label value
// --Modify below based on number of classes and description--
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
	color_num = lengthOf(a1)-1;
	for (n=1; n <= color_num; n++) {
		selectImage(ID);
		run("Duplicate...", "temp.png");
		ID_temp = getImageID();
		selectImage(ID_temp);
		runMacro(List.get(a1[n]));//select class
		setThreshold(255, 255);
		run("Convert to Mask");
		ID_temp = getImageID();
		selectImage(ID_temp);
		run("Local Thickness (complete process)", "threshold=255");
		ID_temp1 = getImageID();
		selectImage(ID_temp1);
		run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=0 font=12 zoom=8 overlay");
		saveAs("tif", pathtif + "_class_" + a1[n]);
		saveAs("png", pathtif + "_class_" + a1[n]);
		selectImage(ID_temp1);
		close();
		selectImage(ID_temp);
		close();
	}
	close("source_labels.png");
	close(original);
}
// Done!
  showMessage("5/5", "<html>"
     +"<h1><font color=blue><i>Done!</i></h1>");
