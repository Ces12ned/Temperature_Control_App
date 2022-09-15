function ttc=TemperatureM(a,PWM)
    
    
    %% Task configuration
    ttc= timer;    
    ttc.Period = 0.1;    % mean sampling period
    ttc.ExecutionMode = 'fixedRate';
    ttc.TasksToExecute = Inf;
    ttc.StartDelay = 0.1;   
   
    ttc.TimerFcn = @(~,~)Measurement(a,PWM);
end


function Measurement(a,PWM)

persistent pin i u

if isempty(pin)

pin = 'D9';                       %Digital Pin for PWM output
i=0;
u=zeros();

end
i=i+1;

writePWMDutyCycle(a, pin, PWM);  %Write PWM (a,pin,PWM Value)

u(1,i)=PWM;

assignin('base','u',u);

disp(PWM)
    
TF = TemperatureSensor(a);        %Call TemperatureSensor Function
       
end



 


   