function [stiffness]=...
    globalStiffnessMatrix(gdof,nelem,...
    elemdata,nnode, node_coord,xx,yy,zz,ndof);
  % elementDof: element degrees of freedom (Dof)
   stiffness=zeros(gdof); 
 for i=1:nelem;
  indice=elemdata(i,1:2);      
  elementDof=[ indice(1)*3-2 indice(1)*3-1 indice(1)*3 indice(2)*3-2 indice(2)*3-1 indice(2)*3] ;
  xa=xx(indice(2))-xx(indice(1));
  ya=yy(indice(2))-yy(indice(1));
  za=zz(indice(2))-zz(indice(1));
  length_element=sqrt(xa*xa+ya*ya+za*za);
  C1=xa/length_element;
  C2=ya/length_element; 
  C3=za/length_element;
  T =[C1 C2 C3 0 0 0; 0 0 0 C1 C2 C3];
  k_lo = (elemdata(i,3)*elemdata(i,4)/length_element)*[1 -1;-1 1];
  Ke = T'*k_lo*T; 
   %assemble matrix
       for j=1:2*ndof
        for k=1:2*ndof
          stiffness(elementDof(j),elementDof(k))=stiffness(elementDof(j),elementDof(k))+ Ke(j,k);
        end
       end   
     
end

