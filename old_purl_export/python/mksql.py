#!/usr/bin/python

import pyodbc
import bcrypt
from random import randint

def pass_gen():
  chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/!$%&()=~|@`[]{}*+<>?_;:,.\\"

  length = len(chars)
  passwd = ''
  for i in range(0, 12):
    pos = randint(0, length - 1)
    passwd = passwd + chars[pos]

  return(passwd)

'''
  @brief
  文字列に対してエスケープする
'''
def escapeAll(rows_org):
  rows = []
  for row in rows_org:
    rows.append(str(row).replace("'", "''"))

  return(rows)

'''
  @brief
  UsersテーブルにinsertするSQLを生成する
'''
def users(conn):
  salt = bcrypt.gensalt(rounds=11, prefix=b'2a')

  f1 = open("1_users.sql", "w")
  f2 = open("1_users_passwd.csv", "w")

  # SQL
  sql = "select * from users"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      if row[5] != "admin":
        if len(row[4]) == 0:
          email = "-"
        else:
          email = row[4]

        passwd = pass_gen()
        password = passwd.encode()
        crypted_password = bcrypt.hashpw(password, salt)
       
        #crypted_password.decode()
 
        date = "2019/03/11"

        if row[11] == 1:
          allowed = "true" 
          disable = "false"
        else:
          allowed = "false"
          disable = "true"
        
        wait = "false"
        if row[11] == 0:
          wait = "true"

        row = escapeAll(row)

        f2.write('"' + row[5] + '"' + "," + '"' + row[2] + '"' + "," + '"' + passwd + '"' + "\n")

        sql = "insert into users(email, encrypted_password, sign_in_count, failed_attempts, created_at, updated_at, username, allowed_to_log_in, affiliation, fullname, justification, group_flag, admin_flag, disable_flag, new_flag) values ('%s', '%s', 0, 0, '%s', '%s', '%s', %s, '%s', '%s', '%s', false, false, %s, %s);" % (email, crypted_password.decode(), row[9], row[10], row[5], allowed, row[3], row[2], row[8], disable, wait)

        f1.write(sql + "\n")

  f1.close()
  f2.close()

'''
  @brief
  usersテーブル(グループ)にinsertするSQLを生成する
'''
def users_group(conn):
  salt = bcrypt.gensalt(rounds=11, prefix=b'2a')
  f1 = open("2_groups.sql", "w")

  # SQL
  sql = "select * from groups"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      password = b"dummypassword"
      crypted_password = bcrypt.hashpw(password, salt)
 
      date = "2019/03/11"

      if row[6] == 1:
        allowed = "true" 
        disable = "false"
      else:
        allowed = "false"
        disable = "true"

      sql = "insert into users(email, encrypted_password, sign_in_count, failed_attempts, created_at, updated_at, username, allowed_to_log_in, fullname, group_flag, admin_flag, disable_flag, new_flag, comment) values ('-', '%s', 0, 0, '%s', '%s', '%s', false, '%s', true, false, %s, false, '%s');" % (crypted_password.decode(), row[4], row[5], row[2], row[1], disable, row[3])

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  group_maintainer_infosテーブルにinsertするSQLを生成する
'''
def group_maintainer_infos(conn):
  f1 = open("3_group_maintainer_infos.sql", "w")

  # SQL
  sql = "select C.userid, B.g_id from groupmaintainers A left join groups B on A.g_id = B.z_id left join users C on A.m_id = C.z_id"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      date = "2019/03/11"

      sql = "insert into group_maintainer_infos(group_id, user_id, created_at, updated_at) select A.id user_id, B.id group_id, '%s', '%s' from ( select 1 conn_id, id from users where username = '%s') A left join ( select 1 conn_id, id from users where username = '%s') B on A.conn_id = B.conn_id;" % (date, date, row[1], row[0])

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  group_infosテーブルにinsertするSQLを生成する
'''
def group_infos(conn):
  f1 = open("4_group_infos.sql", "w")

  # SQL
  sql = "select C.userid, B.g_id from groupmembers A left join groups B on A.g_id = B.z_id left join users C on A.m_id = C.z_id"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      date = "2019/03/11"

      sql = "insert into group_infos(group_id, user_id, created_at, updated_at) select A.id user_id, B.id group_id, '%s', '%s' from ( select 1 conn_id, id from users where username = '%s') A left join ( select 1 conn_id, id from users where username = '%s') B on A.conn_id = B.conn_id;" % (date, date, row[1], row[0])

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  domain_infosテーブルにinsertするSQLを生成する
'''
def domain_infos(conn):
  salt = bcrypt.gensalt(rounds=11, prefix=b'2a')
  f1 = open("5_domain_infos.sql", "w")

  # SQL
  sql = "select * from domains"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
 
      date = "2019/03/11"

      if row[6] == 1:
        disable = "false"
      else:
        disable = "true"

      wait = "false"
      if row[6] == 0:
        wait = "true"

      public = "false"
      if row[3] != 0:
        public = "true"

      sql = "insert into domain_infos(domain_id, disable_flag, created_at, updated_at, new_flag, name, public_flag) values ('%s', %s, '%s', '%s', %s, '%s', %s);" % (row[2], disable, row[4], row[5], wait, row[1], public)

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  domain_maintainer_infosテーブルにinsertするSQLを生成する
'''
def domain_maintainer_infos(conn):
  f1 = open("6_domain_maintainer_infos.sql", "w")

  # SQL (union)
  sql = "select B.d_id, C.userid from domainmaintainers A left join domains B on A.d_id = B.z_id left join users C on A.m_id = C.z_id where A.type = 0 union all select B.d_id, C.g_id from domainmaintainers A left join domains B on A.d_id = B.z_id left join groups C on A.m_id = C.z_id where A.type = 1;"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      date = "2019/03/11"

      sql = "insert into domain_maintainer_infos(user_id, domain_info_id, created_at, updated_at) select A.id user_id, B.id domain_id, '%s', '%s' from ( select 1 conn_id, id from users where username = '%s') A left join ( select 1 conn_id, id from domain_infos where domain_id = '%s') B on A.conn_id = B.conn_id;" % (date, date, row[1], row[0])

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  domain_writer_infosテーブルにinsertするSQLを生成する
'''
def domain_writer_infos(conn):
  f1 = open("7_domain_writer_infos.sql", "w")

  # SQL (union)
  sql = "select B.d_id, C.userid from domainwriters A left join domains B on A.d_id = B.z_id left join users C on A.w_id = C.z_id where A.type = 0 union all select B.d_id, C.g_id from domainwriters A left join domains B on A.d_id = B.z_id left join groups C on A.w_id = C.z_id where A.type = 1;"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      date = "2019/03/11"

      sql = "insert into domain_writer_infos(user_id, domain_info_id, created_at, updated_at) select A.id user_id, B.id domain_id, '%s', '%s' from ( select 1 conn_id, id from users where username = '%s') A left join ( select 1 conn_id, id from domain_infos where domain_id = '%s') B on A.conn_id = B.conn_id;" % (date, date, row[1], row[0])

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  purl_infosテーブルにinsertするSQLを生成する
'''
def purl_infos(conn):
  salt = bcrypt.gensalt(rounds=11, prefix=b'2a')
  f1 = open("8_purl_infos.sql", "w")

  # SQL
  sql = "select * from purls"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
 
      date = "2019/03/11"

      if row[6] == 1:
        disable = "false"
      else:
        disable = "true"

      wait = "false"
      if row[6] == 0:
        wait = "true"

      if (row[2] != '303' and row[2] != '404' and row[2] != '410' and row[2] != 'clone' and row[2] != 'chain'):
        sql = "insert into purl_infos(path, target, disable_flag, redirect_type_id, created_at, updated_at) select '%s', '%s', %s, id, '%s', '%s' from redirect_types where symbol = '%s';" % (row[1], row[3], disable, row[4], row[5], row[2])

      if row[2] == '303':
        sql = "insert into purl_infos(path, see_also_url, disable_flag, redirect_type_id, created_at, updated_at) select '%s', '%s', %s, id, '%s', '%s' from redirect_types where symbol = '%s';" % (row[1], row[3], disable, row[4], row[5], row[2])

      if row[2] == '404' or row[2] == '410':
        sql = "insert into purl_infos(path, target, disable_flag, redirect_type_id, created_at, updated_at) select '%s', '%s', %s, id, '%s', '%s' from redirect_types where symbol = '%s';" % (row[1], row[3], disable, row[4], row[5], row[2])

      if row[2] == 'clone':
        sql = "insert into purl_infos(path, target, disable_flag, redirect_type_id, created_at, updated_at, clone_flag) select '%s', '%s', %s, id, '%s', '%s', true from redirect_types where symbol = '%s';" % (row[1], row[3], disable, row[4], row[5], row[2])
        
      if row[2] == 'chain':
        sql = "insert into purl_infos(path, target, disable_flag, redirect_type_id, created_at, updated_at, chain_flag) select '%s', '%s', %s, id, '%s', '%s', true from redirect_types where symbol = '%s';" % (row[1], row[3], disable, row[4], row[5], row[2])

      f1.write(sql + "\n")

      if row[2] == 'clone' or row[2] == 'chain':
        sql = "insert into clone_infos(purl_info_id, purl_info_ori_id, created_at, updated_at) select A.id id, B.id target_id, '%s', '%s' from (select 1 conn_id, id, path from purl_infos  where path = '%s') A left join (select 1 conn_id, id, path from purl_infos where path = '%s') B on A.conn_id = B.conn_id;" % (date, date, row[1], row[3])
        f1.write(sql + "\n")

  f1.close()

'''
  @brief
  purl_maintainer_infosテーブルにinsertするSQLを生成する
'''
def purl_maintainer_infos(conn):
  f1 = open("9_purl_maintainer_infos.sql", "w")

  # SQL (union)
  sql = "select B.p_id, C.userid from purlmaintainers A left join purls B on A.p_id = B.z_id left join users C on A.m_id = C.z_id where A.type = 0 union all select B.p_id, C.g_id from purlmaintainers A left join purls B on A.p_id = B.z_id left join groups C on A.m_id = C.z_id where A.type = 1;"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      date = "2019/03/11"

      sql = "insert into purl_maintainer_infos(user_id, purl_info_id, created_at, updated_at) select A.id user_id, B.id purl_id, '%s', '%s' from ( select 1 conn_id, id from users where username = '%s') A left join ( select 1 conn_id, id from purl_infos where path = '%s') B on A.conn_id = B.conn_id;" % (date, date, row[1], row[0])

      f1.write(sql + "\n")

  f1.close()

'''
  @brief
  purl_history_infosテーブルにinsertするSQLを生成する
'''
def purl_history_infos(conn):
  f1 = open("10_purl_history_infos.sql", "w")

  # SQL (union)
  sql = "select B.p_id, A.status, A.type, A.target, A.modtime from purlhistory A left join purls B on A.p_id = B.z_id;"

  # カーソル取得
  with conn.cursor() as cur:
    cur.execute(sql)

    for row in cur.fetchall():
      date = "2019/03/11"
      
      if row[1] == 1:
        disable = "false"
      else:
        disable = "true"

      if (row[2] != '303' and row[2] != '404' and row[2] != '410' and row[2] != 'clone' and row[2] != 'chain'):
        sql = "insert into purl_history_infos(purl_hs_id, path, target, disable_flag, redirect_type_id, created_at, updated_at, symbol, rd_type) select A.id, A.path, '%s', %s, B.id, '%s', '%s', B.symbol, B.rd_type from (select 1 conn_id, id, path from purl_infos where path = '%s') A left join (select 1 conn_id, id, symbol, rd_type from redirect_types where symbol = '%s') B on A.conn_id = B.conn_id;" % (row[3], disable, row[4], row[4], row[0], row[2])

      if row[2] == '303':
        sql = "insert into purl_history_infos(purl_hs_id, path, see_also_url, disable_flag, redirect_type_id, created_at, updated_at, symbol, rd_type) select A.id, A.path, '%s', %s, B.id, '%s', '%s', B.symbol, B.rd_type from (select 1 conn_id, id, path from purl_infos where path = '%s') A left join (select 1 conn_id, id, symbol, rd_type from redirect_types where symbol = '%s') B on A.conn_id = B.conn_id;" % (row[3], disable, row[4], row[4], row[0], row[2])

      if row[2] == '404' or row[2] == '410':
        sql = "insert into purl_history_infos(purl_hs_id, path, target, disable_flag, redirect_type_id, created_at, updated_at, symbol, rd_type) select A.id, A.path, '%s', %s, B.id, '%s', '%s', B.symbol, B.rd_type from (select 1 conn_id, id, path from purl_infos where path = '%s') A left join (select 1 conn_id, id, symbol, rd_type from redirect_types where symbol = '%s') B on A.conn_id = B.conn_id;" % (row[3], disable, row[4], row[4], row[0], row[2])

      if row[2] == 'clone':
        sql = "insert into purl_history_infos(purl_hs_id, path, clone_path, disable_flag, redirect_type_id, created_at, updated_at, symbol, rd_type, clone_flag) select A.id, A.path, '%s', %s, B.id, '%s', '%s', B.symbol, B.rd_type, True from (select 1 conn_id, id, path from purl_infos where path = '%s') A left join (select 1 conn_id, id, symbol, rd_type from redirect_types where symbol = '%s') B on A.conn_id = B.conn_id;" % (row[3], disable, row[4], row[4], row[0], row[2])
        
      if row[2] == 'chain':
        sql = "insert into purl_history_infos(purl_hs_id, path, clone_path, disable_flag, redirect_type_id, created_at, updated_at, symbol, rd_type, chain_flag) select A.id, A.path, '%s', %s, B.id, '%s', '%s', B.symbol, B.rd_type, True from (select 1 conn_id, id, path from purl_infos where path = '%s') A left join (select 1 conn_id, id, symbol, rd_type from redirect_types where symbol = '%s') B on A.conn_id = B.conn_id;" % (row[3], disable, row[4], row[4], row[0], row[2])

      f1.write(sql + "\n")

  f1.close()

# ドライバ名
drv = "MySQL"
# 接続先DB
dbq = "old_purl_export"
# ユーザー名
usr = "root"
# パスワード
pwd = "initial0"
# サーバー
svr = "old_purl_mysql"
# ポート
prt = "3306"

# 接続文字列 (変更不可) 
conn_str = "DRIVER=%s;DATABASE=%s;User=%s;Password=%s;SERVER=%s;PORT=%s" % (drv,dbq,usr,pwd,svr,prt)

# DBに接続
conn = pyodbc.connect(conn_str)

users(conn)
users_group(conn)
group_maintainer_infos(conn)
group_infos(conn)
domain_infos(conn)
domain_maintainer_infos(conn)
domain_writer_infos(conn)
purl_infos(conn)
purl_maintainer_infos(conn)
purl_history_infos(conn)

# DBクローズ
conn.close()
