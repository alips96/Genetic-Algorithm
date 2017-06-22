function y=Mutate(x)

nVar = numel(x);
j = randi([1 nVar]);
y = x;
y(j) = 1-x(j);

end