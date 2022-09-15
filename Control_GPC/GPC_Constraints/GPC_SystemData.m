function [Bd,Ad,N,Nu,Ql,Qd,F,G,Gif]=GPC_SystemData 


%% System Data 

T=0.1;                          %Sample time in seconds
B=[0.2963];                     %Numerator transfer function 
A=[1 0.00185];                  %Denominator transfer function
d=120;                          %Dead time of the system

sys=tf(B,A)                     %Continuous-time transfer function 

sysd=c2d(sys,T)                 %Discretizes the continuous-time dynamic system model 
                                %sys using zero-order hold on the inputs and a sample 
                                %time of T.

[Bd,Ad]=tfdata(sysd,'v');       %Numerator and denominator of the discrete 
                                %transfer function

if Bd(1)==0
    Bd=Bd(2:end);               %Delete first element of the vector if equal to zero. 
end       

%% GPC Tuning Parameters

N=20;                           %Window Prediction
N1=d+1;                         %Minimum costing horizon
N2=d+N;                         %Maximum costing horizon
Nu=N;                           %Control horizon
lambda=18;                     %Control weighting sequence 
Ql=eye(Nu)*lambda;              %Control weighting sequence matrix
delta=10;                       %Reference error weighting sequence        
Qd=eye(Nu)*delta;               %Reference error weighting sequence matrix


%% Diophantine_Solution 

[En,F] = Diophantine_Solution(Ad,N2,d); %Diophantine equation solution
E=En(end,:);                            %E polynomial
F=F(1:N,1:end);                         %F polynomial

%% G Matrix calculation

g=conv(E,Bd);                           %Calculus g polynomial 

G=zeros(N,Nu);                          %Initialization G matrix
 
for m=1:Nu
    G(m:end,m)=g(1:Nu-m+1);             %G Matrix                  
end

%% Free response past inputs

Gif=zeros(N1,N)';

aux=N-1;
for j=1:Nu

    Gi=conv(En(j,:),Bd);
    
        if length(Gi) < N1+aux-1 
            Gi=[Gi zeros(1,(N1+aux-1)-length(Gi))]; 
        end
    
    Gif(j,:)=Gi(1,N1+aux-1);
    
    aux=aux+1;
end


end