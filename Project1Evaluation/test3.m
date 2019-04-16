close all;
clc; clearvars;

for num = 8%[1,2,4,6,8,9,11]

    str_l = ['MammoTraining/',num2str(3000+num),'_LEFT.png'];
    str_r = ['MammoTraining/',num2str(3000+num),'_RIGHT.png'];
    left = imread(str_l);
    right = imread(str_r);

    figure
    subplot(1,2,1)
    imshow(left)
    title('Left Breast')
    subplot(1,2,2)
    imshow(right)
    title('Right Breast')
    
    % get the image shapes
    l_shape = size(left);
    r_shape = size(right);

    % initizlize diag and masks
    diag = zeros([1,2]);
    l_mask = zeros(l_shape);
    r_mask = zeros(r_shape);

    % for use in rose diagram
    l = reshape(double(left),[1,prod(l_shape)]);
    r = reshape(double(right),[1,prod(r_shape)]);
    
    % histogram attributes for left breast
    figure
    hist = polarhistogram(l,0:pi/10:2*pi);
    title('Rose Diagram: Left Breast')
    l_edge = hist.BinEdges;
    l_count = hist.BinCounts;
    l_edge(hist.BinEdges < pi) = [];
    l_count(hist.BinEdges < pi) = []
    l_edge = l_edge * (65535/(2*pi))

    % histogram attributes for right breast
    figure
    hist = polarhistogram(r,0:pi/10:2*pi);
    title('Rose Diagram: Right Breast')
    r_edge = hist.BinEdges;
    r_count = hist.BinCounts;
    r_edge(hist.BinEdges < pi) = [];
    r_count(hist.BinEdges < pi) = []
    r_edge = r_edge * (65535/(2*pi))
    
    [l_m,l_in] = max(l_count)
    [r_m,r_in] = max(r_count)
    
    l = reshape(uint16(l),l_shape);
    r = reshape(uint16(r),r_shape);
    
    l_unhealthy = 1
    if i == 6
        l_unhealthy = 0
    end
    if l_unhealthy == 1
        in = l_in - 1
        if in <= 0
            in = 1
        end    
        l_mask(l > l_edge(in)) = 1;
        l_mask([1:l_shape(1)/4,3*l_shape(1)/4:l_shape(1)],:) = 0;
        l_mask(:,1:l_shape(2)/8) = 0;
        figure
        imshow(l_mask == 1)
        title('Mask before Lambda')
        [row,col] = find(l_mask == 1);
        mid_row = median(row);
        mid_col = median(col);
        
        for i = 1:l_shape(1)
            for j = 1:l_shape(2)
                if sqrt((mid_row - i)^2 + (mid_col - j)^2) < 400
                    l_mask(i,j) = 1;
                end
            end
        end
        
        figure
        imshow(l_mask == 1)
        title('Mask after Lambda')
        
        figure
        act_mask = imread(['MammoTraining/',num2str(3000+num),'_LEFT_MASK.png']);
        imshow(act_mask == 1)
        title('Actual Mask')
    else
        in = r_in - 1
        if in <= 0
            in = 1
        end
        r_mask(r > r_edge(in)) = 1;
        r_mask([1:r_shape(1)/4,3*r_shape(1)/4:r_shape(1)],:) = 0;
        r_mask(:,7*r_shape(2)/8:r_shape(2)) = 0;
        figure
        imshow(r_mask == 1)
        title('Mask before Lambda')
        [row,col] = find(r_mask == 1)
        mid_row = median(row)
        mid_col = median(col)
        
        for i = 1:r_shape(1)
            for j = 1:r_shape(2)
                if sqrt((mid_row - i)^2 + (mid_col - j)^2) < 400
                    r_mask(i,j) = 1;
                end
            end
        end
        figure
        imshow(r_mask == 1)
        title('Mask after Lambda')
    end
    
end