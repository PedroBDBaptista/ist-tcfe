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

%Opening file
filename="data_octave_current.tex";
fid=fopen(filename,"w");

%lei das malhas
a=[(R1+R3+R4),-R3,0,-R4; R4, 0, 0, -(R4+R6+R7)+Kc; 0, 0, 1, 0; -Kb*R3, Kb*R3-1, 0, 0];
b=[Va;0;-Id;0];

I=a\b
s=["b ";"d ";"R1";"R2";"R3";"R4";"R5";"R6";"R7";"Va";"Vc"];
i=[-I(2);-I(3);I(1);-I(2);I(1)-I(2);I(1)-I(3);I(2)-I(3);-I(4);-I(4);I(1);I(3)-I(4)]

for k = 1:11
 fprintf(fid, "$I_{%s%s}$ &  %e \\\\ \\hline \n",s(k,1),s(k,2),i(k));
endfor
fclose(fid);

%lei doS nos
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
	fprintf(fid,"$V_%d$ & %d \\\\ \\hline\n",k,v(k));
endfor;

fclose(fid);
