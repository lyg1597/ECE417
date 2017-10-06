function run(data_folder,T)
%RUN Summary of this function goes here
%   Detailed explanation goes here
speaker = 65;
number = 1;
instance = 97;
data_set=zeros(T,100);
for i = 1:100
    file_name=[data_folder,char(speaker),num2str(number),char(instance),'.wav'];
    [data,Fs]=audioread(file_name);
    data=imresize(data(:,1,[T,1]));
    data_set(:,i)=data(1:T,1);
    if mod(i,25) == 0
        speaker=speaker+1;
    end
    if mod(i,5) == 0
        number = number+1;
    end
    
    instance = instance+1;
    
    if speaker > 68
        speaker = 65;
    end
    
    if number > 5
        number = 1;
    end
    
    if instance > 101
        instance = 97
    end
end
        

end

