x = linspace(-20, 60, 100);
y = [];

for i=1:length(x)
    [new, ~] = test_function(x(i));
    y = [y, new];
end

plot(x, y, 'LineWidth', 3)
axis([-15 40 -50 80])
yline(0, 'k-', LineWidth=3)
legend("Function", "X Axis", FontSize=14, Interpreter= "latex",  Location='northwest');
title("Initial Test Function For Root Finding", 'FontSize', 16, "Interpreter","latex")
ylabel("Test Function - F(x) (-)",'FontSize', 14, "Interpreter","latex")
xlabel("Test Function - x (-)",'FontSize', 14, "Interpreter","latex")
exportgraphics(gca, 'plots/test_func_1.png', 'Resolution', 300);


