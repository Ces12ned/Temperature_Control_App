function TF=TemperatureSensor(a)


persistent rAux vcc beta temp0 r0 i T tt Tem


if isempty(rAux)
    
    rAux = 10000.0;        %Physical resistance at the voltage divider.
    vcc = 5.0;             %Input voltage at the voltage divider.
    beta = 3889.0;         %Beta constant given by the manufacturer of the Thermistor NTC 56A1002-C3 (Alphatechnics).
    temp0 = 298.15;        %Room temperature (25°C) Written in Kelvin.
    r0 = 10000.0;          %(R25) Thermistor resistance value at room temperature (temp0).
    i = 0;                 %Iteration.
    T = zeros();           %Temperature vector. 
    tt = zeros();          %Iterations vector.
    Tem = zeros();         %Filtered temperature vector. 

end


i = i+1;                    %Iteration update. 


%% Get Temperature

    % Read current voltage value.
    Thermocouple_Sensor=readVoltage(a,'A0');         %Voltage reading on analog pin 0.
    
    % Calculate temperature from voltage (based on data sheet).
    rntc = rAux / ((vcc/Thermocouple_Sensor)-1);     %Calculation of the resistance of the NTC (voltage divider).
    temperatureK = beta/(log(rntc/r0)+(beta/temp0)); %Temperature calculation in Kelvin.
    TemperatureR=temperatureK-273.15;                %Temperature calculation in Celsius. 
    
    T(1,i)=TemperatureR;                             %Save temperature in celsius on the T vector. 
    

     TF = lp_filter(T(1,i));                         %Use MAF on the measured temperature. 
     
     Tem(1,i) = TF;                                  %Save filtered mesured temperature on Tem vector. 
    
     tt(1,i) = i;                                    %Save iteration on the tt vector. 
       
     disp(TF)                                        %Display filtered measured temperature. 
    
    
    
    
     assignin('base','Tem',T)                        %Save measured temperature vector at the workspace. 
     assignin('base','TemF',Tem)                     %Save filtered measured temperature vector at the workspace.
     assignin('base','TF',TF)                        %Save measured temperature in celsius at the workspace.
     assignin('base','Time',tt)                      %Save iteration vector at the workspace.

end