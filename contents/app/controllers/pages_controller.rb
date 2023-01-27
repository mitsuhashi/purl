class PagesController < ApplicationController
  include Common

  @@per_page = 5

=begin
  @brief
  トップページ用のメソッド
=end
  def index
    @newuser = User.new
    @newdomain = DomainInfo.new
    @newgroup = GroupInfo.new
    @newpurl = PurlInfo.new
    #@newpurl_clone = PurlInfo.new #clone or chain用

    #通知メッセージ
    @information = ""
    if current_user.try(:admin_flag) == true
      reg_user_count = User.where(new_flag: true).count
      if reg_user_count != 0
        @information = @information + "Registration new user id from the user\n"
      end 
      reg_domain_count = DomainInfo.where(new_flag: true).count
      if reg_domain_count != 0
        @information = @information + "Registration new domain from the user\n"
      end
    end
  end

=begin
  @brief
  結果表示用フレーム用のメソッド
=end
  def result
    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  ユーザー作成ページのコミット時に実行されるメソッド
=end
  def user_commit

    ##エラー判定
    if params[:user][:password] != params[:user][:password_confirmation]
      @result = "[Error]\n"
      @result = @result + "&nbsp;&nbsp;" + "Passwords do not match"
      @result_flag = false
      render :layout => nil

      return false
    end
    ##エラー判定 -end-

    ##モードの設定
    mode = 0
    if params[:newuser_submit] == "Submit"
      newuser = User.new
      mode = 1
    end
    
    if params[:newuser_submit] == "Modify"
      newuser = User.find(params[:modify_userid])
      mode = 2
    end

    if params[:newuser_submit] == "Disable"
      newuser = User.find(params[:chgstate_userid])
      mode = 3
    end

    if params[:newuser_submit] == "Enable"
      newuser = User.find(params[:chgstate_userid])
      mode = 4
    end
    ##モードの設定 -end-

    ##値の更新
    if mode == 1 or mode == 2
      newuser.fullname = params[:user][:fullname]
      newuser.affiliation = params[:user][:affiliation]
      newuser.email = params[:user][:email]
      newuser.username = params[:user][:username]
      
      if params[:user][:password].length != 0
        newuser.password = params[:user][:password]
      end
      
      newuser.justification = params[:user][:justification]
    end

    if mode == 1
      #管理者が作成した場合は認証無し
      if current_user.try(:admin_flag?) == true
        newuser.allowed_to_log_in = true
        newuser.new_flag = false
        newuser.disable_flag = false
        newuser.group_flag = false
      else
        #修正の時(mode == 2)は現状のステータスを維持する
        if mode == 1
          #未承認状態
          newuser.allowed_to_log_in = false
          newuser.new_flag = true
          newuser.disable_flag = true
          newuser.group_flag = false
        end
      end
    end

    if mode == 2
      if current_user.try(:admin_flag) == true
        newuser.admin_flag = params[:admin_flag]
      end
    end

    if mode == 3
      #無効状態
      newuser.disable_flag = true
      newuser.allowed_to_log_in = false
    end
      
    if mode == 4
      #有効状態
      newuser.disable_flag = false
      newuser.allowed_to_log_in = true
    end
    ##値の更新 --end-- 

    ##コミット
    @result_flag = true
    if newuser.valid?
      #変更履歴
      if mode == 2
        history = UserHistoryInfo.new
        history = copy2history(newuser.attributes, history, "user_hs_id")
        history.save
      end

      re = newuser.save
    
      #作成履歴
      if mode == 1
        history = UserHistoryInfo.new
        history = copy2history(newuser.attributes, history, "user_hs_id")
        history.save
      end

      if re == false 
        @result = 'Failed!!: Unexpected error'
        @result_flag = false;
      else
        if mode == 1
          NotificationMailer.send_reg_user_to_admin(params[:user][:fullname], params[:user][:username], params[:user][:email], params[:user][:affiliation], params[:user][:justification]).deliver_later
          #NotificationMailer.send_reg_user_to_admin(params[:user][:fullname], params[:user][:fullname], params[:user][:username], params[:user][:email], params[:user][:affiliation], params[:user][:justification]).deliver
        end

        if mode == 1 && current_user.try(:admin_flag?) != true
          @result = "Success\nStatus: Pending approval"
        else
          @result = "Success"
        end
        @result_flag = true;
      end
    else
      @result = "[Error]\n"
      i = 0
      newuser.errors.messages.each {|key, values|
        for value in values do
          k = key.to_s
          k = k.to_s.sub(/password/, "Password")
          k = k.to_s.sub(/fullname/, "Full name")
          k = k.to_s.sub(/username/, "User ID")
          @result = @result + "&nbsp;&nbsp;" + k + " => " + value + "\n"
        end
      }
    
      @result_flag = false
    end
    ##コミット -end-
    
    #debug
    #@result = params
    #@result = params[:user][:id]
    #@result = @debug_sql

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  ユーザーの検索結果を表示する際に実行されるメソッド

  @detail
  ユーザー検索のコミット時に実行される
