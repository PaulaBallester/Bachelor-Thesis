function b_decod = decodif(b_hat,Nt);

switch Nt
    case 1
        if isequal(b_hat,1) 
            b_decod = -1;
        else
            b_decod = 1;
        end
        
    case 2
%         b_decod = 2*de2bi(b_hat-1,Nt,'left-msb')-1;
        switch b_hat
            case 1 
                b_decod = [-1 -1];
            case 2 
                b_decod = [-1 1];
            case 3 
                b_decod = [1 -1];
            case 4 
                b_decod = [1 1];
            otherwise
                b_decod = [1 1];
        end
        
    case 4
        switch b_hat
            case 1 
                b_decod = [-1 -1 -1 -1];
            case 2 
                b_decod = [-1 -1 -1 1];
            case 3 
                b_decod = [-1 -1 1 -1];
            case 4 
                b_decod = [-1 -1 1 1];      
            case 5 
                b_decod = [-1 1 -1 -1];        
            case 6 
                b_decod = [-1 1 -1 1];        
            case 7 
                b_decod = [-1 1 1 -1];        
            case 8 
                b_decod = [-1 1 1 1];        
            case 9 
                b_decod = [1 -1 -1 -1];
            case 10 
                b_decod = [1 -1 -1 1];
            case 11
                b_decod = [1 -1 1 -1];
            case 12 
                b_decod = [1 -1 1 1];      
            case 13 
                b_decod = [1 1 -1 -1];        
            case 14 
                b_decod = [1 1 -1 1];        
            case 15 
                b_decod = [1 1 1 -1];        
            case 16 
                b_decod = [1 1 1 1];          
        end

end

