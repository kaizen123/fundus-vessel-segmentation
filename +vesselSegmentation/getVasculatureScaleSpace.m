function vasculature =  getVasculatureScaleSpace(img,gaussian_window_range,step_size,var,median_filter_window_range )
%GETVASCULATURESCALESPACE: Uses laplacian edge detection on 
% images convolved with different sizes of a gaussian kernel. Edges 
% which appear across all 'scales' are retained.
% The scaling effect is accomplished by considering larger gaussian kernels with higher standard deviation.
% The median filter is used to remove noise. 
% Parameters: gaussian kernel sizes,  adaptive median filtering window size,
    grayImg = helper.selectChannel(img);
    % preallocate memory
    preImg{ceil((gaussian_window_range(2)-gaussian_window_range(1)+1)/step_size)}.vessels = zeros(size(grayImg));
    
    idx = 0;
    for k = gaussian_window_range(1):step_size:gaussian_window_range(2)
            sigma = (0.5*k -1)*0.3+ var;
            
            kernel = fspecial('gaussian',k,sigma);
            laplace = fspecial('laplacian');
            blurImg = imfilter(grayImg,kernel);
            filteredImg = conv2(double(blurImg),laplace,'same'); 
            g = im2bw(filteredImg);
                        
            %Choosing kernel for adaptive median filtering
            for f = median_filter_window_range(1):median_filter_window_range(2)
               zmin = ordfilt2(g, 1, ones(f, f), 'symmetric');
               zmax = ordfilt2(g, f * f, ones(f, f), 'symmetric');
               zavg = 0.5*zmax + 0.5*zmin;
               zmed = median(zavg(:));
               zmean = mean(zavg(:)); 
               if abs(zmean - zmed) < std2(zmax*0.5+zmin*0.5)
                 mf = medfilt2(g, [f f], 'symmetric');
               end
            end
            
            
           idx = idx + 1;
           preImg{idx}.vessels = mf;
           
    end
        %% Edges which appear across (3?) scales can be retained and the rest discarded.
        n = idx;
        vasculature = zeros(size(grayImg));
        temp = zeros(size(grayImg));
        for i=1:n-2
            temp = preImg{i}.vessels + preImg{i+1}.vessels + preImg{i+2}.vessels;
            vasculature = ((temp == 3) | vasculature);
        end
end
