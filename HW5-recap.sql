--se sterge coloana data angajare + sa se adaugae coloana PRIMA in tabela ANGAJATI. 
--Prima va fi calculata ca sal - sal_min/sal_minim doar pt cei care au salariu mai mare decat media pe firma

--primii 3 angsati din firma tinand cont de suma = sal + prima. se va selecta numele, salariu + prima si numele
--sefului

--top 3 departamente dupa suma tuturor salariilor si primelor din acel dep. Afisati den dep + suma

DROP TABLE PENALIZARI;
DROP TABLE ANGAJAT;
DROP TABLE DEPARTAMENT;


CREATE TABLE DEPARTAMENT(
	ID_DEPARTAMENT NUMBER(2) PRIMARY KEY,
	DEN_DEPART VARCHAR(50),
	ID_SEF NUMBER(2));

CREATE TABLE ANGAJAT(
	ID_ANGAJAT NUMBER(2) PRIMARY KEY,
	NUME VARCHAR2(50),
	DATA_ANGAJARE DATE,
	SALARIU NUMBER(6),
	ID_DEPART NUMBER(2) REFERENCES DEPARTAMENT(ID_DEPARTAMENT));

CREATE TABLE PENALIZARI(
	ID_ANGAJAT NUMBER(2) REFERENCES ANGAJAT(ID_ANGAJAT),
	PENALIZARE NUMBER(3));


INSERT INTO DEPARTAMENT VALUES(1, 'HR', 2);
INSERT INTO DEPARTAMENT VALUES(2, 'FIN', 3);
INSERT INTO DEPARTAMENT VALUES(3, 'IT', 4);
INSERT INTO DEPARTAMENT VALUES(4, 'ADM', 5);

INSERT INTO ANGAJAT VALUES(1, 'HORIA', TO_DATE('12-APR-2014'), 100, 1);



INSERT INTO ANGAJAT VALUES(2, 'FLORIN', TO_DATE('14-APR-2014'), 1002, 2);
INSERT INTO ANGAJAT VALUES(3, 'DANA', TO_DATE('16-APR-2014'), 200, 3);
INSERT INTO ANGAJAT VALUES(4, 'ANCA', TO_DATE('17-APR-2014'), 223, 4);
INSERT INTO ANGAJAT VALUES(5, 'ANA', TO_DATE('18-APR-2014'), 223, 3);
INSERT INTO ANGAJAT VALUES(6, 'MONICA', TO_DATE('25-APR-2014'), 223, 3);
INSERT INTO ANGAJAT VALUES(7, 'MIHAI', TO_DATE('11-APR-2014'), 223, 4);
INSERT INTO ANGAJAT VALUES(8, 'MARIAN', TO_DATE('10-APR-2014'), 223, 1);
INSERT INTO ANGAJAT VALUES(9, 'ION', TO_DATE('29-APR-2014'), 223, 4);
INSERT INTO ANGAJAT VALUES(10, 'IONELA', TO_DATE('27-APR-2014'), 223, 2);


INSERT INTO PENALIZARI VALUES(1, 23);
INSERT INTO PENALIZARI VALUES(2, 200);
INSERT INTO PENALIZARI VALUES(5, 40);
INSERT INTO PENALIZARI VALUES(9, 25);

ALTER TABLE ANGAJAT DROP COLUMN DATA_ANGAJARE;
ALTER TABLE ANGAJAT ADD  PRIMA NUMBER(4);

UPDATE ANGAJAT SET PRIMA = (SALARIU - (SELECT MIN(SALARIU) FROM ANGAJAT))/(SELECT MIN(SALARIU) FROM ANGAJAT)
WHERE SALARIU  > (SELECT AVG(SALARIU) FROM ANGAJAT);

SELECT * FROM ANGAJAT;

SELECT A.NUME, A.SALARIU + NVL(A.PRIMA, 0), C.NUME  FROM ANGAJAT A, ANGAJAT C, DEPARTAMENT B
WHERE  A.ID_DEPART = B.ID_DEPARTAMENT
AND B.ID_SEF = C.ID_ANGAJAT
AND   3  >  (SELECT COUNT(*) FROM ANGAJAT D
		WHERE (D.SALARIU + NVL(D.PRIMA, 0))  > (A.SALARIU + NVL(A.PRIMA, 0)) 
                     );


CREATE VIEW EX3 AS SELECT A.DEN_DEPART, SUM(B.SALARIU + NVL(B.PRIMA, 0)) AS SUMA_TOTALA
FROM ANGAJAT B, DEPARTAMENT A WHERE B.ID_DEPART = A.ID_DEPARTAMENT
GROUP BY A.DEN_DEPART;

SELECT A.DEN_DEPART,  A.SUMA_TOTALA FROM EX3 A
	WHERE 3 > (SELECT COUNT(*) FROM EX3 B WHERE B.SUMA_TOTALA > A.SUMA_TOTALA)
ORDER BY A.SUMA_TOTALA DESC;