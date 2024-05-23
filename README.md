# Nuclei Cell Detector
MATLAB program to detect green cell nuclei at the tip of a plant root microscopic image. The output of the program transforms each of these images whereby colours are generated at random to mark the different regions corresponding to nuclei. 

## Pre-processing
### Summary
![image](https://github.com/xtGitCode/Nuclei-Cell-Detector/assets/103571608/6506375a-18f9-424d-84fc-616264da22f3)

### Noise removal
The initial pre-processing technique is a subtle reduction of noise using the Gaussian Blur technique 
so that unnecessary details do not get enhanced during the brightening process. The function 
imgaussfilt() standard deviation value is set to ‘0.5’, after several trials and errors, so that important 
information is retained, and noise is slightly removed.  

### Brighten image
Finally, the image is brightened using the imlocalbrighten() function with a parameter of ‘0.9’, so 
that not too much noise is introduced. The reason for brightening is to amplify the details of the 
cells. As can be observed in Figure 1.1, the original image is quite dark and contains many cells that 
are hidden due to their similarity in contrast with the background. This will result in a better output 
when we binarize it as the dimmer cells will also be captured.  

## Pipeline
### Summary
![image](https://github.com/xtGitCode/Nuclei-Cell-Detector/assets/103571608/021f45e9-c3f0-4ada-bc6b-1e91c3546964)
![image](https://github.com/xtGitCode/Nuclei-Cell-Detector/assets/103571608/aab9d27d-0f3d-422a-9920-18a5bf7d5e85)

### Convert to HSV, extract green cells and binarize the image 
Initially, we convert the brightened images from RGB to HSV colour space utilizing the rgb2hsv() 
function.  
Next, we extract the image's hue, saturation, and value channels to create a mask for green pixels. 
The mask is created by defining the lower and upper bounds for each of these channels, where 
pixels that fall within the range are considered to be our desired cells and extracted. The bounds are 
determined as follows, based on trials and errors: 
• 0.08 <= hue <= 0.9 
• 0 <= saturation <= 1 
• 0.05 <= value <= 1 
The mask is then applied to the original image and converted to greyscale. The greyscale image is 
then transformed to binary form using the imbinarize() function for further processing.

### Remove Noise
we use bwareaopen() with a parameter value of 20, so that 
all pixels with an area less than 20 are removed and larger objects, representing the cells are 
retained. 

### Separate small and big cells 
If we used a single processing pipeline for all cells, the smaller-sized cells could be lost during 
processing, and their shape will be significantly altered after performing morphology due to their 
small size. 
To ensure that we don't lose those cells during processing and to maintain their original shape, we 
utilize different processing pipelines for cells based on their pixel area using bwareaopen(), with a 
threshold value of 150. Cells with an area less than 150 are categorized as "small cells," while those 
greater than 150 are "big cells."

### Open big cells
Next, we proceed to process the big cells by applying morphological operator opening using the 
structured element of disk shape and radius of 4 pixels. The purpose of opening is to remove the 
small pixels that cause the cells to look smudged and messy while preserving the shape and size.

### Smoothen small cells 
Subsequently, we process the small cells by blurring them using conv2() with a square kernel size 
4x4, as this will fill up small holes inside the cells and smoothen the cell edges. Then, we re-threshold 
it to remove any noise that may have been introduced during the convolution operation. 

### Combine both outputs 

### Watershed Segmentation 
we apply watershed segmentation to separate cells that are merged. The purpose is so 
that when we add colour to the cells in the final step, each cell has its own colour. However, the 
shape of the cells is very important to us, thus we need to prevent over-segmentation by selecting a 
lower threshold value. 

### Colour cells
Finally, we display our final output by labelling a unique colour randomly to each connected cell. This 
is done using the label2rgb() function with the parameters ‘shuffle’ to assign colours randomly and 
‘k’ to set the background colour to black. We also generated a randomized colour map using the 
rand() function on the number of labels in the image – by 3 for the three colour channels, RGB. This 
ensures that each label is assigned a unique colour from the colour map.  


