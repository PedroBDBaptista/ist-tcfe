close all
clear all

%===================================================

%LEITURA DO FICHEIRO DATA

%===================================================
%open=fopen("/home/vaz/ist-tcfe/t2/data.txt","r")

data=fileread('../data.txt');

data=strsplit(data,{"\n","="});

for i=1:7
  R(i)=str2double(cell2mat(data(i*2-1+4)))*1000;
  G(i)=1/R(i);
endfor

Vs= str2double(cell2mat(data(19)));
C = str2double(cell2mat(data(21))) / 1000000;
Kb= str2double(cell2mat(data(23))) /1000;
Kd= str2double(cell2mat(data(25)))*1000;


%===================================================

%FICHEIRO DATA NGSPICE 1)

%===================================================

filename = "data_ngspice1.txt";
fid=fopen(filename,"w");

fprintf(fid, "*ANALISE ESTATICA\n");

fprintf(fid, "*fontes de tensao\n" );
fprintf(fid, "Vs 1 0 %f \n",Vs);

fprintf(fid, "Vaux 0 9 0 \n");

fprintf(fid, "Hvd 5 8 Vaux %f \n",Kd);


fprintf(fid, "*fontes de corrente\n" );

fprintf(fid, "Gib 6 3 2 5 %f \n",Kb);


fprintf(fid, "*resistencias\n" );

fprintf(fid, "R1 1 2 %f \n", R(1));
fprintf(fid, "R2 3 2 %f \n", R(2));
fprintf(fid, "R3 2 5 %f \n", R(3));
fprintf(fid, "R4 5 0 %f \n", R(4));
fprintf(fid, "R5 5 6 %f \n", R(5));
fprintf(fid, "R6 9 7 %f \n", R(6));
fprintf(fid, "R7 7 8 %f \n", R(7));

fprintf(fid, "*condensador\n" );

fprintf(fid, "C1 6 8 %f \n",C );

fprintf(fid, ".end \n");

fclose(fid);






%===================================================

%ALINEA 1

%===================================================

A=[
0,     0,0,1,0,0,0,0;
1,     0,0,0,0,0,0,0;
G(1),  -(G(1)+G(2)+G(3)),    G(2),   0,   G(3),          0,   0,   0;
0,     -(G(2)+Kb),           G(2),    0,    Kb,          0,   0,   0;
-G(1),   G(1),                0,      0,    G(4)         ,0   ,G(6)    ,0;
0,       0,                   0,      0,     1,          0,   Kd*G(6),-  1;
0,      -Kb,                  0,      0,    G(5)+Kb,    -G(5),       0,       0;
0,       0,                   0,       0,    0,           0,   -(G(6)+G(7)),    G(7);
];

B=[0;Vs;0;0;0;0;0;0;];

Vol=A\B;


%IMPRESSAO DOS VALORES DAS TENSOES PARA FICHEIRO PARA O LATEX

filename = "data_alinea_1.tex";
fid=fopen(filename,"w");

%IMPRESSAO DA CORRENTES
fprintf(fid,"$I(C)$ & %.6g A \\\\ \\hline\n",0.);
fprintf(fid,"$Ib$ & %.6g A \\\\ \\hline\n",(Vol(3)-Vol(2))/R(2));
fprintf(fid,"$I(R1)$ & %.6g A \\\\ \\hline\n",(Vol(1)-Vol(2))/R(1));
fprintf(fid,"$I(R2)$ & %.6g A \\\\ \\hline\n",(Vol(3)-Vol(2))/R(2));
fprintf(fid,"$I(R3)$ & %.6g A \\\\ \\hline\n",(Vol(2)-Vol(5))/R(3));
fprintf(fid,"$I(R4)$ & %.6g A \\\\ \\hline\n",(Vol(5)-Vol(4))/R(4));
fprintf(fid,"$I(R5)$ & %.6g A \\\\ \\hline\n",(Vol(5)-Vol(6))/R(5));
fprintf(fid,"$I(R6)$ & %.6g A \\\\ \\hline\n",(Vol(7)-Vol(4))/R(6));
fprintf(fid,"$I(R7)$ & %.6g A \\\\ \\hline\n",(Vol(7)-Vol(8))/R(7));



for k=1:8
	fprintf(fid,"$V_%d$ & %.7f V \\\\ \\hline\n",k,Vol(k));
endfor;

fprintf(fid,"$I(Vs)$ & %.6g A \\\\ \\hline\n",(Vol(1)-Vol(2))/R(1));
fprintf(fid,"$I(Vd)$ & %.6g A \\\\ \\hline\n",(Vol(7)-Vol(8))/R(7));

