function [vasculature] = getVasculatureMotionBlur(img, LEN)
%GETVASCULATUREMORPHOLOGY: Averages the image by translating it along LEN pixels 
% through 30 deg angles  using the motion blur filter. The difference image 
% gives the foreground on which entropy thresholding and connected component analysis 
% is performed.
% Input: Colour Fundus Image
% Output: Vessel segmented binary image
% Parameters: connected component size     
% Why motion blur? Why not something like averaging filter? Possibly
% because it erases most other structures and retains only the vessels
% Does this have something to do with the intensities of the structures?
% i.e. different intensity structures show up on different translation
% lengths. Yes. The macula can be located by using high values(~150 on the drive dataset)
% of LEN
    grayImg = helper.selectChannel(img);

    input = grayImg;
    for ii = 0:30:360
        grayImg = imfilter(grayImg,fspecial('motion',LEN,ii));
    end
    
    H = grayImg - input;
    H = imadjust(H);
    %% Local thresholding
    [tt1,e1,cmtx] = misc.myThreshold(H);

     %% Apply threshold; 

     vasculature = (H >= tt1);
end
