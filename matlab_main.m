for k=1:inf
clear all;
tic
cla;
Average = 106939;
%vobj=videoinput('winvideo',1);
%camerainfo = imaqhwinfo(vobj)
 
vobj=videoinput('winvideo',1,'YUY2_640x480');
w= getsnapshot(vobj);                       %read image from camera and save it in variable w
ref = imread('fulljuice.jpg');
set(vobj,'ReturnedColorSpace','rgb'); 
triggerconfig(vobj,'manual');
%Capture one frame per trigger
 
set(vobj,'FramesPerTrigger',1 );
         
qq=0;                                               %initializes film counter
a_a=1;                                                %initializes frame number counter
preview(vobj);                                      %display camera output on the screen
threshold = 0.01;            %read the value of threshold 
flag = 1;
%start a for loop that equal the number of images usually infinity
for l = 1:40
    if (flag==1)
        a_a=a_a+1;
        
        v= getsnapshot(vobj);                       %read image from camera and save it in variable v
 
        
        
        x= rgb2gray (v);                            %convert image to gray scale
        y= rgb2gray(w);                             %convert image to gray scale
        
        z = imabsdiff(x,y);                         %get absolute diffrence between both images
        zz= sum(z,1);                           %calculate SAD
        zzz= sum(zz)/ 307200;                        %scale the value of SAD by dividing by number of pixels
        
        h_h(a_a) = zzz;                              %put values of SAD in array h
        
        hh_h=[ h_h(a_a-1) h_h(a_a) ];                         %calculate variance value
        var_value=var(hh_h,1);
        
        var_values(a_a)=var_value;                 %put values of variance in array var_value
           
        if (var_value>threshold)                    %check if value of variance greater than threshold  
            qq=qq+1;
            imshow(v);                              %display image with motion on screen
            imwrite(v , 'Detected.png');
            film(qq) = im2frame(v);                 %add image to film structure
            %image(film.cdata)
            %colormap(film.colormap) 
        else
        end                                         %end of if statment
    else
        break                                       %if stop button was pressed exit for loop
    end                                             %end of if statment (flag)
    toc
end                                                 %end of for loop
 
% Test With an Image%
a5 = imread('Detected.png');
b5 = rgb2gray(a5);
c5 = medfilt2(b5);
imhist(c5);
d5 = im2bw(c5 ,0.40);
e5 =~d5; 
f5 = bwareaopen(e5,250);
imshow(f5);
g5 = bwareaopen(f5, 8000);
figure 
imshow(g5);
mask = strel('diamond',5);
I5 = imopen(g5,mask);
figure 
imshow(I5);
h5 = regionprops(I5);
level5 = h5.Area;
level5
if (level5 > 13000)
    disp ('PASSED it is above average');
else
    disp('FAILED it is below average!')
end
subplot(2,2,1)
imshow(ref);
subplot(2,2,2)
imshow('liquidlevel.png');
subplot(2,2,3)
imshow(a5);
subplot(2,2,4)
imshow(g5);
 
 
%fclose(s);                                          %close serial port object
%delete(s);                                          %delete serial port object
delete(vobj); 
 
%delete video object
%savefile = 'var.mat';                               %initialize file name
%save(savefile,'var_values','film')                   %save variables var_values and film to file name
 
end