=end
  def user_search_results

    @result = 'Search results'

    users = User.where(group_flag: false).where(new_flag: false)

    ##条件指定
    first = true
    #Full nameによる検索
    users, first = searchFromKeyword(first, users, "user_search_fullname", "fullname")
    #Affiliationによる検索
    users, first = searchFromKeyword(first, users, "user_search_affiliation", "affiliation")
    #E-mailによる検索
    users, first = searchFromKeyword(first, users, "user_search_email", "email")
    #User IDによる検索
    users, first = searchFromKeyword(first, users, "user_search_userid", "username")
    #Disable
    if params[:user_search_disabled] != "1"
      users = users.where(disable_flag: false)
    end

    if params[:user_search_all] == "1"
      @users = User.all.where(group_flag: false).where(new_flag: false)
      @debug_sql = users.to_sql()
      first = false
    end

    if first == false
      if users.length != 0
        @debug_sql = users.to_sql()
      else
        users = Array([])
        @debug_sql = ""
      end
    else
      users = Array([])
      @debug_sql = ""
    end
    
    @users = Kaminari.paginate_array(users).page(params[:page]).per(@@per_page)
    
    #logger.debug("debug_sql:" + @debug_sql)
    
    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  ユーザー情報の変更履歴を取得する
=end
  def user_history
    users = UserHistoryInfo.where(user_hs_id: params[:history_userid]).order(:id)
    @users = Kaminari.paginate_array(users).page(params[:page]).per(@@per_page)
    
    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  ドメインのコミット
