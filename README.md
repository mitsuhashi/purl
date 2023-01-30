# purl
persistent URL  management system written in Ruby

## インストール

### 0. ソースコードのダウンロード
```
$ pwd
/opt
$ git clone https://github.com/mitsuhashi/purl
```

### 1. コンテナの起動
コンテナのビルドには20分程度かかる。
```
$ cd purl
$ docker-compose up -d
purl_web_apache is up-to-date
purl_db is up-to-date
$ docker-compose ps
     Name                    Command              State                     Ports
----------------------------------------------------------------------------------------------------
purl_db           docker-entrypoint.sh postgres   Up      0.0.0.0:15432->5432/tcp,:::15432->5432/tcp
purl_web_apache   /run_in_container.sh            Up      0.0.0.0:13000->3000/tcp,:::13000->3000/tcp
$
```

### 2. purl_dbにpostgresqlデータベースを作成
#### 「purl_dev」データーベースの作成
```
$ docker exec -it purl_db psql -U postgres -c "create database purl_dev;"
CREATE DATABASE
$ docker exec -it purl_db psql -U postgres -l
                                         データベース一覧
   名前    |  所有者  | エンコーディング |  照合順序  | Ctype(変換演算子) |     アクセス権限
-----------+----------+------------------+------------+-------------------+-----------------------
 postgres  | postgres | UTF8             | ja_JP.utf8 | ja_JP.utf8        |
 purl_dev  | postgres | UTF8             | ja_JP.utf8 | ja_JP.utf8        |
 template0 | postgres | UTF8             | ja_JP.utf8 | ja_JP.utf8        | =c/postgres          +
           |          |                  |            |                   | postgres=CTc/postgres
 template1 | postgres | UTF8             | ja_JP.utf8 | ja_JP.utf8        | =c/postgres          +
           |          |                  |            |                   | postgres=CTc/postgres
(4 行)
```
#### スキーマー(各テーブル,ビュー等のオブジェクト)の作成
```
$ ./run_migrate_in_host.sh
== 20190121053606 DeviseCreateUsers: migrating ================================
-- create_table(:users)
   -> 0.0056s
-- add_index(:users, :email, {:unique=>true})
   -> 0.0030s
-- add_index(:users, :reset_password_token, {:unique=>true})
   -> 0.0026s
== 20190121053606 DeviseCreateUsers: migrated (0.0113s) =======================

== 20190121055933 AddUsernameToUsers: migrating ===============================
-- add_column(:users, :username, :string)
   -> 0.0006s
-- add_index(:users, :username, {:unique=>true})
   -> 0.0025s
== 20190121055933 AddUsernameToUsers: migrated (0.0032s) ======================

== 20190121060030 RemoveIndexEmailFromUsers: migrating ========================
-- remove_index(:users, {:column=>:email, :unique=>true})
   -> 0.0036s
== 20190121060030 RemoveIndexEmailFromUsers: migrated (0.0036s) ===============

== 20190122041221 AddColumnToUser: migrating ==================================
-- add_column(:users, :allowed_to_log_in, :boolean, {:default=>true, :null=>false})
   -> 0.0009s
== 20190122041221 AddColumnToUser: migrated (0.0010s) =========================

== 20190122133515 AddColumnAffilicationToUser: migrating ======================
-- add_column(:users, :affiliation, :text)
   -> 0.0005s
== 20190122133515 AddColumnAffilicationToUser: migrated (0.0006s) =============

== 20190122133735 AddIndexAffiliationToUser: migrating ========================
-- add_index(:users, :affiliation)
   -> 0.0025s
== 20190122133735 AddIndexAffiliationToUser: migrated (0.0025s) ===============

== 20190122143401 AddColumnFullnameToUser: migrating ==========================
-- add_column(:users, :fullname, :text)
   -> 0.0005s
-- execute("      update users set fullname = '' where fullname is null;\n")
   -> 0.0005s
-- change_column(:users, :fullname, :text, {:null=>false})
   -> 0.0005s
== 20190122143401 AddColumnFullnameToUser: migrated (0.0018s) =================

== 20190122143410 AddIndexFullnameToUser: migrating ===========================
-- add_index(:users, :fullname)
   -> 0.0028s
== 20190122143410 AddIndexFullnameToUser: migrated (0.0029s) ==================

== 20190122150000 AddColumnJustificationToUser: migrating =====================
-- add_column(:users, :justification, :text)
   -> 0.0005s
== 20190122150000 AddColumnJustificationToUser: migrated (0.0006s) ============

== 20190122235049 AddColumnGroupToUser: migrating =============================
-- add_column(:users, :group_flag, :boolean, {:null=>false, :default=>false})
   -> 0.0008s
== 20190122235049 AddColumnGroupToUser: migrated (0.0009s) ====================

== 20190122235119 AddIndexGroupToUser: migrating ==============================
-- add_index(:users, :group_flag)
   -> 0.0026s
== 20190122235119 AddIndexGroupToUser: migrated (0.0026s) =====================

== 20190125014339 AddAdminToUsers: migrating ==================================
-- add_column(:users, :admin, :boolean)
   -> 0.0005s
== 20190125014339 AddAdminToUsers: migrated (0.0005s) =========================

== 20190128071920 RenameColumnAdminToUser: migrating ==========================
-- rename_column(:users, :admin, :admin_flag)
   -> 0.0034s
== 20190128071920 RenameColumnAdminToUser: migrated (0.0034s) =================

== 20190128073027 CreateRedirectTypes: migrating ==============================
-- create_table(:redirect_types)
   -> 0.0035s
-- add_index(:redirect_types, :symbol, {:unique=>true, :name=>"rt_symbol_idx1"})
   -> 0.0025s
== 20190128073027 CreateRedirectTypes: migrated (0.0061s) =====================

== 20190128074526 CreateGroupInfos: migrating =================================
-- create_table(:group_infos)
   -> 0.0081s
== 20190128074526 CreateGroupInfos: migrated (0.0082s) ========================

== 20190128081604 CreatePurlInfos: migrating ==================================
-- create_table(:purl_infos)
   -> 0.0076s
-- add_index(:purl_infos, :path, {:unique=>true, :name=>"purl_info_idx1"})
   -> 0.0028s
-- add_index(:purl_infos, :target, {:name=>"purl_info_idx2"})
   -> 0.0025s
-- add_index(:purl_infos, :see_also_url, {:name=>"purl_info_idx3"})
   -> 0.0025s
-- add_index(:purl_infos, :clone_flag, {:name=>"purl_info_idx4"})
   -> 0.0024s
-- add_index(:purl_infos, :chain_flag, {:name=>"purl_info_idx5"})
   -> 0.0024s
-- add_index(:purl_infos, :disable_flag, {:name=>"purl_info_idx6"})
   -> 0.0025s
-- add_index(:purl_infos, :redirect_type_id, {:name=>"purl_info_idx7"})
   -> 0.0030s
== 20190128081604 CreatePurlInfos: migrated (0.0262s) =========================

== 20190128083705 CreateCloneInfos: migrating =================================
-- create_table(:clone_infos)
   -> 0.0090s
== 20190128083705 CreateCloneInfos: migrated (0.0090s) ========================

== 20190128090008 CreatePurlMaintainerInfos: migrating ========================
-- create_table(:purl_maintainer_infos)
   -> 0.0081s
== 20190128090008 CreatePurlMaintainerInfos: migrated (0.0082s) ===============

== 20190128090851 CreateDomainInfos: migrating ================================
-- create_table(:domain_infos)
   -> 0.0039s
-- add_index(:domain_infos, :domain_id, {:unique=>true, :name=>"domain_infos_idx1"})
   -> 0.0024s
== 20190128090851 CreateDomainInfos: migrated (0.0064s) =======================

== 20190128091402 CreateDomainMaintainerInfos: migrating ======================
-- create_table(:domain_maintainer_infos)
   -> 0.0082s
== 20190128091402 CreateDomainMaintainerInfos: migrated (0.0083s) =============

== 20190128091855 AddColumnNewFlagToDomainInfo: migrating =====================
-- add_column(:domain_infos, :new_flag, :boolean, {:null=>false, :default=>true})
   -> 0.0008s
== 20190128091855 AddColumnNewFlagToDomainInfo: migrated (0.0009s) ============

== 20190128130614 AddColumnNameToDomainInfo: migrating ========================
-- add_column(:domain_infos, :name, :text, {:null=>false})
   -> 0.0005s
-- add_index(:domain_infos, :name, {:unique=>true})
   -> 0.0024s
== 20190128130614 AddColumnNameToDomainInfo: migrated (0.0030s) ===============

== 20190128144832 AddColumnPublicToDomainInfo: migrating ======================
-- add_column(:domain_infos, :public_flag, :boolean, {:null=>false, :default=>false})
   -> 0.0009s
-- add_index(:domain_infos, :public_flag)
   -> 0.0024s
== 20190128144832 AddColumnPublicToDomainInfo: migrated (0.0034s) =============

== 20190129013403 AddColumnCommentToUser: migrating ===========================
-- add_column(:users, :comment, :text)
   -> 0.0005s
== 20190129013403 AddColumnCommentToUser: migrated (0.0006s) ==================

== 20190129020944 CreateGroupMaintainerInfos: migrating =======================
-- create_table(:group_maintainer_infos)
   -> 0.0078s
== 20190129020944 CreateGroupMaintainerInfos: migrated (0.0079s) ==============

== 20190201021115 AddColumnDisableFlagToUser: migrating =======================
-- add_column(:users, :disable_flag, :boolean)
   -> 0.0006s
-- execute("      update users set disable_flag = false;\n")
   -> 0.0005s
-- change_column(:users, :disable_flag, :boolean, {:null=>false})
   -> 0.0005s
== 20190201021115 AddColumnDisableFlagToUser: migrated (0.0017s) ==============

== 20190201041543 AddColumnNewFlagToUser: migrating ===========================
-- add_column(:users, :new_flag, :boolean)
   -> 0.0005s
-- execute("      update users set new_flag = false;\n")
   -> 0.0004s
-- change_column(:users, :new_flag, :boolean, {:null=>false})
   -> 0.0005s
== 20190201041543 AddColumnNewFlagToUser: migrated (0.0015s) ==================

== 20190202093057 CreateGroupMaintainersOneInfos: migrating ===================
-- execute("      create view group_maintainers_one_infos as select group_id user_id, array_to_string(array_agg(B.username), ',') as maintainer_names from group_maintainer_infos A left join users B on A.user_id = B.id group by group_id;\n")
   -> 0.0016s
== 20190202093057 CreateGroupMaintainersOneInfos: migrated (0.0017s) ==========

== 20190202095430 CreateGroupMembersOneInfos: migrating =======================
-- execute("      create view group_members_one_infos as select group_id user_id, array_to_string(array_agg(B.username), ',') as member_names from group_infos A left join users B on A.user_id = B.id group by group_id\n")
   -> 0.0011s
== 20190202095430 CreateGroupMembersOneInfos: migrated (0.0011s) ==============

== 20190204125344 CreateModelDomainWriterInfos: migrating =====================
-- create_table(:domain_writer_infos)
   -> 0.0084s
== 20190204125344 CreateModelDomainWriterInfos: migrated (0.0084s) ============

== 20190204135154 CreateDomainMaintainersOneInfos: migrating ==================
-- execute("      create view domain_maintainers_one_infos as select domain_info_id, array_to_string(array_agg(B.username), ',') as maintainer_names from domain_maintainer_infos A left join users B on A.user_id = B.id group by domain_info_id;\n")
   -> 0.0011s
== 20190204135154 CreateDomainMaintainersOneInfos: migrated (0.0012s) =========

== 20190204143931 CreateDomainWritersOneInfos: migrating ======================
-- execute("      create view domain_writers_one_infos as select domain_info_id, array_to_string(array_agg(B.username), ',') as writer_names from domain_writer_infos A left join users B on A.user_id = B.id group by domain_info_id;\n")
   -> 0.0010s
== 20190204143931 CreateDomainWritersOneInfos: migrated (0.0011s) =============

== 20190205075014 RenameColumnTypeToRedirectType: migrating ===================
-- rename_column(:redirect_types, :type, :rd_type)
   -> 0.0017s
== 20190205075014 RenameColumnTypeToRedirectType: migrated (0.0018s) ==========

== 20190205075905 ChangeColumnTypeToRedirectType: migrating ===================
-- change_column(:redirect_types, :symbol, :text)
   -> 0.0008s
== 20190205075905 ChangeColumnTypeToRedirectType: migrated (0.0009s) ==========

== 20190206012609 CreatePurlMaintainersOneInfos: migrating ====================
-- execute("      create view purl_maintainers_one_infos as select H.purl_info_id, array_to_string(array_agg(H.username), ',') as maintainer_names from ( select A.id purl_info_id, case when A.clone_flag = true then G.username else C.username end username from purl_infos A left join purl_maintainer_infos B on A.id = B.purl_info_id left join users C on B.user_id = C.id left join clone_infos D on A.id = D.purl_info_id left join purl_infos E on D.purl_info_ori_id = E.id left join purl_maintainer_infos F on E.id = F.purl_info_id left join users G on F.user_id = G.id) H group by H.purl_info_id\n")
   -> 0.0025s
== 20190206012609 CreatePurlMaintainersOneInfos: migrated (0.0026s) ===========

== 20190208005818 AddIndexPurlInfoIdToCloneInfo: migrating ====================
-- remove_index(:clone_infos, :purl_info_id)
   -> 0.0026s
-- add_index(:clone_infos, :purl_info_id, {:unique=>true})
   -> 0.0025s
== 20190208005818 AddIndexPurlInfoIdToCloneInfo: migrated (0.0053s) ===========

== 20190208021336 CreatePurlMaintainersScInfos: migrating =====================
-- execute("      create view purl_maintainer_sc_infos as select A.id purl_info_id, case when A.clone_flag = true then G.id else C.id end user_id from purl_infos A left join purl_maintainer_infos B on A.id = B.purl_info_id left join users C on B.user_id = C.id left join clone_infos D on A.id = D.purl_info_id left join purl_infos E on D.purl_info_ori_id = E.id left join purl_maintainer_infos F on E.id = F.purl_info_id left join users G on F.user_id = G.id\n")
   -> 0.0023s
== 20190208021336 CreatePurlMaintainersScInfos: migrated (0.0024s) ============

== 20190208063949 CreateUserHistoryInfos: migrating ===========================
-- execute("      create table user_history_infos as select * from users where 1 = 2;\n")
   -> 0.0022s
-- add_column(:user_history_infos, :user_hs_id, :integer, {:null=>false})
   -> 0.0005s
-- add_index(:user_history_infos, :user_hs_id)
   -> 0.0026s
-- remove_column(:user_history_infos, :id)
   -> 0.0005s
-- execute("      alter table user_history_infos add id serial\n")
   -> 0.0064s
== 20190208063949 CreateUserHistoryInfos: migrated (0.0125s) ==================

== 20190208083735 CreatePurlHistoryInfos: migrating ===========================
-- execute("       create table purl_history_infos as select purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path, purl_clone_infos.id clone_path_id from purl_infos left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id left join redirect_types on purl_infos.redirect_type_id = redirect_types.id left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos  on clone_infos.purl_info_ori_id = purl_clone_infos.id  where 1 = 2;\n")
   -> 0.0046s
-- add_column(:purl_history_infos, :purl_hs_id, :integer, {:null=>false})
   -> 0.0006s
-- add_index(:purl_history_infos, :purl_hs_id)
   -> 0.0028s
-- remove_column(:purl_history_infos, :id)
   -> 0.0004s
-- execute("      alter table purl_history_infos add id serial\n")
   -> 0.0039s
== 20190208083735 CreatePurlHistoryInfos: migrated (0.0124s) ==================

== 20190208145544 CreateDomainHistoryInfos: migrating =========================
-- execute("      create table domain_history_infos as select domain_infos.*, domain_maintainers_one_infos.maintainer_names, domain_writers_one_infos.writer_names from domain_infos join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id where 1 = 2\n")
   -> 0.0029s
-- add_column(:domain_history_infos, :domain_hs_id, :integer, {:null=>false})
   -> 0.0005s
-- add_index(:domain_history_infos, :domain_hs_id)
   -> 0.0026s
-- remove_column(:domain_history_infos, :id)
   -> 0.0005s
-- execute("      alter table domain_history_infos add id serial\n")
   -> 0.0038s
== 20190208145544 CreateDomainHistoryInfos: migrated (0.0104s) ================

== 20190209140317 AddColumnIDsToUserHistoryInfo: migrating ====================
-- add_column(:user_history_infos, :maintainer_names, :text)
   -> 0.0005s
-- add_column(:user_history_infos, :member_names, :text)
   -> 0.0005s
== 20190209140317 AddColumnIDsToUserHistoryInfo: migrated (0.0011s) ===========
$
```
### 最初のログインユーザを登録する
```
$ ./first_user.sh
INSERT 0 1
$
```

## 3. 起動確認
```
$ curl -LI http://localhost:13000 -o /dev/null -w '%{http_code}\n' -s
200
$
ブラウザから最初のログインユーザでログインする
```
