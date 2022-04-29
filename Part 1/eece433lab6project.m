% EECE 433 Lab 6 Project
% August Byrne
% 6/1/2021

frames = 5;
filepath = 'easyimage';
extension = '.png';
template = im2gray(im2double(imread('easyTemplate.png')));
reference = imread('easyimage1.png'); %Later will want to wrap with rgb2gray()
refSize = size(reference);
templateSize = size(template);
images = zeros(refSize(1),refSize(2),frames);

for k=1:frames
    images(:,:,k) = im2gray(imread(strcat(filepath,num2str(k),extension))); %Later will want to wrap with rgb2gray()
end

xcorrVals = zeros(refSize(1)+templateSize(1)-1,refSize(2)+templateSize(2)-1,frames);
for k=1:frames
    xcorrVals(:,:,k) = xcorr2(images(:,:,k),template);
end

for k=1:frames
    figure(k)
    radius = floor(templateSize(1)/2);
    [~,yCoords] = max(xcorrVals(:,:,k),[],1); %yCoords is the coordinate of the max value of each row
    [~,xCoords] = max(xcorrVals(:,:,k),[],2); %same as above, but for columns
    y = max(yCoords(yCoords>1)); %y is the max value of the max row coordinates
    x = max(xCoords(xCoords>1)); %x is the max value of the max column coordinates
    loc = [x-radius y-radius]; %location of best match at the center of supposed template object
    imshow(images(:,:,k))
    viscircles(loc,(radius-0.5)*sqrt(2),'Color','r','LineWidth',1/8);
    xyr(:,k) = [x y radius];
end



% for k=1:frames
%     edgeImage(:,:,k)=edge(image2(:,:,k),'Canny');
%     
% end


% for k = 1:frames
%     image(:,:,k) = rgb2gray(imread(strcat(filepath,num2str(k),extended)));
% end
%  
% % use edge detection
% for k = 1:frames
%     edgefim()=edge(image2(:,:,k),'Canny');
%     imshow;
% end
% 
% 
% %mean image
% for k = 1:frames
%     sum = sum+ cast(edgeofm(:,:,k),'double');
% end

%edge detection and background removal, then resize template (imresize) MOST LIKELY WILL HAVE TO DO THIS
%then template matching using xcorr2
%find max value of correlation result (will give one row, then find next dimension after)
%imshowpair(a, backgroundremove(:,:,m),'blend') with
%a(ybounds:ybounds2,xbounds:xbounds2,m) is bottom right corr result;