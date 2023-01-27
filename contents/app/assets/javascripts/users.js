/**
  @brief
  usersタブの選択ボックスによる表示の切り替え
*/
function users_display_select()
{
  var selected = document.getElementById('users_select');
  var operates = document.getElementsByName('users_operate');

  if (selected.value == "") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    
  }

  if (selected.value == "register") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('users-register');
    element.style.display = "";
  }
  
  if (selected.value == "search") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('users-search');
    element.style.display = "";
  }

  result_frame_clear();
}

/**
  @brief
  ユーザーの検索結果で編集ボタンをクリックした時に実行する

  @param iter iterator
  @param admin ログインユーザーが管理者の場合はtrue

  @detail
  編集画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_user_edit(iter, admin)
{
  var elements1 = new Array('edit_userid_' + iter, 'edit_fullname_' + iter, 'edit_affiliation_' + iter, 'edit_email_' + iter, 'edit_username_' + iter, 'edit_justification_' + iter);
  var elements2 = new Array('modify_userid', 'modify_fullname', 'modify_affiliation', 'modify_email', 'modify_username', 'modify_justification');

  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
  }

  if (admin) {
    var chk = document.getElementById("edit_admin_flag_" + iter);
    var target_chk = parentWin.document.getElementById('modify_admin_flag');
    
    if (chk.value == "true") {
      target_chk.checked = true;
    } else {
      target_chk.checked = false;
    }
  }

  var form1 = parentWin.document.getElementById('user_search_form1');
  var form2 = parentWin.document.getElementById('user_search_form2');
  var form3 = parentWin.document.getElementById('user_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = '';
  form3.style.display = 'none';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('user_subtitle');
  textobj.innerText = "Modify a user";
  var textobj = parentWin.document.getElementById('user_subtext');
  textobj.innerText = "Fill in the following information to modify a user. ";
  var btn = parentWin.document.getElementById('modify_newuser_submit');
  btn.value = "Modify";
  btn.className = "btn btn-success btn-block"
  var p = parentWin.document.getElementById('users-search');
  p.className = "panel panel-success";

  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

/**
  @brief
  ユーザーの検索結果で無効ボタンをクリックした時に実行する

  @param disable_flag 無効ユーザーの場合はtrue
  @param iter iterator
  @param admin ログインユーザーが管理者の場合はtrue

  @detail
  無効化画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_user_disable(disable_flag, iter, admin)
{
  var elements1 = new Array('chg_userid_' + iter, 'chg_fullname_' + iter, 'chg_affiliation_' + iter, 'chg_email_' + iter, 'chg_username_' + iter, 'chg_justification_' + iter);
  var elements2 = new Array('chgstate_userid', 'chgstate_fullname', 'chgstate_affiliation', 'chgstate_email', 'chgstate_username', 'chgstate_justification');

  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
    target.readOnly = true;
  }

  var target = parentWin.document.getElementById('chgstate_password_area');
  target.style.display = 'none';
  
  if (admin) {
    var chk = document.getElementById("edit_admin_flag_" + iter);
    var target_chk = parentWin.document.getElementById('chgstate_admin_flag');
    target_chk.readOnly = true;
    target_chk.disabled = true;
    if (chk.value == "true") {
      target_chk.checked = true;
    } else {
      target_chk.checked = false;
    }
  }

  var form1 = parentWin.document.getElementById('user_search_form1');
  var form2 = parentWin.document.getElementById('user_search_form2');
  var form3 = parentWin.document.getElementById('user_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = 'none';
  form3.style.display = '';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('user_subtitle');
  textobj.innerText = "Chenge status for a user";
  var textobj = parentWin.document.getElementById('user_subtext');
  textobj.innerText = "";
  var btn = parentWin.document.getElementById('chgstate_newuser_submit');
  var p = parentWin.document.getElementById('users-search');

  if (disable_flag == 0) {
    btn.value = "Disable";
    btn.className = "btn btn-danger btn-block"
    p.className = "panel panel-danger";
  } else {
    btn.value = "Enable";
    btn.className = "btn btn-warning btn-block"
    p.className = "panel panel-warning";
  }
  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

/**
  @brief
  ユーザーの承認に対して拒否する場合の最終確認
*/
function user_deny()
{
  var result = window.confirm("Is it really good to remove?");

  return result;  
}
