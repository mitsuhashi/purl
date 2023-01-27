class RedirectController < ApplicationController
  protect_from_forgery with: :null_session

  include Common

=begin
  @brief
  リダイレクト処理の実行
=end
  def index
    @postdata = params
    @getdata = request.query_parameters
    @request_url = request.url
    url = URI.parse(request.url)
    @request_query = url.query

    request_path = "/" + params[:topdomain] + "/" + params[:group_num] 

    if params.has_key?(:path)
      request_path = request_path + "/" + params[:path] 
    end
 
    noformat_request_path = request_path

    if params.has_key?(:format)
      request_path = request_path + "." + params[:format] 
    end

    getstr = ''
    count = 0
    @getdata.each{|key, value|
      if count == 0
        getstr = getstr + '?' + key + "=" + value
      else        
        getstr = getstr + '&' + key + "=" + value
      end

      count = count + 1
    }

    count = PurlInfo.where(path: request_path).count

    if count != 0
      purl = PurlInfo.joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").select("purl_infos.*, redirect_types.symbol").find_by(path: request_path)

      target = purl.target
      
      if (purl.symbol == "303")
        target = purl.see_also_url
      end

      count = 0

      target = target + getstr      
        
      if (purl.symbol == "simple")
        redirect_to target, status: 302
      end
      if (purl.symbol == "301")
        redirect_to target, status: 301
      end
      if (purl.symbol == "302")
        redirect_to target, status: 302
      end
      if (purl.symbol == "303")
        redirect_to target, status: 303
      end
      if (purl.symbol == "304")
        redirect_to target, status: 304
      end
      if (purl.symbol == "307")
        redirect_to target, status: 307
      end
      if (purl.symbol == "404")
        redirect_to target, status: 404
      end
      if (purl.symbol == "410")
        redirect_to target, status: 410
      end 

      if (purl.symbol == "clone")
        purl_clone = CloneInfo.joins("left join purl_infos on clone_infos.purl_info_ori_id = purl_infos.id").select("purl_infos.target").find_by("clone_infos.purl_info_id = ?", purl.id)
        redirect_to purl_clone.target, status: 302
      end
      
      if (purl.symbol == "chain")
        target = getChainTarget(purl.id) 
        redirect_to target, status: 302
      end
    else
      #上記のいずれにもヒットしなかった場合はpartial
      subs = DomainCutout(request_path, true)      
      
      hit = false
      partial_path = ''
      for sub in subs do
        count = PurlInfo.where(path: sub).count
        if count != 0
          hit = true
          partial_path = sub
          break
        end

        count = PurlInfo.where(path: sub + "/").count
        if count != 0
          hit = true
          partial_path = sub + "/"
          break
        end
      end

      if partial_path.length != 0
        purl = PurlInfo.joins("left join redirect_types on purl_infos.redirect_type_id = redirect_types.id").select("purl_infos.*, redirect_types.symbol").find_by(path: partial_path)

        if purl.symbol == "partial"
          target = request_path.gsub(partial_path, purl.target) + getstr
          
          #target = target.gsub('//', '/') 
          redirect_to target, status: 302
        end
        
        if purl.symbol == "partial-append-extension"
          #拡張子部分を取り出す
          sps = request_path.split(partial_path)
          sps2 = sps[1].split('/')
          extension = sps2[0]

          head = request_path.slice(0, request_path.index(sps[1]))
          tail = sps[1].slice(sps[1].index(extension) + extension.length, sps[1].length)
          target = head + tail

          target = target.gsub(partial_path, purl.target) + "." + extension + getstr
          target = target.reverse.sub('//', '/').reverse

          redirect_to target, status: 302
        end

        if purl.symbol == "partial-ignore-extension"
          target = request_path.gsub(partial_path, purl.target)
          extension = File.extname(target)
          target = target.slice(0, target.rindex(extension)) + getstr

          #target = target.gsub('//', '/') 
          redirect_to target, status: 302
        end

        if purl.symbol == "partial-replace-extension"
          #拡張子の置き換え後の文字列を取り出す
          sps = request_path.split(partial_path)
          sps2 = sps[1].split('/')
          replace_str = sps2[0]

          head = request_path.slice(0, request_path.index(sps[1]))
          tail = sps[1].slice(sps[1].index(replace_str) + replace_str.length, sps[1].length)
          target = head + tail
          
          target = target.gsub(partial_path, purl.target)
          extension = File.extname(target)
          target = target.slice(0, target.rindex(extension)) + '.' + replace_str
          target = target.reverse.sub('//', '/').reverse
          
          @debug = target
          
          redirect_to target, status: 302
        end
      end
    end

    @request_path = request_path

    #render :layout => nil
    #これより後ろにインスタンスを定義してはいけない
  end
end
