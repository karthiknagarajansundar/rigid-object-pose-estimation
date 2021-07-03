function [in,P_est] = outlier_rejection(U, u)

    % init param
    epsilon = 0.01; alpha = 0.95; s = 3; t = 0;
    T = 1.5 * ceil(log(1-alpha)/log(1-epsilon^s));
    
    while t <= T
        % 3 random correspondences 
        ind = randsample(size(U, 2), 3);
        
        % respective U and u
        U_rand = U(:, ind);
        u_rand = pextend(u(:, ind));
        
        % minimalCameraPose
        Ps = minimalCameraPose(u_rand, U_rand);

        % compute inliers 
        in = []; f_in = 0;
        
        for k = 1:length(Ps)
            err = compError(Ps{k},U,u);
            current_in = sum((err <= 0.020));

            % saving best solution of maximun inliers
            if f_in < current_in
                f_in = current_in;
                in = find((err <= 0.020));
                P_est = Ps{k};
            end
        end
        
        % update param
        epsilon = current_in/size(U,2);
        T = 1.5 * ceil(log(1-alpha)/log(1-epsilon^s));        
        t = t + 1;
    end

end
