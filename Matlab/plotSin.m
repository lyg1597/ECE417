function plotSin(f1,f2)

if nargin==1
    x=linspace(0,2*pi,f1*16+1)
    y=sin(f1*x)
    plot(x,y)
else
    x=linspace(0,2*pi,f1*16+1);
    y=linspace(0,2*pi,f2*16+1);
    [X,Y]=meshgrid(x,y);
    Z=sin(f1*X)+sin(f2*Y);
    subplot(2,1,1)
    imagesc(Z);
    colorbar;
    axis xy;
    subplot(2,1,2)
    surf(X,Y,Z);
    colormap(hot(255));
    shading interp;
end
