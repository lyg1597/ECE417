function [A_accurcy,B_accurcy,C_accurcy,D_accurcy,overall_accurcy]=mp2_test(feat,dim1,dim2,knn_num,feature)

A_correct = 0;
B_correct = 0;
C_correct = 0;
D_correct = 0;
for i=1:80
    [~,class]=knn(i,feature,knn_num);
    if fix((i-1)/20)==class
        if fix((i-1)/20)==0 
            A_correct=A_correct+1;
        elseif fix((i-1)/20)==1
            B_correct=B_correct+1;
        elseif fix((i-1)/20)==2
            C_correct=C_correct+1;
        elseif fix((i-1)/20)==3
            D_correct=D_correct+1;
        end
    end
end
A_accurcy=A_correct/20;
B_accurcy=B_correct/20;
C_accurcy=C_correct/20;
D_accurcy=D_correct/20;
overall_accurcy = (A_accurcy+B_accurcy+C_accurcy+D_accurcy)/4;    
text1=['Feat = ',feat,', Input Dims = [',num2str(dim1),' ',num2str(dim2),'], kNN = ',num2str(knn_num)];
disp(text1);
text2=['A: ',num2str(fix(A_accurcy*10000)/100),'%  B: ',num2str(fix(B_accurcy*10000)/100),'%  C: ',num2str(fix(C_accurcy*10000)/100),'%  D: ',num2str(fix(D_accurcy*10000)/100),'%  Overall: ',num2str(fix(overall_accurcy*10000)/100),'%'];
disp(text2);
disp(' ');