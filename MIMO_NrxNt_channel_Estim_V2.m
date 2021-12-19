%% MIMO SYSTEM IMPLEMENTATION
%% TRANSMITTER

%Initial data
L = 7; %number of taps (channel contributions)
SNR_dB = 4:2:12;
% SNR_dB = 12;
SNR_lin = db2pow(SNR_dB); %in lineal
% num_sim = [8000 15000 25000 43000 130000 340000 1000000 0]; ];
% num_sim = [100 400 900 1000 1200 3000 5000 8000];

num_sim = 12000;
num_sim = repelem(num_sim,length(SNR_dB));

num_channels = 500; %Number of different channels we are going to generate 

% length_preamble = 25; %In percentage
% num_pilots = round((length_preamble/100)*num_sim); %For now we use 20% of symbols to tx --> It is a vector!! 
num_pilots = 2^6;
num_pilots = repelem(num_pilots,length(SNR_dB));

num_error_ps_estim = zeros(length(SNR_dB),length(L));
num_error_ps_real = zeros(length(SNR_dB),length(L));

BER_ps_real = zeros(length(SNR_dB),length(L),num_channels);
BER_ps_estim = zeros(length(SNR_dB),length(L),num_channels);
Nt = 4; %Number of Tx antennas
Nr = 2; %Number of Rx antennas



% Then we generate the orthogonal chip sequences we can choose from
if (Nt==1) || (Nt==2)
    Nc = 13;%Length of spreading sequence
elseif Nt==4
        Nc = 47;%Length of spreading sequence
end

ZC_base = zadoffChuSeq(Nt+1,Nc); %generates the 2nd root Zadoff-Chu sequence of
    %length Nc. The output SEQ is an Nc-length column vector of complex
    %symbols. We use 2nd root because we have 4 Nt
    
BPS = 1;%Bits per symbol
num_codes = 2^(BPS*Nt-1); %num of orthogonal codes needed for the algorithm   

dist_mat = zeros((Nt*BPS)^2,1);

T = 5; %Guard interval length between codes and symbols

if T*num_codes > Nc
    disp('There might be intersymbol interference')
end

%ZC orthogonal codes 
%If T>L  codes dont interfer with eachother
ZC_codes = zeros(Nc,num_codes);

for q = 1:num_codes
   ZC_codes(:,q) = circshift(ZC_base,(q-1)*T); %Generates all the codes needed from the ZC_base
end

%generate message library
b_lib = 2*de2bi(0:2^Nt-1,'left-msb') -1;%generate all possible tx messages


%% Simulation

for canales = 1:num_channels
    disp('Channel:')
    disp(canales)
    
    %Create the channel because we assume it is time invariant -> same
    %channel for every tx symbol and for every SNR value
    
    H = zeros(Nc+T+L,Nc,Nr,Nt); %We have a toeplitz matrix for each antenna pair
    H_lib = zeros(Nr,Nt,L); %An H that is easier to work with later Nr x Nt x L(taps)
                              %Contains every channel response for every
                              %antenna pair -> H_lib(1,1,:) is the channel
                              %response for Tx1 and Rx1 for all the taps
  

    h = (randn(L,Nr,Nt) + 1i*randn(L,Nr,Nt))/(sqrt(2)*sqrt(L)); %L first to avoid squeeze func
        %h is the impulse response, we use Rayleigh fading to model the multipath
        %propagation. The channel vector follows a Gaussian distribution, this is
        %why we use "randn"

    %Loop to assign channel response to H and save it in H_lib to use it at Rx
    for i = 1:Nr
        for j = 1:Nt        
            for k = 1 : Nc+T
                H(k:k+L-1, k,i,j) = h(:,i,j);
                H_lib(i,j,:) = transpose(h(:,i,j)); %Transponse bc the dimensions change but ir does not change the values
            end        
        end
    end

    H(end-L+1:end,:,:,:) = [];
    
    %Initialize the variables needed to estikmate the channel
    H_estim = zeros(Nr,Nt,L);%We only have to initialize it in the beginning of the tx
    channel_estim_lib = zeros(num_pilots(1),Nr,Nt,L);
    
for taps = 1:length(L)   
for snr = 1:length(SNR_dB) 
for sim = 1:num_sim(snr)

