function [ Output ] = singlenode_schedule(varargin)
format bank;
addpath('../MatlabCommon/','../MatlabCommon/export_fig-master/','../../packages/glmnet_matlab');

filename = Create_BM();
m        = length(filename);
opt     = propertylist2struct(varargin{:});
opt     = set_defaults(opt,'display',1,'k',7,'N',1,'W',100*ones(m,1),'model','quadratic');
   
% Options
N           = opt.N;
k           = opt.k;
W           = opt.W;
% Load data
for i = 1:(k-1)
    dat{i}    = loaddata_general(i+1); 
    Y{i}      = dat{i}.yy;
    X{i}      = dat{i}.xx;
    Yerror{i} = dat{i}.err;
end

% Baseline in paper
[ MEM,IPC,L3R ] = activity_vectors();

%% glmnet Estimation method
fprintf('**************    Scheduling using glmnet Estimation method    **************\n');
pp = [1,0.7];
timee     = zeros(N,6);

for i = 1:N 
    main_itr_loop = tic;
    %% EST
    Y_rnd = normrnd_sp(Y, Yerror); 
    for j = 1:length(pp)   
        % Samples
        NumSamples = 0;
        for ii = 1:length(Y_rnd)
            p = pp(j);
            if(pp(j)~=1 && pp(j)~=0 ) 
                switch ii
                case 1
                    p = 0.7;
                case 2
                    p = 0.4;
                otherwise
                    p = 0.2;    
                end
            end
            NumSamples=NumSamples+p*size(Y_rnd{ii},1);
            [Yhat{ii},acc(ii),acc_est(ii) ,name,~,~ ] = glmnet_new(...
                X{ii}, Y_rnd{ii}, p,'model',opt.model);
            if(opt.display==1)
                fprintf('p = %5.2f, multi-%d, acc_est = %5.2f, acc_train = %5.2f \n',...
                    p,ii+1,acc(ii),acc_est(ii));
            end
        end
        Schedule = schedule_cover_controller(Yhat,Y,Yerror, W ,'LLF',...
            MEM,'name',name,'display',0);   
        Output.EST{j}.sched = Schedule;  timee(i,j) = Schedule.time;
    end
    Schedule = baseline_general( MEM,Y_rnd, W, 'name', 'MEM');
    Output.MEM.sched = Schedule;  timee(i,3) = Schedule.time;
    
    Schedule = baseline_general( IPC,Y_rnd, W, 'name', 'IPC');
    Output.IPC.sched = Schedule;   timee(i,4) = Schedule.time;
    
    Schedule = baseline_general( L3R,Y_rnd, W, 'name', 'L3R');
    Output.L3R.sched = Schedule;    timee(i,5) = Schedule.time;
    
    Schedule = baseline_general( randperm(m),Y_rnd, W, 'name','RND');
    Output.RND.sched = Schedule;    timee(i,6) = Schedule.time; 
    if(opt.display==1)
        fprintf('i = %d -- OPT = %.0f, EST = %.0f, MEM = %.0f, IPC = %.0f, L3R = %.0f, RND = %.0f \n',...
        i, timee(i,1),timee(i,2),timee(i,3),timee(i,4),timee(i,5),timee(i,6));
    end
       
    toc(main_itr_loop)
end
Output.timee = timee;
end