=end
  def domain_commit

    ##エラー判定
    domain_id, chkflag, errMsg = checkDomainId(params[:domain_info][:domain_id])
    #管理者の場合は無制限に作成できる
    if current_user.try(:admin_flag?) == true
      chkflag == true
    end
    if chkflag == false 
      @result = errMsg
      @result_flag = false;
    
      render :layout => nil
      return false
    end 
    ##エラー判定 -end-

    ##モードの設定
    mode = 0
    if params[:newdomain_submit] == "Submit"
      newdomain = DomainInfo.new
      mode = 1
    end
    
    if params[:newdomain_submit] == "Modify"
      newdomain = DomainInfo.find(params[:modify_did])
      mode = 2
    end

    if params[:newdomain_submit] == "Disable"
      newdomain = DomainInfo.find(params[:chgstate_did])
      mode = 3
    end

    if params[:newdomain_submit] == "Enable"
      newdomain = DomainInfo.find(params[:chgstate_did])
      mode = 4
    end
    ##モードの設定 -end-

    ##値の更新
    mt_check = true
    if mode == 1 or mode == 2
      newdomain.name = params[:domain_info][:name] #Name
      newdomain.domain_id = domain_id #Domain ID
      newdomain.public_flag = params[:domain_info][:public_flag]     

      #管理者が作成した場合は承認無し 
      if current_user.try(:admin_flag?) == true
        newdomain.disable_flag = false
        newdomain.new_flag = false
      else
        #修正の時(mode == 2)は現状のステータスを維持する
        if mode == 1
          newdomain.disable_flag = true
          newdomain.new_flag = true
        end
      end

      #Maintainer IDs
      mt_ids = Ids2Array(params[:newdomain_maintainer_ids][0])
      writer_ids = Ids2Array(params[:newdomain_writer_ids][0])
    end

    if mode == 3
      #無効状態
      newdomain.new_flag = false
      newdomain.disable_flag = true
    end
      
    if mode == 4
      #有効状態
      newdomain.new_flag = false
      newdomain.disable_flag = false
    end
    ##値の更新 --end-- 
    
    ##コミット
    if newdomain.valid?
      DomainInfo.transaction do

        #変更履歴
        if mode == 2
          cur_domain = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").joins("left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id").select("domain_infos.*, domain_writers_one_infos.writer_names").find(newdomain.id)
          history = DomainHistoryInfo.new
          history = copy2history(cur_domain.attributes, history, "domain_hs_id")
          history.save
        end

        re = newdomain.save

        if re == true
          nowcommit = DomainInfo.find_by(domain_id: domain_id)

          if mode == 1 or mode == 2
            #Maintainer IDs -> 一旦削除して登録
            deleteAndInsert(nowcommit, DomainMaintainerInfo, "domain_info_id", User, "username", mt_ids)
            #Writer IDs -> 一旦削除して登録
            deleteAndInsert(nowcommit, DomainWriterInfo, "domain_info_id", User, "username", writer_ids)
          end
        
          #作成履歴
          if mode == 1
            cur_domains = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").joins("left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id").select("domain_infos.*, domain_writers_one_infos.writer_names").find(nowcommit.id)
          history = DomainHistoryInfo.new
          history = copy2history(cur_domains.attributes, history, "domain_hs_id")
          history.save
        end
        end

        @result_flag = true;
        if re == false
          @result = 'Failed!!: Unexpected error'
          @result_flag = false;
        else
          if mode == 1 && current_user.try(:admin_flag?) != true
            @result = "Success\nStatus: Pending approval"
          else
            @result = "Success"
          end
        end 
      end
    else
      @result = "[Error]\n"
      i = 0
      newdomain.errors.messages.each {|key, values|
        for value in values do
          k = key.to_s
          @result = @result + "&nbsp;&nbsp;" + k + " => " + value + "\n"
        end
      }
    
      @result_flag = false
    end
    ##コミット -end-

    #debug
    #@result = params
    #@result = domain_id

    #@result = params
    #logger.debug("########")
    #logger.debug(params)
    #logger.debug(mt_ids)

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  ドメインの検索結果を表示する際に実行されるメソッド

  @detail
  ドメインの検索のコミット時に実行される
=end
  def domain_search_results
    
    domains = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").joins("left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id").select("domain_infos.*, domain_writers_one_infos.writer_names").where(new_flag: false)

    ##条件指定
    first = true
    #Nameによる検索
    domains, first = searchFromKeyword(first, domains, "domain_search_name", "name")
    #Group IDによる検索
    domains, first = searchFromKeyword(first, domains, "domain_search_domainid", "domain_id")
    #Maintainer IDsによる検索
    domains, first = searchFromIds(first, domains, "domain_search_maintainer_ids", DomainMaintainerInfo, "DomainMaintainerInfo", "domain_info_id")
    #Member IDsによる検索
    domains, first = searchFromIds(first, domains, "domain_search_writer_ids", DomainWriterInfo, "DomainWriterInfo", "domain_info_id")
    #Disable
    if params[:domain_search_disabled] != "1"
      domains = domains.where(disable_flag: false)
    end
    ##条件指定 -end-

    #Maintainer IDsを調べて権限の有無を調べる
    @readonlys = recordReadonly(domains, "id")

    if params[:domain_search_all] == "1"
      @domains = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").joins("left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id").select("domain_infos.*, domain_writers_one_infos.writer_names").where(new_flag: false)
      first = false
    end

    if first == false
      if domains.length != 0
        @debug_sql = domains.to_sql()
      else
        domains = Array([])
        @debug_sql = ""
      end
    else
      domains = Array([])
      @debug_sql = ""
    end

    @domains = Kaminari.paginate_array(domains).page(params[:page]).per(@@per_page)

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  ドメイン情報の変更履歴を取得する
=end
  def domain_history
    domains = DomainHistoryInfo.where(domain_hs_id: params[:history_domainid]).order(:id)
    @domains = Kaminari.paginate_array(domains).page(params[:page]).per(@@per_page)
    
    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  グループのコミット

  @detail
  グループはUserモデルにコミット
