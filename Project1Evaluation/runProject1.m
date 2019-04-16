function [diag,l_mask,r_mask] = runProject1(left,right)
% Inputs:   left       -      the mammogram of the left side (rowL x colL)
%                             where rowL and colL are the image dimensions.
%           right      -      the mammogram of the right side (rowR x colR)
%
% Outputs:  diag       -      the estimated diagnosis.  Should only have
%                             values of 0(healthy), 1(benign), and 2(cancer).
%                             and be of size (1 x 2) (left, right).
%
%           l_mask     -      the output binary mask for the left side. 
%                             Should only have values of zero or one.
%                             If the estdiag is 0, the mask should only have 
%                             values of 0. Should be of size (rowL x colL).
%           r_mask     -      the output binary mask for the right side. 
%                             Should only have values of zero or one.
%                             If the estdiag is 0, the mask should only have 
%                             values of 0. Should be of size (rowR x colR).
%

%% SETUP

left = imread('MammoTraining/3008_LEFT.png');
right = imread('MammoTraining/3008_RIGHT.png');

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
l_edge = hist.BinEdges;
l_count = hist.BinCounts;

% histogram attributes for right breast
hist = polarhistogram(r,0:pi/10:2*pi);
r_edge = hist.BinEdges;
r_count = hist.BinCounts;

%% DETERMINE HEALTHY / UNHEALTHY

% distinguish health vs not
diff_count = l_count(17) + r_count(17) - l_count(18) - r_count(18);
%fprintf('diff: %f\n',diff_count)
if (diff_count < 0)
    %display('healthy');
    return;
end

%% MORE SETUP

% get intensity frequencies for both images
[l_counts,~] = imhist(left(left > 65535*(50/255)));
[r_counts,~] = imhist(right);

% get peak intensity frequencies for both images
[lpk,lpk_loc] = findpeaks(l_counts);
[rpk,rpk_loc] = findpeaks(r_counts);

% ignore any peak intensity frequencies that are too dark
lpk(lpk_loc < 100) = [];
rpk(rpk_loc < 100) = [];
lpk_loc(lpk_loc < 100) = [];
rpk_loc(rpk_loc < 100) = [];

% get sorted peak intensity frequencies for both images
[sort_lpk,sort_lpk_loc] = findpeaks(l_counts,'SortStr','descend');
figure
findpeaks(l_counts)
text(sort_lpk_loc(1:5)+.02,sort_lpk(1:5),num2str((1:5)'))
[sort_rpk,sort_rpk_loc] = findpeaks(r_counts,'SortStr','descend');

% ignore any peak intensity frequencies that are too dark
sort_lpk(sort_lpk_loc < 50) = [];
sort_rpk(sort_rpk_loc < 50) = [];
sort_lpk_loc(sort_lpk_loc < 50) = [];
sort_rpk_loc(sort_rpk_loc < 50) = [];

%% DETERMINE WHICH BREAST IS UNHEALTHY

lpk_m = mean(sort_lpk([1:5]))/sum(sort_lpk);
rpk_m = mean(sort_rpk([1:5]))/sum(sort_rpk);
l_unhealthy = 0;
fprintf('l: %f\n',lpk_m)
fprintf('r: %f\n',rpk_m)
if rpk_m > lpk_m
    fprintf('left unhealthy\n')
    l_unhealthy = 1;
else
    fprintf('right unhealth\n')
end

%% DETERMINE BENIGN / CANCEROUS

count = []
if l_unhealthy
    count = l_count;
    fprintf('l_std: %f\n',std(l_count))
else
    count = r_count;
    fprintf('r_std: %f\n',std(r_count))
end
if (std(count) < 1.6 * 10.^5)
    display('benign');
    diag = [l_unhealthy,1 - l_unhealthy];
else
    display('cancerous');
    diag = 2*[l_unhealthy,1 - l_unhealthy];
end

%% DETERMINE MASK

% ignore darker regions in left breast
l_count(l_edge < pi) = [];
l_edge(l_edge < pi) = [];
l_edge = l_edge * (65535/(2*pi));

% ignore darker regions in right breast
r_count(r_edge < pi) = [];
r_edge(r_edge < pi) = [];
r_edge = r_edge * (65535/(2*pi));

% get the most frequent intensity
[l_sort,l_in] = sort(l_count,'descend');
[r_sort,r_in] = sort(r_count,'descend');

% return l and r to original shapes
l = reshape(uint16(l),l_shape);
r = reshape(uint16(r),r_shape);

if l_unhealthy == 1
    in = l_in(1) - 1;
    if in <= 0
        in = 1;
    end
    l_mask(l > l_edge(in)) = 1;
    l_mask([1:l_shape(1)/4,3*l_shape(1)/4:l_shape(1)],:) = 0;
    l_mask(:,1:l_shape(2)/8) = 0;
    [row,col] = find(l_mask == 1);
    mid_row = mean(row);
    mid_col = mean(col);

    for i = 1:l_shape(1)
        for j = 1:l_shape(2)
            if sqrt((mid_row - i)^2 + (mid_col - j)^2) < 500
                l_mask(i,j) = 1;
            end
        end
    end
    %figure
    %imshow(l_mask == 1)
else
    in = r_in(1) - 1;
    if in <= 0
        in = 1;
    end
    r_mask(r > r_edge(in)) = 1;
    r_mask([1:r_shape(1)/4,3*r_shape(1)/4:r_shape(1)],:) = 0;
    r_mask(:,7*r_shape(2)/8:r_shape(2)) = 0;
    [row,col] = find(r_mask == 1);
    mid_row = mean(row);
    mid_col = mean(col);

    for i = 1:r_shape(1)
        for j = 1:r_shape(2)
            if sqrt((mid_row - i)^2 + (mid_col - j)^2) < 500
                r_mask(i,j) = 1;
            end
        end
    end
    %figure
    %imshow(r_mask == 1)
end