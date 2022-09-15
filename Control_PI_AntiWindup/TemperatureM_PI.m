function ttc=TemperatureM(a)
    
    
    %% Task configuration
    ttc=timer;                           %Make timer name ttc. 
    ttc.Period = 0.1;                    %Sampling period.
    ttc.ExecutionMode = 'fixedRate';     %Determine execution mode as fixed rate.
    ttc.TasksToExecute = Inf;            %Determine infinite executions. 
    ttc.StartDelay = 0.1;                %Start delay. 
   
    ttc.TimerFcn = @(~,~)Measurement(a); %Call Measurement function.
end


function Measurement(a)


    TF = TemperatureSensor(a);   %Call TemperatureSensor function.
    
    PIDControl(a,TF);            %Call PIDControl function.
   
end



 


   