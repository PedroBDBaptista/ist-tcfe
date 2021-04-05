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

Vs= str2double(cell2mat(data(19)))
C = str2double(cell2mat(data(21))) / 1000000
Kb= str2double(cell2mat(data(23))) /1000
Kd= str2double(cell2mat(data(25)))*1000


%===================================================

%FICHEIRO DATA NGSPICE 1)

%===================================================

filename = "data_ngspice.mod";
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

filename = "data_alinea_a.tex";
fid=fopen(filename,"w");

for k=1:8
	fprintf(fid,"$V_%d$ & %.7f \\\\ \\hline\n",k,Vol(k));
endfor;

%IMPRESSAO DA CORRENTES


fclose(fid);


%=======================================

%IMPRESSAO DOS VALORES PARA NGSPICE 2)

%=======================================
filename = "data_ngspice3.txt";
fid=fopen(filename,"w");

fprintf(fid, "*ANALISE t>0 Natural solution\n");

fprintf(fid, "*fontes de tensao\n" );
fprintf(fid, "Vs 1 0 0 \n");

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


%printf("\n\n Ix=   %f", Ix);


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
fprintf(fid,"$R_{eq}$ & %.7f \\\\ \\hline\n",(Vol(6)-Vol(8))/Ix);


fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%FALTA O GRAFICO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================================

%Dados 3) para NGSPICE

%=======================================================

filename = "data_ngspice3.txt";
fid=fopen(filename,"w");

fprintf(fid, "*ANALISE ESTATICA\n");

fprintf(fid, "*fontes de tensao\n" );
fprintf(fid, "Vs 1 0 0 \n");

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

%filename = "data_ngspice3_2.txt";
%fid=fopen(filename,"w");

%fprintf(fid, "")

%============================================

%alinea 3

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
