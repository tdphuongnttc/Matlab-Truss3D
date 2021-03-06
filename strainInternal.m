function strainInternal(nelem,elemdata,U,xx,yy,zz)
%% calculate internal stress
%strain : deformation
% U: displacement
  
for i=1:nelem                   
  indice=elemdata(i,1:2);      
  elementDof=[ indice(1)*3-2 indice(1)*3-1 indice(1)*3 indice(2)*3-2 indice(2)*3-1 indice(2)*3]; 
  U(elementDof);
  xa=xx(indice(2))-xx(indice(1));
  ya=yy(indice(2))-yy(indice(1));
  za=zz(indice(2))-zz(indice(1));
  length_element=sqrt(xa*xa+ya*ya+za*za);
  C1=xa/length_element;
  C2=ya/length_element;
  C3=za/length_element;
  T =[C1 C2 C3 0 0 0; 0 0 0 C1 C2 C3];
  strainInternal(i)=[-1/length_element 1/length_element]*T*U(elementDof); 
end
disp('internal strain')
jj=1:nelem ; format long
[jj' strainInternal']