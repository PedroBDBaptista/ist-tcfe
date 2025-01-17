close all
clear all
%comentario

dt=5e-4;
period=1./50.;
tmax=11*period/dt;
tmaxgraf=10*period/dt;
translacao_tempo=period/dt;
freq=2*pi*50.;
A=230./10.;


%envelope
R1=300e3;
R2=715e3;
C1=300e-6;



% T off
toff=(1/freq)*atan(R1*C1*freq);


j=1;

for i=1:tmax

	t(i)=i*dt;
	v2(i)=A*sin(freq*t(i));

	if(v2(i)>0)
		v3(i)=v2(i);
	else
		v3(i)=0.;
	endif;



	if(t(i)>toff &&    A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1)) > v3(i))
		vo(i)=A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1));
	else
		vo(i)=0.;
	endif;

	if(A * sin(freq*toff) * exp(-(t(i)-toff)/(R1*C1)) < v3(i)    &&   t(i)>toff+period)
		toff=toff+period;
	endif;

	%voltagem envelope
	venvelope(i)=v3(i);
	if(vo(i)>v3(i))
		venvelope(i)=vo(i);
	endif;


endfor;

%%%%VOLTAGE REGULATOR

%solving using accurate model

function f=f(v,Vs,R)
Is=1e-14;
VT=0.02586491702;
f=v+R*Is*(exp(v/(22*VT))-1)-Vs;
endfunction

function fd=fd(v,R)
Is=1e-14;
VT=0.02586491702;
fd=1+R*Is/(22*VT)*exp(v/(22*VT));
endfunction

function find_Root=Solve_f(Vs,R)
	delta=1e-6;
	x_next=0.5;

	do
		x=x_next;
		x_next=x-f(x,Vs,R)/fd(x,R);
	until (abs(x-x_next)<delta);
	find_Root=x_next;
endfunction


for i=1:tmax
v_out(i)=Solve_f(venvelope(i),R2);
endfor;

%GRAFICOS

%making new vectores

for j=1:tmaxgraf
	tgraf(j)=t(j+translacao_tempo);
	v2graf(j)=v2(j+translacao_tempo);
	v3graf(j)=v3(j+translacao_tempo);
	vograf(j)=vo(j+translacao_tempo);
	venvelopegraf(j)=venvelope(j+translacao_tempo);
	v_outgraf(j)=v_out(j+translacao_tempo);
	v_out_graf_12(j)=v_outgraf(j)-12;
endfor

hf = figure ();
plot(tgraf, v2graf, "g;Voltage source;");
hold on;
plot(tgraf, v3graf, "r;Rectifier only;");
hold on;
%plot(tgraf, vograf, "b");
%hold on;
plot(tgraf, venvelopegraf, "-k;Envelope Detector;");

axis([tgraf(1),tgraf(tmaxgraf)]);
xlabel("t[s]");
ylabel("Voltage [V]");
print(hf, "v2.eps", "-depsc");

clf(hf);

plot(tgraf, venvelopegraf, "-k");
axis([tgraf(1),tgraf(tmaxgraf)]);
xlabel("t[s]");
ylabel("Voltage [V]");
print(hf, "venvelope.eps", "-depsc");


clf(hf);
hf = figure();
plot(tgraf,v_outgraf,"b");
axis([tgraf(1),tgraf(tmaxgraf)]);
xlabel("t[s]");
ylabel("v_{out}(t) [V]");
print(hf,"vout.eps","-depsc");

clf(hf);
hf = figure();
plot(tgraf,v_out_graf_12,"b");
axis([tgraf(1),tgraf(tmaxgraf)]);
xlabel("t[s]");
ylabel("v_{out}(t)-12 [V]");
print(hf,"vout_12.eps","-depsc");

printf("media do vout:      %f\n",mean(v_outgraf));
printf("ripplr do vout:      %f\n",max(v_outgraf)-min(v_outgraf));
