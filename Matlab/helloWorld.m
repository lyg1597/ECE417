disp('Hello World!')
disp('I am going to learn MATLAB!')
myString='No type?'
disp(myString)
a = 10
c = 1.3*45-2*a
cooldude = 13/3
X=[a,c,cooldude]
disp(X)
row=[1,2,5.4,-6.6]
colum=[4;2;7;4]
a=[1,3;2,4]
b=[1,3]
c=[2,4]
d=[5;6]
e=[[[b;c],d,d];[b,c]]
start=clock
size(start)
length(start)
startString=datestr(start)
tau=1.5*24*3600
endOfClass=5*24
knowledgeAtEnd=1-exp((-endOfClass)/tau)
phrase=['At the end of 6.094,I will know ',num2str(knowledgeAtEnd*100),'% of MATLAB']
disp(phrase)
