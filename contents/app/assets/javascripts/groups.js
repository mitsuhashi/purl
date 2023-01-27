/**
  @brief
  groupsタブの選択ボックスによる表示の切り替え
*/
function groups_display_select()
{
  var selected = document.getElementById('groups_select');
  var operates = document.getElementsByName('groups_operate');

  if (selected.value == "") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    
  }

  if (selected.value == "create") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('groups-create');
    element.style.display = "";
  }
  
  if (selected.value == "search") {
    for (var i = 0; i < operates.length; i++) {
      operates[i].style.display = "none";
    }    

    var element = document.getElementById('groups-search');
    element.style.display = "";
  }

  result_frame_clear();
}

/**
  @brief
  グループの検索結果で編集ボタンをクリックした時に実行する

  @param iter Iterator

  @detail
  編集画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_group_edit(iter)
{
  var elements1 = new Array('edit_groupid_' + iter, 'edit_fullname_' + iter, 'edit_username_' + iter, 'edit_maintainers_' + iter, 'edit_writers_' + iter, 'edit_group_comment_' + iter);
  var elements2 = new Array('modify_newgroup_groupid', 'modify_newgroup_fullname', 'modify_newgroup_username', 'modify_newgroup_maintainer_ids', 'modify_newgroup_writer_ids', 'modify_newgroup_comment');

  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
  }

  var form1 = parentWin.document.getElementById('group_search_form1');
  var form2 = parentWin.document.getElementById('group_search_form2');
  var form3 = parentWin.document.getElementById('group_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = '';
  form3.style.display = 'none';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('group_subtitle');
  textobj.innerText = "Modify a group";
  var textobj = parentWin.document.getElementById('group_subtext');
  textobj.innerText = "Fill in the following information to modify a user. ";
  var btn = parentWin.document.getElementById('modify_newgroup_submit');
  btn.value = "Modify";
  btn.className = "btn btn-success btn-block"
  var p = parentWin.document.getElementById('groups-search');
  p.className = "panel panel-success";

  //カーソル位置を上にずらす
  parentWin.scrollTo(0, target.offsetTop);
}

/**
  @brief
  グループの検索結果で無効ボタンをクリックした時に実行する

  @param disable_flag 無効グループの場合はtrue
  @param iter Iterator

  @detail
  無効化画面は新規登録画面を流用するため，新規登録画面のテキスト等のフォームを上書きする(置き換える)
*/
function send_group_disable(disable_flag, iter)
{
  var elements1 = new Array('chg_groupid_' + iter, 'chg_fullname_' + iter, 'chg_username_' + iter, 'chg_maintainers_' + iter, 'chg_writers_' + iter, 'chg_group_comment_' + iter);
  var elements2 = new Array('chgstate_newgroup_groupid', 'chgstate_newgroup_fullname', 'chgstate_newgroup_username', 'chgstate_newgroup_maintainer_ids', 'chgstate_newgroup_writer_ids', 'chgstate_newgroup_comment');

  var parentWin = window.parent;
  for (var i = 0; i < elements1.length; i++) {
    var source = document.getElementById(elements1[i]);
    var target = parentWin.document.getElementById(elements2[i]);
    target.value = source.value;
    target.readOnly = true;
  }

  var target = parentWin.document.getElementById('chgstate_password_area');
  target.style.display = 'none';

  var form1 = parentWin.document.getElementById('group_search_form1');
  var form2 = parentWin.document.getElementById('group_search_form2');
  var form3 = parentWin.document.getElementById('group_search_form3');
  
  //2つ目の非表示項目（編集画面=新規登録画面）を表示し，それ以外を非表示にする
  form1.style.display = 'none';
  form2.style.display = 'none';
  form3.style.display = '';

  //リソースの置き換え
  var textobj = parentWin.document.getElementById('group_subtitle');
  textobj.innerText = "Chenge status for a group";
  var textobj = parentWin.document.getElementById('group_subtext');
  textobj.innerText = "";
  var btn = parentWin.document.getElementById('chgstate_newgroup_submit');
  var p = parentWin.document.getElementById('groups-search');

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

