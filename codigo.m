clear all
close all

porcentagem = 0;
contPercent = 1;
for(imDaVez=1:1:10)
    imCinza = imread(strcat('C:\Users\Erick\Documents\black-bean-profitability\Imagens-originais\',mat2str(imDaVez),'.jpg'));

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
            imwrite(imCropada,strcat('C:\Users\Erick\Documents\black-bean-profitability\Crops\imagem',mat2str(imDaVez),',L',mat2str(i),',C',mat2str(j),'.jpg'))

            porcentagem = floor((contPercent)*100/250);
            clc
            disp('CROPANDO IMAGENS'),disp(strcat(mat2str(porcentagem),'%'))
            contPercent++;
        endfor
    endfor
endfor

porcentagem = 0;
contPercent = 1;
for(imagem=1:10)
    for(linha=1:5)
        for(coluna=1:5)
            im = imread(strcat('C:\Users\Erick\Documents\black-bean-profitability\Crops\imagem',mat2str(imagem),',L',mat2str(linha),',C',mat2str(coluna),'.jpg'));
            imCinza = im;

            vHist = imhist(imCinza);
            vHistSrc(1,:) = vHist(:,1);

            % ================ ALARGAMENTO DE CONTRASTE ================

            % Pegando primeiro e último ponto da imagem no histograma
            firstPoint = 0;
            lastPoint = 0;

            for(i=1:size(vHistSrc,2))
                if(vHistSrc(i) > 0)
                    firstPoint = i;
                    break;
                end
            end

            for(i=size(vHistSrc,2):1)
                if(vHistSrc(i) > 0)
                    lastPoint = i;
                    break;
                end
            end

            imCinza -= firstPoint - 1;

            largura = firstPoint - lastPoint + 1;
            coeficiente = 256/largura;
            imCinza *= coeficiente;

            % ================ SEPARAÇÃO DE REGIÕES ================

            % Obtendo histograma da imagem para fazer a separação de regiões


            vHistED = vHistSrc;
            vHistDE = vHistSrc;

            for(i=2: size(vHistED,2))
                if(vHistED(i) < vHistED(i-1))
                    vHistED(i) = vHistED(i-1);
                end
            end

            for(i=size(vHistDE,2)-1:-1:1)
                if(vHistDE(i) < vHistDE(i+1))
                    vHistDE(i) = vHistDE(i+1);
                end
            end

            pico1 = mode(vHistED);
            pico2 = mode(vHistDE);

            iPico1 = 0;
            iPico2 = 0;

            % For para pegar indice do pico1
            for(i=size(vHistSrc,2):-1:1)
                if(vHistSrc(i) == pico1)
                    iPico1 = i;
                end
            end

            % For para pegar indice do pico2
            for(i=1:size(vHistSrc,2))
                if(vHistSrc(i) == pico2)
                    iPico2 = i;
                end
            end

            depressao = pico1;
            iDepressao = iPico1 + 59;
            % For para pegar o indice da maior depressão entre os picos
            for(i=iPico2:iPico1)
                if(vHistSrc(i) < depressao)
                    depressao = vHistSrc(i);
                    iDepressao = i;
                end
            end

            imCinza(im > iDepressao) = 0;
            imCinza(im <= iDepressao) = 255;
            imLogica = logical(imCinza);

            % ================ FINAL SEPARAÇÃO DE REGIÕES ================

            imTeste = imLogica;

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

##            figure('name','erodida pela primeira vez')
##            imshow(final)

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
##            figure('name','imagem dilatada')
##            imshow(final2)



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

            imLogica = final4;

            imSegmentada = imLogica .* im;

##            figure('name','imagem final')
##            imshow(imCinza)

            imwrite(imSegmentada,strcat('C:\Users\Erick\Documents\black-bean-profitability\Imagem-Final\imagem',mat2str(imagem),',L',mat2str(linha),',C',mat2str(coluna),'.jpg'))

            % Mostrando porcentagem do processamento das imagens no terminal
            porcentagem = floor((contPercent)*100/250);
            clc
            disp('SEPARAÇÃO DE REGIÕES'),disp(strcat(mat2str(porcentagem),'%'))
            contPercent++;
        end
    end
end
