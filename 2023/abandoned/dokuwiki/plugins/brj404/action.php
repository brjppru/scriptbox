<?php
/**
 * brj404: redirect to not found page, if u not admin
 *
 * @author Roman Y. Bogdanov <sam@brj.pp.ru>
 */

if (!defined('DOKU_INC')) die();
if (!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN', DOKU_INC . 'lib/plugins/');
require_once (DOKU_PLUGIN . 'action.php');

class action_plugin_brj404 extends DokuWiki_Action_Plugin
{
    function getInfo() {
        return array (
            'author' => 'Roman Y. Bogdanov',
            'email' => 'sam@brj.pp.ru',
            'date' => '13-03-2015',
            'name' => 'brj404 Plugin',
            'desc' => "Redirect to notfound namespace",
            'url' => 'https://www.dokuwiki.org/plugin:brj404',
        );
    }

    function page_exists($id) {
        if (function_exists('page_exists'))
            return page_exists($id);
        else
            return @file_exists(wikiFN($id));
    }

    function register(&$controller) {
        $controller->register_hook('ACTION_ACT_PREPROCESS', 'AFTER', $this, 'preprocess', array ());
    }

    function preprocess(& $event, $param) {
        global $INFO;
        global $auth;
        global $conf;
        global $ID;
        if ($INFO['isadmin']) return;
        if (!$this->page_exists($ID) && $event->data == 'show')
        {
	$id = $this->GetConf('idnamespace');
        header('Location: ' . wl($id,'',true));
        }
}
}
