%criação dos elos do robô de acordo com os parametros alpha,d, a e theta da
%matriz DN.

L(1) = Link([0  42  35  0  0]);
L(2) = Link([0  4  30  0  0]);
L(3) = Link([0  0  0  pi  1]);

%cria o robô a partir dos elos

robo = SerialLink(L, 'name', 'Robô engraxate');


%matriz q recebe a trajetoria de theta 1 , theta 2 e a variacao prismatica
%do elo 3
thetas1 = [0.1745    0.1461    0.0689   -0.0449   -0.1830   -0.3334   -0.4837   -0.6218   -0.7356 -0.8128   -0.8412 ];
thetas2 = [0.1745    0.1916    0.2381    0.3065    0.3896    0.4800    0.5704    0.6535    0.7219 0.7683    0.7854];
q1 = [thetas1; thetas2; 0 0 0 0 0 0 0 0 0 0 0];%3 vetores de 11 elementos cada
q = q1';

qf = [-48.1996 45.0000 0];%valores finais (última linha)

disp('Cinematica direta')
%calculo da cinematica direta a partir dos valores  finais de
%theta1 e 2 para conferir
T = robo.fkine(qf);
%pause;


%determinar o 'workspace' limites de x, y, z

robo.plotopt = {'workspace' [ -90,90,-90,90,0,100  ] };


%plot sem a trajetoria
robo.plot(qf);

%plot com a trajetoria
figure()
robo.plot(q)

%plot da trajetoria pelo temopo
figure()
plot(q);
