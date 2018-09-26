clear all; clc;

A = xlsread('Results test I');
B = xlsread('Results test II');
C = xlsread('Results test III');


A(:,2:end-1) = [];
A(341:end,:) = [];
B(:,[2 4:end]) = [];
B(338:339,:) = [];
C(332:end, :) = [];
C(:, 2:end-1) = [];

A(:,2) = round(A(:,2)*10)/10;
B(:,2) = round(B(:,2)*10)/10;
C(:,2) = round(C(:,2)*10)/10;

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
n_left_exam2 = size(B,1);
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
n_left_exam3 = size(C,1);
disp(n_left_exam3);
T(n_T + 1: n_T + n_left_exam3, 1) = C(:, 1);
T(n_T + 1: n_T + n_left_exam3, 4) = C(:, 2);

T = sortrows(T);

%%
T(:, 5) = mean(T(:,2:4),2);
T(:, 6) = round(T(:,5)*2)/2;

%%
xlswrite('grades_allexams.xls', T);

T(:, 2:5) = [];
xlswrite('grades_mean.xls', T);