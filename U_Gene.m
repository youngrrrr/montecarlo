% Given parameters
S0 = 15.6;     % In millions
r = 0.36;      % Balance sheet growth from 1995 to 1996
T = 1/3;       % 4 months, from May 1 to September 1
K = S0 * 0.95; % Exercise strike

delta = 0.0001;
steps = T / delta;
v_t_est = 0;

% Estimated parameters
sdev = 0.70283; % Estimated using historical data based on Parexel's stock performance from January 1, 1997 to May 1, 1997

trials = 10000;

paths_y = zeros(trials,int16(steps));
path_x = 0:delta:T-delta;

for j=1:trials
    % Reinitialize on every trial
    s_prev = S0;
    s_curr = S0;
    s_max = S0;

    % Normal samples
    u1 = rand(uint64(steps/2),1);
    u2 = rand(uint64(steps/2),1);
    x = sqrt(-2 * log(u1)) .* cos(2 * pi * u2);
    y = sqrt(-2 * log(u1)) .* sin(2 * pi * u2);
    standard_samples = [x;y];
    
    path_y = zeros(1,int16(steps));

    for i=1:steps
        % Conditional
        s_curr = exp(log(s_prev) + (r - 0.5*(sdev^2))*delta + sdev*sqrt(delta)*standard_samples(i));

        path_y(i) = s_curr;
        s_prev = s_curr;
    end

    if (s_curr - K) > 0
        v_t_est = v_t_est + (s_curr - K);
    end

    paths_y(j,:) = path_y;
end

v_t_est = v_t_est / trials;

V_0 = exp(-r*T)*v_t_est

%plot(path_x, paths_y);
