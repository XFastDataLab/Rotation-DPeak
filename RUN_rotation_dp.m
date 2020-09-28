%################################################################################
% Author : Ming Yan, Yewang Chen
% Email  : 19014083027@stu.hqu.edu.cn,ywchen@hqu.edu.cn
% Version:1.0
% Date   :2020/5/11             
% College of Computer Science and Technology£¬ Huaqiao University, Xiamen, China
% Copyright@hqu.edu.cn
%################################################################################
%%
%Method 1: Establish a quadratic equation based on the parameter c and select the density peaks
clc;
clear;
disp('Reading orginal data')
load('.\RotationDP_Data\data6.mat');
disp('\Reading input distance matrix')
load('.\RotationDP_Data\data6_distances.mat');
disp('Reading completed')

%Hyperparameter
percent=4; %Select the percentage of dc,default:percent=2
a=3;       %The parameter 'a' of the quadratic curve after rotating the decision chart
theta=pi/6;%Angle of hyperbola rotation,default:theta=pi/4           
percent_rho=5;  %Find noise:Take the percent of rho
percent_delta=5;%Find noise:After take the percent of delta

disp('Starting Rotation-DPeak in c')
%Method 1: Establish a quadratic equation based on the parameter c and select the density peaks
c=0.29;     %The parameter 'c' of the quadratic curve after rotating the decision chart
rotation_dp_c( distances, percent,a,c,points,percent_rho,percent_delta,theta);

%%
%Method 2: Take K points in the curve as the density peaks
clc;
clear;
disp('Reading orginal data')
load('.\RotationDP_Data\data2.mat');
disp('\Reading input distance matrix')
load('.\RotationDP_Data\data2_distances.mat');
disp('Reading completed')

%Hyperparameter
percent=2; %Select the percentage of dc,default:percent=2
a=2;       %The parameter 'a' of the quadratic curve after rotating the decision chart
theta=pi/4;%Angle of hyperbola rotation,default:theta=pi/4           
percent_rho=5;  %Find noise:Take the percent of rho
percent_delta=5;%Find noise:After take the percent of delta

disp('Starting Rotation-DPeak in K')
%Method 2: Establish a quadratic equation based on the parameter k and select the density peaks
K=6;     %Select the k large points before the previous gamma value in the quadratic curve as the density peaks.
rotation_dp_k( distances, percent,a,K,points,percent_rho,percent_delta,theta);