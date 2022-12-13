close all
clear all
pkg load image

im = imread('/home/phelyppe/Documentos/Workspace/black-bean-profitability/Crops/imagem8,L4,C5.jpg');
imCinza = im;

figure('Name','Imagem original')
imshow(im)

% Obtendo histograma da imagem para fazer a separação de regiões
vHist = imhist(im);
vHistSrc(1,:) = vHist(:,1);

vHistED = vHistSrc;
vHistDE = vHistSrc;

for(i=2: size(vHistED,2))
    if(vHistED(i) < vHistED(i-1))
        vHistED(i) = vHistED(i-1);
    end
end

figure('Name','Gráfico com pico esquerda-direita')
plot(vHistED)

for(i=size(vHistDE,2)-1:-1:1)
    if(vHistDE(i) < vHistDE(i+1))
        vHistDE(i) = vHistDE(i+1);
    end
end

figure('Name','Gráfico com pico direita-esquerda')
plot(vHistDE)

pico1 = mode(vHistED)
pico2 = mode(vHistDE)

iPico1 = 0;
iPico2 = 0;

% For para pegar indice do pico1
for(i=1:size(vHistSrc,2))
    if(vHistSrc(i) == pico1)
        iPico1 = i
    end
end

% For para pegar indice do pico2
for(i=size(vHistSrc,2):-1:1)
    if(vHistSrc(i) == pico2)
        iPico2 = i
    end
end

depressao = pico1;
iDepressao = 0;
% For para pegar o indice da maior depressão entre os picos
for(i=iPico1:iPico2)
    if(vHistSrc(i) < depressao)
        depressao = vHistSrc(i);
        iDepressao = i;
    end    
end

imCinza(im > iDepressao) = 0;
imCinza(im <= iDepressao) = 255;
imLogica = logical(imCinza);

figure('Name','Imagem em parte segmentada')
imshow(imLogica .* im)