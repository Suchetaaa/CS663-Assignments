function [U,S,V] = mySVD_final(A)

    A_left = A*A';
    A_right = A'*A;
    flipped_identity = flip(eye(size(A)),1);
    [U, D1] = eig(A_left);
    [V,~] = eig(A_right);
    
    U = U * flipped_identity;
    V = V * flipped_identity;
    
    S = D1.^(1/2);
    S = real(S);
    S = flipped_identity * S * flipped_identity;
    
    for i=1:min(size(A))
        if (dot(A*V(:,i), U(:,i)) <= 0)
            V(:,i) = -V(:,i);
        end
    end
    
end