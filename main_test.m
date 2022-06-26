% init treshold
th_down = 0.3;
th_up = 0.36;

% Capture an image from the drone's camera
frame = imread('문제3.png')
subplot(2,1,1);
imshow(frame);
pause(1);

% Get the hue data of the image  
hsv = rgb2hsv(frame);
h = hsv(:,:,1);
    
    
% imshow current binary image
if (th_up - th_down) < 0
    binary_res = (th_down<h)+(h<th_up);
else
    binary_res = (th_down<h)&(h<th_up);
end
subplot(2,1,2);
imshow(binary_res);                                           
disp("th_down: " + th_down + "   th_up: " + th_up);

% [B,L] = bwboundaries(binary_res,'noholes');

% bwareafilt: 가장 큰 영역만 남기기
binary_res = bwareafilt(binary_res, 1);
[B,L,N] = bwboundaries(binary_res);
binary_res= imcomplement(binary_res);

imshow(binary_res); 
hold on;

% median filtering
median_im = medfilt2(binary_res, [3,3]);

% 300이하의 값 필터
filtered_im = bwareaopen(median_im, 300);

% 경계선 가르기
bw = bwlabel(filtered_im, 8);

% 자르기 Stats
stats = regionprops(bw, 'BoundingBox', 'Centroid');

imshow(frame)

hold on

% 좌표 출력
for object = 1:length(stats)
    bb = stats(object).BoundingBox;
    bc = stats(object).Centroid;
    rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
    plot(bc(1),bc(2), '-m+')
    a=text(bc(1)+15, bc(2), strcat('X: ', num2str(round(bc(1))), '  Y: ', num2str(round(bc(2)))));
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    x_data = num2str(round(bc(1)));
    y_data = num2str(round(bc(2)));
end

axis equal