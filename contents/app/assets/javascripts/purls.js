/**
  @brief
  purlsタブの選択ボックスによる表示の切り替え
*/
function purls_display_select()
{
  var selected = document.getElementById('purls_select');
  var operates = document.getElementsByName('purls_operate');

  if (selected.value == "") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    
  }

  if (selected.value == "create") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('purls-create');
    element.style.display = "";
    
    var element = document.getElementById('new_purls-adv-create');
    element.style.display = "none";
  }
  
  if (selected.value == "advancedcreate") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('purls-create');
    element.style.display = "none";

    var element = document.getElementById('new_purls-adv-create');
    element.style.display = "";
  }
 
  /* 
  if (selected.value == "modify") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('purls-mod');
    element.style.display = "";
  }
  */

  if (selected.value == "search") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('purls-search');
    element.style.display = "";
    
    var element = document.getElementById('new_purls-adv-create');
    element.style.display = "none";
  }
  
  if (selected.value == "validate") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('purls-vld');
    element.style.display = "";
  }

  result_frame_clear();
}

/**
  @brief
  アドバンス登録用の入力フォームの切り替え

  @param sign_in ログインしている場合は1，していない場合は0
  @param mode new, midify ...
*/
function adv_display_select(sign_in, mode)
{
  var selected = document.getElementById(mode + '_adv-select');
  var operates = document.getElementsByClassName(mode + '_adv-form');

  if (sign_in == true) {
    var element = document.getElementById(mode + '_adv_purls_submit_hidden');
    element.style.display = "";
  }

  if (selected.value == "") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    } 
  }
  
  if (selected.value == mode + "_302" || selected.value == mode + "_301" || selected.value == mode + "_307" || selected.value == mode + "_partial" || selected.value == mode + "_partial-append-extension" || selected.value == mode + "_partial-ignore-extension" || selected.value == mode + "_partial-replace-extension") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById(mode + '_adv_target_hidden');
    element.style.display = "";
    
    var element = document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";
  }

  if (selected.value == mode + "_303") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    
    
    var element = document.getElementById(mode + '_adv_see_also_hidden');
    element.style.display = "";
    
    var element = document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";
  }
  
  if (selected.value == mode + "_404" || selected.value == mode + "_410") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";
  }
 
  if (selected.value == mode + "_clone") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";

      if (sign_in == true) {
        var element = document.getElementById(mode + '_adv_clone_hidden');
        element.style.display = "";
      }
    } 
  }

  if (selected.value == mode + "_chain") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";

      if (sign_in == true) {
        var element = document.getElementById(mode + '_adv_clone_hidden');
        element.style.display = "";
        var element = document.getElementById(mode + '_adv_maintainer_ids_hidden');
        element.style.display = "";
      }
    } 
  }

  //result_frame_clear();
}

