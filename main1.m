clc;clear
close all
%% 设置导入选项并导入数据
opts = spreadsheetImportOptions("NumVariables", 15);

% 指定工作表和范围
opts.Sheet = "表单2";
opts.DataRange = "A2:O70";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ImportErrorRule = "error";

% 指定变量属性 空值赋0.00001
opts = setvaropts(opts, "VarName1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName1", "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"], "FillValue", 1e-05);
opts = setvaropts(opts, ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"], "TreatAsMissing", '');

% 导入数据
data1 = readtable("附件.xlsx", opts, "UseExcel", false);

% 清除临时变量
clear opts

% 判断数据 1为符合条件，0为不符
data1_part = table2array(data1(:,2:end));
opts=sum(data1_part,2);
index=[];
for ii=1:size(opts,1)
    if opts(ii)>85&&opts(ii)<105
        data1_part(ii,15)=1;
    else
        data1_part(ii,15)=0;
        index=[index;ii];
    end
end
clear opts

% 剔除数据
for jj=1:size(index,1)
    data1(index(jj),:)=[];
    index=index-1;
end
data1_part = table2array(data1(:,2:end));
data1_part(find(~data1_part))=0.0001;
% 数据归一化
opts=sum(data1_part,2);
data1_part_normalize=data1_part./opts;

%% CLR(form 归一化)
geo_mean_nor=geomean(data1_part_normalize,2);
for ii=1:length(geo_mean_nor)
    data1_CLR_nor(ii,:)=log(data1_part_normalize(ii,:)./geo_mean_nor(ii));
end
%% CLR(form 原始数据)
geo_mean_orig=geomean(data1_part,2);
for ii=1:length(data1_part)
    data1_CLR_orig(ii,:)=log(data1_part(ii,:)./geo_mean_orig(ii));
end
