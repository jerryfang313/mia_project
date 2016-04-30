function score = evaluate_reg(yourbox,truebox,t)
%% 1. Is it a box? 
    [R,C,Z] = ind2sub(size(yourbox),find(yourbox==1));
    edge = zeros(6,1);
    edge(1) = min(R);edge(3) = min(C);edge(5) = min(Z);
    edge(2) = max(R);edge(4) = max(C);edge(6) = max(Z);
    if isempty(find(yourbox(edge(1):edge(2),edge(3):edge(4),edge(5):edge(6))==0,1))
        isBox = 'Yes';
        box = 1;
    else
        isBox = 'No';
        box = 0;
    end
    m_box = ['  Is Box :',isBox];

%% 2. Dice coefficient (Jaccard)
    s_overlap = sum(sum(truebox(truebox == 1 & yourbox == 1)));
    s_I = sum(sum(sum(truebox==1)));
    in = sum(sum(truebox(truebox == 1 & yourbox == 1)));
    s_mybox = sum(sum(sum(yourbox)));
    out =  s_mybox - in;
    DC = (in*2)/(s_I+s_mybox);

    %m_over = ['  Overlap: ',num2str(in), '/', num2str(s_I),' (',num2str((in)/s_I),')'];
    %m_notin = ['  Not included: ', num2str(s_I - in), '/', num2str(s_I), ' (',num2str((s_I-in)/s_I),')'];
    %m_out = ['  Redundancy: ', num2str(out), '/', num2str(s_mybox),' (',num2str((out)/s_mybox),')'];
    m_s = ['  Dice coefficient: ', num2str(DC)];


%% 3. Edge distance
    [R0,C0,Z0] = ind2sub(size(truebox),find(truebox==1));
    edge0 = ones(6,1);
    edge0(1) = min(R0);edge0(3) = min(C0);edge0(5) = min(Z0);
    edge0(2) = max(R0);edge0(4) = max(C0);edge0(6) = max(Z0);
    d = sqrt(sum((edge0-edge).^2));
    m_d = ['  Distance deviation: ',num2str(d)];

%% 4. elapsed time    
    elapse = ['  Elapsed time: ',num2str(t)];

%% 5. score and display
    wd = 200;
    wt = 5000;
    if t < 300 
        t = 0;
    end
    
    score = box*(DC)*exp(-d/wd)*exp(-t/wt);
    m_score = [' Score : ',num2str(score)];
    icondata = ([1:128]'*[1:128])/64;
    if DC >= 0.9
        iconmap = [0 1 0];
    elseif DC < 0.9 && DC >= 0.6
        iconmap = [1 1 0];
    elseif DC < 0.6 && DC > 0
        iconmap = [1 0 0];
    else
        iconmap = [0 0 0];
    end
    h = msgbox({m_box m_s m_d elapse m_score},'Bounding Box Evaluation','custom',icondata,iconmap);
    th=findall(h,'type','text');
         set(th,'fontsize',20);
         set(th,'fontname','Times New Roman');
         set(th,'color',[0 0 0]);
         set(h, 'position', [400 440 450 180]); %makes box bigger

    result = truebox + yourbox;
    %mprov(result);colormap summer
end