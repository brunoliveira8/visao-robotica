%Identificando o Sapato
clc 
clear all
close all

 S = load('img_3_Xyz.mat');
 imagem_xyz = cell2mat(S.img_3_Xyz(1,1));
 x_pos = imagem_xyz(:,:,1);
 y_pos = imagem_xyz(:,:,2);
 z_pos = imagem_xyz(:,:,3);
 
 clear S


imagem = aquisicao_imagem();


figure();
imshow(imagem,[]);

% transforma a imagem em preto e branco
level = graythresh(imagem);
BW = im2bw(imagem,level);
figure()
imshow(BW)

% pega os buracos na imagem em preto e branco
[B,L] = bwboundaries(BW,'holes');
% figure()
% imshow(L)

%Pega a matriz L e aplica um filtro nela.
% A matriz L tem os pixels da imagem com labels, eu filtro com os valor que
% se aproxima dos pixel do sapato, no caso eh 8
[m,n] = size(L);
imagem_filtrada = zeros(m,n);
threshold = 3;
for i=1:m
    for j=1:n
        if L(i,j) > threshold
            imagem_filtrada(i,j) = 1;
        end
    end
end

%tira pixels aleatorios da imagem.
imagem_filtrada = bwareaopen(imagem_filtrada,15);
figure()
imshow(imagem_filtrada)


%cria uma submatriz detectora
detector = ones(3,3);

%pega as posi��es onde existem a submatriz na matriz
[RR,CR] = findsubmat(imagem_filtrada, detector);

%escolhe qual dos poss�veis ponto � o melhor. Estou so pegando o valor
%medio do array
n_options = size(RR);

if mod(n_options(2),2) == 0
    R = RR(end/2)+1;
    C = CR(end/2)+1;
else
    R = RR((end+1)/2)+1;
    C = CR((end+1)/2)+1;
end

xc = x_pos(R,C);
yc = y_pos(R,C);
zc = z_pos(R,C);

%transforma��o para o frame da base
xb = xc*(-1)+0.12;
yb = yc*(1)+0.2;
l1 = 0.35;
l2 = 0.30;
%calculando os thetas finais atraves da cinematica inversa
c2 = ((xb^2 + yb^2 - l2^2-l1^2)/(2*l1*l2));
s2 = sqrt(abs(1-c2^2));
theta2 = atan2(s2,c2);
theta1 = atan2(yb,xb)-atan2((12*sin(theta2)),(11+12*cos(theta2)));

teta1 = theta1*180/pi;
teta2 = theta2*180/pi;

%calculo da trajetoria de theta1
theta0 = -10*pi/180;
tf = 5;
t = 0:0.5:5;
a01 = theta0;
a11 = 0;
a21 = (3/tf^2)*(theta1-theta0);
a31 = (-2/tf^3)*(theta1-theta0);

thetas1 = a01+a11.*t+a21.*t.^2+a31.*t.^3;

tetas1 = thetas1.*(180/pi)


%calculo da trajetoria de theta2
a02 = theta0;
a12 = 0;
a22 = (3/tf^2)*(theta2-theta0);
a32 = (-2/tf^3)*(theta2-theta0);

thetas2 = a02+a12.*t+a22.*t.^2+a32.*t.^3;

tetas2 = thetas2.*(180/pi)


figure()
plot(t,tetas1,t,tetas2);