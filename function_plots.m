% x = linspace(-20, 60, 100);
% y = [];
% 
% for i=1:length(x)
%     [new, ~] = test_function(x(i));
%     y = [y, new];
% end
% 
% plot(x, y, 'LineWidth', 3)
% axis([-15 40 -50 80])
% yline(0, 'k-', LineWidth=3)
% legend("Function", "X Axis", FontSize=14, Interpreter= "latex",  Location='northwest');
% title("Initial Test Function For Root Finding", 'FontSize', 16, "Interpreter","latex")
% ylabel("Test Function - F(x) (-)",'FontSize', 14, "Interpreter","latex")
% xlabel("Test Function - x (-)",'FontSize', 14, "Interpreter","latex")
% exportgraphics(gca, 'plots/test_func_1.png', 'Resolution', 300);
%This function generates the parametric curve describing an oval
%INPUTS:
%s: the curve parametr. s is a number from 0 to 1. The curve function has a
% period of 1, so s=.3 and s=1.3 will generate the same output
% s can also be a list (row vector) of numbers
%theta: rotation of the oval. theta is a number from 0 to 2*pi.
% Increasing theta rotates the oval counterclockwise
%x0: horizontal offset of the oval
%y0: vertical offset of the oval
%egg_params: a struct describing the hyperparameters of the oval
% egg_params has three variables, a,b, and c
% without any rotation/translation, the oval satisfies the equation:
% xˆ2/aˆ2 + (yˆ2/bˆ2)*eˆ(c*x) = 1
% tweaking a,b,c changes the shape of the oval
%OUTPUTS:
%V: the position of the point on the oval given the inputs
% If s is a single number, then V will have the form of a column vector
% [x_out;y_out] where (x_out,y_out) are the coordinates of the point on
% the oval. If the input t is a list of numbers (a row vector) i.e.:
% s = [s_1,...,s_N]
% then V will be an 2xN matrix:
% [x_1,...,x_N; y_1,...,y_N]
% where (x_i,y_i) correspond to input s_i
%G: the gradient of V taken with respect to s
% If s is a single number, then G will be the column vector [dx/ds; dy/ds]
% If s is the list [s_1,...,s_N], then G will be the 2xN matrix:
% [dx_1/ds_1,...,dx_N/ds_N; dy_1/ds_1,...,dy_N/ds_N]
function [V, G] = egg_func(s,x0,y0,theta,egg_params)
    %unpack the struct
    a=egg_params.a;
    b=egg_params.b;
    c=egg_params.c;
    %compute x (without rotation or translation)
    x = a*cos(2*pi*s);
    %useful intermediate variable
    f = exp(-c*x/2);
    %compute y (without rotation or translation)
    y = b*sin(2*pi*s).*f;
    %compute the derivatives of x and y (without rotation or translation)
    dx = -2*pi*a*sin(2*pi*s);
    df = (-c/2)*f.*dx;
    dy = 2*pi*b*cos(2*pi*s).*f + b*sin(2*pi*s).*df;
    %rotation matrix corresponding to theta
    R = [cos(theta),-sin(theta);sin(theta),cos(theta)];
    %compute position and gradient for rotated + translated oval
    V = R*[x;y]+[x0*ones(1,length(theta));y0*ones(1,length(theta))];
    G = R*[dx;dy];
end

