


/*****************************************************************************************************
******************************************************************************************************
                          Math30602 Logiciels statistiques en gestion
                          Séance2_exercies_solutions                                                                                                             *;

******************************************************************************************************
******************************************************************************************************
*****************************************************************************************************/




/****************************************************************************************************
******************************************  Question 1	*********************************************

En utilisant les tables de données«data_etudiants_notes»et«data_etudiants_socio»,veuillez construire: 
 
*****************************************************************************************************
*****************************************************************************************************/

/*Importer des données EXCEL dans SAS et les stocker dans la librairie WORK*/
PROC IMPORT OUT= data_etudiants_notes
DATAFILE= "C:\Users\gita\Desktop\HEC_COURS\Seance2\data_etudiants_notes_rev2.xls"
DBMS=EXCEL REPLACE;
RANGE="Feuil1$";
GETNAMES=YES;
RUN;

PROC IMPORT OUT= data_etudiants_socio
DATAFILE= "C:\Users\gita\Desktop\HEC_COURS\Seance2\data_etudiants_socio_rev2.xlsx"
DBMS=EXCEL REPLACE;
RANGE="Feuil1$";
GETNAMES=YES;
RUN;

/****************************************************************************************************
Q1-1:La table data_etudiants_30 qui contiendra tous les étudiants ayant plus de 30 ans
*****************************************************************************************************/


*SQL;
proc sql;
create table data_etudiants_30 as 
select *
from data_etudiants_socio
where age> 30
;
quit;

/****************************************************************************************************
Q1-2:La table data_etudiants_H3B qui contiendra tous les étudiants qui ont pour habitation le RTA«H3B»
*****************************************************************************************************/

*SQL_LIKE;
proc sql;
create table data_etudiants_H3B as 
select *
from data_etudiants_socio
where code_postal like "H3B%" 
;
quit;

*OU SQL_SUBSTR;
proc sql;
create table data_etudiants_H3B as 
select *
from data_etudiants_socio
where SUBSTR(code_postal,1,3)="H3B" 
;
quit;


/****************************************************************************************************
Q1-3:La table data_etudiants_40_fr qui contiendra tous les étudiants ayant plus de 40 ans et étant
des Français.
*****************************************************************************************************/

*SQL;
proc sql;
create table data_etudiants_40_fr as 
select *
from data_etudiants_socio
where age>40 and provenance="France" 
;
quit;

/****************************************************************************************************
Q1-4:La table data_etudiants_f70 qui contiendra tous les étudiants ayant eu plus de 70 en français.
*****************************************************************************************************/

*SQL;
proc sql;
create table data_etudiants_f70 as 
select *
from data_etudiants_notes
where Note_Francais>70 
;
quit;

/****************************************************************************************************
Q1-5:La table data_etudiants_m50_a50 qui contiendra tous les étudiants ayant eu moins de 50 en math
et en anglais.
*****************************************************************************************************/

*SQL;
proc sql;
create table data_etudiants_m50_a50 as 
select *
from data_etudiants_notes
where Note_Math<50 and  Note_Anglais<50
;
quit;





/****************************************************************************************************
******************************************  Question 2	*********************************************

Quels sont les étudiants qui sont contenus à la fois dans la table data_etudiants_40_fr et 
data_etudiants_H3B.
La table créée se nommera data_etudiants40fr_H3B.

*****************************************************************************************************
*****************************************************************************************************/


proc sql;
create table data_etudiants40fr_H3B as 
select *
from data_etudiants_40_fr
INTERSECT
select *
from data_etudiants_H3B;


select * from data_etudiants40fr_H3B;
quit;



/****************************************************************************************************
Q2-1:Combien y a-t-il d'étudiants?                          
*****************************************************************************************************/

proc sql;
select count(*) from data_etudiants40fr_H3B;
quit;

/****************************************************************************************************                   
Q2-2:Quels sont les frais de scolarité de ces personnes?
 *****************************************************************************************************/
proc sql;
select Nom, Frais_de_scolarite from data_etudiants40fr_H3B;
quit;


/****************************************************************************************************
******************************************  Question 3	*********************************************

Veuillez créer une nouvelle table qui possèdera
- Tous les étudiants qui ont pour habitation le RTA «H3B» et des frais de scolarité d'au moins 1900$
- Tous les étudiants ayant entre 31 et 40 ans
  Utiliser les tables data_etudiants_H3B et data_etudiants_30.
  Vous nommerez cette table data_etudiants30_40_H3B_1900. 
  De plus, nous voulons que chaque étudiant soit unique dans cette base de données

*****************************************************************************************************
*****************************************************************************************************/

