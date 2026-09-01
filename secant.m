% function x = secant_solver(fun,x_0, x_1)
%     [f_x_0, dfdx_0] = fun(x_0);
%     [f_x_1, dfdx_1] = fun(x_1);
%     while abs(f_x_0) > 10e-7
%        x = ((x_1*f_x_0) - (x_0*f_x_1))/(f_x_0 - f_x_1);
%        x_1 = x_0;
%        x_0 = x;
%        [f_x_0, dfdx_0] = fun(x_0);
%        [f_x_1, dfdx_1] = fun(x_1);
%     end
% end
% 
% root = secant_solver(@test_function, 30, 40)


function [x_0, exit_flag] = secant_solver(fun,x_0,x_1,dxtol,ftol,max_iter,dxmax)
    iter = 1;
    exit_flag = 0;

    [f_x_0, dfdx_0] = fun(x_0);
    [f_x_1, dfdx_1] = fun(x_1);
    x = ((x_1*f_x_0) - (x_0*f_x_1))/(f_x_0 - f_x_1);

    while abs(f_x_1) > ftol && abs(x-x_0) > dxtol
        
        if abs(x-x_0) > dxmax
            exit_flag = 1;
            break
        end

        x_1 = x_0;
        x_0 = x;
        [f_x_0, ~] = fun(x_0);
        [f_x_1, ~] = fun(x_1);
        
       if f_x_0 - f_x_1 == 0
            exit_flag = 1;
            break
       end

       x = ((x_1*f_x_0) - (x_0*f_x_1))/(f_x_0 - f_x_1);

       iter = iter + 1;

       if iter >= max_iter
            exit_flag = 2;
            break
       end
    end
end

%exit_flag = 1 is division error
%exit_flag = 2 is iter limit
%exit_flag = 0 is ran successfully

[root, flag] = secant_solver(@test_function, -5, 5, 1e-14, 1e-14, 100, 50)