% exit flag 0 = ran successfully
% exit flag 1 = bisection error
% exit flag 2 = reached maximum iteration
function [x, exit_flag] = bisection_solver(func,x_left,x_right,dxtol,ftol, max_iter)

    x_m = (x_left+x_right)/2;
    [func_m, ~] = func(x_m);
    [func_l, ~] = func(x_left);
    [func_r, ~] = func(x_right);
    iter = 0;

    if func_l*func_r > 0
        x = 0;
        exit_flag = 1;
        return
    end

    while abs(func_m) > ftol && abs(x_left - x_right) > dxtol
        x_m = (x_left+x_right)/2;

        [func_m, ~] = func(x_m);
        [func_l, ~] = func(x_left);
        [func_r, ~] = func(x_right);

        if func_m*func_l < 0
            x_right = x_m;
        elseif func_m*func_r < 0
            x_left = x_m;
        end

        iter = iter + 1;
        if iter >= max_iter
            x = 0;
            exit_flag = 2;
            return
        end
          

    end

    x = x_m;
    exit_flag = 0;
   
end


[root, exit_flag] = bisection_solver(@test_function, 30, 40, 10e-14, 10e-14, 100)