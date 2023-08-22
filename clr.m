function res=clr(x)
opts=sum(x,2);
x_normalize=x./opts;
    geo_mean=geomean(x_normalize,2);
for ii=1:length(geo_mean)
    res(ii,:)=log(x_normalize(ii,:)./geo_mean(ii));
end
end