% 灰色关联分析
clc;clear
close all
%% 导入归一化数据
opts = spreadsheetImportOptions("NumVariables", 16);

% 指定工作表和范围
opts.Sheet = "Sheet1";
opts.DataRange = "A2:P19";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"];
opts.VariableTypes = ["categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ImportErrorRule = "error";

% 指定变量属性
opts = setvaropts(opts, ["VarName1", "VarName2"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"], "FillValue", 1e-05);
opts = setvaropts(opts, ["SiO2", "Na2O", "K2O", "CaO", "MgO", "Al2O3", "Fe2O3", "CuO", "PbO", "BaO", "P2O5", "SrO", "SnO2", "SO2"], "TreatAsMissing", '');

% 导入数据
Untitled = readtable("C:\Users\LZZ\Desktop\数学建模2023\2022C\归一化 铅钡.xlsx", opts, "UseExcel", false);

clear opts
data_part=table2array(Untitled(:,3:end));
data_mean=mean(data_part,1);
z_Fnormalize=data_part./data_mean;
data1=z_Fnormalize;
%% 灰色关联分析
% 画图
figure(1)
x=1:size(data1,1);
plot(x,data1(:,1),'LineWidth',2)
hold on 
for i=1+1:size(data1,2)
    plot(x,data1(:,i),'--')
    hold on
end
xlabel('样本点')
legend('氧化钠(Na2O)','氧化钾(K2O)','氧化钙(CaO)','氧化镁(MgO)',...
    '氧化铝(Al2O3)',',氧化铁(Fe2O3)','氧化铜(CuO)','氧化铅(PbO)',...
    '氧化钡(BaO)','五氧化二磷(P2O5)','氧化锶(SrO)','氧化锡(SnO2)','二氧化硫(SO2)')
title('灰色关联分析')


for jj=1:size(data_part,2)
    opts=z_Fnormalize;
    opts(:,jj)=[];
    data1=opts;clear opts
    opts=z_Fnormalize(:,jj);
% 计算 子序列 与 主序列 之间的灰色关联度
%得到其他列和参考列相等的绝对值
data2=abs(data1(:,1:end)-opts);
%得到绝对值矩阵的全局最大值和最小值
d_max=max(max(data2));
d_min=min(min(data2));
%灰色关联矩阵
a=0.5;   %分辨系数
zeta=mean((d_min+a*d_max)./(data2+a*d_max))';
% 制作zeta_table
opts=num2cell(zeta);
name={'二氧化硅(SiO2)';'氧化钠(Na2O)';'氧化钾(K2O)';'氧化钙(CaO)';'氧化镁(MgO)';...
    '氧化铝(Al2O3)';',氧化铁(Fe2O3)';'氧化铜(CuO)';'氧化铅(PbO)';...
    '氧化钡(BaO)';'五氧化二磷(P2O5)';'氧化锶(SrO)';'氧化锡(SnO2)';'二氧化硫(SO2)'};
name(jj)=[];
colname={'化学成分','关联系数'};
zeta_table=table(name,opts,'VariableNames',colname);
zeta_table=sortrows(zeta_table,{'关联系数'},{'descend'});
% writetable(zeta_table,'zeta_table.xls','Sheet',jj,'Range','A2:B15')
end
