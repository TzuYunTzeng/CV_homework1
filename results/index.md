# 林沅廷<span style="color:red">(102061148)</span>

# Project 1 / Image Filtering and Hybrid Images

## Overview

>The project is related to image filtering and hybrid images. In this project, we need to implement our own filtering function which has the same functionality as the 2D convolution with padding. Then, we will use proper filter to extract high and low frequency components of two different images and merge them as one new image(ex: high frequency component from image1 and low frequency component from image2. The most obvious effect is that we may consider the new image to be more similar to image if we are close to it. In the contrast, if we are far away from it, we could only see the low frequency component and regard it as image2 as a result! 


## Implementation
* **my_imfilter:**
	1. Use im2double to change the type of each pixel from uint8 to double and save the size of input image and filter.
		```
		im = im2double(image);
	[my,mx,mz] = size(image);
	[fy,fx] = size(filter);
		``` 
	
	2. According to the convolution operation, we need to rotate the filter 180 degree and then do the multiply and sum (Although there is no difference here, gaussian filter is symmetric to its center.) Hence, we flip the filter. 
		```
		filter2 = zeros(fy,fx);
	for x = 1:fx,
    		for y=1:fy,
        		filter2(y,x) = filter(fy-y+1,fx-x+1);
    		end
	end
	filter = filter2;
		```
	
	3. As teacher mentioned in the class, when performing convolution on the edge of the image, the filter kernel would exceed the boundary(unless you use 1 * 1 filter). As a result, we should perform padding on  the edge of the image to avoid this condition. For example, we are supposed to pad 1 pixel width on the edge if we use 3 * 3 filter. 
		```
		pad_x = floor(fx/2);
	pad_y = floor(fy/2);
	im = padarray(im,[pad_y,pad_x]);
		```
	
	4. In the end, we perform convolution to the whole image. I simply treat the filter as a sliding window and move it through every index. If we can simplify the 3 for loop structure, the operation might become faster.
		```
		output = zeros(my,mx);
	for x = 1:mx,
    		for y = 1:my,
        		for z = 1:mz,
            		output(y,x,z) = sum(sum(im(y:y+2*pad_y,x:x+2*pad_x,z).*filter));
       			end
    		end
	end
		```
	
* **proj1:**
	
	   With my_imfilter, we can make hybrid image now:
	1. Read in two images from the 5 provided pairs (Or some image pairs from the internet).
	
		```
		image1 = im2single(imread('../data/plane.bmp'));
image2 = im2single(imread('../data/bird.bmp'));
		```
		
	2. Define the cutoff frequency and the lowpass filter we'd like to use:
		
		```
		cutoff_frequency = 7;
		filter = fspecial('Gaussian', cutoff_frequency*4+1, cutoff_frequency);
		```
		
	3. Extract the low frequency part from image1 and high frequency from image2 (I do this by removing low frequency part from the original image instead of using high pass filter). Combine the 2 parts to form a new image:
		```
		low_frequencies = my_imfilter(image1,filter);
		high_frequencies = image2 - my_imfilter(image2,filter);
		hybrid_image = low_frequencies + high_frequencies;
		```
	
	4. In the end, we visualize the ouput to confirm the functionality:
		```
		figure(1); imshow(low_frequencies)
figure(2); imshow(high_frequencies + 0.5);
vis = vis_hybrid_image(hybrid_image);
figure(3); imshow(vis);
imwrite(low_frequencies, 'low_frequencies.jpg', 'quality', 95);
imwrite(high_frequencies + 0.5, 'high_frequencies.jpg', 'quality', 95);
imwrite(hybrid_image, 'hybrid_image.jpg', 'quality', 95);
imwrite(vis, 'hybrid_image_scales.jpg', 'quality', 95);
		```
	

## Installation
* Other required packages.
* How to compile from source?

### Results

<table border=1>
<tr>
<td>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg"  width="24%"/>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg" width="24%"/>
</td>
</tr>

<tr>
<td>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg"  width="24%"/>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg" width="24%"/>
</td>
</tr>

</table>
