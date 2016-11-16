function [ grayImg ] = selectChannel( img )
%SELECTCHANNEL Summary of this function goes here
%   Detailed explanation goes here
%     G = img(:,:,2);
%     B = img(:,:,3);
%     R1 = img(:,:,1);
%     if (mean(double(G(:))) >64)
%         if(mean(double(B(:))) > 64)
%             if(var(double(G(:))) < var(double(B(:))))
%                 grayImg = G;
%             else
%                 grayImg = B;
%             end
%         else
%             grayImg = G;
%         end
%     else
%         grayImg = R1;
%     end
    grayImg = adapthisteq(img(:,:,2));

end

