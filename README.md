# Rotation-DPeak
Density Peak (DPeak) is an effective clustering algorithm. It maps arbitrary dimensional data onto a 2-dimensional space, which yields cluster centers and outliers automatically
distribute on upper right and upper left corner, respectively. However, DPeak is not suitable for imbalanced data set with large difference in density, where sparse clusters are usually not identified. Hence, an improved DPeak, namely Rotation-DPeak, is proposed to overcome this drawback according to an simple idea: the higher density of a point p, the larger δ it should have such that p can be picked as a density peak, where δ is the distance from p to its nearest neighbor with higher density. Then, based on this idea, a new strategy for selecting density peaks is invented by a quadratic curve, instead of choosing points with the largest γ, where γ = ρ×δ. Experiments shows that the proposed algorithm obtains better performance on imbalanced data set, which proves that it is promising.

***********************************************************************************
 The Rotation-DPeak program was compiled under Windows using matlab R2016b.
*********************************************************************************** 

Files
===================================================================================
These program mainly containing:
- a startup code named `RUN_rotation_dp.m`.
- a dataset folder named `RotationDP_Data`.
- two main functions of Rotation-DPeak named `rotation_dp_c.m` and `rotation_dp_k.m`
- A code to calculate the distance between each point named `gendist.m`

Dataset Format
===================================================================================
The dataset should be given in a text file of the following format:
-First, prepare the data set, the format is two columns of data, no column number and row number are required.When using malab to read the given mat format data in the project, you can use the `load` function. By default, the variable name of the data matrix is named `points`.
For instance, the first 10 lines of the sample dataset "data4.mat"(whose data number is 1903 and dimension is 2) are shown as below:

-0.520646005085819	0.293612012914928  
-0.504458237959391	0.298871658423075  
-0.491045758053012	0.271197372056081  
-0.483753834975323	0.188044223374019  
-0.475571941102939	-0.119416545727582  
-0.471517705104794	0.223863418943912  
-0.465465827086863	0.273292620992041  
-0.463318783566958	0.258764633611583  
-0.455461579767554	0.322886076963542  
-0.454379381101554	0.301553916376130  

-Seconnd, prepare a file that calculates the distance between each point in the data set(if you already have this file, please ignore this step).
Use the "gendist.m" file in the project root directory to calculate the distance between the data points.

```matlab
load('RotationDP_Data\data4.mat');
```
save the distance calculation result.
```matlab
save 'data4_distances' distances;
```
Finally, you will get a three-column data set with the result of calculating the distance between each point.

An example of quick start
===================================================================================
Step1:
Open the startup code `RUN_rotation_dp.m`, and load the data sets we prepared already.
```matlab
load('.\RotationDP_Data\data4.mat');
load('.\RotationDP_Data\data4_distances.mat');
```

Step2:
Choose to use method ‘c’ or ‘k’ to select Density Peaks, and adjust parameters(if you don't know how to choose parameters, you can use the default parameters suggested in the notes.).
```matlab
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
```
```matlab
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
```

Step4:
-Press the “Run” button in Matlab and the code will be run.

 Output Format
===================================================================================
The running result is the decision graph and the Rotation-DPeak result graph.As shown below:
![](https://github.com/XFastDataLab/Rotation-DPeak/blob/master/RotationDP_Data/data4_RDP_decision.jpg)
![](https://github.com/XFastDataLab/Rotation-DPeak/blob/master/RotationDP_Data/data4_RDP_result.jpg)









