pkg load image;
close all
clear all

imCinza = imread('C:\Users\Erick\Documents\PDI\black-bean-profitability\Crops\imagem1,L2,C2.jpg');

% Guardando em um vetor o histograma da imagem
v = imhist(imCinza);
vHist(1,:) = v(:,1);

% Criando vetores para guardar os picos
vHist1 = vHist;
vHist2 = vHist;

% laço para achar o valor do pico1
for(i=2:size(vHist,2))
    if(vHist1(i) < vHist1(i-1))
        vHist1(i) = vHist1(i-1);
    end
end

##figure(1)
##plot(vHist1)

% atribuindo valor do pico1
pico1 = mode(vHist1);

% laço para achar o valor do pico2
for(i=size(vHist,2)-1:-1:1)
    if(vHist2(i) < vHist2(i+1))
        vHist2(i) = vHist2(i+1);
    end
end

##figure(2)
##plot(vHist2)

% atribuindo valor do pico2
pico2 = mode(vHist2);

iPico1 = 0;
iPico2 = 0;

% atribuindo o indice do iPico1
for(i=1:size(vHist,2))
    if(vHist1(i) == pico1)
        iPico1 = i;
        break;
    end
end

% atribuindo o indice do iPico2
for(i = size(vHist,2):-1:1)
    if(vHist1(i) == pico2)
        iPico2 = i;
        break;
    end
end

depre = pico1;
iDepre = 0;

% pegando o indice da depressao
for(i=iPico1:iPico2)
    if(vHist(i) < depre)
        iDepre = i;
        depre = vHist(i);
    end
end

imTeste = imCinza;
imTeste(imCinza(:,:) > iDepre) = 255;

##figure(3)
##imshow(imTeste)


#EE(IA) para dilatar
IA = [0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0];


#EE(ID) para erodir
ID = [1 1 1;
      1 1 1;
      1 1 1];

EE = [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1];
EA = [0 0 0 0 0;0 0 0 0 0;0 0 0 0 0;0 0 0 0 0;0 0 0 0 0];

imDecremento = imTeste;
imDecremento(imTeste>126) = 0;
imDecremento(imTeste<126) = 255;
imDecremento = logical(imDecremento);

imteste = zeros(size(imDecremento, 1)+2, size(imDecremento, 2)+2);

for(i=2:size(imteste,1)-1)
    for(j=2:size(imteste,2)-1)
        imteste(i,j) = imDecremento(i-1,j-1);
    end
end

final = imteste;

% Erosão para remover ruídos

for (i=2:size(imteste,1)-1)
    for (j=2:size(imteste,2)-1)
        if(imteste(i, j) == 1)
            SomV = [imteste(i-1,j- 1) imteste(i-1,j) imteste(i-1,j+1);...
                    imteste(i , j- 1) imteste(i , j) imteste(i , j+1);...
                    imteste(i+1,j-1) imteste(i+1,j) imteste(i+1,j+1)];
            if(sum(sum(SomV == ID))!= 9)
                final(i, j) = 0;
            end
        end
    end
end

figure('name','erodida pela primeira vez')
imshow(final)

# Dilatação para remover buraco do brilho no feijão

final2 = final;

for (i=3:size(final,1)-3)
    for (j=3:size(final,2)-3)
        if(final(i,j)==0)
            if (!( final(i-2,j-2)==EA(1,1) && final(i-2,j-1)==EA(1,2)  && final(i-2,j)==EA(1,3)  && final(i-2,j+1)==EA(1,4) && final(i-2,j+2)==EA(1,5) &&
                final(i-1,j-2)==EA(2,1) && final(i-1,j-1)==EA(2,2)  && final(i-1,j)==EA(2,3)  && final(i-1,j+1)==EA(2,4) && final(i-1,j+2)==EA(2,5) &&
                final(i ,j-2)==EA(3,1) && final(i  ,j-1)==EA(3,2)  && final(i  ,j)==EA(3,3)  && final(i   ,j+1)==EA(3,4) && final(i  ,j+2)==EA(3,5) &&
                final(i+1,j-2)==EA(4,1) && final(i+1,j-1)==EA(4,2)  && final(i+1,j)==EA(4,3)  && final(i+1,j+1)==EA(4,4) && final(i+1,j+2)==EA(4,5) &&
                final(i+2,j-2)==EA(5,1) && final(i+2,j-1)==EA(5,2)  && final(i+2,j)==EA(5,3)  && final(i+2,j+1)==EA(5,4) && final(i+2,j+2)==EA(5,5)))
                final2(i,j)=1;
            end
        end
    end
end

final3 = final2;
figure('name','imagem dilatada')
imshow(final2)



% Erosão para voltar a forma normal

for (i=3:size(final2,1)-2)
    for (j=3:size(final2,2)-2)
        if(final2(i, j) == 1)
            SomV = [final2(i-2,j-2) final2(i-2,j-1) final2(i-2,j) final2(i-2,j+1) final2(i-2,j+2);...
                    final2(i-1,j-2) final2(i-1,j-1) final2(i-1,j) final2(i-1,j+1) final2(i-1,j+2);...
                    final2(i,j-2) final2(i,j-1) final2(i,j) final2(i,j+1) final2(i,j+2);...
                    final2(i+1,j-1) final2(i+1,j-1) final2(i+1,j) final2(i+1,j+1) final2(i+1,j+2);...
                    final2(i+2,j-2) final2(i+2,j-1) final2(i+2,j) final2(i+2,j+1) final2(i+2,j+2)];
            if(sum(sum(SomV == EE))!= 25)
                final3(i, j) = 0;
            end
        end
    end
end

final3 = logical(final3);
final4 = uint8(zeros(size(imCinza,1),size(imCinza,2)));

for(i=2:size(final3,1)-1)
    for(j=2:size(final3,2)-1)
        final4(i-1,j-1) = final3(i,j);
    end
end

imCinza .*= final4;


figure('name','imagem final')
imshow(imCinza)