fclose(fid);


%=======================================

%IMPRESSAO DOS VALORES PARA NGSPICE 2)

%=======================================
filename = "data_ngspice2.txt";
fid=fopen(filename,"w");

fprintf(fid, "*ANALISE ESTATICA T=0 \n");

fprintf(fid, "*fontes de tensao\n" );
fprintf(fid, "Vs 1 0 0 \n");

fprintf(fid, "Vaux 0 9 0 \n");

fprintf(fid, "Hvd 5 8 Vaux %f \n",Kd);

fprintf(fid, "Vx 6 8 %f \n",Vol(6)-Vol(8));
fprintf(fid, "*fontes de corrente\n" );

fprintf(fid, "Gib 6 3 2 5 %f \n",Kb);


fprintf(fid, "*resistencias\n" );

fprintf(fid, "R1 1 2 %f \n", R(1));
fprintf(fid, "R2 3 2 %f \n", R(2));
fprintf(fid, "R3 2 5 %f \n", R(3));
fprintf(fid, "R4 5 0 %f \n", R(4));
fprintf(fid, "R5 5 6 %f \n", R(5));
fprintf(fid, "R6 9 7 %f \n", R(6));
fprintf(fid, "R7 7 8 %f \n", R(7));

fprintf(fid, ".end \n");

fclose(fid);




%============================================

%alinea 2

%============================================

%DETERMINAÇAO DE IX

SVS=[        -(G(1)+G(2)+G(3)),  G(2) ,  G(3),                0,            0,              0,             0;
	        -(G(2)+Kb),          G(2),    Kb,                 0,            0,              0,             0;
	       G(1),                  0,     G(4),                0,           G(6),              0,           0;
	        -Kb,                 0,     G(5)+Kb,           -G(5),          0,               0,           -1;
	         0,                   0,             1,           0,              Kd*G(6),      -1               0;
	         0,                0,         0,                  1,             0,             -1,             0;
	         0,                   0,     0,                      0,       -(G(6)+G(7)),       G(7),      0;];

col=[0;0;0;0;0;Vol(6)-Vol(8);0];


sol=SVS\col;


Ix=sol(7);
Req=abs((Vol(6)-Vol(8))/Ix);

filename = "res_eq.tex";
fid=fopen(filename,"w");
fprintf(fid,"V(6)-V(8) &   %f V \\\\ \\hline\n", (Vol(6)-Vol(8)));
fprintf(fid,"$I_x$ &   %f A \\\\ \\hline\n", Ix);
fprintf(fid,"$R_{eq}$ &   %f $\\Omega$ \\\\ \\hline\n", Req);
fprintf(fid,"$\\tau$ & %f s \\\\ \\hline\n",C*Req);
fclose(fid);



%IMPRESSAO DA TABELA%%%%%%%%%%%%%%%%%%

filename = "data_alinea_2.tex";
fid=fopen(filename,"w");

fprintf(fid,"$V_1$ & %.7f \\\\ \\hline\n",0);
fprintf(fid,"$V_2$ & %.7f \\\\ \\hline\n",sol(1));
fprintf(fid,"$V_3$ & %.7f \\\\ \\hline\n",sol(2));
fprintf(fid,"$V_4$ & %.7f \\\\ \\hline\n",0);
fprintf(fid,"$V_5$ & %.7f \\\\ \\hline\n",sol(3));
fprintf(fid,"$V_6$ & %.7f \\\\ \\hline\n",sol(4));
fprintf(fid,"$V_7$ & %.7f \\\\ \\hline\n",sol(5));
fprintf(fid,"$V_8$ & %.7f \\\\ \\hline\n",sol(6));
fprintf(fid,"$I_x$ & %.7f \\\\ \\hline\n",Ix);
fprintf(fid,"$V_x$ & %.7f \\\\ \\hline\n",Vol(6)-Vol(8));
fprintf(fid,"$R_{eq}$ & %.7f \\\\ \\hline\n",abs((Vol(6)-Vol(8))/Ix));


fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%NATURAL SOLUTION GRAPHIC [NUMERIC COMPUTATION]%%%%% v6n[t]%

%time axis: 0 to 20ms with 1 micro seconds as step
t=0:1e-6:20e-3;

Tc=1/(Req*C); %timeconstant

v6n=sol(4)*exp(-Tc*t);

hf = figure ();
plot (t*1000, v6n, "r;V6n(t);");