=end
  def group_commit

    ##モードの設定
    mode = 0
    if params[:newgroup_submit] == "Submit"
      newuser = User.new
      mode = 1
    end
    
    if params[:newgroup_submit] == "Modify"
      newuser = User.find(params[:modify_groupid])
      mode = 2
    end

    if params[:newgroup_submit] == "Disable"
      newuser = User.find(params[:chgstate_groupid])
      mode = 3
    end

    if params[:newgroup_submit] == "Enable"
      newuser = User.find(params[:chgstate_groupid])
      mode = 4
    end
    ##モードの設定 -end-

    ##値の更新
    mt_check = true
    if mode == 1 or mode == 2
      newuser.fullname = params[:user][:fullname] #Name
      newuser.username = params[:user][:username] #Group ID
      newuser.comment = params[:user][:comment]
      
      newuser.allowed_to_log_in = false
      newuser.group_flag = true
      newuser.new_flag = false
      newuser.disable_flag = false

      #Maintainer IDs
      mt_ids = Ids2Array(params[:newgroup_maintainer_ids][0])
      member_ids = Ids2Array(params[:newgroup_member_ids][0])
 
      #ダミーのパスワード
      newuser.password = "2*!W8Au*r!q|"
      newuser.password_confirmation = "2*!W8Au*r!q|"
    end

    if mode == 3
      #無効状態
      newuser.allowed_to_log_in = false
      newuser.group_flag = true
      newuser.new_flag = false
      newuser.disable_flag = true
    end
      
    if mode == 4
      #有効状態
      newuser.allowed_to_log_in = false
      newuser.group_flag = true
      newuser.new_flag = false
      newuser.disable_flag = false
    end
    ##値の更新 --end-- 
    
    ##コミット
    if newuser.valid?
      User.transaction do
        #変更履歴
        if mode == 2
          history = UserHistoryInfo.new
          history = copy2history(newuser.attributes, history, "user_hs_id")
          mt = GroupMaintainersOneInfo.find_by(user_id: params[:modify_groupid])
          history["maintainer_names"] = mt.maintainer_names
          mem = GroupMembersOneInfo.find_by(user_id: params[:modify_groupid])
          history["member_names"] = mem.member_names
          history.save
        end

        re = newuser.save

        #作成履歴
        if mode == 1
          history = UserHistoryInfo.new
          history = copy2history(newuser.attributes, history, "user_hs_id")
          history.maintainer_names = Ids2String(mt_ids)
          history.member_names = Ids2String(member_ids)
          history.save
        end

        if re == true
          nowcommit = User.find_by(username: params[:user][:username])

          if mode == 1 or mode == 2
            #Maintainer IDs -> 一旦削除して登録
            deleteAndInsert(nowcommit, GroupMaintainerInfo, "group_id", User, "username", mt_ids)
            #Member IDs -> 一旦削除して登録
            deleteAndInsert(nowcommit, GroupInfo, "group_id", User, "username", member_ids)
          end
        end

        if re == false
          @result = 'Failed!!: Unexpected error'
          @result_flag = false;
        else
          @result = 'Success'
          @result_flag = true;
        end 
      end
    else
      @result = "[Error]\n"
      i = 0
      newuser.errors.messages.each {|key, values|
        for value in values do
          k = key.to_s
          k = k.to_s.sub(/password/, "Password")
          k = k.to_s.sub(/fullname/, "Name")
          k = k.to_s.sub(/username/, "Group ID")
          @result = @result + "&nbsp;&nbsp;" + k + " => " + value + "\n"
        end
      }
    
      @result_flag = false
    end
    ##コミット -end-

    #debug
    #@result = params
    #@result = params[:user][:id]
    #@result = @debug_sql

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  グループの検索結果を表示する際に実行されるメソッド

  @detail
  グループの検索のコミット時に実行される
