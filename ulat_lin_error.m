function eqn = ulat_lin_error(k,x,y)
    eqn = k(1).*x+k(2)-y;
end