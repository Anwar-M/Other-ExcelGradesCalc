clear all; clc;

A = xlsread('exam1.xls');
B = xlsread('exam2.xls');
C = xlsread('exam3.xls');

A(:,3:4) = [];
B(:,3) = [];
C(:,3) = [];

A = sortrows(A);
B = sortrows(B);
C = sortrows(C);

%%
n_exam1 = length(A);
n_exam2 = length(B);

% Check if stnr in exam1 is also on exam2 and add grade. If stnr in exam1
% not on exam2, get 0 points. There will be a residual left of stnr in
% exam2 which did not do exam1
for i = 1:n_exam1
    T(i, 1) = A(i, 1);
    T(i, 2) = A(i, 2);
    
    j = 1;
    while (j <= n_exam2)&&(A(i, 1) >= B(j, 1))
        if A(i, 1) == B(j, 1)
            T(i, 3) = B(j, 2);
            B(j, :) = [];
            n_exam2 = n_exam2 - 1;
            break;
        end
        j = j + 1;
    end
    
end
% Add the residual, i.e., stnr which has 0 points for exam1 (or did not
% attend)
n_left_exam2 = length(B);
disp(n_left_exam2);
T(n_exam1 + 1: n_exam1 + n_left_exam2, 1) = B(:, 1);
T(n_exam1 + 1: n_exam1 + n_left_exam2, 3) = B(:, 2);

T = sortrows(T);

%% Same
n_T = length(T);
n_exam3 = length(C);

for i = 1:n_T
    j = 1;
    while (j <= n_exam3)&&(T(i, 1) >= C(j, 1))
        if T(i, 1) == C(j, 1)
            T(i, 4) = C(j, 2);
            C(j, :) = [];
            n_exam3 = n_exam3 - 1;
            break;
        end
        j = j + 1;
    end
end
n_left_exam3 = length(C);
disp(n_left_exam3);
T(n_T + 1: n_T + n_left_exam3, 1) = C(:, 1);
T(n_T + 1: n_T + n_left_exam3, 3) = C(:, 2);

T = sortrows(T);

%%
T(:, 5) = 10*sum(T(:, 2:4), 2)/(3*17);
T(:, 6) = round(T(:,5)*10)/10;

xlswrite('grades_allexams.xls', T);

T(:, 2:5) = [];
xlswrite('grades_mean.xls', T);