proc sql;
create table data_etudiants30_40_H3B_1900 as 
select *
from data_etudiants_30
where age<=40
union 
select *
from data_etudiants_H3B
where frais_de_scolarite>=1900;
quit;




/****************************************************************************************************
******************************************  Question 4	*********************************************

Veuillez créer une nouvelle table qui possèdera tous les étudiants qui ont plus de 30 ans ou une note
supérieure à 70 en français. Cette table comprendra seulement les colonnes suivantes: « nom », « age»
et « note_anglais ». Vous la nommerez data_etudiants_30_f70
*****************************************************************************************************
*****************************************************************************************************/


proc sql;
create table Data_etudiants_30_f70 as 
select nom_all,age,note_anglais from(select
t1.nom as nom_t1,t2.nom as nom_t2,
t1.age ,t2.note_anglais ,
case 
when t1.nom="" then t2.nom
when t2.nom="" then t1.nom 
else t1.nom end as nom_all
from data_etudiants_30 as t1 
full join Data_etudiants_f70 as t2 
on t1.nom=t2.nom);
quit;

*SQL COALESCE() Function:Retourne la première valeur non nulle dans une liste;
proc sql;
create table test_Data_etudiants_30_f70_1 as 
select coalesce(t1.nom ,t2.nom) as nom,
t1.age,t2.note_anglais
from data_etudiants_30 as t1 
full join 
data_etudiants_f70 as t2 
on t1.nom=t2.nom;
quit;



/****************************************************************************************************
******************************************  Question 5	*********************************************

Veuillez afficher le nom de tous les étudiants n'étant ni dans la table data_etudiants_30 ni dans la 
table data_etudiants_f70. 
Vous utiliserez la table initiale data_etudiants_socio.

*****************************************************************************************************
*****************************************************************************************************/

proc sql number;
select nom
from data_etudiants_socio
except
select nom
from data_etudiants_30
except
select nom 
from data_etudiants_f70;
quit;


*Écrire une requête qui retourne les mêmes étudiants mais en utilisant les tables data_etudiants_socio
 et data_etudiants_notes;
*new;
proc sql number;
select t1.nom
from data_etudiants_socio t1
left join data_etudiants_notes t2 on t1.nom=t2.nom
where age<=30
and note_francais<=70; 
quit;

/****************************************************************************************************
******************************************  Question 6	*********************************************

Veuillez afficher le nom des étudiants ayant plus de 40 ans, étant des Français et ayant moins de 50 
en math et en anglais. Combien d'individus y a-t-il?

*****************************************************************************************************
*****************************************************************************************************/

proc sql number;
select a.nom
from data_etudiants_m50_a50 as a
inner join data_etudiants_40_fr as b on a.nom=b.nom;

quit;
 

*Même résultat en utilisant les tables initiales;
proc sql number;
select t1.nom
from data_etudiants_socio as t1
inner join data_etudiants_notes as t2 on t1.nom=t2.nom
where age>40 and provenance="France"  and note_anglais<50 and note_math<50;
quit;


/****************************************************************************************************
******************************************  Question 7	*********************************************

Pour tous les étudiants ayant plus de 30 ans, nous voulons savoir leur âge, leurs notes, leur 
sexe et leurs frais de scolarité. De plus nous voulons écarter tous les étudiants n'ayant pas eu 
de bourse. Nous ordonnerons cette nouvelle table (que nous nommerons data_etudiants_30_p60)par nom
par ordre décroissant
*****************************************************************************************************
*****************************************************************************************************/

proc sql;
create table data_etudiants_30_p60 as 
select a.nom, a.age, a.sexe, a.frais_de_scolarite, b.note_francais,
b.note_anglais,b.note_math,b.note_histoire,b.note_physique
from data_etudiants_30 as a 
left join data_etudiants_notes as b 
on a.nom=b.nom
where b.bourse=1
order by a.nom desc ;
quit;


/****************************************************************************************************
******************************************  Question 8	*********************************************

Quel est le nom et l'âge de l'étudiant.e qui a eu la meilleure moyenne générale?

*****************************************************************************************************
*****************************************************************************************************/


proc sql;
select nom,(note_francais+note_anglais+note_math+note_histoire+note_physique)/5 as avg_generale
from data_etudiants_notes
order by 2 desc
;

select  max((note_francais+note_anglais+note_math+note_histoire+note_physique)/5) as avg_generale
from data_etudiants_notes;
;
select t1.nom ,t2.age
from data_etudiants_notes t1
left join data_etudiants_socio t2 on t1.nom=t2.nom
where (note_francais+note_anglais+note_math+note_histoire+note_physique)/5=
		(select max(note_francais+note_anglais+note_math+note_histoire+note_physique)/5 from data_etudiants_notes)
;
quit;


/****************************************************************************************************
*****************************************************************************************************/

