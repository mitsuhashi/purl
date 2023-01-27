/**
  @brief
  domainsタブの選択ボックスによる表示の切り替え
*/
function domains_display_select()
{
  var selected = document.getElementById('domains_select');
  var operates = document.getElementsByName('domains_operate');

  if (selected.value == "") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    
  }

  if (selected.value == "create") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('domains-create');
    element.style.display = "";
  }
  
  if (selected.value == "search") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('domains-search');
    element.style.display = "";
  }

  result_frame_clear();
}

/**
  @brief
  ドメインの検索結果で編集ボタンをクリックした時に実行する
  
  @param iter iterator

  @detail
  編集画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_domain_edit(iter)
{
  var elements1 = new Array('edit_did_' + iter, 'edit_domainname_' + iter, 'edit_domainid_' + iter, 'edit_maintainers_' + iter, 'edit_writers_' + iter);
  var elements2 = new Array('modify_did', 'modify_newdomain_name', 'modify_newdomain_domainid', 'modify_newdomain_maintainer_ids', 'modify_newdomain_writer_ids');
  
  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
  }

  var check = document.getElementById("edit_public_flag_" + iter);
  var target = parentWin.document.getElementById("modify_newdomain_public_flag");
  if (check.value == "true") {
    target.checked = true;
  } else {
    target.checked = false;
  }

  var form1 = parentWin.document.getElementById('domain_search_form1');
  var form2 = parentWin.document.getElementById('domain_search_form2');
  var form3 = parentWin.document.getElementById('domain_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = '';
  form3.style.display = 'none';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('domain_subtitle');
  textobj.innerText = "Modify a domain";
  var textobj = parentWin.document.getElementById('domain_subtext');
  textobj.innerText = "Fill in the following information to modify a domain. ";
  var btn = parentWin.document.getElementById('modify_newdomain_submit');
  btn.value = "Modify";
  btn.className = "btn btn-success btn-block"
  var p = parentWin.document.getElementById('domains-search');
  p.className = "panel panel-success";

  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

/**
  @brief
  ドメインの検索結果で無効ボタンをクリックした時に実行する

  @param disable_flag 無効ドメインの場合はtrue
  @param iter iterator

  @detail
  無効化画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_domain_disable(disable_flag, iter)
{
  var elements1 = new Array('chg_did_' + iter, 'chg_domainname_' + iter, 'chg_domainid_' + iter, 'chg_maintainers_' + iter, 'chg_writers_' + iter);
  var elements2 = new Array('chgstate_did', 'chgstate_newdomain_name', 'chgstate_newdomain_domainid', 'chgstate_newdomain_maintainer_ids', 'chgstate_newdomain_writer_ids');
  
  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
    target.readOnly = true;
  }
  
  var check = document.getElementById("chg_public_flag_" + iter);
  var target = parentWin.document.getElementById("chgstate_newdomain_public_flag");
  if (check.value == "true") {
    target.checked = true;
  } else {
    target.checked = false;
  }
  target.disabled = true;

  var target = parentWin.document.getElementById('chgstate_password_area');
  target.style.display = 'none';

  var form1 = parentWin.document.getElementById('domain_search_form1');
  var form2 = parentWin.document.getElementById('domain_search_form2');
  var form3 = parentWin.document.getElementById('domain_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = 'none';
  form3.style.display = '';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('domain_subtitle');
  textobj.innerText = "Chenge status for a domain";
  var textobj = parentWin.document.getElementById('domain_subtext');
  textobj.innerText = "";
  var btn = parentWin.document.getElementById('chgstate_newdomain_submit');
  var p = parentWin.document.getElementById('domains-search');

  if (disable_flag == 0) {
    btn.value = "Disable";
    btn.className = "btn btn-danger btn-block"
    p.className = "panel panel-danger";
  } else {
    btn.value = "Enable";
    btn.className = "btn btn-warning btn-block"
    p.className = "panel panel-warning"
  }

  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

