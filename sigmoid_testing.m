x_guess = linspace(0, 50, 1000);
x_zero = zeros(1000);

dxtol = 1e-12;
ftol = 1e-12;
max_iter = 2000;
dxmax = 1e10;

fontsize_axis = 14;
fontsize_title = 18;
ax = gca;
ax.FontSize = 13;

% NEWTON 
x_newt_good = [];
y_newt_good = [];
x_newt_bad = [];
y_newt_bad = [];
target_root = fzero(@sigmoid, 30);

for i=1:length(x_guess)
    [x, exit_flag] = newton(@sigmoid,x_guess(i),dxtol,ftol,max_iter,dxmax);

    if abs(x - target_root) < ftol
        x_newt_good = [x_newt_good, x_guess(i)];
        [y, ~] = sigmoid(x_guess(i));
        y_newt_good = [y_newt_good, y];
    else
        x_newt_bad = [x_newt_bad, x_guess(i)];
        [y, ~] = sigmoid(x_guess(i));
        y_newt_bad = [y_newt_bad, y];
    end
end
figure();
plot_x = linspace(0, 50, 1000);
[y, ~] = sigmoid(plot_x);
fontsize_axis = 14;
fontsize_title = 16;
ax = gca;
ax.FontSize = 14;
hold on
plot(x_newt_good, y_newt_good, "ro", 'Color','g', MarkerFaceColor='g')
plot(x_newt_bad, y_newt_bad, "ro", 'Color','r', MarkerFaceColor='r')
plot(target_root, 0, "o", "MarkerFaceColor","k", MarkerEdgeColor='k')
plot(plot_x, x_zero, 'Color', 'k');
ylim([-5 6])
title("Newton's Method Initial Guess Convergence Evaluation for Sigmoid Function", 'FontSize', fontsize_title, "Interpreter","latex")
ylabel("Sigmoid Function - F(x0) (-)", 'FontSize', fontsize_axis, "Interpreter","latex")
xlabel("Initial Guess - x0 (-)", 'FontSize', fontsize_axis, "Interpreter","latex")
legend( "Successful Initial Guesses", "Failed Initial Guesses", "Root Location", Location='northwest', fontsize=16, Interpreter="latex")
hold off
exportgraphics(gca, 'plots/newton_sigmoid.png', 'Resolution', 300);

% FZERO
x_fzero_good = [];
y_fzero_good = [];
x_fzero_bad = [];
y_fzero_bad = [];
target_root = fzero(@sigmoid, 30);

for i=1:length(x_guess)
    [x, exit_flag] = fzero(@sigmoid,x_guess(i));

    if abs(x - target_root) < ftol
        x_fzero_good = [x_fzero_good, x_guess(i)];
        [y, ~] = sigmoid(x_guess(i));
        y_fzero_good = [y_fzero_good, y];
    else
        x_fzero_bad = [x_fzero_bad, x_guess(i)];
        [y, ~] = sigmoid(x_guess(i));
        y_fzero_bad = [y_fzero_bad, y];
    end
end

figure();
plot_x = linspace(0, 50, 1000);
[y, ~] = sigmoid(plot_x);
fontsize_axis = 14;
fontsize_title = 16;
ax = gca;
ax.FontSize = 13;
hold on
plot(x_fzero_good, y_fzero_good, "ro", 'Color','g', MarkerFaceColor='g')
plot(x_fzero_bad, y_fzero_bad, "ro", 'Color','r', MarkerFaceColor='r')
plot(target_root, 0, "o", "MarkerFaceColor","k", MarkerEdgeColor='k')
plot(plot_x, x_zero, 'Color', 'k', MarkerEdgeColor='k');
ylim([-5 6])
title("Fzero Method Initial Guess Convergence Evaluation for Sigmoid Function", 'FontSize', fontsize_title, "Interpreter","latex")
ylabel("Sigmoid Function - F(x0) (-)", 'FontSize', fontsize_axis, "Interpreter","latex")
xlabel("Initial Guess - x0 (-)", 'FontSize', fontsize_axis, "Interpreter","latex")
legend("Successful Initial Guesses", "Root Location", Location='northwest' ,fontsize=16, Interpreter="latex")
hold off
exportgraphics(gca, 'plots/fzero_sigmoid.png', 'Resolution', 300);