xlabel("t[ms]");
ylabel("V6n(t) [V]");
print (hf, "natural.eps", "-depsc");
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================================

%Dados 3) para NGSPICE

%=======================================================

filename = "data_ngspice3.txt";
fid=fopen(filename,"w");

fprintf(fid, "*ANALISE T>0 NATURAL SOLUTION\n");

fprintf(fid, "*Fontes de tensao\n" );
fprintf(fid, "Vs 1 0 0 \n");

fprintf(fid, "Vaux 0 9 0 \n");

fprintf(fid, "Hvd 5 8 Vaux %f \n",Kd);


fprintf(fid, "*Fontes de corrente\n" );

fprintf(fid, "Gib 6 3 2 5 %f \n",Kb);


fprintf(fid, "*Resistencias\n" );

fprintf(fid, "R1 1 2 %f \n", R(1));
fprintf(fid, "R2 3 2 %f \n", R(2));
fprintf(fid, "R3 2 5 %f \n", R(3));
fprintf(fid, "R4 5 0 %f \n", R(4));
fprintf(fid, "R5 5 6 %f \n", R(5));
fprintf(fid, "R6 9 7 %f \n", R(6));
fprintf(fid, "R7 7 8 %f \n", R(7));

fprintf(fid, "*condensador\n" );

fprintf(fid, "C1 6 8 %f \n",C );

fprintf(fid, "*INITIAL CONDITIONS FOR TRANSIENT ANALYSIS\n")
fprintf(fid, ".ic v(6)=%f v(8)=%f \n",sol(4),sol(6))
fprintf(fid, ".end \n");

fclose(fid);



%============================================

%alinea 4

%============================================

f=1000;
w=2*pi*f;

vs=exp(-pi/2 * j)

y=(j*w*C)

A3=[
0,     0,0,1,0,0,0,0;
1,     0,0,0,0,0,0,0;
G(1),  -(G(1)+G(2)+G(3)),    G(2),   0,   G(3),          0,   0,   0;
0,     -(G(2)+Kb),           G(2),    0,    Kb,          0,   0,   0;
-G(1),   G(1),                0,      0,    G(4)         ,0   ,G(6)    ,0;
0,       0,                   0,      0,     1,          0,   Kd*G(6), -1;
0,       0,                   0,       0,    0,           0,   -(G(6)+G(7)),    G(7);
0,       -Kb,                 0,        0,     G(5)+Kb,    -G(5)-y,     0,        y;
];

B3=[0;vs;0;0;0;0;0;0;];

sol3=A3\B3

%PRINTING COMPLEX AMPLITUDE NODES TO LATEX TABLE


filename = "data_alinea_d.tex";
fid=fopen(filename,"w");
for k=1:8
	fprintf(fid,"$\\tilde{V}_%d$ & %.7f +i (%.7f) \\\\ \\hline\n",k,real(sol3(k)),imag(sol3(k)));
endfor;

fclose(fid);

%PLOTTING FORCED SOLUTION%%%%%%%%%%%%%%%%%%%

%time axis: 0 to 20ms with 1 micro second as step
%t=0:1e-6:20e-3;

Ampl=abs(sol3(6));
Phase=-arg(sol3(6));
v6f=Ampl*cos(w*t-Phase);

clf(hf);
plot (t*1000, v6f, "r;V6f(t);");

xlabel("t[ms]");
ylabel("V6f(t) [V]");
print (hf, "forced.eps","-depsc");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================

%Dados 4 para NGSPICE

%============================================

filename = "data_ngspice4.txt";
fid=fopen(filename,"w");

fprintf(fid, "*ANALISE T>0 TRANSIENT ANALYSIS AND FREQUENCY ANALYSIS\n");

fprintf(fid, "*Fontes de tensao\n" );
fprintf(fid, "Vs 1 0 0.0 ac 1.0 sin (0 1 1k) \n");

fprintf(fid, "Vaux 0 9 0 \n");

fprintf(fid, "Hvd 5 8 Vaux %f \n",Kd);


fprintf(fid, "*Fontes de corrente\n" );

fprintf(fid, "Gib 6 3 2 5 %f \n",Kb);


fprintf(fid, "*Resistencias\n" );

fprintf(fid, "R1 1 2 %f \n", R(1));
fprintf(fid, "R2 3 2 %f \n", R(2));
fprintf(fid, "R3 2 5 %f \n", R(3));
fprintf(fid, "R4 5 0 %f \n", R(4));
fprintf(fid, "R5 5 6 %f \n", R(5));
fprintf(fid, "R6 9 7 %f \n", R(6));
fprintf(fid, "R7 7 8 %f \n", R(7));

