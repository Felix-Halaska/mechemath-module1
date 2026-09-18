x = linspace(-10, 60, 100);
y = [];

for i=1:length(x)
    [new, ~] = sigmoid(x(i));
    y = [y, new];
end

plot(x, y)
axis([0 50 -6 8])
yline(0, 'k-')
legend("Function", "X Axis", FontSize=14, Interpreter= "latex",  Location='northwest');
title("Sigmoid Test Function For Initial Guess Evaluation", 'FontSize', 16, "Interpreter","latex")
ylabel("Sigmoid Function - F(x) (-)",'FontSize', 14, "Interpreter","latex")
xlabel("Sigmoid Function - x (-)",'FontSize', 14, "Interpreter","latex")
exportgraphics(gca, 'plots/sigmoid.png', 'Resolution', 300);


