-- { echoOn }

SYSTEM DROP QUERY RESULT CACHE;
DROP TABLE IF EXISTS old;

-- insert entry into query result cache
SELECT 1 SETTINGS enable_experimental_query_result_cache = true;
SELECT COUNT(*) FROM system.queryresult_cache;

-- save hash of (only) entry in query result cache
CREATE TABLE old (query_hash UInt64) ENGINE=MergeTree ORDER BY query_hash;
INSERT INTO old SELECT query_hash FROM system.queryresult_cache;

-- run same query but with different case
-- should still have just one entry with same hash as before
SELECT 1 SETTINGS enable_experimental_query_result_cache = true;
SELECT COUNT(*) FROM system.queryresult_cache;
SELECT query_hash = (SELECT query_hash FROM old) FROM system.queryresult_cache;

DROP TABLE old;
SYSTEM DROP QUERY RESULT CACHE;

-- { echoOff }