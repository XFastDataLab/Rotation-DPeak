%################################################################################################################
% Author : Ming Yan, Yewang Chen
% Email  : 19014083027@stu.hqu.edu.cn,ywchen@hqu.edu.cn
% Version:1.0
% Date   :2020/5/11             
% College of Computer Science and Technologyï¼?Huaqiao University, Xiamen, China
% Copyright@hqu.edu.cn
%################################################################################################################
function []= rotation_dp_k(distances, percent,a,K,points,percent_rho,percent_delta,theta)   
    [rho,ordrho,delta,ND,nneigh]=dpeak(distances,percent);     %computing rho and delta by original density peaks              
    
    %normalize delta and delta
    delta(ordrho(1))=max(delta(:));
    [rho,PS] = mapminmax(rho,0,1);
    [delta,PS] = mapminmax(delta,0,1);
    [delta_sorted,orddelta]=sort(delta,'descend');
    [rho_sorted,ordrho]=sort(rho,'descend');
    %end of normalization 
    
    %draw decision graph
    disp('Generated file:DECISION GRAPH')
    disp('column 1:Density')
    disp('column 2:Delta')
    fid = fopen('DECISION_GRAPH', 'w');
    for i=1:ND
       fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
    end

    NCLUST=0;    
    for i=1:ND
      cl(i)=-1;                                                %initialize cluter id for each point
    end
    
    T=[cos(theta) -sin(theta); sin(theta) cos(theta)];         %Rotation matrix
    deta_gamma_delta=[rho; delta];
    new_data=T*deta_gamma_delta;                               %Rotating   
    new_data=new_data';
    
    figure(1);
    plot(new_data(:,1),new_data(:,2),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
    axis([-0.9 0.9 0 1.6]);
    hold on
    
    z=new_data(:,2)-a*new_data(:,1).^2;                        %decision gap: y-a*x^2
    [~,indice]=sort(z,'descend');
    ids=indice(1:K);                                           %pick density peaks by selecting top K points with the largest decision gap      
    c=z(ids(K),1);                                             %determine equation: y=a*x^2 +c, which pass throught the last peak.
    
    %plot the curve of y=a*x^2+c
    x=-1:0.1:1;                                                
    y=a*x.^2+c;
    plot(x,y,'Color',[0.945 0.463 0.4]);
    
    new_rho=new_data(:,1);
    new_delta=new_data(:,2);
    for i=1:length(ids)                                        %Computing cluster center
        NCLUST=NCLUST+1;
        cl(ids(i))=NCLUST;  
        icl(NCLUST)=ids(i);
    end

    % figure(1);
    fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
    disp('Performing assignation')

    for i=1:ND                                                %assignation
      if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));  
      end
    end

    for i=1:ND                                                %calculate noise
      halo(i)=cl(i);
    end
    if (NCLUST>1)
        des_percent_rho=rho_sorted(ceil(ND-0.01*percent_rho*ND));          %Obtain the first batch of noise points 
        des_percent_delta=delta_sorted(ceil(0.01*percent_delta*ND));       %according to the percentage of delta and rho
        for i=1:ND
           if ((rho(i)<=des_percent_rho)&&(delta(i)>=des_percent_delta)) 
             halo(i)=0;
           end
        end
        for m=1:5
          for i=1:ND
            if (halo(i)==0)
                  for j=1:ND
                     if(nneigh(j)==i)          %If a certain point is a noise point, then all the child nodes of this point are noise points.           
                         halo(j)=0;
                     end
                  end
            end
          end
        end
    end

    for i=1:NCLUST
      nc=0;
      nh=0;
      for j=1:ND
        if (cl(j)==i) 
          nc=nc+1;
        end
        if (halo(j)==i)                      %print the values of CLUSTER, CENTER, ELEMENTS, CORE, HALO
          nh=nh+1;
        end
      end
      fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
    end

    cmap=colormap;
    for i=1:NCLUST
       ic=int8((i*60.)/(NCLUST*1.));        %Mark the cluster center in the decision graph
       figure(1)
       hold on
       plot(new_rho(icl(i)),new_delta(icl(i)),'o','MarkerSize',7,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
    figure(2)
    disp('Performing 2D nonclassical multidimensional scaling')

    xlabel ('X')
    ylabel ('Y')
    for i=1:ND
     A(i,1)=0.;
     A(i,2)=0.;
    end
    shapes='o*^+sx*<pd.^ph>dv';
    for i=1:NCLUST                          %Draw the scatter plot
      nn=0;
      ic=int8((i*60.)/(NCLUST*1.));      
      for j=1:ND
        if (halo(j)==i)
          nn=nn+1;
          A(nn,1)=points(j,1);
          A(nn,2)=points(j,2);
        end
      end
      shapeindex= mod(icl(i),length(shapes))+1;
      hold on
      plot(A(1:nn,1),A(1:nn,2),shapes(shapeindex),'MarkerSize',6,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end

    faa = fopen('CLUSTER_ASSIGNATION', 'w');
    disp('Generated file:CLUSTER_ASSIGNATION')
    disp('column 1:element id')
    disp('column 2:cluster assignation without halo control')
    disp('column 3:cluster assignation with halo control')
    for i=1:ND                              %Mark noise points as black points
       fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));
       if halo(i)==0
          h=plot(points(i,1),points(i,2),'.','MarkerSize',5,'MarkerEdgeColor','k');
       end
       for j=1:NCLUST                       %Mark density peaks as the red circle
          if i==ids(j)
              m=plot(points(i,1),points(i,2),'o','MarkerSize',5,'linewidth',2,'MarkerEdgeColor','r');
          end
       end
    end
    legend([m,h],'density peaks','noise','Location','northeast');
end