%% 导入风化铅钡数据
opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:N26";

% 指定列名称和类型
opts.VariableNames = ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
Untitled1 = readtable("归一化 铅钡 风化.xlsx", opts, "UseExcel", false);

% 清除临时变量
clear opts
%% 导入无风化铅钡数据
opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:N25";

% 指定列名称和类型
opts.VariableNames = ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
Untitled2 = readtable("归一化 铅钡 无风化.xlsx", opts, "UseExcel", false);

% 清除临时变量
clear opts

%% 导入风化高钾数据
opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:N7";

% 指定列名称和类型
opts.VariableNames = ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
Untitled3 = readtable("归一化 铅钡 无风化.xlsx", opts, "UseExcel", false);

% 清除临时变量
clear opts

clc;clear
close all
%% 导入无风化高钾数据

opts = spreadsheetImportOptions("NumVariables", 14);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:N13";

% 指定列名称和类型
opts.VariableNames = ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 导入数据
Untitled4 = readtable("归一化 铅钡 无风化.xlsx", opts, "UseExcel", false);

% 清除临时变量
clear opts
%% 计算统计评估系数
for ii=1:4
matrixname=['Untitled' num2str(ii)];
data2_part=table2array(eval(matrixname));
data2_mean=mean(data2_part)'; % 平均值
data2_std=std(data2_part)'; % 标准差
data2_max=max(data2_part)'; % 最大值
data2_min=min(data2_part)'; % 最小值
data2_kur=kurtosis(data2_part)'; % 峰度
data2_coef=(data2_std./data2_mean); % 变异系数
data2_ske=skewness(data2_part)'; % 偏度
Var={'化学成分','平均值','标准差','最大值','最小值','峰度','变异系数','偏度'};
ClosNames={"SiO2";"Na2O"; "K2O"; "CaO"; "MgO"; "Al2O3"; "Fe2O3"; "CuO"; "PbO";"BaO";"P2O5"; "SrO"; "SnO2"; "SO2"};
T=table(ClosNames,data2_mean,data2_std,data2_max,data2_min,data2_kur,data2_coef,data2_ske,'VariableNames',Var);
% writetable(T,'第一题统计数据.xls','Sheet',ii,'Range','A2:H30')
end
disp('运行结束')