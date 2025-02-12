clc
close all
load('proj_fit_06.mat'); %incarcare date proiect

%date de identificare
X1_identificare=id.X{1};
X2_identificare=id.X{2};
Y1=id.Y;

%date de validare
X1_validare=val.X{1};
X2_validare=val.X{2};
Y2=val.Y;

n=5; %gradul polinomului

m1=length(X1_identificare); %dimnesiunea lui X1 identificare
numar_termeni=(n+1)*(n+2)/2; %calcul numar de termeni ai polinomului in functie de grad

%initializare matrici
F1=zeros(m1*m1,numar_termeni); 
F_1=zeros(m1*m1,numar_termeni);
p=1;% contor pentru randurile matricei F_1
for i=1:m1
    for j=1:m1
        ind=1; % folosim un indice pentru pozitia coloanei
         for a=0:n %a-puterea lui X1
             for b=0:(n-a) % b-putearea lui X2
              F1(i,ind)=X1_identificare(i)^a*X2_identificare(j)^b; %calculam fiecare  termen din matricea de regresori 
              F_1(p,ind)=F1(i,ind); %punem fiecare termen calculat mai sus in randul p
             ind=ind+1; %incrementam pentru a trece la urmatorul coloana 
             end
         end
         p=p+1;%incrementam  pentru a trece la urmatorul rand 
    end
end

%transformarea lui Y1 in vector coloana
Y1_identificare=Y1(:); %sau cu functia reshape Y1_identificare = reshape(Y1, [], 1);
teta=F_1\Y1_identificare; %model
Y1_caciula=F_1*teta; %Y1 aproximat


%Mesh pentru Y1
%meshgrid pentru X1_identificare si X2_identificare
[X1_grid_id,X2_grid_id]=meshgrid(X1_identificare,X2_identificare);

figure
subplot(1,2,1)
mesh(X1_grid_id,X2_grid_id,Y1);
colormap(spring); %alegere culoare pentru mesh
xlabel('X1');
ylabel('X2');
zlabel('Y1');
title('Mesh pentru Y1')

%Mesh pentru Y1_caciula
Y1_mesh=reshape(Y1_caciula,[m1,m1]);
subplot(1,2,2)
mesh(X1_grid_id,X2_grid_id,Y1_mesh);
colormap(spring);
xlabel('X1');
ylabel('X2');
zlabel('Y1mesh');
title('Mesh pentru Y1 aproximat')

%calcularea MSE pentru Y1 identificare
MSE_y1=0;%initializam eroarea ca fiind 0
for i=1:m1 
     MSE_y1=MSE_y1+(Y1_identificare(i)-Y1_caciula(i))^2;
end
MSE_y1=(1/m1)*MSE_y1; 
disp('Eroarea medie patratica pentru Y1 identificare: ')
disp(MSE_y1); %afisarea MSE
   




%calcule cu datele de validare
m2=length(X1_validare); %dimnesiunea lui X1 validare

%initalizare matrici
F2=zeros(m2*m2,numar_termeni);
F_2=zeros(m2*m2,numar_termeni);

p2=1;% contor pentru randurile matricei F_2
for i=1:m2
    for j=1:m2
        ind2=1;  % folosim un indice pentru pozitia coloanei
         for a=0:n
             for b=0:(n-a)
              F2(i,ind2)=X1_validare(i)^a*X2_validare(j)^b; %calculam fiecare  termen din matricea de regresori
              F_2(p2,ind2)=F2(i,ind2); %punem fiecare termen calculat mai sus in randul p
              ind2=ind2+1; %incrementam pentru a trece la urmatorul coloana 
             end
         end
         p2=p2+1;%incrementam  pentru a trece la urmatorul rand 
    end
end
%transformarea lui Y2 in vector coloana
Y2_validare=Y2(:); %sau cu functia reshape Y2_validare = reshape(Y2, [], 1);
Y2_caciula=F_2*teta; %Y2 aproximat

%Mesh pentru Y2
%meshgrid pentru X1_validare si X2_validare
[X1_grid_val,X2_grid_val]=meshgrid(X1_validare,X2_validare);

figure
subplot(1,2,1)
mesh(X1_grid_val,X2_grid_val,Y2);
colormap(cool);
xlabel('X1');
ylabel('X2');
zlabel('Y2');
title('Mesh pentru Y2')

%Mesh pentru Y2_caciula
Y2_mesh=reshape(Y2_caciula,[m2,m2]);
subplot(1,2,2)
mesh(X1_grid_val,X2_grid_val,Y2_mesh);
colormap(cool);
xlabel('X1');
ylabel('X2');
zlabel('Y2mesh');
title('Mesh pentru Y2 aproximat')

%calcularea MSE pentru Y2 validare
MSE_y2=0; 
for i=1:m2
     MSE_y2=MSE_y2+(Y2_validare(i)-Y2_caciula(i))^2;
end

MSE_y2=(1/m2)*MSE_y2;
disp('Eroarea medie patratica pentru Y2 validare: ')
disp(MSE_y2); %afisarea MSE

%suprapunere grafic pentru Y1 si Y1 aproximat 
figure
g1=mesh(X1_grid_id,X2_grid_id,Y1_mesh);%scriem mesh pt Y1 mesh(caciula)
hold on
g2=mesh(X1_grid_id,X2_grid_id,Y1);%scriem mesh pt Y1 initial

%setam culorile si transparenta pentru o mai buna vizualizare 
set(g1,'FaceColor','yellow','FaceAlpha','0.5'); 
set(g2,'FaceColor','magenta','FaceAlpha','0.5');
xlabel('X1');
ylabel('X2');
zlabel('Y1');
title('Suprapunerea graficelor Y1 si Y1 aproximat ');
legend('Y1 aproximat ', 'Y1 ');

%suprapunere grafic pentru Y2 si Y2 aproximat 
figure
g3=mesh(X1_grid_val,X2_grid_val,Y2_mesh);%scriem mesh pt Y2 mesh(caciula)
hold on
g4=mesh(X1_grid_val,X2_grid_val,Y2);%scriem mesh pt Y2 initial

%setam culorile si transparenta pentru o mai buna vizualizare 
set(g3,'FaceColor','cyan','FaceAlpha','0.5'); 
set(g4,'FaceColor','magenta','FaceAlpha','0.5');

xlabel('X1');
ylabel('X2');
zlabel('Y2');
title('Suprapunerea graficelor pentru Y2 si Y2 aproximat ');
legend('Y2 aproximat ', 'Y2 ');

