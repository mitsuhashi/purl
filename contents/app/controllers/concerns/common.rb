module Common
  extend ActiveSupport::Concern

=begin
  @brief
  ディレクトリー構造から切り出しを行う

  @detail
  /hoge1/hoge2/hoge3
    => ["/hoge1/hoge2/hoge3", "/hoge1/hoge2", "/hoge1"]
    or 
    => ["/hoge1/hoge2", "/hoge1"]
=end
  def DomainCutout(directory, oneself)
    if directory[0] == '/'
      #先頭の「/」を削除
      len = directory.length
      directory_chk = directory.slice(1, len - 1)
    else
      #先頭の「/」を追加  
      directory_chk = directory
      diretory = "/" + directory_chk
    end

    sps = directory_chk.split('/')
    subdirs_tmp = []
    i = 0
    for sp in sps
      subdir = ''
      for j in 0 .. i
        subdir = subdir + "/" + sps[j]
      end
      subdirs_tmp.append(subdir)

      i = i + 1
    end 

    #順番をひっくり返す
    i = subdirs_tmp.length - 2
    if oneself == true
      subdirs = [directory]
    else
      subdirs = []
    end
    while i >= 0 do
      subdirs.append(subdirs_tmp[i])
      i = i - 1
    end

    return subdirs 
  end 

=begin
  @brief
  検索フォームに指定されたキーワードからSQLインスタンスを作成
  
  @param first 最初の検索キーワードか？
  @param sqlobj SQLのインスタンス
  @param 検索キーワードのフォーム名
  @param clmname 検索対象のカラムの名前
  @param exact_flag 完全一致の場合はtrue

  @return sqlobj SQLのインスタンス
  @return first 最初の検索キーワードか？
=end
  def searchFromKeyword(first, sqlobj, search_word_sym, clmname, exact_flag = false)

    if params[search_word_sym] == nil then
      return sqlobj, first
    end

    p = params[search_word_sym]
    if p[0].length != 0 then
      if first == true then
        if exact_flag == true
          sqlobj = sqlobj.where(clmname + " = ?", p[0])
        else
          sqlobj = sqlobj.where(clmname + " like ?", "%" + p[0] + "%")
        end
        first = false
      else
        if exact_flag == true
          sqlobj = sqlobj.or(sqlobj.where(clmname + " = ?", p[0]))
        else
          sqlobj = sqlobj.or(sqlobj.where(clmname + " like ?", "%" + p[0] + "%"))
        end
      end 
    end

    return sqlobj, first
  end

=begin
  @brief
  検索フィームにして指定されたMaintainer IDs，Member IDs，Writer IDsの指定からSQLインスタンスを作成
  
  @param first 最初の検索キーワードか？
  @param sqlobj SQLのインスタンス
  @param 検索キーワードのフォーム名
  @param mode 検索対象のモデル(オブジェクト)
  @param modelname 検索対象のモデル名
  @param clmname 検索対象のモデルのリレーション先のモデルとの外部キーの名前
  @param exact_flag 完全一致の場合はtrue

  @return sqlobj SQLのインスタンス
  @return first 最初の検索キーワードか？
=end
  def searchFromIds(first, sqlobj, search_word_sym, model, modelname, clmname, exact_flag = false)

    if params[search_word_sym] == nil then
      return sqlobj, first
    end

    p = params[search_word_sym]
    if p[0].length != 0 then
      if exact_flag == true
        data  = model.joins("left join users on " + modelname.tableize + ".user_id = users.id").select(modelname.tableize + '.' + clmname + ' ' + clmname).where("username = ?", p[0])
      else
        data  = model.joins("left join users on " + modelname.tableize + ".user_id = users.id").select(modelname.tableize + '.' + clmname + ' ' + clmname).where("username like ?", '%' + p[0] + '%')
      end
     
      ids = []
      for datum in data do
        ids.append(datum[clmname])
      end

      if first == true then
        sqlobj = sqlobj.where(id: ids)

        first = false
      else
        sqlobj = sqlobj.or(sqlobj.where(id: ids))
      end 
    end
     
    return sqlobj, first
  end