fprintf(fid, "*condensador\n" );

fprintf(fid, "C1 6 8 %f \n",C );

fprintf(fid, "*INITIAL CONDITIONS FOR TRANSIENT ANALYSIS\n")
fprintf(fid, ".ic v(6)=%f v(8)=%f \n",sol(4),sol(6))
fprintf(fid, ".end \n");

fclose(fid);


%============================================

%alinea 5

%============================================

% PLOTTING FINAL SOLUTION
AmpSource=abs(vs);
PhaseSource=-arg(vs);

Vsource=AmpSource*cos(w*t-PhaseSource);


clf(hf);
plot(t*1000,v6n+v6f,"r;V6(t);");
hold on;
plot(t*1000,Vsource,"b;Vsource(t);");
hold on;


xlabel("t[ms]");
ylabel("V6(t)/Vs(t) [V]");
print(hf, "final.eps","-depsc");


%============================================

%alinea 6

%============================================

freq=logspace(0,6,100);

we=2*pi*freq;

ye=(j*we*C)

for i=1:100
	A6=[
	0,     0,0,1,0,0,0,0;
	1,     0,0,0,0,0,0,0;
	G(1),  -(G(1)+G(2)+G(3)),    G(2),   0,   G(3),          0,   0,   0;
	0,     -(G(2)+Kb),           G(2),    0,    Kb,          0,   0,   0;
	-G(1),   G(1),                0,      0,    G(4)         ,0   ,G(6)    ,0;
	0,       0,                   0,      0,     1,          0,   Kd*G(6), -1;
	0,       0,                   0,       0,    0,           0,   -(G(6)+G(7)),    G(7);
	0,       -Kb,                 0,        0,     G(5)+Kb,    -G(5)-ye(i),     0,        ye(i);
	];

	B6=[0;vs;0;0;0;0;0;0;];

	C6=A6\B6;

	amp_f_6(i)=C6(6);
	amp_f_8(i)=C6(8) %guarda num vetor a tensao em 8 para diferentes freq tal como amp_f_8
	fonte_s(i)=1.; %Vs
	fase_vs(i)=arg(vs)+pi/2;

endfor;

%PLOTTING


amp_6=abs(amp_f_6);
for(i=1:100)
	if(arg(amp_f_6(i))>pi/2)
		fase_6(i)=arg(amp_f_6(i))-2*pi;
	else
	fase_6(i)=arg(amp_f_6(i));
	endif;
endfor;

clf(hf);
semilogx (freq, 20*log10(amp_6),"r;Amplitude V6(f);");
hold on;
semilogx(freq,20*log10(fonte_s),"-b;Amplitude Vs(f);");
hold on;
semilogx(freq,20*log10(abs(amp_f_6-amp_f_8)),"g;Amplitude Vc(f);");
hold on;
semilogx(freq,20*log10(abs(amp_f_8)),"--y;Amplitude V8(f);");

xlabel("f [Hz]");
ylabel("V(f) [dB]");
print (hf, "alinea_6_amp.eps","-depsc");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf(hf);
semilogx (freq, 20*log10(amp_6),"r;Amplitude V6(f);");
hold on;
semilogx(freq,20*log10(fonte_s),"-b;Amplitude Vs(f);");
%hold on;
%semilogx(freq,20*log10(abs(amp_f_6-amp_f_8)),"g;Amplitude Vc(f);");
hold on;
semilogx(freq,20*log10(abs(amp_f_8)),"--y;Amplitude V8(f);");

xlabel("f [Hz]");
ylabel("V(f) [dB]");
print (hf, "alinea_6_amp_2.eps","-depsc");




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf(hf)
semilogx(freq,(fase_vs)*180/pi,"--y;Phase Vs(f);"); %fase de vs como
hold on;
semilogx(freq,(fase_6+pi/2)*180/pi,"r;Phase V6(f);");
hold on;
semilogx(freq,(arg(amp_f_8)+pi/2-2*pi)*180/pi,"b;Phase V8(f);"); %fase de 8
hold on;
semilogx(freq,(arg(amp_f_6-amp_f_8)+pi/2)*180/pi,"g;Phase Vc(f);"); %fase de Vc
xlabel("f [Hz]");
ylabel("Phase [degrees]");
print (hf, "alinea_6_fases.eps","-depsc");
