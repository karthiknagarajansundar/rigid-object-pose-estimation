%% Predefined functions
% ComputeReprojectionErrormod
% draw_bounding_boxes
% eval_pose_estimates
% LinearizeReprojErr
% minimalCameraPose
% pextend
% pflat
% rq
% update_solution

%% New functions
% importDataImage
% outlier_rejection
% compError
% ComputeReprojectionErrormod

%% importing data
clear; clc; close all; opengl software
[U u bounding_boxes poses I] =  importDataImage;

%% RANSAC (Outlier rejection)
for obj_idx=1:7
    for img_idx=1:9
        [~ , P_est{obj_idx,img_idx}] = outlier_rejection(U{obj_idx, img_idx}, u{obj_idx, img_idx});
    end
end

%% LM update 
for obj_idx = 1:7
    for img_idx = 1:9
        
        % considering inliers
        [gP,~] = outlier_rejection(U{obj_idx, img_idx}, u{obj_idx, img_idx});
        
        % corresponding U and u
        u_gP = u{obj_idx,img_idx}(:,gP);
        U_gP = U{obj_idx,img_idx}(:,gP);

        lambda = 1e-6;
        P = {[eye(3) zeros(3,1)] , P_est{obj_idx,img_idx}};
        uu = {pextend(u_gP), pextend(u_gP)};
        
        % 10 iterations
        for i = 1:10
            P_iter{i} = P{2};
            [err_lm_temp(i),res] = ComputeReprojectionErrormod(P{2},U_gP,uu{2});
            [r,J] = LinearizeReprojErr(P,U_gP,uu);
            C = J'*J+lambda*speye(size(J,2));
            c = J'*r;
            deltav = -C\c;
            [Pnew,~] = update_solution(deltav,P,U_gP);
            P=Pnew;
        end
        
        % saving best solution
        [err_min , err_min_idx] = min(err_lm_temp);
        err2{obj_idx, img_idx} = err_min;
        P_est_lm{obj_idx,img_idx} = P_iter{err_min_idx};
    end
end
save('temp1.mat');
%% draw_bounding_boxes

% RANSAC
for img_idx=1:1 %1:9
    draw_bounding_boxes(I{img_idx}, poses(:,img_idx) , P_est(:,img_idx) , bounding_boxes(:,img_idx));
end

% LM refinement
for img_idx=1:1 %1:9
    draw_bounding_boxes(I{img_idx}, poses(:,img_idx) , P_est_lm(:,img_idx) , bounding_boxes(:,img_idx));
end

%% Scores
% clear; load('temp1.mat');
for i=1:9
    scores_1{i} = eval_pose_estimates(poses(:,i) , P_est(:,i) , bounding_boxes(:,i));
    scores_2{i} = eval_pose_estimates(poses(:,i) , P_est_lm(:,i) , bounding_boxes(:,i));
end

avg_scores_set_1 = [];
avg_scores_set_2 = [];
scores_1_hist = [];
scores_2_hist = [];
for obj_idx = 1:7
    for img_idx = 1:9
        % average scores
        avg_scores_set_1 = [avg_scores_set_1 scores_1{img_idx}{obj_idx}];
        avg_scores_set_2 = [avg_scores_set_2 scores_2{img_idx}{obj_idx}];
        % for histogram
        scores_1_hist = [scores_1_hist scores_1{img_idx}{obj_idx}];
        scores_2_hist = [scores_2_hist scores_2{img_idx}{obj_idx}];
        % to display
        scores_display_1(obj_idx,img_idx) = scores_1{img_idx}{obj_idx};
        scores_display_2(obj_idx,img_idx) = scores_2{img_idx}{obj_idx};
    end
    avg_scores_1(obj_idx) = mean(avg_scores_set_1);
    avg_scores_2(obj_idx) = mean(avg_scores_set_2);
end

% plots
figure(); histogram(scores_1_hist,63);
figure(); histogram(scores_2_hist,63);

clc
mean(avg_scores_set_1,'all')
mean(avg_scores_set_2,'all')
