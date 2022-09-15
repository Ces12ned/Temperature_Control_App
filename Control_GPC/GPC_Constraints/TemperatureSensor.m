function TF=TemperatureSensor(a)


persistent rAux vcc beta temp0 r0 i T tt Tem


if isempty(rAux)
    
    rAux = 10000.0;        %Physical resistance at the voltage divider
    vcc = 5.0;             %Input voltage at the voltage divider
    beta = 3889.0;         %Beta constant given by the manufacturer of the Thermistor NTC 56A1002-C3 (Alphatechnics)
    temp0 = 298.15;        %Room temperature (25°C) Written in Kelvin
    r0 = 10000.0;          %(R25) Thermistor resistance value at room temperature (temp0)
    i = 0;
    T = zeros();
    tt = zeros();
    Tem = zeros();

end


i = i+1;


%% Get Temperature

    % Read current voltage value
    Thermocouple_Sensor=readVoltage(a,'A0');    %Voltage reading on analog pin 0
    % Calculate temperature from voltage (based on data sheet)
    rntc = rAux / ((vcc/Thermocouple_Sensor)-1);     %Calculation of the resistance of the NTC (voltage divider)
    temperatureK = beta/(log(rntc/r0)+(beta/temp0)); % Temperature calculation in Kelvin
    TemperatureR=temperatureK-273.15;
    
    T(1,i)=TemperatureR;    
    

     TF = lp_filter(T(1,i));
     
     Tem(1,i) = TF;
    
     tt(1,i) = i;
       
     disp(TF)
    
     assignin('base','Tem',T)
     assignin('base','TemF',Tem)
     assignin('base','Time',tt)
     assignin('base','TF',TF)

end