=end
  def group_search_results
    
    #グループはUserモデルに登録するので，Userモデルのインスタンスを宣言する
    users = User.joins("left join group_maintainers_one_infos on users.id = group_maintainers_one_infos.user_id").select("users.*, group_maintainers_one_infos.maintainer_names").joins("left join group_members_one_infos on users.id = group_members_one_infos.user_id").select("users.*, group_members_one_infos.member_names, group_maintainers_one_infos.maintainer_names").where(group_flag: true)

    @maintainer_ids = ""
    @member_ids = "test"

    ##条件指定
    first = true
    #Nameによる検索
    users, first = searchFromKeyword(first, users, "group_search_name", "fullname")
    #Group IDによる検索
    users, first = searchFromKeyword(first, users, "group_search_groupid", "username")
    #Maintainer IDsによる検索
    users, first = searchFromIds(first, users, "group_search_maintainerid", GroupMaintainerInfo, "GroupMaintainerInfo", "group_id")
    #Member IDsによる検索
    users, first = searchFromIds(first, users, "group_search_memberid", GroupInfo, "GroupInfo", "group_id")
    #Disable
    if params[:group_search_disabled] != "1"
      users = users.where(disable_flag: false)
    end
    ##条件指定 -end-

    #Maintainer IDsを調べて権限の有無を調べる
    @readonlys = recordReadonly(users, "username")
    #logger.debug("debug:readonly")
    #logger.debug(@readonlys)

    if params[:group_search_all] == "1"
      users = User.joins("left join group_maintainers_one_infos on users.id = group_maintainers_one_infos.user_id").select("users.*, group_maintainers_one_infos.maintainer_names").joins("left join group_members_one_infos on users.id = group_members_one_infos.user_id").select("users.*, group_members_one_infos.member_names, group_maintainers_one_infos.maintainer_names").where(group_flag: true)
      first = false
    end

    if first == false
      if users.length != 0
        @debug_sql = users.to_sql()
      else
        users = Array([])
        @debug_sql = ""
      end
    else
      users = Array([])
      @debug_sql = ""
    end

    @users = Kaminari.paginate_array(users).page(params[:page]).per(@@per_page)

    #logger.debug(@params)

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  グループ情報の変更履歴を取得する
=end
  def group_history
    users = UserHistoryInfo.joins("left join group_maintainers_one_infos on user_history_infos.user_hs_id = group_maintainers_one_infos.user_id").select("user_history_infos.*, group_maintainers_one_infos.maintainer_names").joins("left join group_members_one_infos on user_history_infos.user_hs_id = group_members_one_infos.user_id").select("user_history_infos.*, group_members_one_infos.member_names, group_maintainers_one_infos.maintainer_names").where(user_hs_id: params[:history_groupid]).order(:id)
    logger.debug("#####")
  
    @users = Kaminari.paginate_array(users).page(params[:page]).per(@@per_page) 

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  PURLの設定のコミット
=end
  def purl_commit

    purl_type, rdtype = setRedirectMode(params)

    ##エラー判定
    path, chkflag, errMsg = checkPath(params[:purl_info][:path])

    #管理者の場合は無制限に作成できる
    if current_user.try(:admin_flag?) == true
      chkflag == true
    end
    if chkflag == false 
      @result = errMsg
      @result_flag = false;
    
      render :layout => nil
      return false
    end
    
    ##エラー判定 -end-

    ##モードの設定
    mode = 0
    if params["purls-create_purls_submit"] == "Submit" or params[:adv_purls_submit] == "Submit"
      purl = PurlInfo.new
      mode = 1
    end
    
    if params["purls-create_purls_submit"] == "Modify" or params[:adv_purls_submit] == "Modify"
      purl = PurlInfo.find(params[:modify_adv_purl_id])
      mode = 2
    end

    if params["purls-create_purls_submit"] == "Disable" or params[:adv_purls_submit] == "Disable"
      purl = PurlInfo.find(params[:chgstate_adv_purl_id])
      mode = 3
    end

    if params["purls-create_purls_submit"] == "Enable" or params[:adv_purls_submit] == "Enable"
      purl = PurlInfo.find(params[:chgstate_adv_purl_id])
      mode = 4
    end
    ##モードの設定 -end-

    ##値の更新
    mt_check = true
    if mode == 1 or mode == 2
      purl.path = standardizePath(params[:purl_info][:path]) #path
      purl.redirect_type_id = rdtype #redirect_type_id
     
      purl.target = ""
      purl.see_also_url = ""
      purl.clone_flag = false
      purl.chain_flag = false
 
      if purl_type == "simple" or purl_type == "302" or purl_type == "301" or purl_type == "307" or \
          purl_type == "partial" or purl_type == "partial-append-extension" or \
          purl_type == "partial-ignore-extension" or purl_type == "partial-replace-extension" then
      
          purl.target = params[:purl_info][:target] #target
      end

      if purl_type != "clone" then
        #Maintainer IDs
        if purl_type == "simple" then
          mt_ids = Ids2Array(params[:newpurl_maintainer_ids][0])
        else
          mt_ids = Ids2Array(params[:adv_maintainer_ids][0])
        end
      end

      if purl_type == "303" then
        purl.see_also_url = params[:purl_info][:see_also_url]
      end
      
      if purl_type == "clone" then
        clone = standardizePath(params[:adv_clone][0])
        purl.clone_flag = true
        clone_id = getPrimIdFromPath(clone)

        if clone_id == -1
          @result = "Can not find 'existing purl path'"
          @result_flag = false;
    
          render :layout => nil

          return false
        end
      end

      if purl_type == "chain" then
        clone = standardizePath(params[:adv_clone][0])
        purl.chain_flag = true
        clone_id = getPrimIdFromPath(clone)
        if clone_id == -1
          @result = "Can not find 'existing purl path'"
          @result_flag = false
    
          render :layout => nil

          return false
        end
      end

      purl.disable_flag = false
    end

    if mode == 3
      #無効状態
      purl.disable_flag = true
    end
      
    if mode == 4
      #有効状態
      purl.disable_flag = false
    end
    ##値の更新 --end-- 
    
    ##コミット
    if purl.valid?
      PurlInfo.transaction do
        #変更履歴
        if mode == 2
          cur_purl = PurlInfo.joins("left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id").joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").joins("left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos on clone_infos.purl_info_ori_id = purl_clone_infos.id").select("purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path, purl_clone_infos.id clone_path_id").find(purl.id)

          history = PurlHistoryInfo.new
          history = copy2history(cur_purl.attributes, history, "purl_hs_id")
          history.save
        end

        re = purl.save

        if re == true
          if mode == 2
            #clone_infosのレコードを一旦削除
            CloneInfo.where(purl_info_id: params[:modify_adv_purl_id]).delete_all
          end

          nowcommit = PurlInfo.find_by(path:  params[:purl_info][:path]) 
        

          #cline_infosのレコードを登録
          if purl_type == "clone" or purl_type == "chain" then
            cloneinfo = CloneInfo.new
            cloneinfo.purl_info_id = nowcommit.id
            cloneinfo.purl_info_ori_id = clone_id

            re = cloneinfo.save          
          end

          if mode == 1 or mode == 2
            #Maintainer IDs -> 一旦削除して登録
            if purl_type != "clone" then
              deleteAndInsert(nowcommit, PurlMaintainerInfo, "purl_info_id", User, "username", mt_ids)
            end
          end
          
          #作成履歴
          if mode == 1
            cur_purl = PurlInfo.joins("left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id").joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").joins("left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos on clone_infos.purl_info_ori_id = purl_clone_infos.id").select("purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path, purl_clone_infos.id clone_path_id").find(nowcommit.id)

            history = PurlHistoryInfo.new
            history = copy2history(cur_purl.attributes, history, "purl_hs_id")
            history.save
          end
        end

        if re == false
          @result = 'Failed!!: Unexpected error'
          @result_flag = false;
        else
          @result = 'Success'
          @result_flag = true;
        end 
      end
    else
      @result = "[Error]\n"
      i = 0
      purl.errors.messages.each {|key, values|
        for value in values do
          k = key.to_s
          @result = @result + "&nbsp;&nbsp;" + k + " => " + value + "\n"
        end
      }
    
      @result_flag = false
    end
    ##コミット -end-

    #debug
    #@result = params
    #@result = params[:user][:id]
    #@result = @debug_sql
    #@result = rdtype

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  PURLの検索結果を表示する際に実行されるメソッド

  @detail
  PURLの検索のコミット時に実行される
