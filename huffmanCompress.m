function huffmanCompress(fileName)
    data = load(fileName); 
    myData = data.testfile;
    myMax = max(myData); %max random variable in the list of RVs
    myMin = min(myData); %min random variable in the list of RVs
 
    HistMat = zeros(myMax, 2);  %create [2 X max] matrix of zeros
    HistMat(:,1) = 1:myMax;     %number 1 to max for the first column of HistMat
 
    for x = 1:length(myData)
        temp = myData(1, x);
        HistMat(temp,2) = HistMat(temp,2) + 1; %add 1 at location temp for every occurence of a RV
    end
 
    size(myData);
    
    figure(1); %plot the PMF
    title('Histogram of PMF Px');  
    hold on
    bar(HistMat(:,2));
    plot(HistMat(:,2));
    grid on
    hold off
 
    sortedHist = sortrows(HistMat, 2); %sort the RVs based on frequency
    format long
    originalArray = [sortedHist(:,1) sortedHist(:,2)./length(myData)];
    %-----------------------compression stage---------------
   
    [path, name, ext] = fileparts(fileName);
    y = strcat(name,'-PMF.mat');
    save(y, 'originalArray'); %store the Px in (*user input)-PMF.mat file
    
    sortedOriginalArray = sortrows(originalArray, 2);
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
 
    for i = 1:length(originalArray)
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
    
    binFileName = [fileName(1:length(fileName)-4) '.bin'];
    binFile = fopen(binFileName,'w');
    fclose(binFile);
    binFile = fopen(binFileName,'a');
    
    binArray = [];
    for x=1:100
        textCode = valueSet(keySet == myData(x));
        encoding = ['ubit' num2str(strlength(textCode))];
        B = bin2dec(textCode);
        fwrite(binFile,B,encoding,'b');
    end
    
    fclose(binFile);
    
end