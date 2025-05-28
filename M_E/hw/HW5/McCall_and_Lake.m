% 定义参数
w_min = 10; % 最小工资
w_max = 40; % 最大工资
n = 5000; % 离散化点的数量
alpha = 0.2; % job separation rate
beta = 0.98; % discount rate
gamma = 0.7; % job offer rate
sigma = 2; % utility parameter
b = 2:20; % unemployment benefit sequence
rho = 1; % 初始化收敛性参数
e = 0.8; % 就业率
u = 0.2; % 失业率
x = zeros(10001, 2);
x(1,:) = [e, u];
r = 0.0124; % 进入劳动力市场的率
d = 0.00822; % 退出劳动力市场的率
welfare = zeros(20, 0); % 不同b的社会福利
employment_rate = zeros(20, 0); % 不同b的就业率
unemployment_rate = zeros(20, 0); % 不同b的失业率

% 计算离散化的工资点
w = linspace(w_min, w_max, n+1);

% 收敛性阈值
tolerance = 1e-9;

% Lake，计算稳态就业率和失业率的函数
function [e_steady, u_steady] = compute_steady_state(e_initial, u_initial, lambda, alpha, r, d)
    % 初始化容忍度和初始值
    tol = 1e-9;
    x = [e_initial; u_initial]; % 初始量

    % 构建矩阵A
    A = [(1 - d)*(1 - alpha), (1 - d)*lambda;
         (1 - d)*alpha + r, (1 - d)*(1 - lambda) + r];

    % 迭代计算稳态
    while true
        x_next = (1 / (1 + r - d)) * A * x;
        rho = sum((x_next - x).^2); % 总平方差

        if rho < tol
            break;
        end

        x = x_next;
    end

    e_steady = x(1);
    u_steady = x(2);
end

max_iter = 10000; % 最大迭代次数
% 循环sequence b
for num = 1:19
    e_i = 0; % b(num)时的失业率
    u_i = 0; % b(num)时的就业率
    VU_i = 0; % b(num)时的VU
    VE_i = zeros(n+1, 1);% b(num)时的不同工资的VE
    w_R = 0; % 保留工资
    idx = 0; % 保留工资的位置
    % Lake迭代
    for count = 1:max_iter
        VE = zeros(n+1, 1);
        VU = 0;
        % McCall值迭代
        for iter = 1:max_iter
            VE_new = zeros(n+1, 1);
            VU_new = 0;
            tao = x(count,2) * b(num);

            % 更新VE
            for j = 1:n+1
                u_w = ((w(j) - tao)^(1-sigma) - 1)/(1 - sigma);
                VE_new(j) = u_w + beta*(alpha*VU + (1 - alpha)*VE(j));
            end

            % 更新VU
            u_b = ((b(num) - tao)^(1-sigma) - 1)/(1 - sigma);
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
                VU_i = VU;
                VE_i = VE; % 传递最终结果
                break;
            end
        end

        % disp(['Converged after ', num2str(iter), ' iterations.']);

        % 找到保留工资 w_R
        idx = find(VE > VU, 1, 'first');
        w_R = w(idx);
        % disp(['Reservation wage: ', num2str(w_R)]);

        % Lake模型
        lambda = gamma * sum(w >= w_R) / (n+1);
        [e_steady, u_steady] = compute_steady_state(x(count,1), x(count,2), lambda, alpha, r, d);
        x(count+1,:) = [e_steady, u_steady];
        row = x(count, :);
        row_next = x(count+1, :);
        rho = max(abs(row_next - row));
        if rho < tolerance
            e_i = x(count+1, 1);
            u_i = x(count+1, 2);
            % fprintf('(e, u): (%.4f, %.4f)\n', e_i, u_i);
            break;
        end
    end
    total = 0;
    for k = 1:sum(w >= w_R)
        total = total + VE_i(idx + k - 1) / (1+n);
    end
    welfare(num) = u_i * VU_i + total;
    unemployment_rate(num) = u_i;
    employment_rate(num) = e_i;
end

% 绘制图形
figure;
plot(b, welfare, 'b', 'LineWidth', 2);
hold on;
xlabel('Benefit (b)');
ylabel('Welfare');
% legend('V_E(w)', 'V_U', 'Location', 'NorthWest');
title('Welfare with Different Benefit');
grid on;

figure;
plot(b, employment_rate, 'b', 'LineWidth', 2);
hold on;
xlabel('Benefit (b)');
ylabel('Employment Rate');
% legend('V_E(w)', 'V_U', 'Location', 'NorthWest');
title('Employment Rate And Unemployment Rate');
grid on;

figure;
plot(b, unemployment_rate, 'b', 'LineWidth', 2);
hold on;
xlabel('Benefit (b)');
ylabel('Unemployment Rate');
% legend('V_E(w)', 'V_U', 'Location', 'NorthWest');
title('Employment Rate And Unemployment Rate');
grid on;