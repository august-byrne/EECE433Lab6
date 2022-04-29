% EECE 433 Lab 6 Project
% August Byrne
% 6/11/2021

%%
% Part 1
% frames = 5;
% filepath = 'easyimage';
% extension = '.png';
% template = im2gray(im2double(imread('easyTemplate.png')));
% reference = imread('easyimage1.png'); %Later will want to wrap with rgb2gray()
% refSize = size(reference);
% templateSize = size(template);
% images = zeros(refSize(1),refSize(2),frames);
% 
% for k=1:frames
%     images(:,:,k) = im2gray(imread(strcat(filepath,num2str(k),extension))); %Later will want to wrap with rgb2gray()
% end
% 
% xcorrVals = zeros(refSize(1)+templateSize(1)-1,refSize(2)+templateSize(2)-1,frames);
% for k=1:frames
%     xcorrVals(:,:,k) = xcorr2(images(:,:,k),template);
% end
% 
% for k=1:frames
%     figure(k)
%     radius = floor(templateSize(1)/2);
%     [~,yCoords] = max(xcorrVals(:,:,k),[],1); %yCoords is the coordinate of the max value of each row
%     [~,xCoords] = max(xcorrVals(:,:,k),[],2); %same as above, but for columns
%     y = max(yCoords(yCoords>1)); %y is the max value of the max row coordinates
%     x = max(xCoords(xCoords>1)); %x is the max value of the max column coordinates
%     loc = [x-radius y-radius]; %location of best match at the center of supposed template object
%     imshow(images(:,:,k))
%     viscircles(loc,(radius-0.5)*sqrt(2),'Color','r','LineWidth',1/8);
%     xyr(:,k) = [x y radius];
% end

%%
% Part 2
frames = 5;
filepath = 'hardimage';
extension = '.png';
template = im2double(imread('hardTemplate.png'));
reference = im2double(imread('hardimage1.png'));
refSize = size(reference);
bwImages = zeros(refSize(1),refSize(2),frames);
edgeImages = zeros(refSize(1),refSize(2),frames);
scale = 0.96;
template = imresize(template,scale);    % resize template
templateSize = size(template);
IOU = zeros(2,frames);
EdgeDetectionOn = 1;    % switch between project part 2a and 2b output
ViewOutlines = 0;       % switch to view outlines in output (iff EdgeDetection = 1)
xcorrVals = zeros(refSize(1)+templateSize(1)-1,refSize(2)+templateSize(2)-1,frames);

for k=1:frames
    bwImages(:,:,k) = im2double(im2gray(imread(strcat(filepath,num2str(k),extension))));
    colorImages(:,:,1+(3*(k-1)):3+(3*(k-1))) = imread(strcat(filepath,num2str(k),extension));
end


for k=1:frames
    if (EdgeDetectionOn == 1)
        edgeImages(:,:,k) = edge(bwImages(:,:,k),'Canny',0.2);    % Canny edge detection filter
    end
    xcorrVals(:,:,k) = xcorr2(edgeImages(:,:,k),template);  % cross-correlation
end

for k=1:frames
    figure(k)
    [Vals,ValIndex] = max(xcorrVals(:,:,k),[],1); %Vals is max value of each column
    [~,x] = max(Vals); %x is the max value of the max column coordinates
    y = ValIndex(x); %y is the max value of the max row coordinates
    position = [x-templateSize(1) y-templateSize(2) templateSize(1) templateSize(2)];
    if (EdgeDetectionOn == 1 && ViewOutlines == 1)
        imshowpair(edgeImages(:,:,k),colorImages(:,:,1+(3*(k-1)):3+(3*(k-1))),'blend')
    else
        imshow(colorImages(:,:,1+(3*(k-1)):3+(3*(k-1))))
    end
    rectangle('Position',position,'EdgeColor','r')
    IOU(:,k) = [x-templateSize(1) y-templateSize(2)]; %top right corner of each detected object box
end
% figure(12)
% plot(xcorrVals(:,y,5)), xlabel('location'),ylabel('correlation')