=end
  def purl_search_results
    
    purls = PurlInfo.joins("left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id").joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").joins("left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos on clone_infos.purl_info_ori_id = purl_clone_infos.id").select("purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path, purl_clone_infos.id clone_path_id")

    @maintainer_ids = ""
   
    @clone_path = ""
    @chain_path = ""
    
    @redirect_type_sym = ""

    ##条件指定
    first = true
    #Pathによる検索
    purls, first = searchFromKeyword(first, purls, "purls_search_path", "purl_infos.path")
    #Targetによる検索
    purls, first = searchFromKeyword(first, purls, "purls_search_target", "purl_infos.target")
    #see_alsoによる検索
    purls, first = searchFromKeyword(first, purls, "purls_search_see_also", "purl_infos.see_also_url")
    #Maintainer IDsによる検索
    #purls, first = searchFromIds(first, purls, "purls_search_maintainers_ids", PurlMaintainerInfo, "PurlMaintainerInfo", "purl_info_id")
    purls, first = searchFromIds(first, purls, "purls_search_maintainers_ids", PurlMaintainerScInfo, "PurlMaintainerScInfo", "purl_info_id")
    #Explicit Maintainer IDsによる検索
    #purls, first = searchFromIds(first, purls, "purls_search_exp_maintainers_ids", PurlMaintainerInfo, "PurlMaintainerInfo", "purl_info_id", true)
    purls, first = searchFromIds(first, purls, "purls_search_exp_maintainers_ids", PurlMaintainerScInfo, "PurlMaintainerScInfo", "purl_info_id", true)
    #Disable
    if params[:purls_search_disabled] != "1"
      purls = purls.where(disable_flag: false)
    end
    ##条件指定 -end-

