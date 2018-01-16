function eqn = ulat_sin_error(x,F_n,F_lat)
    eqn = x(1)*sin(F_n./x(2))-F_lat;
end