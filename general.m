function [p,precision,arr,etime]=  general(eqn,iter,tol  , s_step , plot_m ,handles, p0 )
tic;    
format shortG
format compact

old_f = inline(eqn);
if(~exist('p0', 'var'))
    p0 = get_guess(inline(eqn));
end
eqn = strcat(eqn , ' + x^1 ') ;
f = inline(eqn);
arr = zeros(1 , 6);
for i=1:iter   % get ready to do a large, but finite, number of iterations.
               % This is so that if the method fails to converge, we won't
               % be stuck in an infinite loop.
    p1=f(p0);  % calculate the next two guesses for the fixed point.
    p2=f(p1);
    p=p0-(p1-p0)^2/(p2-2*p1+p0); % use Aitken's delta squared method to
    if(p2-2*p1+p0 == 0)
         p = p0-(p1-p0)^2 / 0.00001;
    end
    err = abs((p-p0) / p) *100;
    arr(i,:) = [i p0 p1 p2 p err];
    precision = 100 - err;
    if abs((p-p0)/p)<tol  % test to see if we are within tolerance.
        break         % if we are, stop the iterations, we have our answer.
    end
    p0=p;              % update p0 for the next iteration.
end
etime = toc;
if (plot_m )
    x = linspace(p0-10, p0+10);
    axes(handles.axes3);
    plot(arr(:,1), arr(:, 5));
    xlabel('num of itr');
    ylabel('root');

    axes(handles.axes2);
    plot(arr(:, 1), arr(:, 6));
    xlabel('num of itr');
    ylabel('error');
    
    axes(handles.axes1);
    plot(x, old_f(x));
    xlabel('x');
    ylabel('f(x)');
end

if (s_step)
    x = linspace(p0-10, p0+10);
    axes(handles.axes1);
    plot(x, old_f(x));
    xlabel('x');
    ylabel('f(x)');
end
end
function [best_guess] = get_guess(f)
    best_guess = 0;
    best_zero = 0;
    a = -1;
    b = 1;
    for i = 1 : 100
        for j = 1 : 100      
            r = (b-a).*rand(1,1) + a;
            g = r * i * j / (i+j);
            zero =  f(g); 
            if(abs(zero) <  abs(best_zero))
                best_zero = zero; 
                best_guess = g;
            end
        end
    end
end