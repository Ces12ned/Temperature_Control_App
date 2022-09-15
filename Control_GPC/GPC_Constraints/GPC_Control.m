function GPC_Control(Bd,Ad,N,Nu,Ql,Qd,F,G,Gif,a,TF)

%% Control signal calculation

persistent w ym u uf u_l duf pin i Fs lFs lGif 


   %% Loop initial conditions 
        
          

if isempty(ym)        
        
        w=63;       %Reference 
        ym=zeros(); %Output system initialization. 
        u=zeros();  %Control input signal system initialization.
        uf=zeros(); %
        u_l=0;      %Control input calculation (Amplitude limit) initialization.
        pin = 'D9'  %Digital Pin for PWM output
        i=1;
         
        Fs=size(F); %F matrix size
        lFs=Fs(1,2);%F polynomial lenght    
        
        lGif=size(Gif); % Free response past inputs size
        lGif=lGif(1,1); % Free response past inputs lenght 
        duf=zeros(N,lGif); %Past increments inputs vector

end   

     
i=i+1;


    ym(i)=TF; %Output system

    %Free response calculation  

            f=0;        %Free response reinitialization.

            for k=1:lFs
                f=f+ym(i-k+1)*F(:,k);        
            end
            
            for k=1:N
                
                for j=1:2
                     fdu(k,j)=Gif(k,1)*duf(k,j);
                end 
      
                fdus(k,1)=fdu(k,j-1)-fdu(k,j);
      
            end
                   f=f+fdus;  %Free response
                   
                   
                   % Change upper limit when prediction reach 60 Celsius
                   
                    if f(N,1)>=60
                    
                        ub=0.5;          %Upper limit
                    else 
                        
                        ub=1;            %Upper limit
                    end
              

   %% Control signal calculation with amplitude limits  
    
   
              I=eye(Nu);                   %Identity matrix
              Triang=tril(ones(Nu));       %Lower triangular matrix
              l=ones(Nu,1);                %Vector of ones                      
              u_max=ub*ones(Nu,1);         %Control signal amplitude upper limit
              u_min=-0*ones(Nu,1);         %Control signal amplitude lower limit 
              InUmax=0.5*ones(Nu,1);      %Maximum increment
              InUmin=-0.5*ones(Nu,1);     %Minimum increment
              
              
              R=[I; -I; Triang; -Triang;];                          %Left side inequality constraint matrix    
              c=[InUmax; -InUmin; u_max-l*u(i-1); l*u(i-1)-u_min;]; %Right side inequality constraint matrix 
              
              %Uncomment next two lines if just want constraints in the
              %amplitude of the control signal.  
              
%             R=[Triang; -Triang;];
%             c=[u_max-l*u(i-1); l*u(i-1)-u_min;];



              H=2*(G'*Qd*G+Ql);                                            %H matrix get from cost function reduction
              b=2*(f-w)'*Qd*G;                                             %b matrix get from cost function reduction
              options = optimset('LargeScale','off');                      %Choose optimization parameter for medium-scale algorithms. 
              [x,fval,exitflag] = quadprog(H,b,R,c,[],[],[],[],[],options);%Solver for quadartic objective function the preceding problem using the optimization options specified in options.
              u_l=x(1);                                                    %Return first element of the real vector solution. 
              
              
            if i==1
                u(i)=u_l;

                if u(i)>1 
                    uo=1;
                writePWMDutyCycle(a,pin,uo);


                else

                    writePWMDutyCycle(a,pin,u(i));
                end

                assignin('base','u',u); 

            else
                 u(i)=u(i-1)+ u_l;
                    
                                 

                if u(i)>1 
                    uo=1;
                    u(i)=uo;
                writePWMDutyCycle(a,pin,u(i));       

                else
                    writePWMDutyCycle(a,pin,u(i));
                end
                
                assignin('base','u',u);
               


            end
            
        %Update Δu(t-1) for the free response calculation    
            
        duf_a=u(i)*ones(N,1);      
        duf_n=duf(:,1);
        duf=[duf_a,duf_n];
              
 
            

           





  

end
 