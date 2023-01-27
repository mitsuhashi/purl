function help_tab_click(id)
{
  //event.preventDefault();
  var ele = document.getElementById('help_page');
  ele.click();
  window.location.hash = id;
}
