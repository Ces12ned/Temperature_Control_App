function TF=TemperatureSensor(a)

%This function returns the current filtered temperature measured by the NTC  


persistent rAux vcc beta temp0 r0 i T tt Tem


if isempty(rAux)
    
    rAux = 10000.0;        %Physical resistance at the voltage divider
    vcc = 5.0;             %Input voltage at the voltage divider
    beta = 3889.0;         %Beta constant given by the manufacturer of the Thermistor NTC 
                                %56A1002-C3 (Alphatechnics)
    temp0 = 298.15;        %Room temperature (25C) Written in Kelvin
    r0 = 10000.0;          %(R25) Thermistor resistance value at room 
                                %temperature (temp0)
    
    i = 0;                 % Set up counter to 0
    T = zeros();           % Set up T vector
    tt = zeros();          % Set up tt vector
    Tem = zeros();         % Set up Tem vector

end

i = i+1;                   % Updates counter


%% Get Temperature

 % Read current voltage value
 Thermocouple_Sensor=readVoltage(a,'A0');         %Voltage reading on analog pin 0
 rntc = rAux / ((vcc/Thermocouple_Sensor)-1);     %Calculation of the resistance of the 
                                                     %NTC (voltage divider)
 temperatureK = beta/(log(rntc/r0)+(beta/temp0)); %Temperature calculation in Kelvin
 TemperatureR=temperatureK-273.15;                %Get temperature in Celcius
    
 T(1,i)=TemperatureR;                             %Save the current raw temperature 
                                                     %measured by the NTC 
    
 TF = lp_filter(T(1,i));                          %Apply a Low Pass Filter to the current
                                                     %raw temperature measured by the NTC
     
 Tem(1,i) = TF;                                   %Saves the filtered measured temperature
                                                     %in a vector.  
    
 tt(1,i) = i;                                     %Counter
       
 disp(TF)                                         %Displays in the Command Window the 
                                                     %current filtered measured temperature
      
   
 assignin('base','Tem',T)                        %Assign value of 'Tem' vector to variable 'T' 
                                                     %in the base workspace
 assignin('base','TemF',Tem)                     %Assign value of 'TemF' vector to variable 'Tem'
                                                     %in the base workspace
 assignin('base','Time',tt)                      %Assign value of 'Time' vector to variable 'tt'
                                                     %in the base workspace

end