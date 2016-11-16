function [ img , sLmtx] = connectedComponentThres( img , threshold)
%CONNECTEDCOMPONENTTHRES Given a binary image , remove
%connected components having size less than the threshold. The threshold
%could be a function of the image segment lengths (histogram analysis?).

[Label,Num] = bwlabel(img);
[M,N] = size(img);
Lmtx = zeros(Num+1,1);
%% Count length of connected components
for i=1:M
    for j=1:N
        Lmtx(double(Label(i,j))+1) = Lmtx(double(Label(i,j))+1) + 1;
    end
end
sLmtx = sort(Lmtx);
if(threshold == 0)
    maxCurvaturePoint = findMaxCurvature(sLmtx);
    if(maxCurvaturePoint ~= 0)
        threshold = sLmtx(maxCurvaturePoint);
    end
end
%% Remove components having length less than threshold
for i=1:M
    for j=1:N
        if (Lmtx(double(Label(i,j)+1)) >= threshold) & (Lmtx(double(Label(i,j)+1)) ~= sLmtx(Num+1,1))
            img(i,j) = 0;
        else
            img(i,j) = 1;
        end
    end
end
img = ~img;

end

function maxCurvaturePoint = findMaxCurvature(sLmtx)
%Input: Sorted list of connected component lengths
%Output: point of maximum curvature as 
%'four times the area of the triangle formed by the three points divided
% by the product of its three sides' which is equal to the curvature of a
% circle drawn through the 3 points. (Why is this so?)
%TODO: 1. look at only the top 'n' percentile
%      2. Stop when there is no curvature point update for 'n' runs
%      3. Create a 3 x n matrix to vectorize the curvature computation
maxK = 0;
maxCurvaturePoint = 0;
%Curvatures = zeros(size(sLmtx));
%% Look at only the top n percentile to come up with a threshold.
%PERCENTILE = 10; 
size_sLmtx = size(sLmtx,1);
for i=size_sLmtx:-1:3  %ceil(size_sLmtx*(1-(PERCENTILE/100)))
    x1=i;
    x2=i-1;
    x3=i-2;
    
    y1 = sLmtx(x1);
    y2 = sLmtx(x2);
    y3 = sLmtx(x3);
    %% http://in.mathworks.com/matlabcentral/answers/57194-how-to-find-the-sharp-turn-in-a-2d-line-curve
    %% K = 4*area of triangle / product of sides
    K = 2*abs((x2-x1).*(y3-y1)-(x3-x1).*(y2-y1)) ./ ...
        sqrt(((x2-x1).^2+(y2-y1).^2)*((x3-x1).^2+(y3-y1).^2)*((x3-x2).^2+(y3-y2).^2));
    %Curvatures(i) = K;
    if(K > maxK)
        maxCurvaturePoint = i;
        maxK=K;
    end
    
end
%plot(Curvatures);
end

