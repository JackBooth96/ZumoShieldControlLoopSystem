function [X,Y] = GoStraight(Vr,Vl,tspan,x0,y0,theta)
    t = [0:0.01:tspan];
    Xp = x0+(((Vr+Vl)/2).*t).*sin(theta);
    Yp = y0+(((Vr+Vl)/2).*t).*cos(theta);
    plot(Xp,Yp,'r')
    hold on     
    X = x0+(((Vr+Vl)/2)*tspan)*sin(theta);
    Y = y0+(((Vr+Vl)/2)*tspan)*cos(theta);
end