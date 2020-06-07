function [x, w] = gaussHermite(n)

    p = zeros(n+1);
    p(1, end) = 1;
    p(2, n:end) = [1 0]*2;
    for k = 3:n+1
        p(k, n-k+2:end) = 2*[p(k-1, n-k+3:end) 0]-2*(k-2)*[0 0 p(k-2, n-k+4:end)];
    end

    x = roots(p(n+1, :));
    w = zeros(1, n);
    for i = 1:n
        w(i) = 2^(n-1)*factorial(n)*sqrt(pi)/(n^2*polyval(p(n, :), x(i))^2);
    end
    x = x.';
end