message = round(rand(Nt,1)); %binary message to tx (column vector)
bpskmodulator = comm.BPSKModulator;
b = bpskmodulator(message); %modulate the message using BPSK
b= real(b.'); %we need to change the dimension

%Generate code setup according to D'Amours perm spreading table
x = zeros(Nc,Nt); %Tx signal without CP
c = zeros(Nc,Nt); %ZC codes

%Select the codes to be used
[c,coset] = select_codes(ZC_codes,Nt,b,b_lib);


x = b.*c/(sqrt(Nc)*sqrt(Nt)); %Add the bits and power normalization over Tx antennas

x_cp = [x(end-T+1:end,:); x]; %Add cyclic prefix of length T


%% Tx through the Channel


%Received signal y, when x goes through the channel
y = zeros(Nc+T,Nr);

for r = 1:Nr
    for t = 1:Nt
        y(:,r) = y(:,r) + H(:,:,r,t)*x_cp(:,t); %The received part of the signal + the signal convolutioned with the channel     
        %we receive a combination of all the tx messages of each Tx antenna but convolutioned with Hij (for all taps)
    end
end

%y contains in column "i" what receives antenna "i"


%Generate AWGN noise and add it 
w = (randn(Nc+T,Nr) + randn(Nc+T,Nr)*1i)/sqrt(2); %Complex gaussian noise
noisePower = 1/SNR_lin(snr);
w = sqrt(noisePower)*w;


y = y + w; %Add noise


%% Receiver

y(1:T,:) = []; %Remove cyclic prefix

U = zeros(Nr,L(taps),num_codes); %Output from correlators to the codes, where we also use the delayed signal paths
%U contains all the "r" of the scheme with added noise 

for n=1:num_codes
     for m = 1:L(taps)
        U(:,m,n) = (ZC_base/sqrt(Nc))'*circshift(y,-((n-1)*T + m-1));
        %contains all the correlated variables, all the "r" in the scheme
        %for every Nr we have a "r" in U
     end
end

%% Library with all possible rx symbols

if Nt==1
    r_lib = zeros(2,Nt,Nr,L(taps));%It will conatin all "r" of the scheme perfectly received, NO noise
    r_lib_estim = zeros(2,Nt,Nr,L(taps));
else
    r_lib = zeros((Nt*BPS)^2,Nt,Nr,L(taps));%It will conatin all "r" of the scheme perfectly received, NO noise
    r_lib_estim = zeros((Nt*BPS)^2,Nt,Nr,L(taps));
end


%% Channel Estimation
%When estimating the channel instead of using H_lib we should use H_estim

if sim<(num_pilots(snr)+1) 
    [H_estim,channel_estim_lib] = Channel_EstimationLS(H_estim,channel_estim_lib,U,b,b_lib,Nr,Nt,L,taps,sim,coset);
    
end

if (sim>num_pilots(snr)) 
    for nr=1:Nr
        for nt=1:Nt
            for t=1:L(taps)
                H_estim(nr,nt,t) = mean(channel_estim_lib(:,nr,nt,t));
            end
        end
    end

  for i = 1:Nr
        for l=1:L(taps)
                r_lib_estim(:,:,i,l) = H_estim(i,:,l).*b_lib/sqrt(Nt);   
            %Trying to replicate U but with the message library
            %r_lib contains all the "r" of the scheme but perfectly rx, all the "r" that
            %could be rx but without noise
         end
   end

end

%Without channel estimation (to compare)
for i = 1:Nr
        for l=1:L(taps)
                r_lib(:,:,i,l) = H_lib(i,:,l).*b_lib/sqrt(Nt);   
            %Trying to replicate U but with the message library
            %r_lib contains all the "r" of the scheme but perfectly rx, all the "r" that
            %could be rx but without noise
         end
end

%% ML Decoder

if Nt==1
    U_lib = zeros(Nr,L(taps),num_codes,2);%contains r_libs, NO noise
    U_lib_estim = zeros(Nr,L(taps),num_codes,2);
else
    U_lib = zeros(Nr,L(taps),num_codes,(Nt*BPS)^2);%contains r_libs, NO noise
    U_lib_estim = zeros(Nr,L(taps),num_codes,(Nt*BPS)^2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If there is no channel estimation

    U_lib = create_Ulib(U_lib,r_lib,Nr,L,taps,Nt); %we do this for each symbol, NO pilot symbols

%Look for the message at minimum distance 
    if Nt==1
        possible_messages = 2;
    else
        possible_messages = (Nt*BPS)^2;
    end
    
    for k = 1:possible_messages %there are 2 possible messages
       dist_mat(k) = sum(sum(sum(abs(U-U_lib(:,:,:,k)).^2))); 
    end

    %Chose the minumum and decode
    [useless,b_hat] = min(dist_mat);
    b_decod = decodif(b_hat,Nt);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5   
%For the channel estimation

if sim>num_pilots(snr)
    U_lib_estim = create_Ulib_estim(U_lib_estim,r_lib_estim,Nr,L,taps,Nt);
     
    %Look for the message at minimum distance 
    if Nt==1
        possible_messages = 2;
    else
        possible_messages = (Nt*BPS)^2;
    end
    
    for k = 1:possible_messages 
       dist_mat_estim(k) = sum(sum(sum(abs(U-U_lib_estim(:,:,:,k)).^2))); 
    end

    %Chose the minumum and decode
    [useless,b_hat_estim] = min(dist_mat_estim);
    b_decod_estim = decodif(b_hat_estim,Nt);
   
    
else
    b_decod_estim = b; %We are tx pilot symbols 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Demodulate the decodified symbol
bpskdemodulator = comm.BPSKDemodulator; %Demodulator
message_decod = bpskdemodulator(b_decod.');
message_decod_estim = bpskdemodulator(b_decod_estim.');

%Error calculation
num_error_ps_real(snr, taps) = num_error_ps_real(snr, taps) + sum(b_decod~=b);
num_error_ps_estim(snr, taps) = num_error_ps_estim(snr, taps) + sum(b_decod_estim~=b);


end %We have done this process for all the symbols tx

% disp(snr) %It is displayed in the screen

BER_ps_real(snr, taps, canales) =  num_error_ps_real(snr, taps)/(Nt*num_sim(snr));%Calculate the BER per symbol
BER_ps_estim(snr, taps, canales) =  num_error_ps_estim(snr, taps)/(Nt*num_sim(snr));%Calculate the BER per symbol

[PSNR,MSE_canal,MAXERR,L2RAT] = measerr(H_lib,H_estim);%Calculate the MSE of our channel estimation


% Display text to follow the simulation 
% disp('Ber_ps_real:')
% disp(BER_ps_real(snr))
% disp('Ber_ps_estim:')
% disp(BER_ps_estim(snr))
% disp('MSE:')
% disp(MSE_canal)
% 
% for nr=1:Nr  
%     disp(compose('Noise variance of Nr%d', nr))
%     disp(var(w(:,nr)))
%     if MSE_canal<var(w(:,nr))
%         disp(compose('The MSE of the channel is lower than the noise variance received by Nr%d', nr))
%     else
%         disp(compose('The MSE of the channel is greater than the noise variance received by Nr%d', nr))
%     end
% end
    
end %We have done this process for all the SNR values defined
 
end %We have done this process for all the channel taps
end %We have done it for all the different channels 
 
% save('Results_for_plotting/BER_ZC_STBC_4x2L=4.mat', 'BER_ps_estim')



%% simulation results -> plot

fh = figure(1);
fh.WindowState = 'maximized';

BER_ps_real_av = zeros(length(SNR_dB),length(L));
BER_ps_estim_av = zeros(length(SNR_dB),length(L));

for i=1:num_channels
    for j=1:length(SNR_dB)
        BER_ps_real_av(j,:) = mean(BER_ps_real(j,:,i));
        BER_ps_estim_av(j,:) = mean(BER_ps_estim(j,:,i));
    end
end

[row_real, col_real] = find(BER_ps_real==0);
BER_ps_real(row_real, col_real) = 10e-8;

[row_estim, col_estim] = find(BER_ps_estim==0);
BER_ps_estim(row_estim, col_estim) = 10e-8;

semilogy(SNR_dB, BER_ps_estim_av ,'Color','#A2142F','Linewidth', 1)
hold on
semilogy(SNR_dB, BER_ps_real_av,'Color','#4DBEEE','Linewidth', 1)

xlabel('SNR [dB]')
ylabel('BER')
% ylim([10e-5, 1])
label1 = compose('With channel estimation and L = %d', L);
label2 = compose('Without channel estimation and L = %d', L);

legend('With channel estimation','Without channel estimation')
title('Bit Error Rate (BER) / Signal-to-Noise Ratio (SNR)')

%Display characteristics of the system
txt1 = ['Number of taps: L = ' num2str(L)];
text(0.8,0.85,txt1,'FontSize',8,'Units','Normalized')
txt2 = ['Number of Tx antennas: Nt  = ' num2str(Nt)];
text(0.8,0.8,txt2,'FontSize',8,'Units','Normalized')
txt3 = ['Number of Rx antennas: Nr  = ' num2str(Nr)];
text(0.8,0.75,txt3,'FontSize',8,'Units','Normalized')
txt4 = ['Length of the preamble: ' num2str(num_pilots(1))];
text(0.8,0.7,txt4,'FontSize',8,'Units','Normalized')
txt4 = ['Number of channels generated: ' num2str(num_channels)];
text(0.8,0.65,txt4,'FontSize',8,'Units','Normalized')
% set(txt4, 'VerticalAlignment', 'baseline');   % Or 'middle'

grid on
hold off
% saveas(gcf,'Plots/Damours_ZC_STBC_4x4_L=1.eps', 'epsc')
