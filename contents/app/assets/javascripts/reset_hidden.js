/**
  @brief
  表示・非表示, テキストの表示の切り替えをリセットする
*/
function reset_hidden()
{
  var elements = new Array('user', 'domain', 'group', 'purl');

  //タブ内の右側の表示をリセット
  for (var i = 0; i < elements.length; i++) {
    var form1 = document.getElementById(elements[i] + '_search_form1');
    var form2 = document.getElementById(elements[i] + '_search_form2');
    var form3 = document.getElementById(elements[i] + '_search_form3');

    form1.style.display = '';
    form2.style.display = 'none';
    form3.style.display = 'none';
  }

  //ラベルをリセット
  var textobj = document.getElementById('user_subtitle');
  textobj.innerText = "Search for a user";
  var textobj = document.getElementById('user_subtext');
  textobj.innerText = "Search users based on any of the following characteristics.";
  var p = document.getElementById('users-search');
  p.className = "panel panel-primary";
  
  var textobj = document.getElementById('domain_subtitle');
  textobj.innerText = "Search for a domain";
  var textobj = document.getElementById('domain_subtext');
  textobj.innerText = "Search domains based on any of the following characteristics.";
  var p = document.getElementById('domains-search');
  p.className = "panel panel-primary";

  var textobj = document.getElementById('group_subtitle');
  textobj.innerText = "Search for a group";
  var textobj = document.getElementById('group_subtext');
  textobj.innerText = "Search groups based on any of the following characteristics.";
  var p = document.getElementById('groups-search');
  p.className = "panel panel-primary";
  
  var textobj = document.getElementById('purl_subtitle');
  textobj.innerText = "Search for a PURL";
  var textobj = document.getElementById('purl_subtext');
  textobj.innerText = "Search PURLs based on any of the following characteristics.";
  var p = document.getElementById('purls-search');
  p.className = "panel panel-primary";
}