=begin
  @brief
  Maintainer IDs, Member IDs, Writer IDsなどを1行ずつ読み込んで配列を返す

  @detail
  ログインユーザーを必ず含め，ユーザー名はユニークにして返す

  @param ids 改行を含む文字列
=end
  def Ids2Array(ids)
    ans = [current_user.try(:username).to_s]
    ids.each_line {|line|
      ans.push(line.chomp)
    }

    return ans.uniq
  end

=begin
  @brief
  配列をカンマ区切りの文字列に変換

  @param ids 配列
=end
  def Ids2String(ids)
    i = 0
    str = ''
    for id in ids do
      if i == 0
        str = id
      else
        str = str + "," + id
      end
      i = i + 1
    end

    return str
  end

=begin
  @brief
  引数「usernames」配列の各要素がUserモデルのusername属性として含まれているかを確認する

  @param usernames usernameの配列

  @return
  全ての値がUserモデルに含まれていればtrue, そうでなければfalse
=end
  def checkIdsInUsers(usernames)
    re = true
    for username in usernames do
      count = User.where(username: username).count

      if count == 0
        re = false
      end
    end

    return re
  end

=begin
  @brief
  グループ名からUserモデルのプライマリーキーを全て取り出す

  @params usernames ユーザー名，グループ名
  @params user_ids グループ名から取り出したUserモデルのプライマリーキーが入る配列
  @params already_group_ids 再帰処理する際に同じグループがあるかどうかを検査するためのデーター(Userモデルのプライマリーキーが入る)
=end
  def Group2UserIds(usernames, user_ids = nil, already_group_ids = nil)
   
    if user_ids == nil
      user_ids = []
    end
 
    if already_group_ids == nil
      already_group_ids = []
    end

    for username in usernames do
      onerecord = User.find_by("username = ?", username) 

      if onerecord != nil and onerecord.group_flag == true and onerecord.disable_flag == false #グループ
        if user_ids.include?(onerecord.id) == false
          already_group_ids.append(onerecord.id)

          #groups = User.find_by_sql("select C.username from users A left join group_infos B on A.id = B.group_id left join users C on B.user_id = C.id where A.username = ?", username)
          #groups = User.find_by_sql("select C.username from users A left join group_infos B on A.id = B.group_id left join users C on B.user_id = C.id where A.username = '" +  username + "'")
          groups = User.joins("left join group_infos B on users.id = B.group_id left join users C on B.user_id = C.id").select("C.username").where("users.username = ?", username)
          groups_array = []
          for group in groups do
            groups_array.append(group.username)
          end

          #user_ids, already_group_ids = Group2UserIds(groups, user_ids, already_group_ids)
          user_ids, already_group_ids = Group2UserIds(groups_array, user_ids, already_group_ids)
        end
      else #ユーザー  
        if onerecord != nil
          user_ids.append(onerecord.id)
        end
      end
    end

    return user_ids, already_group_ids
  end

=begin
  @brief
  各レコードに操作権限があるかどうかを調べる

  @param records 各行のデーター
  @param key 検索結果のユニークキー
=end
  def recordReadonly(records, key)
    readonlys = {}
    for record in records do
      maintainer_names_str = record.maintainer_names
      if (maintainer_names_str != nil)
        maintainer_names = maintainer_names_str.split(",")
        user_ids, dummy = Group2UserIds(maintainer_names)

        if user_ids.include?(current_user.try(:id)) == true
          readonlys.merge!(record[key] => false)
        else
          already = false
          if record["public_flag"] == true 
            readonlys.merge!(record[key] => false)
            already = true
          end
          if already == false
            readonlys.merge!(record[key] => true)
          end
        end
      else
        readonlys.merge!(record[key] => false)
      end
    end
 
    return readonlys
  end

=begin
  @brief
  Maintainer IDs, Member IDs, Writers IDsを一旦削除してから登録する

  @param nowcommit 今，コミットした親テーブルのレコード
  @param model Maintainer IDs, Member IDs, Writers IDsが入るモデル
  @param clmname 親モデルと紐づいているMaintainer IDs, Member IDs, Writers IDsが入るモデルの属性
  @param parentModel 親モデル
  @param parent_clmname Maintainer IDs, Member IDs, Writers IDsが入るモデルと紐づいている親モデルの属性名
  @param ids Maintainer IDs, Member IDs, Writers IDsが入るモデルに登録するMaintainer IDs, Member IDs, Writers IDs 
