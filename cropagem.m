clear all
close all

for(imDaVez=1:1:10)
    imCinza = imread(strcat('/home/phelyppe/Documentos/Workspace/black-bean-profitability/Imagens-originais/',mat2str(imDaVez),'.jpg'));
    
    % Pegando a distância entre cada linha
    distRows = floor((size(imCinza,1)/5));
    distRows = uint64(distRows);

    % Pegando a distância entre cada coluna
    distColumns = floor((size(imCinza,2)/5));
    distColumns = uint64(distColumns);

    % Andando de posição em posição para cropar imagem
    for(i=uint64(1):1:5)
        for(j=uint64(1):1:5)
            % Matriz para receber imagem cropada
            imCropada = uint8(zeros(distRows,distColumns));
            contY = 1;
            contX = 1;
            % Recebendo imagem cropada
            for(ii=(distRows*i)-distRows+1:1:distRows*i)
                for(jj=(distColumns*j)-distColumns+1:1:distColumns*j)
                    imCropada(contY,contX) = imCinza(ii,jj);
                    contX++;
                endfor
                contX=1;
                contY++;
            endfor
            % Cropando imagem
            imwrite(imCropada,strcat('/home/phelyppe/Documentos/Workspace/black-bean-profitability/Crops/imagem',mat2str(imDaVez),',L',mat2str(i),',C',mat2str(j),'.jpg'))
        endfor
    endfor
endfor