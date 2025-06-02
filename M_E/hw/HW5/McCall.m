function w_R = calculate_reserve_wage(alpha, b)
    % 定义参数
    w_min = 10; % 最小工资
    w_max = 40; % 最大工资
    n = 1000; % 离散化点的数量
    % alpha = 0.2; % job separation rate
    beta = 0.98; % discount rate
    gamma = 0.7; % job offer rate
    sigma = 2; % utility parameter
    % b = 6; % unemployment benefit
    rho = 1; % 初始化收敛性参数
    
    % 计算离散化的工资点
    w = linspace(w_min, w_max, n+1);
    
    % 初始价值函数猜测
    VE = zeros(n+1, 1);
    VU = 0;
    
    % 收敛性阈值
    tolerance = 1e-9;
    
    max_iter = 10000; % 最大迭代次数
    for iter = 1:max_iter
        VE_new = zeros(n+1, 1);
        VU_new = 0;
        
        % 更新VE
        for j = 1:n+1
            u_w = (w(j)^(1-sigma) - 1)/(1 - sigma);
            VE_new(j) = u_w + beta*(alpha*VU + (1 - alpha)*VE(j));
        end
        
        % 更新VU
        u_b = (b^(1-sigma) - 1)/(1 - sigma);
        expectation = 0;
        for j = 1:n+1
            expectation = expectation + (max(VE(j), VU)) / (n+1);
        end
        VU_new = u_b + beta*((1 - gamma)*VU + gamma*expectation);
        
        % 检查收敛性
        diff_VE = max(abs(VE_new - VE));
        diff_VU = abs(VU_new - VU);
        rho = max(diff_VE, diff_VU);
        VE = VE_new;
        VU = VU_new;
        
        if rho < tolerance
            break;
        end
    end
    idx = find(VE > VU, 1, 'first');
    w_R = w(idx);
    % disp(['Converged after ', num2str(iter), ' iterations.']);
end

% 绘制图形
w_min = 10; % 最小工资
w_max = 40; % 最大工资
n = 1000; % 离散化点的数量
alpha = 0.2; % job separation rate
beta = 0.98; % discount rate
gamma = 0.7; % job offer rate
sigma = 2; % utility parameter
b = 6; % unemployment benefit
rho = 1; % 初始化收敛性参数

% 计算离散化的工资点
w = linspace(w_min, w_max, n+1);

% 初始价值函数猜测
VE = zeros(n+1, 1);
VU = 0;

% 收敛性阈值
tolerance = 1e-9;

max_iter = 10000; % 最大迭代次数
for iter = 1:max_iter
    VE_new = zeros(n+1, 1);
    VU_new = 0;
    
    % 更新VE
    for j = 1:n+1
        u_w = (w(j)^(1-sigma) - 1)/(1 - sigma);
        VE_new(j) = u_w + beta*(alpha*VU + (1 - alpha)*VE(j));
    end
    
    % 更新VU
    u_b = (b^(1-sigma) - 1)/(1 - sigma);
    expectation = 0;
    for j = 1:n+1
        expectation = expectation + (max(VE(j), VU)) / (n+1);
    end
    VU_new = u_b + beta*((1 - gamma)*VU + gamma*expectation);
    
    % 检查收敛性
    diff_VE = max(abs(VE_new - VE));
    diff_VU = abs(VU_new - VU);
    rho = max(diff_VE, diff_VU);
    VE = VE_new;
    VU = VU_new;
    
    if rho < tolerance
        break;
    end
end
disp(['Converged after ', num2str(iter), ' iterations.']);
figure;
plot(w, VE, 'b', 'LineWidth', 2);
hold on;
yline(VU, 'r--', 'LineWidth', 2);
xlabel('Wage (w)');
ylabel('Value Function');
legend('V_E(w)', 'V_U', 'Location', 'NorthWest');
title('Value Functions V_E and V_U');
grid on;

% 找到保留工资 w_R
idx = find(VE > VU, 1, 'first');
w_R = w(idx);
disp(['Reservation wage: ', num2str(w_R)]);

% alpha迭代
reserve_wages_alpha = zeros(0, 46);
alpha = 0.05:0.01:0.5;
for i = 1:46
    reserve_wages_alpha(i) = calculate_reserve_wage(alpha(i), 6);
end
figure;
plot(alpha, reserve_wages_alpha, 'b', 'LineWidth', 2);
hold on;
xlabel('alpha');
ylabel('Reserve wage(w_R)');
title('Reserve Wage And Alpha');
grid on;

% benefit迭代
reserve_wages_beta = zeros(0, 131);
benefit = 2:0.1:15;
for i = 1:131
    reserve_wages_beta(i) = calculate_reserve_wage(0.2, benefit(i));
end
figure;
plot(benefit, reserve_wages_beta, 'b', 'LineWidth', 2);
hold on;
xlabel('Beta');
ylabel('Reserve Wage(w_R)');
title('Reserve Wage And Beta');
grid on;