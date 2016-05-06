% Function calculates 3D rigid point cloud transformation from one frame to
% another: Dj = F_D*dj
% The inputs are the two matrices, each of which containing set of points 
% and their coordinate in their own coordinate system. 

% The output are the rotational and translational matrices: 
% F = [R,P]

function [R,P] = registrationFD(dj, Dj)

% Computing the midpoint. Resulting matrix is 3x1
Dj_avg = mean(Dj.')';
dj_avg = mean(dj.')';

% Remapping all points with the midpoint as the reference point
% Resulting matrix is 3xn  
Dj_tau = Dj - repmat(Dj_avg, [1 size(Dj,2)]);
dj_tau = dj - repmat(dj_avg, [1 size(dj,2)]);

% Set up to compute the entries of the H matrix
DH = [0 0 0; 0 0 0; 0 0 0];

% Computing H matrix
for i = 1: size(Dj,2)
    DH = DH + dj_tau(:,i)*(Dj_tau(:,i))';
end

% Computing elementes of G matrix
I = eye(3); 
Ddet = [DH(2,3) - DH(3,2); DH(3,1) - DH(1,3); DH(1,2)-DH(2,1)]';
traceDH = trace(DH);
Dn = DH+DH'-trace(DH)*I; 

% Computing G matrix
DG = [traceDH,  Ddet(1,1), Ddet(1,2), Ddet(1,3);
     Ddet(1,1), Dn(1,1),   Dn(1,2),   Dn(1,3);
     Ddet(1,2), Dn(2,1),   Dn(2,2),   Dn(2,3);
     Ddet(1,3), Dn(3,1),   Dn(3,2),   Dn(3,3)];

% Computing eigenvalue and eigenvector. Identify the eigenvector
% corresponding to the largest eigenvalue. 
[DV,DD] = eig(DG);
diagDD = diag(DD);
maxeigD = max(diagDD);

DVfinal = zeros(4,1);
for i = 1:length(diagDD)
    if diagDD(i) == maxeigD
        DVfinal = DV(:,i);
    end
end

% Assigning the value to quaternion and creating the rotational matrix R
Dq0 = DVfinal(1);
Dq1 = DVfinal(2);
Dq2 = DVfinal(3);
Dq3 = DVfinal(4);

R = [Dq0^2+Dq1^2-Dq2^2-Dq3^2, 2*(Dq1*Dq2-Dq0*Dq3),  2*(Dq1*Dq3+Dq0*Dq2);
     2*(Dq1*Dq2+Dq0*Dq3),  Dq0^2-Dq1^2+Dq2^2-Dq3^2, 2*(Dq2*Dq3-Dq0*Dq1);
     2*(Dq1*Dq3-Dq0*Dq2), 2*(Dq2*Dq3+Dq0*Dq1), Dq0^2-Dq1^2-Dq2^2+Dq3^2]; 

% Computing the translational component P. Used the average values to 
% cancel noises. Resulting matrix is 3x1
P = Dj_avg - R*dj_avg;
end