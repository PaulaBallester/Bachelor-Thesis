function [H_estim,channel_estim_lib] = Channel_EstimationLS(H_estim,channel_estim_lib,U,b,b_lib,Nr,Nt,L,taps,sim,coset)


switch coset
        case 1
            if Nt==4
                codes_used = [1 5 8 6]; %M1 es 0000 & 1111
                if isequal(b,b_lib(1,:))
                    aux_symb = 1;
                else
                    aux_symb = 16;
                end
            elseif Nt==2
                codes_used = [1 2]; %M1
            end

        case 2
            if Nt==4
                codes_used = [2 6 7 5]; %M2 es 0001 & 1110
                 if isequal(b,b_lib(2,:))
                    aux_symb = 2;
                else
                    aux_symb = 15;
                 end
            elseif Nt==2
                codes_used = [2 1]; %M2
            end

        case 3 %From now on there is no need to distinguish btw different Nt because the only 
               %case with so many cosets is Nt=4
            codes_used = [3 7 6 8];%M3 es 0010 & 1101
             if isequal(b,b_lib(3,:))
                aux_symb = 3;
            else
                aux_symb = 14;
             end

        case 4
            codes_used = [4 8 5 7];%M4 es 0011 & 1100
             if isequal(b,b_lib(4,:))
                aux_symb = 4;
            else
                aux_symb = 13;
             end

        case 5
            codes_used = [5 1 4 2];%M5 es 0100 & 1011
             if isequal(b,b_lib(5,:))
                aux_symb = 5;
            else
                aux_symb = 12;
             end

        case 6
            codes_used = [6 2 3 1];%M6 es 0101 & 1010
             if isequal(b,b_lib(6,:))
                aux_symb = 6;
            else
                aux_symb = 11;
             end

        case 7
            codes_used = [7 3 2 4];%M7 es 0110 & 1001
             if isequal(b,b_lib(7,:))
                aux_symb = 7;
            else
                aux_symb = 10;
             end

        case 8
            codes_used = [8 4 1 3];%M8 es 0111 & 1000
             if isequal(b,b_lib(8,:))
                aux_symb = 8;
            else
                aux_symb = 9;
             end

        otherwise    
            codes_used = [1 5 8 6];
            aux_symb = 1;
end


for nr=1:Nr
    for nt=1:Nt
        for t=1:L(taps)
            if Nt==1
              H_estim(nr,nt,t) = U(nr,t,1).*(b(nt)./((abs(b(nt))).^2));
            else
              H_estim(nr,nt,t) = U(nr,t,codes_used(nt)).*(b(nt)./((abs(b(nt))).^2));
            end
          channel_estim_lib(sim,nr,nt,t) = H_estim(nr,nt,t);
        end
    end
end

end

