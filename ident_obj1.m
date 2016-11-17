function [] = ident_obj1(imagem)
    %Transforma a matriz de profundidade em matriz de intensidade
I = mat2gray(imagem);

% figure;
% imshow(I)

%Inverte a imagem. Preto vira branco e branco vira preto
I2 = 1-I;

%Faz a segmenta��o da imagem utilizando o m�todo de Otsu
level = graythresh(I2);
BW = im2bw(I, level);
BW = ~BW;

%Remove pixels pequenos
BW = bwareaopen(BW, 20);
% figure;
% imshow(BW);

%Identificado objeto pela forma
%bwconncomp identifica os objetos
CC = bwconncomp(BW);

%ver quantos objetos tem na cena
n_objects = CC.NumObjects;

%essa variavel ajuda na hora de transformar os indices lineares em indicies
%normais
s = size(I);

%extrai informa��es dos objetos na cena
stats = regionprops(CC, 'area', 'perimeter');

%Analisa a circularidade dos objetos na cena
for l = 1:n_objects
    idx = CC.PixelIdxList{l};
    
    area = stats(l).Area;
    perimeter = stats(l).Perimeter;
    
    %indicador de circularidade
    %fonte: http://angeljohnsy.blogspot.com/2012/05/find-area-perimeter-centroid.html
    roundness = (4*area*pi)/(perimeter^2);
    
    if roundness < 0.90
        [R, C] = ind2sub(s, idx);
        BW(R,C) = 0;
    end
end

%figure;
imshow(BW)

%Dilatar o rob�
% se = offsetstrel('ball',5,5);
% dilatedI = imdilate(BW,se);
% figure
% imshow(dilatedI)

%Desenhar um circulo involta do desenho
stats = regionprops(BW,'Centroid','MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
%diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
diameters = stats.MajorAxisLength;
radii = diameters/2;
hold on
viscircles(centers,radii);
hold off

end