function run
%RUN function to run the mp1 program and plot the result
%   Detailed explanation goes here
for n=1:5
    disp(' ');
    text=['session: ',num2str(n)];
    disp(text);
    cbirMP;
    pvec = [];
    done = false;
    round=0;    
    while round<=3
       text=['round: ',num2str(round)];
        disp(text);
        done = input('Press any key to continue after pressing query: ');
        round=round+1;
        pvec = [pvec,evalin('base','p')];  
    end
    close;
    subplot(5,1,n);
    plot(pvec(2:4));
    text=['mp1 session ',num2str(n)];
    title(text);
    xlim([1 3]); 
    ylim([0 1]); 
    grid on;  
end

end

