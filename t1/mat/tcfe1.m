close all
clear all

format long ;


%data  


R1 = 1.04775855388*1000;
R2 = 2.00711094558*1000;
R3 = 3.02178550749*1000;
R4 = 4.02797784466*1000;
R5 = 3.14843263841*1000;
R6 = 2.07021546873*1000;
R7 = 1.04260703248*1000;
Va = 5.06746014433;
Id = 1.0108365504*0.001;
Kb = 7.1618106871*0.001;
Kc = 8.27502512258*1000;

G1=1/R1;
G2=1/R2;
G3=1/R3;
G4=1/R4;
G5=1/R5;
G6=1/R6;
G7=1/R7;


%====================================================================

%lei das malhas

%====================================================================

%Opening file
filename="data_octave_current.tex";
fid=fopen(filename,"w");


a=[(R1+R3+R4),-R3,0,-R4; R4, 0, 0, -(R4+R6+R7)+Kc; 0, 0, 1, 0; -Kb*R3, Kb*R3-1, 0, 0];
b=[Va;0;-Id;0];

I=a\b
s=["b ";"d ";"R1";"R2";"R3";"R4";"R5";"R6";"R7";"Va";"Vc"];
i=[-I(2);-I(3);I(1);-I(2);I(1)-I(2);I(1)-I(4);I(2)-I(3);-I(4);-I(4);I(1);I(3)-I(4)]


for k = 1:11
 fprintf(fid, "$I_{%s%s}$ &  %.5e \\\\ \\hline \n",s(k,1),s(k,2),i(k));
endfor
fclose(fid);

%====================================================================

%lei dos nos

%====================================================================

c=[1,0,0,0,0,0,0;
G1,-G1,0,0,0,-G6,-G4;
G1, -(G1+G2+G3),G2,0,0,0,G3;
0,-(G2+Kb), G2, 0, 0, 0, Kb;
0, Kb, 0, G5, 0, 0, -(Kb+G5);
0,0,0,0,-1,Kc*G6,1;
0,0,0,0,G7,-(G6+G7),0];

d=[Va;0;0;0;Id;0;0];

v=c\d

%impressao das tensoes

filename = "data_octave_tensoes.tex";
fid=fopen(filename,"w");

fprintf(fid,"$V_0$ & 0.  \\\\ \\hline \n");

for k=1:7
	fprintf(fid,"$V_%d$ & %.5f \\\\ \\hline\n",k,v(k));
endfor;

fclose(fid);


%====================================================================

%erros

%====================================================================
spice_currents=[];
spice_currents(1)=  -2.76229e-04; %ib
spice_currents(2) = 1.010837e-03; %i_d
spice_currents(3) = 2.634648e-04; %r1
spice_currents(4)= -2.76229e-04; %r2
spice_currents(5)= -1.27639e-05; %R3
spice_currents(6) = 1.199108e-03; %R4
spice_currents(7) = 1.287065e-03; %R5
spice_currents(8)= 9.356437e-04; %R6
spice_currents(9) = 9.356437e-04; %R7
spice_currents(10)= -2.63465e-04; %va
spice_currents(11) = 7.519285e-05; %vc

spice_voltages=[];
spice_voltages(1) = 5.067460e+00;
spice_voltages(2) = 4.791413e+00;
spice_voltages(3) = 4.236991e+00;
spice_voltages(4) = 8.882220e+00;
spice_voltages(5) = -2.91249e+00;
spice_voltages(6) = -1.93698e+00;
spice_voltages(7) = 4.829982e+00;
% spice_voltages(8) = 0.000000e+00;
%hvc#branch = 7.519285e-05;
%va#branch = -2.63465e-04;
%vaux#branch = 9.356437e-04;

error_current=[];
for j=1:9
	error_current(j)=abs(spice_currents(j)-i(j))/abs(i(j)) * 100;
endfor;
	error_current(10)=abs(spice_currents(10)+i(10))/abs(i(10)) * 100;
	error_current(11)=abs(spice_currents(11)+i(11))/abs(i(11)) * 100;



error_voltages=[];
for t=1:7
	error_voltages(t)=abs(spice_voltages(t)-v(t))/abs(v(t)) * 100;
endfor;



filename_2 = "error_current.tex";
fid_2=fopen(filename_2,"w");


for t=1:11
	fprintf(fid_2,"$\\epsilon$ ($I_%s%s$) &  %.6f  \\\\ \\hline \n",s(t,1),s(t,2),error_current(t));
endfor;

fclose(fid_2);




filename_3 = "error_tensoes.tex";
fid_3=fopen(filename_3,"w");


for t=1:7
	fprintf(fid_3,"$\\epsilon$ (%d) &  %.6f  \\\\ \\hline \n",t,error_voltages(t));
endfor;

fclose(fid_3);

