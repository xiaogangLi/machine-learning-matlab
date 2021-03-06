function result = WeightedKNN(trainX, trainclassY,testZ, k, weight,type) 
 
% Classify using the Nearest neighbor algorithm 

% Inputs: 
% trainX	       - Train sample matrix, n*d, n points, each d dimentions 
% trainclassY	   - class of trainX, n*1 
% testZ            - Test sample matrix , N*d 
% k		           - Number of nearest neighbors  
% type             - specified measure distance: 2norm, 1norm  etc.

% Outputs: 
% result	       - class of testZ, N*1 
 
%  判断trainX和testZ的样本点维数是否相同                                       
if size(trainX,2) ~= size(testZ,2)                                       
    error ('trainX and testZ must have same column dimensions !')         %  维数d应该相同 
end    
 
%  判断k近邻是否可取 
n= length(trainclassY);                                                   %  训练样本点个数    
if ( n < k)                                 
   error('You specified more neighbors than existed points.') 
end                                                                       %  选择的近邻数不大于样本点数 

class               = unique(trainclassY);                                %  unique(x)表示列出数组x不重复的元素，并按降序排列，这里可以排出类别数目 
N                   = size(testZ, 1);                                     %  testZ的行数，即测试集的样本点数 
result              = zeros(N, 1);                                        %  初始化result矩阵,N*1列向量标出testZ的类别 
 
%  确定使用的度量距离，若未指定，默认为2norm ,默认所有数据权重相等
if  nargin < 6                                                            %  nargin表示函数输入变量的个数，<6即type未输入 
    type = '2norm';                                                       %  L2范数，即用欧氏距离
end

%未指定样本权重，默认权重相等
if nargin < 5
    weight = ones(n,1);                                                  %  样本数据权重都相等，为1
    type = '2norm'
end
 
%  按照所选的度量距离，对testZ的N个点逐个进行k近邻分类  
switch type                                                               %  对type分类 
     
case '2norm'                                                              %  使用L2范数，欧氏距离 
    for i = 1:N 
        dist = sum((trainX - ones(n,1)*testZ(i,:)).^2,2)./weight          %  dist 表示第i个测试点分别与n个训练样本点之间的欧式距离的平方 
        [m, indices]    = sort(dist);                                     %  按升序排列距离    
        histclass       = hist(trainclassY(indices(1:k)), class);         %  取前k个最短距离对应的点所属的类别，按照class进行直方图统计,histclass为class中各类出现的次数 
        [c, best]       = max(histclass);                                 %  c取所属类别出现最多的那个类别的次数，best标记出c在histclass中对应index，即为class中index 
        result(i)       = class(best);                                    %  testZ的第i个点取best在class中对应的类别 
    end 
     
case '1norm'                                                              %  使用L1范数，即 Manhatan 距离 
    for i = 1:N 
        dist = sum(abs(trainX - ones(n,1)*testZ(i,:)),2)./weight          %  dist 表示第i个测试点分别与n个训练样本点之间的L1距离 
        [m, indices]    = sort(dist);    
        histclass       = hist(trainclassY(indices(1:k)), class); 
        [c, best]       = max(histclass); 
        result(i)       = class(best); 
    end 
     
%case 'match'           使用match（匹配）距离，相同元素越多，越匹配，距离越大 
%    for i = 1:N 
%        dist            = sum(trainX == ones(n,1)*testZ(i,:),2);  若相同取1，否则取0 
%        [m, indices]    = sort(dist,2);  按降序排列，距离最大表示最匹配 
%        histclass       = hist(trainclassY(indices(1:k)), class); 
%        [c, best]       = max(histclass); 
%        result(i)       = class(best); 
%    end 
     
otherwise 
    error('Unknown measure function'); 
end
