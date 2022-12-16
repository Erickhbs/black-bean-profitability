pkg load image
close all
clear all

porcentagem = 0;
contPercent = 1;
for(imagem=1:10)
    for(linha=1:5)
        for(coluna=1:5)
            im = imread(strcat('C:\Users\Erick\Documents\PDI\black-bean-profitability\Crops\imagem',mat2str(imagem),',L',mat2str(linha),',C',mat2str(coluna),'.jpg'));
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

            imSegmentada = imLogica .* im;

            % ================ FINAL SEPARAÇÃO DE REGIÕES ================

            imwrite(imSegmentada,strcat('C:\Users\Erick\Documents\PDI\black-bean-profitability\Imagem-Final\imagem',mat2str(imagem),',L',mat2str(linha),',C',mat2str(coluna),'.jpg'))

            % Mostrando porcentagem do processamento das imagens no terminal
            porcentagem = floor((contPercent)*100/250);
            clc
            disp('SEPARAÇÃO DE REGIÕES'),disp(strcat(mat2str(porcentagem),'%'))
            contPercent++;
        end
    end
end
