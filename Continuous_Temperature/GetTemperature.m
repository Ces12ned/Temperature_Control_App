function ttc=GetTemperature(a)
    
    
    %% Task configuration
    ttc= timer;    
    ttc.Period = 0.1;    % mean sampling period
    ttc.ExecutionMode = 'fixedRate';
    ttc.TasksToExecute = Inf;
    ttc.StartDelay = 0;   
   
    ttc.TimerFcn = @(~,~)Measurement(a);
end


function Measurement(a)
   
TF = TemperatureSensor(a);        %Call TemperatureSensor Function
       
end