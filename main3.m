clc;clear
close all
%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 16);

% 指定工作表和范围
opts.Sheet = "表单3";
opts.DataRange = "A2:P9";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["string", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ImportErrorRule = "error";

% 指定变量属性
opts = setvaropts(opts, "VarName1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "VarName2"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"], "FillValue", 1e-05);
opts = setvaropts(opts, ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"], "TreatAsMissing", '');

% 导入数据
S2 = readtable("C:\Users\LZZ\Desktop\数学建模2023\2022C\附件.xlsx", opts, "UseExcel", false);

% 清除临时变量
clear opts

data_part=table2array(S2(:,3:end));

% 归一化
opts=sum(data_part,2);
data_part_normalize=data_part./opts;