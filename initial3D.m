% FEM Code for 3D Truss

% clear memory
clear;
% clear screen
clc;
%==========================================================================
% Open input file for reading data
finput = fopen('input.txt'); % file input 3D

% read total number of nodes
nnode = fscanf(finput,'%d',[1]); %nnode=4

% read nodal coordinates
% 0 0 
for i=1:nnode
   node_coord(i,:) = fscanf(finput,'%f %f %f',[3]);
    %i=1,node_coord(1,:) = 0 0
end

 
% read total number of elements
nelem = fscanf(finput,'%d',[1]); % so element la 05
% read element data: node1, node2, A, E
for i=1:nelem 
    elemdata(i,:) = fscanf(finput,'%d %d %f %f',[4]);
end

ndof=3; 
gdof=ndof*nnode;    %     total number of degrees of freedom % 3 nhan 4 = 12
force=zeros(gdof,1);

%FORCE
% read total number of forces applied on structure
nforce = fscanf(finput,'%d',[1]) %LAY RA 02
% read force data: node#, component, force value
for i=1:nforce
    forcedata(i,:) = fscanf(finput,'%d %d %f',[3]);
     end

% read total number of prescribed displacements
ndisp = fscanf(finput,'%d',[1]);
% read prescribed data: node#, component, value
for i=1:ndisp
    dispdata(i,:) = fscanf(finput,'%d %d %f',[3]);
   end

%Close the input file
fclose(finput);
%%
% gdof: global degree of freedom
% nelem: sum of the element of truss
% U displacement matrix
% Uc displacement matrix of restraint
% Uf displacement matrix of node
% bcdof: degree of freedom of support
% Kff: stiffness matrix 
% Kcc: stiffness matrix 
% Kufc: stiffness matrix 
nesscessaryInput;
%%
%calculate stiffness matrix
  [stiffness]= globalStiffnessMatrix(gdof,nelem,elemdata,nnode,A,xx,yy,zz,ndof);     
%arrange stiffness matrix           
   [Kff,Kcc,Kucf]= arrangeMatrix(stiffness,ndisp,nnode,dispdata,ndof)
%arrange force     
    [rc,rf]=arrangeForce(gdof,bcDof,force)

 %%
 %calculate U
    U = zeros(gdof,1);
    Uc=U(bcDof);
    Uf=inv(Kff)*(rf-Kucf'*Uc);
    
 for i=1:length(bcDof)
    for j= 1:gdof
        if j == bcDof(i)
        U(j)=Uc(i);
        end
   end    
 end
 activeDof=setdiff([1:gdof]',[bcDof]);
 for i=1:length(activeDof)
    for j= 1:gdof
        if j ==activeDof(i)
        U(j)=Uf(i);
        end
    end    
 end
U
%%
%calculate strain
strainInternal(nelem,elemdata,U,xx,yy,zz)
%calculate stress
stressInternal(nelem,elemdata,U,xx,yy,zz)
%N=internalForces(nelem,elemdata,U,xx,yy)'
%disp('internal forces');

