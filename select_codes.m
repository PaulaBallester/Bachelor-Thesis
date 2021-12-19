function [c,coset] = select_codes(ZC_codes,Nt,b,b_lib)

switch Nt
    case 1
        c(:,1) = ZC_codes(:,1);
        coset = 1;
        
    case 2
        if isequal(b,b_lib(1,:)) || isequal(b,b_lib(4,:)) %M1
            c(:,1) = ZC_codes(:,1);
            c(:,2) = ZC_codes(:,2);
            coset = 1;
        elseif isequal(b,b_lib(2,:)) || isequal(b,b_lib(3,:)) %M2
            c(:,1) = ZC_codes(:,2);
            c(:,2) = ZC_codes(:,1); 
            coset = 2;
        end
        
    case 4
        if isequal(b,b_lib(1,:)) || isequal(b,b_lib(16,:)) %M1
            c(:,1) = ZC_codes(:,1);
            c(:,2) = ZC_codes(:,5);
            c(:,3) = ZC_codes(:,8);
            c(:,4) = ZC_codes(:,6);
            coset = 1;
        elseif isequal(b,b_lib(2,:)) || isequal(b,b_lib(15,:)) %M2
            c(:,1) = ZC_codes(:,2);
            c(:,2) = ZC_codes(:,6);
            c(:,3) = ZC_codes(:,7);
            c(:,4) = ZC_codes(:,5);
            coset = 2;
        elseif isequal(b,b_lib(3,:)) || isequal(b,b_lib(14,:)) %M3
            c(:,1) = ZC_codes(:,3);
            c(:,2) = ZC_codes(:,7);
            c(:,3) = ZC_codes(:,6);
            c(:,4) = ZC_codes(:,8);
            coset = 3;
        elseif isequal(b,b_lib(4,:)) || isequal(b,b_lib(13,:)) %M4
            c(:,1) = ZC_codes(:,4);
            c(:,2) = ZC_codes(:,8);
            c(:,3) = ZC_codes(:,5);
            c(:,4) = ZC_codes(:,7);
            coset = 4;
        elseif isequal(b,b_lib(5,:)) || isequal(b,b_lib(12,:)) %M5
            c(:,1) = ZC_codes(:,5);
            c(:,2) = ZC_codes(:,1);
            c(:,3) = ZC_codes(:,4);
            c(:,4) = ZC_codes(:,2);
            coset = 5;
        elseif isequal(b,b_lib(6,:)) || isequal(b,b_lib(11,:)) %M6
            c(:,1) = ZC_codes(:,6);
            c(:,2) = ZC_codes(:,2);
            c(:,3) = ZC_codes(:,3);
            c(:,4) = ZC_codes(:,1);
            coset = 6;
        elseif isequal(b,b_lib(7,:)) || isequal(b,b_lib(10,:)) %M7
            c(:,1) = ZC_codes(:,7);
            c(:,2) = ZC_codes(:,3);
            c(:,3) = ZC_codes(:,2);
            c(:,4) = ZC_codes(:,4);
            coset = 7;
        elseif isequal(b,b_lib(8,:)) || isequal(b,b_lib(9,:)) %M8
            c(:,1) = ZC_codes(:,8);
            c(:,2) = ZC_codes(:,4);
            c(:,3) = ZC_codes(:,1);
            c(:,4) = ZC_codes(:,3);
            coset = 8;
        end
   
end

