% 参数设置
lambda = 0.3;   % 失业者找到工作的概率
alpha = 0.2;   % 就业者失去工作的概率
r = 0.0124;       % 进入劳动力市场的率
d = 0.00822;       % 退出劳动力市场的率

% 初始值
E0 = 138;      % 初始就业人数
U0 = 12;       % 初始失业人数
T = 50;         % 迭代期数

% 初始化存储数组
E = zeros(1, T);
U = zeros(1, T);
E(1) = E0;
U(1) = U0;
N(1) = E0 + U0;

% 迭代计算
for t = 1:T-1
    E_next = (1 - d)*(1 - alpha)*E(t) + (1 - d)*lambda*U(t);
    U_next = (1 - d)*alpha*E(t) + (1 - d)*(1 - lambda)*U(t) + r*(E(t) + U(t));
    N_next = (1 + r - d)*N(t);
    E(t+1) = E_next;
    U(t+1) = U_next;
    N(t+1) = N_next;
end

% 绘图
time = 1:T;
figure;
plot(time, E, 'b-', 'LineWidth', 2);
hold on;
plot(time, U, 'r--', 'LineWidth', 2);
plot(time, N, 'k-.', 'LineWidth', 2);
xlabel('Time Period');
ylabel('Population');
legend('Employed (E_t)', 'Unemployed (U_t)', 'Total Population (N_t)');
title('Employment, Unemployment, and Total Population Dynamics Over 50 Periods');
grid on;

% 计算就业率和失业率，绘图
e = zeros(1, T);
u = zeros(1, T);
for t = 1:T
    e(t) = E(t) / N(t);
    u(t) = U(t) / N(t);
end
time = 1:50;
figure;
plot(time, e, 'b-', 'LineWidth', 2);
hold on;
plot(time, u, 'r--', 'LineWidth', 2);
xlabel('Time Period');
ylabel('Rate');
legend('Employment Rate (e_t)', 'Unemployment Rate (u_t)');
title('Employment Rate and Unemployment Rate Dynamics Over 50 Periods');
grid on;

% 计算稳态就业率和失业率的函数
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

[e_steady, u_steady] = compute_steady_state(0.92, 0.08, lambda, alpha, r, d);
fprintf('稳态就业率: %.4f\n', e_steady); % 0.5854
fprintf('稳态失业率: %.4f\n', u_steady); % 0.4146

function impulse_response_baby_boom(e_steady, u_steady)
    % 参数设置
    lambda = 0.3;   % 失业者找到工作的概率
    alpha = 0.2;   % 就业者失去工作的概率
    r_normal = 0.0124;  % 正常时期的进入劳动力市场的率
    r_high = 0.0248;    % 人口冲击时期的进入率
    d = 0.00822;           % 退出劳动力市场的率
    shock_duration = 10; % 冲击持续期数
    
    % 初始化存储数组
    e = zeros(1, 1000);
    u = zeros(1, 1000);
    e(1) = e_steady;
    u(1) = u_steady;
    
    % 迭代计算
    t = 1;
    while true
        if t <= shock_duration
            r = r_high; % 冲击期使用高进入率
        else
            r = r_normal; % 冲击后恢复原进入率
        end
        
        % 更新就业人数和失业人数
        e_next = ((1 - d)*(1 - alpha)*e(t) + (1 - d)*lambda*u(t)) / (1 + r - d);
        u_next = ((1 - d)*alpha*e(t) + (1 - d)*(1 - lambda)*u(t) + r*(e(t) + u(t))) / (1 + r - d);
        e(t+1) = e_next;
        u(t+1) = u_next;

        rho = (e(t+1) - e(t))^2 + (u(t+1) - u(t))^2;
        tol = 1e-9;
        if rho < tol & t > 10
            break;
        end
        t = t + 1;
    end
    fprintf('t: %i\n', t);
    
    % 绘图
    time = 1:t;
    figure;
    plot(time, e(1:t), 'b-', 'LineWidth', 2);
    hold on;
    plot(time, u(1:t), 'r--', 'LineWidth', 2);
    xlabel('Time Period');
    ylabel('Rate');
    legend('Employment Rate (e_t)', 'Unemployment Rate (u_t)');
    title('Impulse Response to a Baby Boom');
    grid on;
    
    % 标记冲击期
    fill([time(1) time(shock_duration) time(shock_duration) time(1)], ...
         [0 0 1 1], 'g', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
    text(shock_duration/2, 0.9, 'Baby Boom Shock', 'Color', 'g');
end

impulse_response_baby_boom(e_steady, u_steady);