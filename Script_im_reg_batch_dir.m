%% Open a figure window, get the list of data files
figure; colormap gray
main_fname = 'gs01_mgb_g6s_150128_RF_test01';
imfiles = dir([main_fname '*.tif']);

%% View mean images, to choose the target image for alignment
k = 14;
[im, header] = load_scim_data(imfiles(k).name);

im_mean = mean(im(:,:,(1:100)),3);
imagesc(im_mean, [-150 300]);
axis square
figure(gcf)
%% Choose target image
im_tg = im_mean;
% main_fname = 'ztt_som02_20141223_axon1_256_10x_sound_';
%
dft_reg_dir_2(pwd, [], main_fname, im_tg);

