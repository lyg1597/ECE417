function run
%RUN function to run the mp1 program and plot the result
%   Detailed explanation goes here

cbirMP;
pvec = [];
p = [];
done = false;
while ~done
    pvec = [pvec p];    
    done = input('Enter 1 to exit, 0 to continue: ');
    done = logical(done);
end
close all;
plot(pvec);
xlim([1 3]); 
ylim([0 1]); 
grid on;  

end

