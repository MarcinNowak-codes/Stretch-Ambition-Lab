CREATE TABLE t1 (
                    a   int,
                    b   int
);

INSERT INTO t1 SELECT i/100, i/500
FROM generate_series(1,1000000) s(i);

ANALYZE t1;

-- the number of matching rows will be drastically underestimated:
SELECT count(*) FROM t1 WHERE (a = 1) AND (b = 0);

EXPLAIN ANALYZE SELECT * FROM t1 WHERE (a = 1) AND (b = 0);

CREATE STATISTICS s1 (dependencies) ON a, b FROM t1;

ANALYZE t1;

-- now the row count estimate is more accurate:
EXPLAIN ANALYZE SELECT * FROM t1 WHERE (a = 1) AND (b = 0);

DROP STATISTICS s1;