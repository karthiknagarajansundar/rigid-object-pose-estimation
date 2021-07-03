function err = compError(P,U,u)
    U = pextend(U);
    u_est = pflat(P*U);
    u_est = u_est(1:2,:);
	err = abs(vecnorm(u) - vecnorm(u_est));
end
