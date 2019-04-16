close all;
clc; clearvars;

mammoimgleft = imread('MammoTraining/3009_LEFT.png');
mammoimgright = imread('MammoTraining/3009_RIGHT.png');

figure(1)
subplot(1,2,1)
imshow(mammoimgleft)
title('left')
subplot(1,2,2)
imshow(mammoimgright)
title('right')

estdiag = zeros(1,2);
estmaskleft = zeros(size(mammoimgleft));
estmaskright = zeros(size(mammoimgright));

[l_counts,l_bins] = imhist(mammoimgleft);
[r_counts,r_bins] = imhist(mammoimgright);

[lpk,lpk_loc] = findpeaks(l_counts);
[rpk,rpk_loc] = findpeaks(r_counts);

[sort_lpk,sort_lpk_loc] = findpeaks(l_counts,'SortStr','descend');
[sort_rpk,sort_rpk_loc] = findpeaks(r_counts,'SortStr','descend');

sort_lpk(sort_lpk_loc < 50) = [];
sort_rpk(sort_rpk_loc < 50) = [];

sort_lpk_loc(sort_lpk_loc < 50) = [];
sort_rpk_loc(sort_rpk_loc < 50) = [];

lpk_m = mean(sort_lpk([1:5]))
rpk_m = mean(sort_rpk([1:5]))

lpk_loc_m = mean(sort_lpk_loc([1:10]))
rpk_loc_m = mean(sort_rpk_loc([1:10]))

figure(2)
subplot(2,1,1)
findpeaks(l_counts);
text(lpk_loc+.02,lpk,num2str((1:numel(lpk))'))
title('l hist')
subplot(2,1,2)
findpeaks(r_counts);
text(rpk_loc+.02,rpk,num2str((1:numel(rpk))'))
title('r hist')

lpk_loc(lpk_loc < 100) = [];
rpk_loc(rpk_loc < 100) = [];

[l_max,l_i] = max(lpk_loc([2:end])-lpk_loc([1:end-1]));
[r_max,r_i] = max(rpk_loc([2:end])-rpk_loc([1:end-1]));

lpk_loc = (65535/255)*lpk_loc;
rpk_loc = (65535/255)*rpk_loc;

l_i_per = l_i/length(lpk_loc)
r_i_per = r_i/length(rpk_loc)

estmaskleft(mammoimgleft > lpk_loc(l_i)) = 1;
estmaskright(mammoimgright > rpk_loc(r_i)) = 1;

sl = sum(sum(estmaskleft))/prod(size(estmaskleft));
sr = sum(sum(estmaskright))/prod(size(estmaskright));

l_max
r_max
dis = abs(l_max-r_max)/min(l_max,r_max)

abs(sort_lpk(1)-sort_rpk(1))/min(sort_lpk(1),sort_rpk(1))

% get sorted peak intensity frequencies for both image
[sort_lpk,sort_lpk_loc] = findpeaks(l_counts,'SortStr','descend');
[sort_rpk,sort_rpk_loc] = findpeaks(r_counts,'SortStr','descend');

% ignore any peak intensity frequencies that are black
sort_lpk(sort_lpk_loc < 50) = [];
sort_rpk(sort_rpk_loc < 50) = [];
sort_lpk_loc(sort_lpk_loc < 50) = [];
sort_rpk_loc(sort_rpk_loc < 50) = [];

% determine if the breast is healthy
abs(sort_lpk(1)-sort_rpk(1))/min(sort_lpk(1),sort_rpk(1))

figure(3)
subplot(1,2,1)
imshow(mammoimgleft > lpk_loc(l_i))
subplot(1,2,2)
imshow(mammoimgright > rpk_loc(r_i))
