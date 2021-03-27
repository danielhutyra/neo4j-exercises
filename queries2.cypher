/* ZAD 1 */

MATCH p=allShortestPaths((d{name: "Darjeeling"})-[*]-({name: "Sandakphu"}))
RETURN p

/* ZAD 2 */

MATCH p=allShortestPaths((d{name: "Darjeeling"})-[r*]-({name: "Sandakphu"}))
WHERE all(x in r WHERE x.winter = "true")
RETURN p

/* ZAD 3 */

/* uszeregowane trasy z Darjeeling na Sandkaphu wg dystansu */
MATCH (d{name: "Darjeeling"})-[r*]->(s{name: "Sandakphu"})
WITH r, [x IN r | x.distance] as distances
RETURN DISTINCT r as road, reduce(total=0, number in distances | total + number) AS distance
ORDER BY distance

/* wszystkie miejsca do ktorych mozna dotrzec przy pomocy roweru z Darjeeling latem */
/* NIE DAŁO ROZWIĄZAŃ */
MATCH (d{name: "Darjeeling"})-[r:twowheeler*]->(final)
WHERE all(x in r WHERE x.summer = "true")
AND final.name <> "Darjeeling"
RETURN final

/* ZAD 4 */

MATCH (airports:Airport)<-[:ORIGIN]-(f:Flight)
RETURN airports, COUNT(f) AS no_origins
ORDER BY no_origins DESC

/* ZAD 5 */
/* sprawdziłem i dla większej ilości przesiadek nie ma już dodatkowych destynacji */
MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket)
WHERE t1.price < 3000
WITH d1 AS destination, t1.price AS price
RETURN destination

UNION

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket)
WHERE la <> d2
WITH d1, d2, t2.price+t1.price AS price
WHERE price < 3000
RETURN d2 AS destination

UNION 

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport),
(d2:Airport)<-[:ORIGIN]-(f3:Flight)-[:DESTINATION]->(d3:Airport),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket),
(f3:Flight)<-[:ASSIGN]-(t3:Ticket)
WHERE la <> d2
AND la <> d3
AND d1 <> d3
WITH d1, d2, d3, t3.price+t2.price+t1.price AS price
WHERE price < 3000
RETURN d3 AS destination

UNION 

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport),
(d2:Airport)<-[:ORIGIN]-(f3:Flight)-[:DESTINATION]->(d3:Airport),
(d3:Airport)<-[:ORIGIN]-(f4:Flight)-[:DESTINATION]->(d4:Airport),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket),
(f3:Flight)<-[:ASSIGN]-(t3:Ticket),
(f4:Flight)<-[:ASSIGN]-(t4:Ticket)
WHERE la <> d2
AND la <> d3
AND d1 <> d3
AND d1 <> d4
AND la <> d4
AND d2 <> d4
WITH d1, d2, d3, d4, t4.price+t3.price+t2.price+t1.price AS price
WHERE price < 3000
RETURN d4 AS destination


/* ZAD 6 */
/* wyszło, że nie ma takich połączeń */
/* NIE DAŁO ROZWIĄZAŃ */

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport{name: "DAY"}),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket)
WITH d1 AS destination, t1.price AS price
RETURN destination

UNION

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport{name: "DAY"}),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket)
WHERE la <> d2
WITH d1, d2, t2.price+t1.price AS price
RETURN d2 AS destination

UNION 

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport),
(d2:Airport)<-[:ORIGIN]-(f3:Flight)-[:DESTINATION]->(d3:Airport{name: "DAY"}),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket),
(f3:Flight)<-[:ASSIGN]-(t3:Ticket)
WHERE la <> d2
AND la <> d3
AND d1 <> d3
WITH d1, d2, d3, t3.price+t2.price+t1.price AS price
RETURN d3 AS destination

UNION 

MATCH (la:Airport {name: "LAX"})<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport),
(d2:Airport)<-[:ORIGIN]-(f3:Flight)-[:DESTINATION]->(d3:Airport),
(d3:Airport)<-[:ORIGIN]-(f4:Flight)-[:DESTINATION]->(d4:Airport{name: "DAY"}),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket),
(f3:Flight)<-[:ASSIGN]-(t3:Ticket),
(f4:Flight)<-[:ASSIGN]-(t4:Ticket)
WHERE la <> d2
AND la <> d3
AND d1 <> d3
AND d1 <> d4
AND la <> d4
AND d2 <> d4
WITH d1, d2, d3, d4, t4.price+t3.price+t2.price+t1.price AS price
RETURN d4 AS destination

/* ewentualnie: */

MATCH (origin:Airport{name:"LAX"})-[flight*..3]->(destination:Airport{name:"DAY"})
RETURN origin, REDUCE(s=0, x IN flight | s+x.price) AS cost 
ORDER BY cost DESC

/* ZAD 7 */
/* NIE DAŁO ROZWIĄZAŃ */

MATCH (origin:Airport{name:"LAX"})-[flight*..3]->(destination:Airport{name:"DAY"})
RETURN origin, REDUCE(s=0, x IN flight | s+x.price) AS cost 
ORDER BY cost
LIMIT 1

/* ZAD 8 */
/* NIE DAŁO ROZWIĄZAŃ */

MATCH (origin:Airport{name:"LAX"})-[flight*..3]->(destination:Airport{name:"DAY "})
WHERE all(x in flight WHERE x.class = "business")
RETURN origin, REDUCE(s=0, x IN flight | s+x.price) AS cost 
ORDER BY cost
LIMIT 1

/* ZAD 9 */
MATCH (origin:Airport)-[flight1:FLIGHT_TO]->(destination:Airport)
WITH DISTINCT origin, destination
RETURN origin, COUNT(destination) AS relationships
ORDER BY relationships DESC


/* ZAD 10 */
/*wersja1*/
MATCH (origin:Airport)-[flight1:FLIGHT_TO]->(destination:Airport),
(destination:Airport)-[flight2:FLIGHT_TO]->(destination1:Airport)
WHERE origin <> destination1
RETURN origin, destination1, flight1.price+flight2.price AS price
ORDER BY price
LIMIT 1

/*wersja2*/
MATCH (o:Airport)<-[:ORIGIN]-(f1:Flight)-[:DESTINATION]->(d1:Airport),
(d1:Airport)<-[:ORIGIN]-(f2:Flight)-[:DESTINATION]->(d2:Airport),
(f1:Flight)<-[:ASSIGN]-(t1:Ticket),
(f2:Flight)<-[:ASSIGN]-(t2:Ticket)
WHERE o <> d2
RETURN o, d2, t2.price+t1.price AS price
ORDER BY price
LIMIT 1