=begin
    #For clone
    for purl in purls do
      if purl.symbol == "clone" then
        purl_ori = PurlMaintainersOneInfos.find_by(purl_info_id: purl.clone_path_id)
        purl.maintainer_names = purl_ori.maintainer_names 
      end
    end
=end

    #Maintainer IDsを調べて権限の有無を調べる
    @readonlys = recordReadonly(purls, "id")

    if params[:purl_search_all] == "1"
      purls = PurlInfo.joins("left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id").joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").joins("left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos on clone_infos.purl_info_ori_id = purl_clone_infos.id").select("purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path")
      first = false
    end
  
    @debug = params
    if first == false
      if purls.length != 0
        @debug_sql = purls.to_sql()
      else
        purls = Array([])
        @debug_sql = ""
      end
    else
      purls = Array([])
      @debug_sql = ""
    end
        
    @purls = Kaminari.paginate_array(purls).page(params[:page]).per(@@per_page)

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  PURL情報の変更履歴を取得する
=end
  def purl_history
    purls = PurlHistoryInfo.where(purl_hs_id: params[:history_purlid]).order(:id)
    @purls = Kaminari.paginate_array(purls).page(params[:page]).per(@@per_page)
 
    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  Purlの検証をする
=end
  def purl_validate
    purls = PurlInfo.joins("left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id").joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").joins("left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos on clone_infos.purl_info_ori_id = purl_clone_infos.id").select("purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path, purl_clone_infos.id clone_path_id").where(id: params[:validate_purlid])

    @message_flag = true

    target = purls[0].target
    if purls[0].see_also_url != nil && purls[0].see_also_url.length != 0
      target = purls[0].see_also_url
    end
    if purls[0].clone_flag == true or purls[0].chain_flag == true
      target = getChainTarget(purls[0].id)
    end

    result_flag = url_exist?(target)
    @purls = Kaminari.paginate_array(purls).page(params[:page]).per(@@per_page)
    
    @readonlys = {"params[:validate_purlid]]" => true}
 
    if result_flag == true 
      @result = "<p class=\"alert alert-success\">"
      @result = @result + "<strong>Validate result</strong>: Success"
      @result = @result + "</p>" 
    else
      @result = "<p class=\"alert alert-danger\">"
      @result = @result + "<strong>Validate result</strong>: Failed\n"
      @result = @result + "Please review the connection url: " + target
      @result = @result + "</p>" 
    end
    render :purl_search_results, :layout => nil
  end

