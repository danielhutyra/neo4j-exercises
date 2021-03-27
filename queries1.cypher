/* ZAD 1 */

MATCH (movies:Movie) RETURN DISTINCT movies

/* ZAD 2 */

MATCH(a:Person)-[r:ACTED_IN]->(b:Movie) 
WHERE a.name="Hugo Weaving" 
RETURN DISTINCT b

/* ZAD 3 */

MATCH(a:Person)-[:ACTED_IN]->(hugo_movies:Movie) 
WHERE a.name="Hugo Weaving" 
WITH hugo_movies
MATCH(c:Person)-[:DIRECTED]->(hugo_movies)
RETURN DISTINCT c

/* ZAD 4 */

MATCH (hugo:Person {name:"Hugo Weaving"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors) 
RETURN DISTINCT coActors

/* ZAD 5 */

MATCH (matrix_actors: Person)-[:ACTED_IN]->(:Movie {title: "The Matrix"})
WITH matrix_actors
MATCH (matrix_actors)-[:ACTED_IN]->(m:Movie)
RETURN DISTINCT m

/* ZAD 6 */

MATCH (actor: Person)-[r:ACTED_IN]->(:Movie)
WITH actor, count(r) AS no_movies
WHERE no_movies > 0
RETURN actor, no_movies

/* ZAD 7 */

MATCH (a: Person)-[:DIRECTED]->(:Movie)<-[:WROTE]-(a: Person)
RETURN a

/* ZAD 8 */

MATCH(:Person{name:"Hugo Weaving"})-[:ACTED_IN]->(b:Movie)<-[:ACTED_IN]-(:Person{name: "Keanu Reeves"})
RETURN b

/* ZAD 9 */
/* pierw tą część */
CREATE (CaptainAmerica:Movie {title:'Captain America: The First Avenger', released:2011, tagline:'When Patriots Become Heroes'})
CREATE (ChristopherMarkus:Person {name:'Christopher Markus', born:1970})
CREATE (JoeJohnston:Person {name:'Joe Johnston', born:1950})
CREATE (StephenMcFeely:Person {name:'Stephen McFeely', born:1969})
CREATE (ChrisEvans:Person {name:'Chris Evans', born:1981})
CREATE (Samuel:Person {name:'Samuel L. Jackson', born:1948})
CREATE
(ChrisEvans)-[:ACTED_IN {roles:['Capitan America']}]->(CaptainAmerica),
(Samuel)-[:ACTED_IN {roles:['Nick Fury']}]->(CaptainAmerica),
(JoeJohnston)-[:DIRECTED]->(CaptainAmerica),
(ChristopherMarkus)-[:WROTE]->(CaptainAmerica),
(StephenMcFeely)-[:WROTE]->(CaptainAmerica)

/* później tą - w oddzielnym zapytaniu */

MATCH (hugo:Person {name:'Hugo Weaving'}), 
(m:Movie {title:'Captain America: The First Avenger'})
CREATE (hugo)-[:ACTED_IN]->(m)

/* i finalnie sama kwerenda: */

MATCH(a:Person)-[r]->(m:Movie{title: 'Captain America: The First Avenger'})
RETURN a, r, m
