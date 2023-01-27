/**
 * Handles 'Bootstrap' package.
 *
 * @namespace bootstrap_
 */

/**
 * @var {String}
 */
var bootstrap_uri_to_tab_key = 'bootstrap_uri_to_tab';

/**
 * @return {String}
 */
function bootstrap_get_uri()
{
    return window.location.href;
}

/**
 * @return {Object}
 */
function bootstrap_load_tab_data()
{
    var uriToTab = localStorage.getItem(bootstrap_uri_to_tab_key);
    if (uriToTab) {
    try {
        uriToTab = JSON.parse(uriToTab);
        if (typeof uriToTab != 'object') {
        uriToTab = {};
        }
    } catch (err) {
        uriToTab = {};
    }
    } else {
    uriToTab = {};
    }
    return uriToTab;
}

/**
 * @param {Object} data
 */
function bootstrap_save_tab_data(data)
{
    localStorage.setItem(bootstrap_uri_to_tab_key, JSON.stringify(data));
}

/**
 * @param {String} href
 */
function bootstrap_save_tab(href)
{
    var uri = bootstrap_get_uri();
    var uriToTab = bootstrap_load_tab_data();
    uriToTab[uri] = href;
    bootstrap_save_tab_data(uriToTab);
}

/**
 *
 */
function bootstrap_restore_tab()
{
    var uri = bootstrap_get_uri();
    var uriToTab = bootstrap_load_tab_data();
    if (uriToTab.hasOwnProperty(uri) &&
    $('[href="' + uriToTab[uri] + '"]').length) {
    } else {
    uriToTab[uri] = $('a[data-toggle="tab"]:first').attr('href');
    }
    if (uriToTab[uri]) {
        $('[href="' + uriToTab[uri] + '"]').tab('show');
    }
}
