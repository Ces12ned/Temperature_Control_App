function ttc = TemperatureM_GPC(a,Bd,Ad,N,Nu,Ql,Qd,F,G,Gif)

    
    %% Task configuration
    ttc= timer;    
    ttc.Period = 0.1;    % mean sampling period
    ttc.ExecutionMode = 'fixedRate';
    ttc.TasksToExecute = Inf;
    ttc.StartDelay = 0.1;   
   
    ttc.TimerFcn = @(~,~)Measurement(a,Bd,Ad,N,Nu,Ql,Qd,F,G,Gif);
end



function Measurement(a,Bd,Ad,N,Nu,Ql,Qd,F,G,Gif)

    TF = TemperatureSensor(a);
    GPC_Control(Bd,Ad,N,Nu,Ql,Qd,F,G,Gif,a,TF)

end 