=end
  def deleteAndInsert(nowcommit, model, clmname, parentModel, parent_clmname, ids)
    model.where(clmname + " = ?", nowcommit.id).delete_all
    re = true
    for id in ids do
      if re == true
        newrecord = model.new
        newrecord[clmname] = nowcommit.id
        parent = parentModel.find_by(parent_clmname + " = ?", id)

        if parent != nil
          newrecord.user_id = parent.id
          re = newrecord.save!
        end
      end
    end
  end

=begin
  @brief
  指定されたドメインIDより親のドメインIDを調べて，書き込み権限があるかどうかをチェックする

  @param domain_id これから登録するドメインID

  @return domain_id 表記ゆれを直したドメインID
  @return chkflag falseの場合は指定したドメインIDは作成権限が無い
  @return errMsg エラーメッセージ
=end
  def checkDomainId(domain_id)
    #空白を削除
    domain_id = domain_id.gsub(" ", "")
    #末尾の改行を削除
    domain_id = domain_id.chomp

    #先頭の「/」を削除
    while domain_id[0] == '/' do
      len = domain_id.length
      domain_id = domain_id[1..len - 1]
    end

    #末尾の「/」を削除
    len = domain_id.length
    while domain_id[len - 1] == '/' do
      len = domain_id.length
      domain_id = domain_id[0..len - 2]
    end
    #「/」の1文字以上の繰り返しを[/]の1文字に
    domain_id = domain_id.gsub(/\/+/, '/')
   
    #以下のチェック用のdomain_idの文字列 
    chk_domain_id = domain_id
    #最終的に登録するdomain_idの文字列
    domain_id = '/' + domain_id

    #権限のチェック
    subdomains = DomainCutout(domain_id, true)

    for subdomain in subdomains do
      count = DomainInfo.where(domain_id: subdomain).where(new_flag: false).where(disable_flag: false).count
      if (count != 0)
        checkdomains = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").where(domain_id: subdomain).where(new_flag: false).where(disable_flag: false)
        readonlys = recordReadonly(checkdomains, "id")
        logger.debug("###")
        logger.debug(subdomain)
        #logger.debug(checkdomains[0].id)
        #logger.debug(readonlys[checkdomains[0].id])

        #読み込み専用 = 書き込み権限無し
        if readonlys[checkdomains[0].id] == true
          chkflag = false
          errMsg = "You do not have permission '" + subdomain + "' domain"
    
          return domain_id, chkflag, errMsg
        else
          chkflag = true
          errMsg = ""
          
          return domain_id, chkflag, errMsg
        end
      end
    end
    #権限のチェック -end-

    #chkflag = true
    #errMsg = ""
    if current_user.try(:admin_flag) == true
      chkflag = true
      errMsg = ""
    else
      chkflag = false
      errMsg = "You do not have permission '/' domain"
    end

    return domain_id, chkflag, errMsg
  end

=begin
  @brief
  PURL作成用入力フォームから送られてきたPOSTデーターから作成しようとするPURLのタイプを判定

  @param params POSTデーター

  @return mode PURLのタイプ
  @return rdtype RedirectTypeのプライマリーキーの値
=end
  def setRedirectMode(params)
    if params.has_key?(:purl_type) then
      sps = params[:purl_type].split("_")
      mode = sps[1]
    else
      mode = "simple"
    end

    rdtype = RedirectType.find_by(symbol: mode)

    return mode, rdtype.id
  end

=begin
  @brief
  PURLのPATHを標準化

  @param path 元のPURL path

  @return 標準化したPURL path
=end
  def standardizePath(path)
    #空白を削除
    path = path.gsub(' ', '')
    #末尾の改行を削除
    path = path.chomp
    #「/」の1文字以上の繰り返しを[/]の1文字に
    path = path.gsub(/\/+/, '/')
 
    return path 
  end

=begin
  @brief
  PURLのPATHからPurlInfoモデルのプライマリーIDを取得する
=end
  def getPrimIdFromPath(path)
    count = PurlInfo.where(path: path).count
    if count != 0
      exist_purl = PurlInfo.find_by(path: path)
      return exist_purl.id
    else
      return -1
    end
  end

