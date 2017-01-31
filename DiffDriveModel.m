function [] = DiffDriveModel(X,Y,t,speed,type)
%set X,Y as initial coordinates
%t is time you wnt to run simulation for
%speed (only necessary for turning simulations is the amount you wish to
%multiply the right motor's speed by
%for type, 1 is for straight line simulations and 2 is for turning
%simulations
Vr = 0.147*1000;
Vl = 0.147*1000;
if type == 1;
    X = X
    Y = Y
    theta = -pi/2;
    for i =1:1
        [X Y] = GoStraight(Vr,Vl,t,X,Y,theta);
        i=i+1;
    end
end
if type == 2;
    X = X
    Y = -Y
    theta = pi/2;
    for i =0:0
        [X Y theta] = GoRoundCorner(Vr*speed,Vl,t,X,Y,theta);
        i=i+1;
    end
end
