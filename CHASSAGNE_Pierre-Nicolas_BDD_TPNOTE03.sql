-- PREMIERE PARTIE --

-- 1 --
CREATE SCHEMA cirque;

-- 2 --
CREATE TABLE Personnel(
nom varchar(45),
prenom varchar(45),
role varchar(45),
ville varchar(45),
codePostal int,
CONSTRAINT pk_personnel PRIMARY KEY (nom)
)
COMMENT 'Personnel du cirque.', ENGINE InnoDB;

CREATE TABLE Numero(
titreNumero varchar(45),
natureNumero varchar(45),
responsable varchar(45),
CONSTRAINT pk_numero PRIMARY KEY (titreNumero)
)
COMMENT 'Numéros réalisés au cirque.', ENGINE InnoDB;

CREATE TABLE Accessoire(
nom varchar(45),
couleur varchar(45),
volume int,
ratelier int,
camion int,
CONSTRAINT pk_accessoire PRIMARY KEY (nom)
)
COMMENT 'Accessoires utilisés pour les numéros.', ENGINE InnoDB;

CREATE TABLE Utilisation(
titre varchar(45),
utilisateur varchar(45),
accessoire varchar(45),
CONSTRAINT pk_utilisation PRIMARY KEY (titre, utilisateur, accessoire)
)
COMMENT 'Liens entre les numéros, les accessoires et le personnel.', ENGINE InnoDB;

ALTER TABLE Numero
ADD CONSTRAINT fk_numero
FOREIGN KEY (responsable) REFERENCES Personnel(nom);

ALTER TABLE Utilisation
ADD CONSTRAINT fk_utilisation
FOREIGN KEY (titre) REFERENCES Numero(titreNumero);

ALTER TABLE Utilisation
ADD CONSTRAINT fk_utilisation2
FOREIGN KEY (utilisateur) REFERENCES Personnel(nom);

ALTER TABLE Utilisation
ADD CONSTRAINT fk_utilisation3
FOREIGN KEY (accessoire) REFERENCES Accessoire(nom);

-- 3 --
LOAD DATA LOCAL INFILE 'C:/Users/pc260533/Desktop/Personnel.txt'
INTO TABLE Personnel
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/pc260533/Desktop/Numero.txt'
INTO TABLE Numero
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/pc260533/Desktop/Accessoire.txt'
INTO TABLE Accessoire
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

LOAD DATA LOCAL INFILE 'C:/Users/pc260533/Desktop/Utilisation.txt'
INTO TABLE Utilisation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';



-- DEUXIEME PARTIE --

-- 1 --
SELECT DISTINCT ville
FROM Personnel;

-- 2 --
SELECT COUNT(DISTINCT titreNumero) AS nombreNumero
FROM Numero;

-- 3 --
SELECT COUNT(DISTINCT ville) AS nombreVilleDifferentes
FROM Personnel;

-- 4 --
SELECT Personnel.nom, Personnel.prenom
FROM Personnel
WHERE ville = 'Dijon';

-- 5 --
SELECT Personnel.nom, Personnel.prenom
FROM Personnel
WHERE role = 'Jongleur';

-- 6 --
SELECT DISTINCT Utilisation.accessoire
FROM Utilisation INNER JOIN Personnel ON (Utilisation.utilisateur = Personnel.nom)
WHERE Personnel.role = 'Jongleur';

-- 7 --
SELECT DISTINCT Utilisation.accessoire
FROM Utilisation
GROUP BY Utilisation.accessoire
HAVING COUNT(Utilisation.titre) >= 2;

-- 8 --
SELECT DISTINCT camion
FROM Accessoire INNER JOIN Utilisation ON (Accessoire.nom = Utilisation.accessoire) INNER JOIN Personnel ON (Utilisation.utilisateur = Personnel.nom)
WHERE Personnel.role = 'Jongleur';

-- 9 --
SELECT DISTINCT titre
FROM Utilisation
WHERE accessoire = 'Boule' OR accessoire = 'Ballon';

-- 10 --
SELECT SUM(volume) AS volumeTotal
FROM Accessoire;

SELECT AVG(volume) AS volumeMoyen
FROM Accessoire;

-- 11 --
SELECT nom
FROM Accessoire
WHERE nom NOT IN
(SELECT nom
FROM Accessoire INNER JOIN Utilisation ON (Accessoire.nom = Utilisation.accessoire));

-- 12 --
SELECT nom, prenom
FROM Personnel INNER JOIN Utilisation ON (Personnel.nom = Utilisation.utilisateur)
WHERE Utilisation.accessoire IN
(SELECT DISTINCT Utilisation.accessoire
FROM Utilisation
GROUP BY Utilisation.accessoire
HAVING COUNT(Utilisation.titre) >= 2);

-- 13 --
SELECT nom, prenom, COUNT(Utilisation.accessoire) AS nombreAccessoires
FROM Personnel INNER JOIN Utilisation ON (Personnel.nom = Utilisation.utilisateur)
GROUP By nom, prenom, Utilisation.titre
HAVING COUNT(Utilisation.accessoire) > 1;