=begin
  @brief
  指定されたPATHより親のドメインを調べて，書き込み権限があるかどうかをチェックする

  @param path これから登録するPATH

  @return path 表記ゆれを直したPATH
  @return chkflag falseの場合は指定したドメインIDは作成権限が無い
  @return errMsg エラーメッセージ
=end
  def checkPath(path)
    #空白を削除
    path = path.gsub(' ', '')
    #末尾の改行を削除
    path = path.chomp
    #「/」の1文字以上の繰り返しを[/]の1文字に
    path = path.gsub(/\/+/, '/')
    #先頭の「/」を削除
    while path[0] == '/' do
      len = path.length
      path = path[1..len - 1]
    end
   
    #以下のチェック用のPATHの文字列 
    chk_path = path
    #最終的に登録するPATHの文字列
    path = '/' + path

    #権限のチェック
    subdomains = DomainCutout(path, false)
    
    #PATH自身を調べる
    count = PurlInfo.where(path: path).where(disable_flag: false).count
    if (count != 0) #新規PATHの場合はcount=0のはず
      checkpaths = PurlInfo.joins("left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id").select("purl_infos.*, purl_maintainers_one_infos.maintainer_names").where(path: path).where(disable_flag: false)
      readonlys = recordReadonly(checkpaths, "id")
  
      if readonlys[checkpaths[0].id] == true
        chkflag = false
        errMsg = "You do not have permission to '" + path + "'"
    
        return path, chkflag, errMsg
      else
        chkflag = true
        errMsg = ""
          
        return path, chkflag, errMsg
      end
    end 

    for subdomain in subdomains do
      count = DomainInfo.where(domain_id: subdomain).where(new_flag: false).where(disable_flag: false).count
      if (count != 0)
        checkdomains = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").where(domain_id: subdomain).where(new_flag: false).where(disable_flag: false)
        readonlys = recordReadonly(checkdomains, "id")
        logger.debug("###")
        logger.debug(subdomain)
        #logger.debug(checkdomains[0].id)
        #logger.debug(readonlys[checkdomains[0].id])

        #読み込み専用 = 書き込み権限無し
        if readonlys[checkdomains[0].id] == true
          chkflag = false
          errMsg = "You do not have permission '" + subdomain + "' domain"
    
          return path, chkflag, errMsg
        else
          chkflag = true
          errMsg = ""
          
          return path, chkflag, errMsg
        end
      end
    end
    #権限のチェック -end-

    #chkflag = true
    #errMsg = ""
    if current_user.try(:admin_flag) == true
      chkflag = true
      errMsg = ""
    else
      chkflag = false
      errMsg = "You do not have permission '/' domain"
    end

    return path, chkflag, errMsg
  end

=begin
  @brief
  元のモデルの全ての属性を履歴用モデルにコピーする

  @param source 元のモデル
  @param target 履歴用モデル
  @param id_name 元のモデルのプライマリーキーidを履歴モデルのどの属性にコピーをするかを指定
=end
  def copy2history(source, target, id_name)
    source.each{|key, value|
      if key == "id"
        target[id_name] = source['id']
      else
        target[key] = source[key]
      end
    }

    return target
  end

=begin
  @brief
  接続先のURLが存在するか？

  @param url URL

  @return 存在する場合はtrue
=end
  def url_exist?(url)
    agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"
    uri = URI.parse(url)

    sps = url.split(':')
    https_flag = false
    if sps[0] == "https"
      https_flag = true
    end
  
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      if https_flag == true
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.get('/', {"User-Agent" => agent})
    rescue
      return false
    else
      return true
    end
  end

=begin
  @brief
  Chainをたどって，targetを探す

  @param purl_id 探すChain PURLのプライマリーキー
=end
  def getChainTarget(purl_id)
    purl_clone = CloneInfo.joins("left join purl_infos on clone_infos.purl_info_ori_id = purl_infos.id").select("clone_infos.purl_info_ori_id, purl_infos.target").find_by("clone_infos.purl_info_id = ?", purl_id)

    if purl_clone[:target].length == 0 then
      target = getChainTarget(purl_clone.purl_info_ori_id)    
    else
      target = purl_clone.target
    end

    return target
  end
end
