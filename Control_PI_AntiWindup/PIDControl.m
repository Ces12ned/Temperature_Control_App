function PIDControl(a,TemperatureR)


persistent Kp Ki ei_prev PI PIMax PIMin u0 pin i us

T0 = 63;                     %Desired Temperature.

if isempty(ei_prev)
    
    ei_prev = 0;             %Previous Integral error. 
    Kp = -0.3311 - 0.0189 ;  %Proportional Gain.
    Ki = -8.43e-3 + 0.43e-3; %Integral Gain.  
    u0 = 0.24;               %Control signal offset.
    i = 0;                   %Iteration. 
    us = zeros();            %Control signal vector. 
    
 %Saturation Limits.

    PI=0;                    %PI Control initialization. 
    PIMax = 0.01;            %PI-AntiWindUp maximum saturation value.
    PIMin = -0.01;           %PI-AntiWindUp minimum saturation value.
    
    
end

pin = 'D9';                   %Digital Pin for PWM output. 


i=i+1;                        %Iteration update.

%% PI-AntiWindUp

 e = TemperatureR - T0;       %Temperature (signal) error. 
 
 P=Kp*e;                      %Proportional term.
 
 ev = e;                      %Integral switching error.
 ei = ev*0.1 + ei_prev;       %Integral error.
 
   % AntiWind-up Clamping
 if PI > PIMax && -e*PI>0     %First AntiWindUp conditional.
     
     ev = 0;                  %Integral switching error goes to zero.  
     ein=ev*0.1+ei_prev;      %Integral error. 
     I = ein*Ki;              %Integral term.
     PI=P+I;                  %Control calculation.
     ei_prev=ein;             %Integral error update. 
     u = sqrt(u0^2 + PI);     %Control signal.
     
     %Saturator 
      
     if u<=0
         
         u=0;
     
     writePWMDutyCycle(a,pin,u);  %Send PWM to Arduino Board.
     us(1,i)=u;                   %Save the control signal in the us vector.
     assignin('base','u',us);     %Save control signal at the workspace.
     disp([u,ei]);                %Display control signal and integral error
                                    %on the command window. 
         
     elseif u>=1
         
         u=1;
         
     writePWMDutyCycle(a,pin,u); 
     us(1,i)=u;                  
     assignin('base','u',us);    
     disp([u,ei]);              

     
     else 
         
     writePWMDutyCycle(a,pin,u); 
     us(1,i)=u;
     assignin('base','u',us);
     disp([u,ei]);
     
     end
 
 elseif PI < PIMin && -e*PI>0   %Second AntiWindUp conditional
     
     ev = 0;                     
     ein=ev*0.1+ei_prev;        
     I = ein*Ki;                
     PI=P+I;                    
     ei_prev=ein;               
     u = sqrt(u0^2 + PI);       
     
     %Saturator
     
     if u<=0
         
         u=0;
     
     writePWMDutyCycle(a,pin,u);
     us(1,i)=u;
     assignin('base','u',us); 
     disp([u,ei]);
         
     elseif u>=1
         
         u=1;
         
     writePWMDutyCycle(a,pin,u);  
     us(1,i)=u;
     assignin('base','u',us);
     disp([u,ei]);    
         
     else 
         
     writePWMDutyCycle(a,pin,u);
     us(1,i)=u;
     assignin('base','u',us);
     disp([u,ei]);
     
     end
 
 else 

     I=Ki*ei;               %Integal term
     PI=P+I;                %Control calculation
     ei_prev = ei;          %Integral error update
     u = sqrt(u0^2 + PI);   %Control sign
     
     
     %Saturator 
     
     if u<=0
         
         u=0;
     
     writePWMDutyCycle(a,pin,u);
     us(1,i)=u;
     assignin('base','u',us);
     disp([u,ei]);
         
         
     elseif u>=1
         
         u=1;
         
     writePWMDutyCycle(a,pin,u);  
     us(1,i)=u;
     assignin('base','u',us);
     disp([u,ei]);    
     
     else 
         
     writePWMDutyCycle(a,pin,u);
     us(1,i)=u;
     assignin('base','u',us);
     disp([u,ei]);
     
     end
  
 end 

 
 
end

 


   