function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
%pad = 'zero';
im = im2double(image);
isgray =0;
if length(size(image))==2    
    isgray=1;
elseif length(size(image))==3
    [~,~,mz]=size(image);
    isgray=0;
end
[fy,fx] = size(filter);

%flip
%{
filter2 = zeros(fy,fx);
for x = 1:fx,
    for y=1:fy,
        filter2(y,x) = filter(fy-y+1,fx-x+1);
    end
end
filter = filter2;
%}

pad_x = floor(fx/2);
pad_y = floor(fy/2);
%im = padarray(im,[pad_y,pad_x]);

if isgray==1
    output = zeros(size(im)+[2*pad_y 2*pad_x]);
    for x= 1:fx,
        for y=1:fy,
            output(y:end-(fy-y),x:end-(fx-x))=output(y:end-(fy-y),x:end-(fx-x))+im*filter(y,x);
        end
    end
    output = output(1+pad_y:end-pad_y,1+pad_x:end-pad_x);
else
    output = zeros(size(im)+[2*pad_y 2*pad_x 0]);
    for x= 1:fx,
        for y=1:fy,
            for z=1:mz,
                output(y:end-(fy-y),x:end-(fx-x),z)=output(y:end-(fy-y),x:end-(fx-x),z)+im(:,:,z)*filter(y,x);
            end
        end
    end
    output = output(1+pad_y:end-pad_y,1+pad_x:end-pad_x,:);
end
        
%{
for x = 1:mx,
    for y = 1:my,
        for z = 1:mz,
            output(y,x,z) = sum(sum(im(y:y+2*pad_y,x:x+2*pad_x,z).*filter));
        end
    end
end
%}
        









