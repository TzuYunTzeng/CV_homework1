# 林沅廷<span style="color:red">(102061148)</span>

# Project 1 / Image Filtering and Hybrid Images

## Overview

>The project is related to image filtering and hybrid images. In this project, we need to implement our own filtering function which has the same functionality as the 2D convolution with padding. Then, we will use proper filter to extract high and low frequency components of two different images and merge them as one new image(ex: high frequency component from image1 and low frequency component from image2. The most obvious effect is that we may consider the new image to be more similar to image if we are close to it. In the contrast, if we are far away from it, we could only see the low frequency component and regard it as image2 as a result! 


## Implementation
* **my_imfilter:**
	1. Use im2double to change the type of each pixel from uint8 to double and save the size of input image and filter. Moreover, distinguish gray scale image and color image from its dimension
		```
		im = im2double(image);
		isgray =0;
		if length(size(image))==2    
    			isgray=1;
		elseif length(size(image))==3
    			[~,~,mz]=size(image);
    			isgray=0;
		end
		``` 
	
	2. Save the size of the filter and decide how many pixel we need to pad:
		```
		[fy,fx] = size(filter);

		pad_x = floor(fx/2);
		pad_y = floor(fy/2);
		```
	
	3. Take gray scale image as example. Instead of shifting the filter all over the image, we fix the filter and move the image. In this case, if we have a filter which is much smaller than the image (like 3 * 3), we can save much shift and dot operation:
		```
		if isgray==1
    			output = zeros(size(im)+[2*pad_y 2*pad_x]);
    			for x= 1:fx,
        			for y=1:fy,
            				output(y:end-(fy-y),x:end-(fx-x))=output(y:end-(fy-y),x:end-(fx-x))+im*filter(y,x);
        			end
    			end
    			output = output(1+pad_y:end-pad_y,1+pad_x:end-pad_x);
		...
		```
	
	4. In the color image case, we only need to further take channel into consideration and perform the same task as we do in the gray scale case:
		```
		output = zeros(size(im)+[2*pad_y 2*pad_x 0]);
    		for x= 1:fx,
        		for y=1:fy,
            			for z=1:mz,
                			output(y:end-(fy-y),x:end-(fx-x),z)=output(y:end-(fy-y),x:end-(fx-x),z)+im(:,:,z)*filter(y,x);
            			end
        		end
    		end
    		output = output(1+pad_y:end-pad_y,1+pad_x:end-pad_x,:);
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
* Only need matlab (use relatively new version is good choice)
* How to run the code:

```
git clone https://github.com/brade31919/homework1
cd HOMEWORK1ROOT/code/
proj1 #run proj1
```

### Results

* Hybrid image  

<table border=1>  
<em>Cat & Dog </em>
<tr>
<td>
<em>-----------low-frequency dog---------------------high-frequency cat--------------------------hybrid image----------------</em><br>
<img src="https://github.com/brade31919/homework1/blob/master/pic/low_frequencies_cat_dog.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/high_frequencies_cat_dog.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_cat_dog.jpg" width="32%"/>
</td>
</tr>

<tr>
<td>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_scales_cat_dog.jpg" width="99%"/>
</td>
</tr>
</table>


<table border=1>  
<em>Einstein & Marilyn </em>
<tr>
<td>
<em>--------low-frequency Marilyn-----------high-frequency Einstein------------------hybrid image----------</em><br>
<img src="https://github.com/brade31919/homework1/blob/master/pic/low_frequencies_E_M.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/high_frequencies_E_M.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_E_M.jpg" width="32%"/>
</td>
</tr>

<tr>
<td>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_scales_E_M.jpg" width="99%"/>
</td>
</tr>
</table>

<table border=1>  
<em>Bird & Plane </em>
<tr>
<td>
<em>------------low-frequency bird-------------------high-frequency plane----------------------hybrid image----------------</em><br>
<img src="https://github.com/brade31919/homework1/blob/master/pic/low_frequencies_bird_plane.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/high_frequencies_bird_plane.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_bird_plane.jpg" width="32%"/>
</td>
</tr>

<tr>
<td>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_scales_bird_plane.jpg" width="99%"/>
</td>
</tr>
</table>

<table border=1>  
<em>Bike & Motocycle </em>
<tr>
<td>
<em>---------low-frequency bike------------------high-frequency motorcycle---------------------hybrid image----------------</em><br>
<img src="https://github.com/brade31919/homework1/blob/master/pic/low_frequencies_bicycle_motorcycle.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/high_frequencies_bicycle_motorcycle.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_bicycle_motorcycle.jpg" width="32%"/>
</td>
</tr>

<tr>
<td>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_scales_bicycle_motorcycle.jpg" width="99%"/>
</td>
</tr>
</table>

<table border=1>  
<em>Fish & Submarine </em>
<tr>
<td>
<em>------------low-frequency submarine------------------high-frequency fish------------------hybrid image----------------</em><br>
<img src="https://github.com/brade31919/homework1/blob/master/pic/low_frequencies_submarine_fish.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/high_frequencies_submarine_fish.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_submarine_fish.jpg" width="32%"/>
</td>
</tr>

<tr>
<td>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_scales_submarine_fish.jpg" width="99%"/>
</td>
</tr>
</table>


<table border=1>  
<em>Hilary & Trump </em>
<tr>
<td>
<em>------------low-frequency Hilary------------------high-frequency Trump------------------hybrid image----------------</em><br>
<img src="https://github.com/brade31919/homework1/blob/master/pic/low_frequencies_H_T.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/high_frequencies_H_T.jpg" width="32%"/>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_H_T.jpg" width="32%"/>
</td>
</tr>

<tr>
<td>
<img src="https://github.com/brade31919/homework1/blob/master/pic/hybrid_image_scales_H_T.jpg" width="99%"/>
</td>
</tr>
</table>

