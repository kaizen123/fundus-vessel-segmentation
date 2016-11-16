function vasculature = getVasculatureMatchedFilterResponse(img, x, sa)
%GETVASCULATUREMATCHEDFILTERESPONSE: The vessel profile is assumed to be an
%inverted gaussian described by x and sa. The maximum response for the
%image for all possible rotations is noted. The matched filter image is
%then binarized using OTSU's method.
%
% Input: Colour Fundus Image img, vessel profile width x, standard deviation sa?
% Output: Vessel segmented binary image
% Parameters: x, sa 
    grayImg = helper.selectChannel(img);
%     sa = 0.5;
%     x = [-6: 6];
    x = -x:x;
    size_x = size(x,2);
    tmp1 = exp(-(x.*x)/(2*sa*sa));
    tmp1 = max(tmp1)-tmp1;
    ht1 = repmat(tmp1,[9 1]);
    sht1 = sum(ht1(:));
    mean1 = sht1/(size_x*9);
    ht1 = ht1 - mean1;
    ht1 = ht1/sht1;
    h = zeros(15,size_x+3);
    for i = 1:9
        for j = 1:size_x
            h(i+3,j+1) = ht1(i,j);
        end
    end
    ROTATION_ANGLE = 15;
    NUM_ROTATIONS = 12;
    for k=1:NUM_ROTATIONS
        if(k==1)
            curr = conv2(double(grayImg),h, 'same');
            rt = curr;
            continue;
        end
        h = imrotate(h,ROTATION_ANGLE,'bicubic','crop');
        curr = conv2(double(grayImg), h, 'same');
        rt = max(rt,curr);
        
    end
    vasculature = im2bw(rt);
end