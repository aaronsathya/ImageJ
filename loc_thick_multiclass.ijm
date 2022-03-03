// To run local thickness measurements (https://www.optinav.info/LocalThicknessEd.pdf)
// on 2D files with multiple labels, each corresponding to a particular
// segmentation class.
// Takes a while to run since local thickness measurements can be intensive 

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
	saveAs("tif", pathtif + "_class_" + i);
	saveAs("png", pathtif + "_class_" + i);
	selectImage(ID_temp1);
	close();
	selectImage(ID_temp);
	close();
}
close("source_labels.png");