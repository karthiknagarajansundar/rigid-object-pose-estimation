# Rigid Object Pose Estimation

## Objective
Given 9 RGB images that contains 7 objects in each of the image along with a set of dense 2D-3D correspondences, the task is to estimate the pose of each of
these objects, relative to the camera. Initially, the provided noisy correspondences are filtered using RANSAC and poses of the objects are estimated. Then the estimations are refined using Levenberg-Marquardt approach.

## Results
Random images for comparison. Ground truth poses are represented by lightblue while the estimations are represented as darkblue.

### Primary object pose estimation
<img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/img1_Ransac.jpg" width="250" height="250"> <img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/img3_Ransac.jpg" width="250" height="250"> <img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/img6_Ransac.jpg" width="250" height="250">

### Refined object pose estimation
<img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/img1_lm.jpg" width="250" height="250"><img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/img3_lm.jpg" width="250" height="250"><img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/img6_lm.jpg" width="250" height="250"> 

All results on both primary and refined object pose estimations can be found [here](https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/tree/main/Images).

## See Also: Computer Vision Projects
Using two or more partly overlapping images, the goal is to place them on top of each other for creating panoramas (image stitching).

Steps:
* Using VLfeat to compute SIFT features for both images and match them
* Find a homography describing the transformation between the two images using DLT with a minimal number of points needed
* Because not all matches are correct, RANSAC is used to find a set of good correspondences (inliers).

<img src="https://github.com/karthiknagarajansundar/rigid-object-pose-estimation/blob/main/Images/ImageStitching.JPG" width="1000" height="300">
