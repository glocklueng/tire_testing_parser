function eqn = magic_formula(x,a,F_n)
    eqn = F_n.*x(3).*sin(x(2).*atan((x(1).*a-x(4).*(x(1).*a-atan(x(1).*a)))));
end