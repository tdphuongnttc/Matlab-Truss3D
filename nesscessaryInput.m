
ndof=3;     %degree freedom of node
gdof=ndof*nnode;    %     total number of degrees of freedom % 3 nhan 4 = 12
force=zeros(gdof,1);  %create force matrix
A=node_coord; %matrix coordinate
xx=A(:, 1); %x-coord 
yy=A(:, 2); %y-coord 
zz=A(:,3);  %y-coord 

%force
for i=1:nforce
      if forcedata(i,2) == 1
        force((forcedata(i,1)-1)*3 +(forcedata(i,2))) = forcedata(i,3) ;
    elseif forcedata(i,2) == 2
        force((forcedata(i,1)-1)*3 +(forcedata(i,2))) = forcedata(i,3);
    else
        force((forcedata(i,1)-1)*3 +(forcedata(i,2))) = forcedata(i,3);
    end
end
   
%boundary condition
for i=1:ndisp
    if dispdata(i,2) == 1
        bcDof(i,:) = dispdata(i,1)*3 - 2 ;
    elseif dispdata(i,2) == 2
        bcDof(i,:) = dispdata(i,1)*3 - 1;
    else
        bcDof(i,:) = dispdata(i,1)*3;
    end
end