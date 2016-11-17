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

S = load('img_3_I.mat');
imagem = cell2mat(S.img_3_I(1,1));
clear S


% imagem = imresize(imagem,4);
figure();
imshow(imagem,[]);

% transforma a imagem em preto e branco
level = graythresh(imagem);
BW = im2bw(imagem,level);
figure()
imshow(BW)

% pega os buracos na imagem em preto e branco
[B,L,N,A] = bwboundaries(BW,'holes');
image_rgb = label2rgb(L, @jet, [.5 .5 .5]);
imagem_filtrada = image_rgb(:,:,1);
figure()
imshow(image_rgb)

%filtra ainda mais deixando os cinzas preto tbm.
[m,n] = size(imagem_filtrada);
ones_matriz = ones(m,n);
for i=1:m
    for j=1:n
        if imagem_filtrada(i,j) < 255
            ones_matriz(i,j) = 0;
        end
    end
end
figure()
imshow(ones_matriz)

%retira pixels ruidosos
imagem_sem_ruido = bwareaopen(ones_matriz,15);
figure()
imshow(imagem_sem_ruido)

%cria uma submatriz detectora
detector = ones(3,3);

%pega as posições onde existem a submatriz na matriz
[RR,CR] = findsubmat(imagem_sem_ruido, detector);

%escolhe qual dos possíveis ponto é o melhor. Estou so pegando o valor
%medio do array
n_options = size(RR);

if mod(n_options,2) == 0
    R = RR(end/2)+1;
    C = CR(end/2)+1;
else
    R = RR((end+1)/2)+1;
    C = CR((end+1)/2)+1;
end

xc = x_pos(R,C);
yc = y_pos(R,C);
zc = z_pos(R,C);