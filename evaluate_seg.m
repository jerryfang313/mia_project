function score = evaluate_seg(id, x,y,r,labelmask,x_true,y_true,r_true,t)
% Evaluation for segmentation
% Before use : 
% --- Make sure you have getim.m in the same directory
% --- Make sure you have ground truth mask('xml' and 'raw') in the same directory
%
% Input: 
%          id ----- the id of 'mdb213.pgm' is 213
%           x ----- x coordinate of your circle
%           y ----- y cooridnate of your circle
%           r ----- radius of your circle
%   labelmask ----- the Binary mask you get
%      x_true ----- x coordinate of ground truth circle
%      y_true ----- y coordiante of ground truth circle
%      r_true ----- radius of ground truth circle
%           t ----- running time in seconds 

%% (0) To see if MC you detected are in your circle
    stats= regionprops(bwconncomp(labelmask,4),'centroid'); 
    count_valid = 0;
    total = size(stats,1);
    removelist = [];
%     [rr,cc] = meshgrid(1:1024);
%     C1 = (fix(sqrt((rr-x).^2+(cc-y).^2))==fix(r));
%     labelmask(C1) = 1;
%     imagesc(labelmask);colormap gray;axis square
%     hold on
    for i = 1 : total
         cx = stats(i).Centroid(1);
         cy = stats(i).Centroid(2);
         % to see if the centroid of each 'component' microcalcification is
         % outside the ground-truth circle
         if (x - cx)^2 + (y-cy)^2 <= r^2
             count_valid = count_valid + 1;
         else
             removelist = [removelist;i];
             %plot(x,y,'g+', 'MarkerSize', 2);
             %stats(i) = [];
         end
    end

    stats(removelist) = [];
    if total == 0
        V = 0;
    else
        V = count_valid/total;
    end
    m_v = ['Valid MC percentage : ', num2str(V),',',num2str(count_valid),'/',num2str(total)];
    
%% (1) Dice coefficient between your circle area and true circle area
    [rr, cc] = meshgrid(1:1024);
    
    C = sqrt((rr-y).^2+(cc-x).^2)<=r;
    C_true = sqrt((rr-y_true).^2+(cc-x_true).^2)<=r_true;
    C_inter = ((C==1)&(C_true==1));
    
    % Sørensen?Dice coefficient :  D = 2|X intersect Y|/ (|X|+|Y|)
    union = (sum(sum(C==1))+ sum(sum(C_true==1)));
    D = 2*(sum(sum(C_inter)))/union;
    m_D = ['Dice coefficient : ', num2str(D)];
    
%% (2) False microclacification outside ground-truth circle (False Alarm)
    count_fa = 0;
    total = size(stats,1);
    for i = 1 : total
         cx = stats(i).Centroid(1);
         cy = stats(i).Centroid(2);
         % to see if the centroid of each 'component' microcalcification is
         % outside the ground-truth circle
         if (x_true - cx)^2+(y_true-cy)^2 > r_true^2
             count_fa = count_fa + 1;
         end
    end
    if total ==0
        FA =0;
    else
        FA = count_fa/total;
    end
    
    m_fa = ['False Alarm : ',num2str(FA),',', num2str(count_fa),'/',num2str(total)];
    
%% (3) True microcalcification in your circle (Detection Rate)
    file = ['mdb',num2str(id),'_ubMask.raw'];
    label_true = getim(file);
    stats_true= regionprops(bwconncomp(label_true,4),'centroid');
    count_detect = 0;
    total2 = size(stats_true,1);
    for i = 1 :total2
        cx_true = stats_true(i).Centroid(1);
        cy_true = stats_true(i).Centroid(2);
        if (x-cx_true)^2+(y-cy_true)^2 <= r^2
            count_detect = count_detect + 1;
        end
    end
    d = count_detect/total2;
    m_d = ['MC detected rate : ', num2str(d),',',num2str(count_detect),'/',num2str(total2)];
    
%% (4) Speed
    if t < 10
        T = 1;
    else
        T = exp(-(t-10)/10);
    end
    m_t = ['Time efficiency : ',num2str(T)];
    
%% (5) Score and display
    if FA == 0 && d == 1 && V == 1 && r < r_true
        score = 1;
    else
        score = V*T*(D+d+1-FA)/3;
    end
    
    m_s = ['Score : ', num2str(score)];
    icondata = ([1:128]'*[1:128])/64;
    if score >= 0.9
        iconmap = [0 1 0];
    elseif score < 0.9 && score >= 0.6
        iconmap = [1 1 0];
    elseif score < 0.6 && score > 0
        iconmap = [1 0 0];
    else
        iconmap = [0 0 0];
    end
    h = msgbox({m_v m_D m_fa m_d m_t m_s},'Segmentation Evaluation','custom',icondata,iconmap);
th=findall(h,'type','text');
     set(th,'fontsize',20);
     set(th,'fontname','Times New Roman');
     set(th,'color',[0 0 0]);
     set(h, 'position', [400 440 450 200]); 
end