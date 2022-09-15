%%Plot

TT =Time*0.1    %Transform iteration vector to time vector. 



%Plot Time vs Temperature without MAF
 
figure
plot(TT,Tem)
xlabel('Time (sec)')
ylabel('Temperature (\circC)')
ylim([25,70])
hold off

%Plot Time vs Temperature with MAF

figure
plot(TT,TemF)
xlabel('Time (sec)')
ylabel('Temperature (\circC)')
ylim([25,70])
hold off

%Plot Time vs Control Signal

figure
plot(TT,u)
xlabel('Time (sec)')
ylabel('u')
hold off


%% Save results to a file

T = table(TT',Tem',TemF',u','VariableNames',{'Time_sec','Temp_C','TempF_C','u'});
filename = 'Temperature_Data.xlsx';
% Write table to file 
writetable(T,filename)
% Print confirmation to command line
fprintf('Results table with %g temperature measurements saved to file %s\n',...
    length(TT),filename)


