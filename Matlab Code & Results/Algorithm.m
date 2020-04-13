% What is the true measure of a man?
% EEE4114F Project : Steganography
% Nyasha Mashanda


%Fc = 17500; % The carrier frequency above average human hearing range
Fc = 20000;
%Fc = 25000;

BW = 12000; % Measured bandwidth of message/code

% Step I: Read the message

[code,Fs_code] = audioread('aa.mp3');

L = length(code); 
Y = fft(code,L);

% correcting the frequency axis to display freq spectrum
P2 = (abs(Y/L));
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs_code*(0:(L/2))/L;

figure(1)
plot(f,P1) 
title('Frequency Spectrum of Message')
xlabel('F(Hz)') 

% Step II: Modulating message
Fs = 2*(Fc+BW)+1000;
code_mod = modulate(code, Fc, Fs,'am');

c = code_mod;
L_c = length(c);
C = fft(c,L_c);

P6 = (abs(C/L_c));
P5 = P6(1:L_c/2+1);
P5(2:end-1) = 2*P5(2:end-1);

f2 = Fs*(0:(L_c/2))/L_c;
figure(3)

plot(f2, P5) 
title('Frequency Spectrum of Message Modulated')
xlabel('F(Hz)') 

% Step III: Extracting a single side-band

% Reading filter coefficients from file

%hp1 = xlsread('hp1.xlsx'); % for Fc = 17.5 kHz
%lp1 = xlsread('hp1.xlsx'); % for Fc = 17.5 kHz
hp1 = xlsread('hp2.xlsx'); % for Fc = 20 kHz
lp1 = xlsread('hp2.xlsx'); % for Fc = 20 kHz
%hp1 = xlsread('hp3.xlsx'); % for Fc = 25 kHz
%lp1 = xlsread('hp3.xlsx'); % for Fc = 25 kHz


imprespl1 = lp1;
impresph1 =  hp1;
z2 = conv(c(:, 1), impresph1);
z2 = conv(z2, imprespl1);
L_z2 = length(z2);

v = z2;

% Varying amplitude of message

%v = 0.1 .*v; % for stego 4
%v = 0.01 .*v; % for stego 5
Z2 = fft(z2,L_z2); 

P8 = (abs(Z2/L_z2));
P7 = P8(1:L_z2/2+1);
P7(2:end-1) = 2*P7(2:end-1);

figure(4)
f3 = Fs*(0:(L_z2/2))/L_z2;

plot(f3, 10*P7) 
title('Single Sideband of Modulated Message')
xlabel('F(Hz)') 

%  Step IV: Creating the stego file

cover = audioread('cover.mp3');
L_c = length(cover);
L_a = L_c - L_z2;

v_pad = [v;zeros(L_a,1)]; % padding v so that it can be added to cover message

stego = v_pad +  cover(:, 1); %taking the mono
%audiowrite('stego1.wav',stego,Fs_code); %for extract 1
audiowrite('stego2.wav',stego,Fs_code); %for extract 2
%audiowrite('stego3.wav',stego,Fs_code); %for extract 3
%audiowrite('stego4.wav',stego,Fs_code); %%for extract 4
%audiowrite('stego5.wav',stego,Fs_code); %for extract 5
%audiowrite('stego6.wav',stego,Fs_code); %for extract 6
%audiowrite('stego7.wav',stego,Fs_code); %for extract 6
%audiowrite('stego8.wav',stego,Fs_code); %for extract 7
%audiowrite('stego9.wav',stego,Fs_code); %for extract 8
%audiowrite('stego10.wav',stego,Fs_code); %for extract 9


%  Step VI: Demodulation @ receiving side

g = conv(stego,impresph1); % taking the mono-track
g = conv(g, imprespl1);

x = demod(g,Fc,Fs); 
L_x = length(x);
X = fft(x,L_x);

P10 = (abs(X/L_x));
P9 = P10(1:L_x/2+1);
P9(2:end-1) = 2*P9(2:end-1) ;

f3 = Fs*(0:(L_x/2))/L_x;
figure(5)

plot(f3, P9) 
title('Frequency Spectrum of Demodulated Message')
xlabel('F(Hz)') 

%soundsc(x,Fs_code); % lets play the extracted message

%audiowrite('extract1.wav',x,Fs_code);
audiowrite('extract2.wav',x,Fs_code);
%audiowrite('extract3.wav',x,Fs_code);
%audiowrite('extract4.wav',x,Fs_code);
%audiowrite('extract5.wav',x,Fs_code);
%audiowrite('extract6.wav',x,Fs_code);
%audiowrite('extract7.wav',x,Fs_code);
%audiowrite('extract8.wav',x,Fs_code);
%audiowrite('extract9.wav',x,Fs_code);
