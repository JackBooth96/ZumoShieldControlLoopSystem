function [Xp,Yp,Tp] = GoRoundCorner(Vr,Vl,tspan,x0,y0,theta)
    if Vr == Vl
        error('Vr and Vl must not be equal')
    end
    theta = theta+pi/2;
    t = [0:0.01:tspan];
    l = 105;
    w = (Vr-Vl)/l;
    R = (l/2)*((Vl+Vr)/(Vr-Vl));
    ICCx = (x0-R*sin(theta));
    ICCy = (y0+R*cos(theta));
    X = (cos(w.*t).*(x0-ICCx))+(-sin(w.*t).*(y0-ICCy))+ICCx;
    Y = (sin(w.*t).*(x0-ICCx))+(cos(w.*t).*(y0-ICCy))+ICCy;
    plot(X,-Y,'g')
    grid on
    hold on
    Xp = cos(w.*tspan).*(x0-ICCx)+(-sin(w.*tspan).*(y0-ICCy))+ICCx;
    Yp = sin(w.*tspan).*(x0-ICCx)+(cos(w.*tspan).*(y0-ICCy))+ICCy;
    Tp = (theta+(pi/2))+w.*tspan;
end