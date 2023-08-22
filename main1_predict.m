% 化学成分预测
clc;clear

%% 导入高钾风化数据
opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:N19";

% 指定列名称和类型
opts.VariableNames = ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
clr_gaojia = readtable("clr 高钾.xlsx", opts, "UseExcel", false);
clr_gaojia=table2array(clr_gaojia(:,1:14)); 
level=[2;2;1;2;2;1;1;2;2;2;2;2;3;3;4;1;2;2];

% 按照风化等级排序
% 假设 level 和 clr_gaojia 已经定义和赋值

% 创建四个空矩阵用于存储分类后的数据
clr_gaojia_1 = [];
clr_gaojia_2 = [];
clr_gaojia_3 = [];
clr_gaojia_4 = [];

% 根据 level 进行分类
for i = 1:numel(level)
    switch level(i)
        case 1
            clr_gaojia_1 = [clr_gaojia_1; clr_gaojia(i, :)];
        case 2
            clr_gaojia_2 = [clr_gaojia_2; clr_gaojia(i, :)];
        case 3
            clr_gaojia_3 = [clr_gaojia_3; clr_gaojia(i, :)];
        case 4
            clr_gaojia_4 = [clr_gaojia_4; clr_gaojia(i, :)];
        otherwise
            error('未知的 level 值');
    end
end

% 清除临时变量
clear opts

%% 导入铅钡风化数据
opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A3:N27";

% 指定列名称和类型
opts.VariableNames = ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
clr_qianbei = readtable("风化 铅钡玻璃 clr.xlsx", opts, "UseExcel", false);
clr_qianbei=table2array(clr_qianbei);
% 清除临时变量
clear opts

%% 高钾拟合方程

clr_gaojia_mean1=mean(clr_gaojia_1,1);
clr_gaojia_mean2=mean(clr_gaojia_2,1);
clr_gaojia_mean3=mean(clr_gaojia_3,1);
clr_gaojia_mean4=mean(clr_gaojia_4,1);
data=[clr_gaojia_mean2;clr_gaojia_mean3;clr_gaojia_mean4];

% 假设 data 是一个 double 类型的矩阵，每一列代表一个变量

% 获取数据的大小
[m, n] = size(data);

% 创建一个空矩阵来存储回归方程的系数
coefficients = zeros(n, 3);  % 3 表示拟合二阶多项式模型

% 对每一列数据进行回归分析
for i = 1:n
    % 获取自变量和因变量
    x = (1:m)';
    y = data(:, i);
    
    % 拟合二阶多项式模型
    mdl = fitlm(x, y, 'poly2');
    
    % 存储回归方程的系数
    coefficients(i, :) = mdl.Coefficients.Estimate';
    
    % 获取 R 值
    r_squared = mdl.Rsquared.Ordinary;
    
    % 构建降幂形式的方程字符串
    b0 = mdl.Coefficients.Estimate(1);
    b1 = mdl.Coefficients.Estimate(2);
    b2 = mdl.Coefficients.Estimate(3);
    equation_str = sprintf('y = %.4fx^2 + %.4fx + %.4f', b2, b1, b0);
    
    % 打印回归方程、回归系数和 R 值
    fprintf('回归方程 %d: %s\n', i, equation_str);
    fprintf('R 值: %.6f\n', r_squared);
end

%% 铅钡拟合方程
% 获取矩阵的列数
numColumns = size(clr_qianbei, 2);
degree = 2;
% 创建矩阵来存储回归系数和R值
coeffs_R_matrix = zeros(degree+2, numColumns); % 4表示回归系数和R值的个数

% 对每一列数据进行回归拟合
for column = 1:numColumns
    % 获取当前列的数据
    data = clr_qianbei(:, column);
    
    % 拟合二次多项式 (二次回归)
    
    coeffs = polyfit(1:numel(data), data, degree);
    
    % 使用回归方程计算拟合值
    fitted_values = polyval(coeffs, 1:numel(data));
    
    % 计算相关系数R
    R = corrcoef(data, fitted_values);
    R = R(1, 2);
    
    % 存储回归系数和R值到矩阵中
    coeffs_R_matrix(:, column) = [coeffs.'; R];
    
    % 打印回归方程的系数和R值
    fprintf('Column %d: y = %.6f*x^2 + %.6f*x + %.6f, R = %.4f\n', column, coeffs(1), coeffs(2), coeffs(3), R);
end