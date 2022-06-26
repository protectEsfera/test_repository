img = imread('tmp.png');
imshow(img);
pause(1);

gray_image = rgb2gray(img);
canny_image = edge(gray_image,'canny');
imshow(canny_image);

% threshold initialization
th_down = 0.5;
th_up = 0.55;
subplot(2,1,1), subimage(img);

% find threshold
while 1

    hsv = rgb2hsv(img);
    h = hsv(:,:,1);

    if(th_up - th_down) < 0
        binary_res = (th_down<h)*(h<th_up);
    else
        binary_res = (th_down<h)&(h<th_up);
    end

    subplot(2,1,2), subimage(binary_res);
    disp("th_down: " + th_down + "  th_up" + th_up);

    x = input("+:e, -:d, quit:q     ", 's');
    disp(newline);

    if x=='q'
        disp("* final th_down: " + th_down + " fianl th_up" + th_up);
        break
    elseif x=='e'
        th_down = th_down + 0.025;
        th_up = th_up + 0.025;
    elseif x == 'd'
        th_down = th_down - 0.025;
        th_up = th_up - 0.025;
    end

    if th_down > 1
        th_down = th_down-1;
    elseif th_down < 0
        th_down = th_down+1;
    end

    if th_up > 1
        th_up = th_up - 1;
    elseif th_up < 0
        th_up = th_up + 1;
    end
end

% median filtering
median_im = medfilt2(binary_res, [3,3]);

% 300이하의 값 필터
filtered_im = bwareaopen(median_im, 300);

% 경계선 가르기
bw = bwlabel(filtered_im, 8);

% 자르기 Stats
stats = regionprops(bw, 'BoundingBox', 'Centroid');

imshow(img)

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

