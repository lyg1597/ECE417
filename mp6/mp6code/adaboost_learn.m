DOFULL = 0;

% load all the rectangles
load('../rects/allrects.txt','-ascii');
% face rectangles
posrects=allrects(:,17:32);
% none face rectangles
negrects=allrects(:,33:48);

% read directory
jpgdir='../jpg';
images=dir([jpgdir,'/*.jpeg']);

numtrain = round(0.75*length(images));
for k=1:numtrain
    A=imread([jpgdir,'/',images(k).name]);
    II(:,:,k)=integralimage(A);
end

W=ones([numtrain,8]);
Y=[ones(numtrain,4),zeros(numtrain,4)];

BETAS = [];
CLASSIFIERS = zeros(0,9);
NSAMPS = 6;

for t=1:(40^DOFULL)
    W=W/sum(sum(W));
    
    bestwtderr = Inf;
    for xmin=0:(DOFULL*(NSAMPS-1))
        for ymin=0:(DOFULL*(NSAMPS-1))
            disp(sprintf('%d: [%d,%d]',t,xmin,ymin));
            for rwid=1:(NSAMPS-xmin)^DOFULL                     % for width
                for rhgt=1:(NSAMPS-ymin)^DOFULL                     % for height
                    fr = [xmin,ymin,rwid,rhgt]/NSAMPS;                  % fractional rectangle
                    for vert = 0:DOFULL
                        for order=(1+vert):(4-vert)^DOFULL
                            F=rectfeature(II,[posrects,negrects],fr,order,vert);
                            [theta,pola,err]=bestthreshold(F,Y,W);
                        
                            if err<bestwtderr
                                disp(sprintf('%d: [%d,%d,%d,%d],%d,%d: %g < %g with %g, %d',...
                                    t,xmin,ymin,rwid,rhgt,vert,order,err,bestwtderr,theta,pola));
                                bestclassifier = [xmin,ymin,rwid,rhgt,vert,order,theta,pola];
                                bestwtderr=err;
                            end
                        end % for order
                    end % for vert
                end % for rhgt
            end % for rwid
        end % for ymin
    end % for xmin
    
    BEATS(t) = bestwtderr / (1-bestwtderr);
    CLASSIFIERS(t,:) = [bestclassifier,BEATS(t)];
    disp(sprintf('e(%d) = %g; best rectfeature [%d,%d,%d,%d]:%d,%d %g, %d',...
        t,bestwtderr,bestclassifier));
    
    rectf = bestclassifier(1:4)/NSAMPS;
    vert = bestclassifier(5);
    order = bestclassifier(6);
    theta = bestclassifier(7);
    p = bestclassifier(8);
    X = rectfeature(II,[posrects,negrects],rectf,order,vert);
    
    H=(p*X<p*theta);
    W(H==Y)=W(H==Y)*BEATS(t);
end

if DOFULL
    save('learned_classifiers.txt','CLASSIFIERS','-ascii');
end
                