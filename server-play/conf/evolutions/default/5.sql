# JobMatch schema
# --- !Ups
CREATE TABLE IF NOT EXISTS "JOBMATCHES" (
    "ID" SERIAL PRIMARY KEY,
    "JOBID" bigint NOT NULL,
    "NODEID" bigint NOT NULL,
    "HTTPREQUEST" text NOT NULL,
    "HTTPRESPONSE" text NOT NULL,
    "MATCHEDSTRING" text NOT NULL,
    "PAYLOAD" text NOT NULL,
    "CREATEDAT" timestamp NOT NULL
);

INSERT INTO "JOBMATCHES" ( "JOBID", "NODEID", "HTTPREQUEST", "HTTPRESPONSE", "MATCHEDSTRING", "PAYLOAD", "CREATEDAT")
VALUES (1, 1, 'GET /test...', '<html><body>...</body></html>', 'meowmeow', 'vpn', '2017-01-16T13:15:39.248+08:00');

INSERT INTO "JOBMATCHES" ( "JOBID", "NODEID", "HTTPREQUEST", "HTTPRESPONSE", "MATCHEDSTRING", "PAYLOAD", "CREATEDAT")
VALUES (1, 1, 'GET /test...', '<html><body>...</body></html>', 'meowmeow', 'vpn', '2017-01-16T13:15:39.248+08:00');

# --- !Downs
DROP TABLE "JOBMATCHES";