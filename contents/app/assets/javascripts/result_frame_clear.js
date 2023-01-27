/**
  @brief
  結果表示用フレームのクリア
*/
function result_frame_clear()
{
  var iframe = document.getElementById("result_panel");
  var html = "";

  iframe.contentWindow.document.open();
  iframe.contentWindow.document.write(html);
  iframe.contentWindow.document.close();

  reset_hidden();
}
