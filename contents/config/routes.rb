Rails.application.routes.draw do
  #Devise
  devise_for :users
  #トップページ
  root 'pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #!新規ユーザー作成処理
  post "/page/index" => 'pages#user_commit'
  #get '/page/index' => 'pages#user_commit' #-> reload
  #!ユーザー検索処理
  post "/page/user_search_results" => 'pages#user_search_results'
  #get '/page/user_search_results' => 'pages#result'
  get "/page/user_search_results" => 'pages#user_search_results'
  #!ユーザー変更履歴
  get '/page/user_history' => 'pages#user_history'
  post '/page/user_history' => 'pages#user_history'

  #!新規ドメイン作成処理
  post '/page/domain_commit' => 'pages#domain_commit'
  #get '/page/domain_commit' => 'pages#result' #-> reload
  #!ドメイン検索処理
  post '/page/domain_search_results' => 'pages#domain_search_results'
  get '/page/domain_search_results' => 'pages#domain_search_results' 
  #!ドメイン変更履歴
  get '/page/domain_history' => 'pages#domain_history'
  post '/page/domain_history' => 'pages#domain_history'

  #!新規グループの作成処理
  post '/page/group_commit' => 'pages#group_commit'
  #get '/page/group_commit' => 'pages#result' #-> reload
  #!グループ検索処理
  post '/page/group_search_results' => 'pages#group_search_results'
  get '/page/group_search_results' => 'pages#group_search_results'
  #!グループ変更履歴
  get '/page/group_history' => 'pages#group_history'
  post '/page/group_history' => 'pages#group_history'

  #!新規PURLの作成処理
  post '/page/purl_commit' => 'pages#purl_commit'
  #get '/page/purl_commit' => 'pages#result' #-> reload
  #!PURL検索処理
  post '/page/purl_search_results' => 'pages#purl_search_results'
  get '/page/purl_search_results' => 'pages#purl_search_results'
  #!PURL変更履歴
  get '/page/purl_history' => 'pages#purl_history'
  post '/page/purl_history' => 'pages#purl_history'
  #!PURL validate
  get '/page/purl_validate' => 'pages#purl_validate'
  post '/page/purl_validate' => 'pages#purl_validate'

  #!ユーザーリクエスト処理
  get '/page/user_request' => 'pages#user_request'
  post '/page/user_request' => 'pages#user_request'
  #!ドメインリクエスト処理
  get '/page/domain_request' => 'pages#domain_request'
  post '/page/domain_request' => 'pages#domain_request'

  #!PURLsルーティング機能
  #match "/:topdomain" => 'redirect#index', via: [:get, :post]
  match "/:topdomain/:group_num" => 'redirect#index', via: [:get, :post]
  match '/:topdomain/:group_num/*path', to: 'redirect#index', via: [:get, :post]
  #PURLsルーティング機能 -end-

  #上記以外全て
  #get '*path', to: 'bio#index'
end
