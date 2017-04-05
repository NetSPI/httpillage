# Jobs schema
# --- !Ups
CREATE TABLE IF NOT EXISTS "JOBS" (
    "ID" SERIAL PRIMARY KEY,
    "DESCRIPTION" text NOT NULL,
    "HTTPMETHOD" varchar(10) NOT NULL,
    "HTTPURI" varchar(1000) NOT NULL,
    "HTTPHOST" varchar(1000) NULL,
    "HTTPHEADERS" text NOT NULL,
    "HTTPDATA" text,
    "ATTACKTYPE" varchar(255) NOT NULL,
    "ATTACKMODE" varchar(255) NOT NULL,
    "STATUS" varchar(255),
    "OWNER" bigint NOT NULL,
    "DICTIONARYID" bigint,
    "BRUTEFORCECHARSET" varchar(255),
    "NEXTINDEX" bigint,
    "CREATEDAT" timestamp NOT NULL,
    "UPDATEDAT" timestamp NOT NULL
);

INSERT INTO "JOBS" ( "DESCRIPTION", "HTTPMETHOD", "HTTPURI", "HTTPHOST", "HTTPHEADERS", "ATTACKTYPE", "ATTACKMODE", "OWNER", "CREATEDAT", "UPDATEDAT")
VALUES ('TEST JOB', 'GET', '/test.php?page=test', 'google.com', 'cookie: test;', 'bruteforce', 'dos', 1, '2017-01-16T13:15:39.248+08:00', '2017-01-16T13:15:39.248+08:00');

# --- !Downs
DROP TABLE "JOBS";