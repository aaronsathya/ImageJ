// Color Thresholder 2.3.0/1.53p
// Color = light blue, single images only!
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("RGB Stack");
run("Convert Stack to Images");
selectWindow("Red");
rename("0");
selectWindow("Green");
rename("1");
selectWindow("Blue");
rename("2");
min[0]=0;
max[0]=51;
filter[0]="pass";
min[1]=85;
max[1]=255;
filter[1]="pass";
min[2]=186;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
// Colour Thresholding-------------