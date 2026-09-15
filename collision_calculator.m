%Example parabolic trajectory
function [x0,y0,theta] = egg_trajectory01(t)
x0 = 7*t + 8;
y0 = -6*t.^2 + 20*t + 6;
theta = 5*t;
end


function [delta_wall, zero] = wall_dist(fun, t, x_wall)
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    [x0,y0,theta] = fun(t);
    [x_range, ~] = compute_bounding_box(x0, y0, theta, egg_params);
    
    delta_wall = abs(x_wall - x_range(2));
    zero = 0;
end


function [delta_floor, zero] = floor_dist(fun, t, y_floor)
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    [x0,y0,theta] = fun(t);
    [~, y_range] = compute_bounding_box(x0, y0, theta, egg_params);
    
    delta_floor = abs(y_floor - y_range(2));
    zero = 0;
end

%Function that computes the collision time for a thrown egg
%INPUTS:
%traj_fun: a function that describes the [x,y,theta] trajectory
% of the egg (takes time t as input)
%egg_params: a struct describing the hyperparameters of the oval
%y_ground: height of the ground
%x_wall: position of the wall
%OUTPUTS:
%t_ground: time that the egg would hit the ground
%t_wall: time that the egg would hit the wall
function [t_floor,t_wall] = collision_func(traj_fun, egg_params, y_floor, x_wall)
    dxtol = 1e-12;
    ftol = 1e-12;
    max_iter = 2000;
    dxmax = 1e10;

    floor_wrapper = @(t) floor_dist(traj_fun, t, y_floor);
    wall_wrapper = @(t) wall_dist(traj_fun, t, x_wall);

    [t_wall, wall_flag] = secant(wall_wrapper,0,0.1,dxtol,ftol,max_iter,dxmax);
    [t_floor, floor_flag] = secant(floor_wrapper,0,0.1,dxtol,ftol,max_iter,dxmax);


end

egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

[t_floor, t_wall] = collision_func(@egg_trajectory01,egg_params, 0, 5)
