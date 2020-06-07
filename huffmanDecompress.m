function myData = huffmanDecompress(fileName)
    pmfFileName = [fileName(1:strlength(fileName)-4) '-PMF.mat'];
    pmf = load(pmfFileName);
    myPMF = pmf.originalArray;
    
    sortedOriginalArray = sortrows(myPMF, 2);
    AccumulatedArray = [];
 
    freqOri = sortedOriginalArray(:,2);
    AccumulatedArray = [AccumulatedArray freqOri];
 
    counter = 0;
    freqOriLength = length(freqOri);
 
 
    while counter ~= freqOriLength
        counter = counter + 1;
        [M1,I1] = min(freqOri(freqOri > 0));
        freqOri(I1) = 5 ; 
        [M2,I2] = min(freqOri(freqOri > 0));
 
 
        if M2 == 5
            freqOri(I2) = 5;        %if second smallest is 5, means M1 is the only element left
        else
            if I1 > I2                  %always add to store the new value at lower side
                freqOri(I2) = 5;
                freqOri(I1) = M1 + M2;
            else
                freqOri(I2) = M1 + M2;
            end
 
 
            codeArray = 5*ones(size(freqOri)) ;  % second column to add 
            codeArray(I1) = 0;
            codeArray(I2) = 1;
 
            AccumulatedArray = [AccumulatedArray codeArray freqOri];
        end
    end
     %AccumulatedArray;
    encodedArray = [];%mat2str(sortedOriginalArray)
    [Row, Column] =  size(AccumulatedArray);
 
    for i = 1:length(myPMF)
        x_ind = i;
        y_ind = 1;
        location = AccumulatedArray(x_ind,y_ind);
        binary = "";
 
        while  y_ind < Column
            temp = AccumulatedArray(:,y_ind);
            [M1,I1] = min(temp(temp > 0));
            temp(I1) = 5 ;
            [M2,I2] = min(temp(temp > M1));
 
            y_ind = y_ind + 2;
            location = AccumulatedArray(x_ind,y_ind);
 
            if location == AccumulatedArray(x_ind,y_ind-2)
 
            elseif location == 5
                bin = AccumulatedArray(x_ind,y_ind-1);
                binary = strcat(binary, num2str(bin) );
 
                if I1 > I2
                    x_ind = I1;
                elseif I2  > I1
                    x_ind = I2;
                end
 
            elseif location ~= AccumulatedArray(x_ind,y_ind-2)
                bin = AccumulatedArray(x_ind,y_ind-1);
                binary = strcat(binary, num2str(bin) );
 
            end
        end
 
%         if sortedOriginalArray(i,1)  <10
%             temp = sortedOriginalArray(i,1);
%             temp = strcat("0", num2str(temp));
%             encodedArray = [encodedArray ; temp reverse(binary)];
%         else
           encodedArray = [encodedArray ; sortedOriginalArray(i,1) reverse(binary)];
%         end
    end
    keySet = str2double(encodedArray(:,1));
    valueSet = encodedArray(:,2);
    M = containers.Map(keySet,valueSet);
    
    binFile = fopen(fileName,'r');
    
    myData = [];
    while ~feof(binFile)
        B = fread(binFile,1,'ubit1');
        foundStr = 0;
        while foundStr == 0
            for i=1:length(valueSet)
                if strcmp(log2code(B),valueSet(i))
                    foundStr = 1;
                    break;
                end
            end
            if foundStr
                break;
            end
            B = [B fread(binFile,1,'ubit1')];
        end
        myData = [myData keySet(log2code(B)==valueSet)];
    end
    
    fclose(binFile);
    
end