/**
  @brief
  PURLの検索結果で編集ボタンをクリックした時に実行する

  @param iter iterator

  @detail
  編集画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_purl_edit(iter)
{
  var elements1 = new Array('edit_purl_id_' + iter, 'edit_path_' + iter, 'edit_target_' + iter, 'edit_see_also_url_' + iter, 'edit_maintainers_' + iter, 'edit_clone_' + iter) ;
  var elements2 = new Array('modify_adv_purl_id', 'modify_adv_path', 'modify_adv_target', 'modify_adv_see_also', 'modify_adv_maintainer_ids', 'modify_adv_clone');
  
  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
  }
 
  var element = parentWin.document.getElementById('purl_search_form2');
  element.style.display = "";

  //!cloneとchainは同じ
  if (document.getElementById('edit_clone_' + iter).length != 0) {
    var target = parentWin.document.getElementById('modify_adv_clone');
    target.value = document.getElementById('edit_clone_' + iter).value;
  }

  var form1 = parentWin.document.getElementById('purl_search_form1');
  var form2 = parentWin.document.getElementById('purl_search_form2');
  var form3 = parentWin.document.getElementById('purl_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = '';
  form3.style.display = 'none';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('purl_subtitle');
  textobj.innerText = "Modify a purl";
  var textobj = parentWin.document.getElementById('purl_subtext');
  textobj.innerText = "Fill in the following information to modify a purl. ";
  var btn = parentWin.document.getElementById('modify_adv_purls_submit');
  btn.value = "Modify";
  btn.className = "btn btn-success btn-block"
  var p = parentWin.document.getElementById('purls-search');
  p.className = "panel panel-success";

  //アドバンスPURLの選択ボックスの切り替え
  var sele = parentWin.document.getElementById("modify_adv-select");
  var rdsym = document.getElementById('edit_redirect_type_sym_' + iter)
  adv_select(parentWin, "modify", sele, rdsym);

  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

/**
  @brief
  PURLの検索結果で無効ボタンをクリックした時に実行する

  @param disable_flag 無効PURLの場合はtrue
  @param iter iterator

  @detail
  無効化画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)

*/
function send_purl_disable(disable_flag, iter)
{
  var elements1 = new Array('chg_purl_id_' + iter, 'chg_path_' + iter, 'chg_target_' + iter, 'chg_see_also_url_' + iter, 'chg_maintainers_' + iter, 'chg_clone_' + iter) ;
  var elements2 = new Array('chgstate_adv_purl_id', 'chgstate_adv_path', 'chgstate_adv_target', 'chgstate_adv_see_also', 'chgstate_adv_maintainer_ids', 'chgstate_adv_clone');

  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
    target.readOnly = true;
  }

  //!cloneとchainは同じ
  if (document.getElementById('chg_clone_' + iter).length != 0) {
    var target = parentWin.document.getElementById('chgstate_adv_clone');
    target.value = document.getElementById('chg_clone_' + iter).value;
    target.readOnly = true;
  }

  var target = parentWin.document.getElementById('chgstate_password_area');
  target.style.display = 'none';

  var form1 = parentWin.document.getElementById('purl_search_form1');
  var form2 = parentWin.document.getElementById('purl_search_form2');
  var form3 = parentWin.document.getElementById('purl_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = 'none';
  form3.style.display = '';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('purl_subtitle');
  textobj.innerText = "Chenge status for a purl";
  var textobj = parentWin.document.getElementById('purl_subtext');
  textobj.innerText = "";
  var btn = parentWin.document.getElementById('chgstate_adv_purls_submit');
  var p = parentWin.document.getElementById('purls-search');

  if (disable_flag == 0) {
    btn.value = "Disable";
    btn.className = "btn btn-danger btn-block"
    var p = parentWin.document.getElementById('purls-search');
    p.className = "panel panel-danger";
  } else {
    btn.value = "Enable";
    btn.className = "btn btn-warning btn-block"
    p.className = "panel panel-warning";
  }
  
  //アドバンスPURLの選択ボックスの切り替え
  var sele = parentWin.document.getElementById("chgstate_adv-select");
  sele.disabled = true; 
  var rdsym = document.getElementById('chg_redirect_type_sym_' + iter)
  adv_select(parentWin, "chgstate", sele, rdsym);

  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

/**
  @brief
  アドバンスPURLの選択ボックスの選択

  @param parentWin 親のウィンドウ
  @param mode モード
  @param target 選考先の選択ボックスの要素
  @param rdsym 入力フォームのinput type="hidden"で指定されたPURLタイプの要素
*/
function adv_select(parentWin, mode, target, rdsym)
{
  var operates = parentWin.document.getElementsByName('purls_operate');

  if (rdsym.value == "simple" || rdsym.value == "302" || rdsym.value == "301" || rdsym.value == "307" || rdsym.value == "partial" || rdsym.value == "partial-append-extension" || rdsym.value == "partial-ignore-extension" || rdsym.value == "partial-replace-extension") {
    
    var element = parentWin.document.getElementById(mode + '_adv_target_hidden');
    element.style.display = "";
    
    var element = parentWin.document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";
    
    var element = parentWin.document.getElementById(mode + '_adv_see_also_hidden');
    element.style.display = "none";

    if (rdsym.value == "simple") {
      target.selectedIndex = 1;
    }
    if (rdsym.value == "302") {
      target.selectedIndex = 1;
    }
    if (rdsym.value == "301") {
      target.selectedIndex = 2;
    }
    if (rdsym.value == "307") {
      target.selectedIndex = 4;
    }
    if (rdsym.value == "partial") {
      target.selectedIndex = 9;
    }
    if (rdsym.value == "partial-append-extension") {
      target.selectedIndex = 10;
    }
    if (rdsym.value == "partial-ignore-extension") {
      target.selectedIndex = 11;
    }
    if (rdsym.value == "partial-replace-extension") {
      target.selectedIndex = 12;
    }
  }
  
  if (rdsym.value == "303") {
    var element = parentWin.document.getElementById(mode + '_adv_target_hidden');
    element.style.display = "none";

    var element = parentWin.document.getElementById(mode + '_adv_see_also_hidden');
    element.style.display = "";
    
    var element = parentWin.document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";
    
    target.selectedIndex = 3;
  }
  
  if (rdsym.value == "404" || rdsym.value == "410") {
    var element = parentWin.document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";
    
    var element = parentWin.document.getElementById(mode + '_adv_target_hidden');
    element.style.display = "none";

    var element = parentWin.document.getElementById(mode + '_adv_see_also_hidden');
    element.style.display = "none";
    
    if (rdsym.value == "404") {
      target.selectedIndex = 5;
    }
    if (rdsym.value == "404") {
      target.selectedIndex = 6;
    }
  }
 
  if (rdsym.value == "clone") {
    var element = parentWin.document.getElementById(mode + '_adv_clone_hidden');
    element.style.display = "";
    
    var element = parentWin.document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "none";
    
    var element = parentWin.document.getElementById(mode + '_adv_target_hidden');
    element.style.display = "none";

    var element = parentWin.document.getElementById(mode + '_adv_see_also_hidden');
    element.style.display = "none";
    
    target.selectedIndex = 7;
  }

  if (rdsym.value == "chain") {
    var element = parentWin.document.getElementById(mode + '_adv_clone_hidden');
    element.style.display = "";
    
    var element = parentWin.document.getElementById(mode + '_adv_maintainer_ids_hidden');
    element.style.display = "";

    var element = parentWin.document.getElementById(mode + '_adv_target_hidden');
    element.style.display = "none";

    var element = parentWin.document.getElementById(mode + '_adv_see_also_hidden');
    element.style.display = "none";

    target.selectedIndex = 8;
  }
    
  var element = parentWin.document.getElementById(mode + '_adv_purls_submit_hidden');
  element.style.display = "";
}

