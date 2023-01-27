CREATE TABLE IF NOT EXISTS users (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
admin BOOLEAN,
fullname VARCHAR(100),
affiliation VARCHAR(100),
email VARCHAR(100),
userid VARCHAR(32),
password VARCHAR(100),
password_hint VARCHAR(100),
justification VARCHAR(300),
created DATETIME,
lastmodified DATETIME,
status SMALLINT,
indexed BOOLEAN,

index(indexed),
constraint unique(userid)

) ;

CREATE TABLE IF NOT EXISTS domains (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
name VARCHAR(100),
d_id VARCHAR(100),
public BOOLEAN,
created DATETIME,
lastmodified DATETIME,
status SMALLINT,
indexed BOOLEAN,

index(indexed),
constraint unique(d_id)

) ;

CREATE TABLE IF NOT EXISTS domainmaintainers (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
d_id INTEGER UNSIGNED,
m_id INTEGER UNSIGNED,
type SMALLINT,

index(d_id), index(m_id),
foreign key (d_id) references domains(z_id) on delete cascade

) ;

CREATE TABLE IF NOT EXISTS domainwriters (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
d_id INTEGER UNSIGNED,
w_id INTEGER UNSIGNED,
type SMALLINT,

index(d_id), index(w_id),
foreign key (d_id) references domains(z_id) on delete cascade
) ;

CREATE TABLE IF NOT EXISTS groups (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
name VARCHAR(100),
g_id VARCHAR(100),
comments VARCHAR(300),
created DATETIME,
lastmodified DATETIME,
status SMALLINT,
indexed BOOLEAN,

index(indexed),
constraint unique(g_id)

) ;

CREATE TABLE IF NOT EXISTS groupmaintainers (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
g_id INTEGER UNSIGNED,
m_id INTEGER UNSIGNED,
type SMALLINT,
index(g_id),index(m_id),
foreign key (g_id) references groups(z_id) on delete cascade
) ;

CREATE TABLE IF NOT EXISTS groupmembers (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
g_id INTEGER UNSIGNED,
m_id INTEGER UNSIGNED,
type SMALLINT,
index(g_id),index(m_id),
foreign key (g_id) references groups(z_id) on delete cascade
) ;

CREATE TABLE IF NOT EXISTS purls (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
p_id VARCHAR(750),
type VARCHAR(100),
target VARCHAR(4000),
created DATETIME,
lastmodified DATETIME,
status SMALLINT,
indexed BOOLEAN,
index(indexed),
constraint unique(p_id(750))
) ;

CREATE TABLE IF NOT EXISTS purlmaintainers (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
p_id INTEGER UNSIGNED,
m_id INTEGER UNSIGNED,
type SMALLINT,
index(p_id), index(m_id),
foreign key (p_id) references purls(z_id) on delete cascade
) ;

CREATE TABLE IF NOT EXISTS purlhistory (
z_id INTEGER UNSIGNED NOT NULL , PRIMARY KEY (z_id),
p_id INTEGER UNSIGNED,
u_id INTEGER UNSIGNED,
status SMALLINT,
type VARCHAR(100),
target VARCHAR(4000),
modtime DATETIME,
index(p_id), index(u_id),
foreign key (p_id) references purls(z_id) on delete cascade
) ;
