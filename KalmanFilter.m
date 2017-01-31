videoReader = vision.VideoFileReader('5straight.3.AVI');%read video
videoPlayer = vision.VideoPlayer('Position',[100,100,500,400]);%play video


%frame is approx 745mm in H x 1338mm in W

%%Main
%compares a color or grayscale video frame to a background model to determine whether individual 
%pixels are part of the background or the foreground.
foregroundDetector = vision.ForegroundDetector('NumTrainingFrames',10,'InitialVariance',0.05);

%blob analysis detects distinct areas of an image (within a region)
blobAnalyzer = vision.BlobAnalysis('AreaOutputPort',false,'MinimumBlobArea',70);

Location = [];
Trajectory = {};
n=1;
kalmanFilter = []; 
isTrackInitialized = false;

   while ~isDone(videoReader)
       
     colorImage  = step(videoReader);%iterate through frames
     colorImage=imgaussfilt3(colorImage);
     colorImage = imresize(colorImage,0.5);
  
     %creates a black mask? 
     foregroundMask = step(foregroundDetector, rgb2gray(colorImage));
     
     detectedLocation = step(blobAnalyzer,foregroundMask);
     
     isObjectDetected = size(detectedLocation, 1) > 0;

     if ~isTrackInitialized
       if isObjectDetected
         kalmanFilter = configureKalmanFilter('ConstantVelocity',detectedLocation(1,:), [1 1]*1e7, [100  1], 12500);
         isTrackInitialized = true;
       end
       label = ''; circle = zeros(0,3);
     else
       if isObjectDetected
           %predict object and reduce noise by applying filter to find correct location
           %Reduce the measurement noise by calling predict followed by correct.
         predict(kalmanFilter);
         trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
         label = 'Corrected';
       else%if not detected predict location
         trackedLocation = predict(kalmanFilter);
         label = 'Predicted';
       end
        Location = [Location;trackedLocation];
       circle = [trackedLocation, 5];
     end

     colorImage = insertObjectAnnotation(colorImage,'circle',circle,label,'Color','red');
     
      Trajectory{n} = colorImage;
     n=n+1;   
     
     
     step(videoPlayer,colorImage);
   end
      figure;

      %Rescaling from 360x640 pixels to 745x1330cm
   Location(:,1) = 2.0694*Location(:,1);
   Location(:,2) = 2.078125*Location(:,2);
  
  plot(Location(:,1),-(Location(:,2)));
  
%  %%Overlay every 10 frames to see trajectory
   B = imlincomb(1,Trajectory{8},1,Trajectory{18},'single');
   for m = 28:10:178
        B = imabsdiff(B,Trajectory{m});
   end
   imshow(B);