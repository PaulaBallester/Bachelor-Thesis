function U_lib = create_Ulib(U_lib,r_lib,Nr,L,taps,Nt)

switch Nt
    case 1
        for i = 1:Nr
            for j = 1:L(taps)
                U_lib(i,j,1,1) = r_lib(1,1,i,j);
                U_lib(i,j,1,2) = r_lib(2,1,i,j);
            end
        end
        
    case 2
        for i = 1:Nr
            for j = 1:L(taps)
            U_lib(i,j,1,1) = r_lib(1,1,i,j);
            U_lib(i,j,2,1) = r_lib(1,2,i,j);

            U_lib(i,j,2,2) = r_lib(2,1,i,j);
            U_lib(i,j,1,2) = r_lib(2,2,i,j);

            U_lib(i,j,2,3) = r_lib(3,1,i,j);
            U_lib(i,j,1,3) = r_lib(3,2,i,j);
            
            U_lib(i,j,1,4) = r_lib(4,1,i,j);
            U_lib(i,j,2,4) = r_lib(4,2,i,j);
            end
        end
        
    case 4
        for i = 1:Nr
            for j = 1:L(taps)
                U_lib(i,j,1,1) = r_lib(1,1,i,j);U_lib(i,j,1,16) = r_lib(16,1,i,j);
                U_lib(i,j,5,1) = r_lib(1,2,i,j);U_lib(i,j,5,16) = r_lib(16,2,i,j);
                U_lib(i,j,8,1) = r_lib(1,3,i,j);U_lib(i,j,8,16) = r_lib(16,3,i,j);
                U_lib(i,j,6,1) = r_lib(1,4,i,j);U_lib(i,j,6,16) = r_lib(16,4,i,j);

                U_lib(i,j,2,2) = r_lib(2,1,i,j);U_lib(i,j,2,15) = r_lib(15,1,i,j);
                U_lib(i,j,6,2) = r_lib(2,2,i,j);U_lib(i,j,6,15) = r_lib(15,2,i,j);
                U_lib(i,j,7,2) = r_lib(2,3,i,j);U_lib(i,j,7,15) = r_lib(15,3,i,j);
                U_lib(i,j,5,2) = r_lib(2,4,i,j);U_lib(i,j,5,15) = r_lib(15,4,i,j);

                U_lib(i,j,3,3) = r_lib(3,1,i,j);U_lib(i,j,3,14) = r_lib(14,1,i,j);
                U_lib(i,j,7,3) = r_lib(3,2,i,j);U_lib(i,j,7,14) = r_lib(14,2,i,j);
                U_lib(i,j,6,3) = r_lib(3,3,i,j);U_lib(i,j,6,14) = r_lib(14,3,i,j);
                U_lib(i,j,8,3) = r_lib(3,4,i,j);U_lib(i,j,8,14) = r_lib(14,4,i,j);

                U_lib(i,j,4,4) = r_lib(4,1,i,j);U_lib(i,j,4,13) = r_lib(13,1,i,j);
                U_lib(i,j,8,4) = r_lib(4,2,i,j);U_lib(i,j,8,13) = r_lib(13,2,i,j);
                U_lib(i,j,5,4) = r_lib(4,3,i,j);U_lib(i,j,5,13) = r_lib(13,3,i,j);
                U_lib(i,j,7,4) = r_lib(4,4,i,j);U_lib(i,j,7,13) = r_lib(13,4,i,j);

                U_lib(i,j,5,5) = r_lib(5,1,i,j);U_lib(i,j,5,12) = r_lib(12,1,i,j);
                U_lib(i,j,1,5) = r_lib(5,2,i,j);U_lib(i,j,1,12) = r_lib(12,2,i,j);
                U_lib(i,j,4,5) = r_lib(5,3,i,j);U_lib(i,j,4,12) = r_lib(12,3,i,j);
                U_lib(i,j,2,5) = r_lib(5,4,i,j);U_lib(i,j,2,12) = r_lib(12,4,i,j);

                U_lib(i,j,6,6) = r_lib(6,1,i,j);U_lib(i,j,6,11) = r_lib(11,1,i,j);
                U_lib(i,j,2,6) = r_lib(6,2,i,j);U_lib(i,j,2,11) = r_lib(11,2,i,j);
                U_lib(i,j,3,6) = r_lib(6,3,i,j);U_lib(i,j,3,11) = r_lib(11,3,i,j);
                U_lib(i,j,1,6) = r_lib(6,4,i,j);U_lib(i,j,1,11) = r_lib(11,4,i,j);

                U_lib(i,j,7,7) = r_lib(7,1,i,j);U_lib(i,j,7,10) = r_lib(10,1,i,j);
                U_lib(i,j,3,7) = r_lib(7,2,i,j);U_lib(i,j,3,10) = r_lib(10,2,i,j);
                U_lib(i,j,2,7) = r_lib(7,3,i,j);U_lib(i,j,2,10) = r_lib(10,3,i,j);
                U_lib(i,j,4,7) = r_lib(7,4,i,j);U_lib(i,j,4,10) = r_lib(10,4,i,j);

                U_lib(i,j,8,8) = r_lib(8,1,i,j);U_lib(i,j,8,9) = r_lib(9,1,i,j);
                U_lib(i,j,4,8) = r_lib(8,2,i,j);U_lib(i,j,4,9) = r_lib(9,2,i,j);
                U_lib(i,j,1,8) = r_lib(8,3,i,j);U_lib(i,j,1,9) = r_lib(9,3,i,j);
                U_lib(i,j,3,8) = r_lib(8,4,i,j);U_lib(i,j,3,9) = r_lib(9,4,i,j);
            end
        end
        
    otherwise %assume Nt=1
         for i = 1:Nr
            for j = 1:L(taps)
                U_lib(i,j,1,1) = r_lib(1,1,i,j);
                U_lib(i,j,1,2) = r_lib(2,1,i,j);
            end
        end   
        
end
end