%wrapper function that calls egg_func
%and only returns the x coordinate of the
%point on the perimeter of the egg
%(single output)
function [x_out, zero] = egg_wrapper_x(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    x_out = G(1);
    zero = 0;
end


%wrapper function that calls egg_func
%and only returns the x coordinate of the
%point on the perimeter of the egg
%(single output)
function [y_out, zero] = egg_wrapper_y(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    y_out = G(2);
    zero = 0;
end

function [x,y] = egg_wrapper(s,x0,y0,theta,egg_params)
    [V, ~] = egg_func(s,x0,y0,theta,egg_params);
    x = V(1);
    y = V(2);
end

%Function that computes the bounding box of an oval
%INPUTS:
%theta: rotation of the oval. theta is a number from 0 to 2*pi.
%x0: horizontal offset of the oval
%y0: vertical offset of the oval
%egg_params: a struct describing the hyperparameters of the oval
%OUTPUTS:
%x_range: the x limits of the bounding box in the form [x_min,x_max]
%y_range: the y limits of the bounding box in the form [y_min,y_max]
function [x_range,y_range,x_root_right,y_root_bottom] = compute_bounding_box(x0,y0,theta,egg_params)
    dxtol = 1e-12;
    ftol = 1e-12;
    max_iter = 2000;
    dxmax = 1e10;

    egg_wrapper1 = @(s) egg_wrapper_x(s,x0,y0,theta,egg_params);
    egg_wrapper2 = @(s) egg_wrapper_y(s,x0,y0,theta,egg_params);
    
    x_roots = [];
    y_roots = [];
    for i = 0:0.125:1
        x_root = secant(egg_wrapper1,i,i+0.05,dxtol,ftol,max_iter,dxmax);
        y_root = secant(egg_wrapper2,i,i+0.05,dxtol,ftol,max_iter,dxmax);
        x_roots = [x_roots, x_root];
        y_roots = [y_roots, y_root];
    end
    
    y_roots = y_roots(y_roots<=1 & y_roots>0);
    x_roots = x_roots(x_roots<=1 & x_roots>0);
    x_roots = uniquetol(x_roots, 0.0001);
    y_roots = uniquetol(y_roots, 0.0001);
    
    [x_1, ~] = egg_wrapper(x_roots(1),x0,y0,theta,egg_params);
    [x_2, ~] = egg_wrapper(x_roots(2),x0,y0,theta,egg_params);
    [~, y_1] = egg_wrapper(y_roots(1),x0,y0,theta,egg_params);
    [~, y_2] = egg_wrapper(y_roots(2),x0,y0,theta,egg_params);
    
    if x_1 > x_2
        x_left = x_2;
        x_right = x_1;
        x_root_right = x_roots(1);
    else
        x_left = x_1;
        x_right = x_2;
        x_root_right = x_roots(2);
    end
    
    if y_1 > y_2
        y_bottom = y_2;
        y_top = y_1;
        y_root_bottom = y_roots(2);
    else
        y_bottom = y_1;
        y_top = y_2;
        y_root_bottom = y_roots(1);
    end
    
    x_range = [x_left,x_right];
    y_range = [y_bottom,y_top];
end

egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
%specify the position and orientation of the egg
x0 = 5; y0 = 5; theta = pi/6;


[x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params);

width = x_range(2)-x_range(1);
height = y_range(2)-y_range(1);



%set up the axis
hold on; axis equal; axis square
axis([0,10,0,10])
%plot the origin of the egg frame
%compute the perimeter of the egg
[V_list, G_list] = egg_func(linspace(0,1,100),x0,y0,theta,egg_params);
%plot the perimeter of the egg
plot(V_list(1,:),V_list(2,:),'k', LineWidth=3);
rectangle('Position',[x_range(1) y_range(1) width height], 'EdgeColor','b', LineWidth=3)
yline(NaN, "Color","b", LineWidth=3);
plot(x0,y0,'ro','markerfacecolor','r', 'MarkerSize', 10, 'MarkerEdgeColor','r');
legend("Egg", "Bounding Box", "Center of Egg", FontSize=14, Interpreter= "latex",  Location='northwest');
title("Egg in a Box", 'FontSize', 16, "Interpreter","latex")
ylabel("Y (-)",'FontSize', 14, "Interpreter","latex")
xlabel("X (-)",'FontSize', 14, "Interpreter","latex")
exportgraphics(gca, 'plots/egg_in_a_box.png', 'Resolution', 300);

hold off