=begin
  @brief
  Adminタブのユーザーリクエストを選択した際と承認，却下した際に実行されるメソッド
=end
  def user_request

    @result = ""

    #リクエストに対して承認，却下した時の処理
    if params.has_key?(:result)
      if params[:result] == "approve" then #許可
        user = User.find(params[:user_id])
        re = user.update_attributes(allowed_to_log_in: true, new_flag: false, disable_flag: false) 

        if re != false
          @result = 'Success (Approve)'
          @result_flag = true
        else
          @result = 'Failed!! (Approve)'
          @result_flag = false
        end
      else #却下
        user = User.find(params[:user_id]).destroy
        
        if re != false
          @result = 'Success (Deny)'
          @result_flag = true
        else
          @result = 'Failed!! (Deny)'
          @result_flag = false
        end
      end
    end

    users = User.where(new_flag: true)
    #@users = Kaminari.paginate_array(users).page(params[:page]).per(@@per_page)
    @users = users

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end

=begin
  @brief
  Adminタブのドメインリクエストを選択した際と承認，却下した際に実行されるメソッド
=end
  def domain_request

    @result = ""

    #リクエストに対して承認，却下した時の処理
    if params.has_key?(:result)
      if params[:result] == "approve" then
        domain = DomainInfo.find(params[:did])
        re = domain.update_attributes(new_flag: false, disable_flag: false) 
        if (re)
          @result = 'Success (Approve)'
        else
          @result = 'Failed!! (Approve)'
        end
      end
      
      if params[:result] == "deny" then
        re = DomainInfo.find(params[:did]).destroy
        if (re)
          @result = 'Success (Deny)'
        else
          @result = 'Failed!! (Deny)'
        end
      end
    end

    domains = DomainInfo.joins("left join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id").select("domain_infos.*, domain_maintainers_one_infos.maintainer_names").joins("left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id").select("domain_infos.*, domain_writers_one_infos.writer_names").where(new_flag: true)
   
    #@domains =  Kaminari.paginate_array(domains).page(params[:page]).per(@@per_page)
    @domains = domains

    render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end
end
