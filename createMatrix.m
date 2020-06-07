
testfile = binornd(15,0.6,1,12000000);
indices = find(abs(testfile)< 1);
testfile(indices) = [];
save('test2nd.mat', 'testfile');

testfile = binornd(15,0.4,1,12000000);
indices = find(abs(testfile)< 1);
testfile(indices) = [];
save('test3rd.mat', 'testfile');