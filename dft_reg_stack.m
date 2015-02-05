function [im_dft, shift] = dft_reg_stack(im_s, pix_range)

% [im_dft, shift] = dft_reg_stack(im_s, pix_range)
% To align a stack of image. Use the preceding image as target.

% im_s, source image data, can be multi-frame, m x n x p matrix.
% 
% 
% pix_range, specify the fraction of image used for registraiton.
%            If with 2 elements [startRow endRow], take as line_range,
%            If with 4 elements [startRow endRow startCol endCol], use a rectangle fraction of
%            the image.
% - NX
% Updated Sep, 2014, - NX

if nargin < 2 || isempty(pix_range)
    row_nums = 1 : size(im_s,1);
    col_nums = 1: size(im_s, 2);
else
    if numel(pix_range) == 2
        row_nums = pix_range(1) : pix_range(2);
        col_nums = 1:size(im_tg, 2);
    end
    if numel(pix_range) == 4
        row_nums = pix_range(1):pix_range(2);
        col_nums = pix_range(3):pix_range(4);
    end
end

for i = 2:size(im_s,3) % start from the 2nd image in the stack
%     if i <= span
%         im_tg = mean(im_s(:,:,1:span),3);
%     else
%         im_tg = mean(im_s(:,:,i-span:i-1),3);
%     end
     im_tg = im_s(:,:,i-1);
     [output(:,i), fft_frame_reg] = dftregistration(fft2(double(im_tg(row_nums,col_nums))),fft2(double(im_s(row_nums, col_nums,i))),1);
%         im_dft(:,:,i) = abs(ifft2(fft_frame_reg));
%     end
% The above no longer apply for SI4 data.
%     [output(:,i), fft_frame_reg] = dftregistration(fft2(double(im_tg(row_nums,col_nums))),fft2(double(im_s(row_nums, col_nums,i))),1);
end
shift = output(3:4,:);
padding = [0 0 0 0];
im_dft = ImageTranslation_nx(im_s,shift,padding,0);