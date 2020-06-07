originalArray = [1, 0.10; 2, 0.15; 3, 0.30; 4 ,  0.16; 5 , 0.29];
    %-----------------------compression stage---------------


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
     AccumulatedArray;
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
            if i == 10
                location
                I1
                I2
            end
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
        %    encodedArray = [encodedArray ; sortedOriginalArray(i,1) AccumulatedArray(i,1) reverse(binary)];
        encodedArray = [encodedArray ; sortedOriginalArray(i,1) reverse(binary)];
    end
    encodedArray
    
    

    dlmwrite('trialData.txt',AccumulatedArray);
    %-------------------------------------------------------