% BISECTION
% x_guess_1 = 50 .* rand(1000);
% x_guess_2 = 50 .* rand(1000);

x_list = linspace(0,50,50);
[x_left, x_right] = meshgrid(x_list, x_list);

x_bi_good = [];
y_bi_good = [];
x_bi_bad = [];
y_bi_bad = [];
target_root = fzero(@sigmoid, 30)

lines = ones(1000) * target_root;
lines_2 = linspace(0, 50, 1000);

for i=1:length(x_list)^2
    [x, exit_flag] = bisection(@sigmoid,x_left(i), x_right(i), dxtol,ftol,max_iter);
    if abs(x - target_root) < 1e-3
        x_bi_good = [x_bi_good, x_left(i)];
        y_bi_good = [y_bi_good, x_right(i)];
    else
        [x_left(i),x_right(i),x]
        x_bi_bad = [x_bi_bad, x_left(i)];
        y_bi_bad = [y_bi_bad, x_right(i)];
    end
end

figure();
fontsize_axis = 14;
fontsize_title = 16;
ax = gca;
ax.FontSize = 13;
hold on
plot(x_bi_good, y_bi_good, "o", 'MarkerFaceColor','g', MarkerEdgeColor='g')
plot(x_bi_bad, y_bi_bad, "o", 'MarkerFaceColor','r', MarkerEdgeColor='r')
plot(target_root, target_root, "o", "MarkerFaceColor","k", MarkerEdgeColor='k')
plot(lines, lines_2, 'Color', 'k')
plot(lines_2, lines, 'Color', 'k')
t = title("Bisection Method Initial Guess Convergence Evaluation for Sigmoid Function", 'FontSize', fontsize_title, "Interpreter","latex")
t.Position(2) = t.Position(2) + .5;
ylabel("Initial Right X Guess (-)", 'FontSize', fontsize_axis, "Interpreter","latex")
xlabel("Initial Left X Guess (-)", 'FontSize', fontsize_axis, "Interpreter","latex")
legend("Successful Initial Guesses", "Failed Initial Guesses", "Root Location", Location='northwest',fontsize=16, Interpreter="latex")
hold off
exportgraphics(gca, 'plots/bisection_sigmoid.png', 'Resolution', 300);

%SECANT
x_list = linspace(0,50,50);
[x_left, x_right] = meshgrid(x_list, x_list);

x_sec_good = [];
y_sec_good = [];
x_sec_bad = [];
y_sec_bad = [];
target_root = fzero(@sigmoid, 30)

for i=1:length(x_list)^2
    [x, exit_flag] = secant(@sigmoid,x_left(i), x_right(i), dxtol,ftol,max_iter, dxmax);
    if abs(x - target_root) < 1e-3
        x_sec_good = [x_sec_good, x_left(i)];
        y_sec_good = [y_sec_good, x_right(i)];
    else
        [x_left(i),x_right(i),x]
        x_sec_bad = [x_sec_bad, x_left(i)];
        y_sec_bad = [y_sec_bad, x_right(i)];
    end
end

figure();
fontsize_axis = 14;
fontsize_title = 16;
ax = gca;
ax.FontSize = 13;
hold on
plot(x_sec_good, y_sec_good, "o", 'MarkerFaceColor','g', MarkerEdgeColor='g')
plot(x_sec_bad, y_sec_bad, "o", 'MarkerFaceColor','r', MarkerEdgeColor='r')
plot(target_root, target_root, "o", "MarkerFaceColor","k", MarkerEdgeColor='k')
ylabel("Initial X1 Guess (-)", 'FontSize', fontsize_axis, Interpreter ="latex")
xlabel("Initial X0 Guess (-)", 'FontSize', fontsize_axis,  Interpreter ="latex")
t = title("Secant Method Initial Guess Convergence Evaluation for Sigmoid Function", 'FontSize', fontsize_title, "Interpreter","latex")
t.Position(2) = t.Position(2) + .5;
plot(lines, lines_2, 'Color', 'k')
plot(lines_2, lines, 'Color', 'k')
legend("Successful Initial Guesses", "Failed Initial Guesses", "Root Location", Location='northwest',fontsize=16, Interpreter="latex")
hold off
exportgraphics(gca, 'plots/secant_sigmoid.png', 'Resolution', 300);

