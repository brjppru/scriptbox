#!/usr/bin/php
<?php $API='4e4261ff-e031-2116-654d-eff7746712bd'; // ключ Яндекса
if(!isset($argv[1])) die('NO FILE'); $txt=$argv[1];
$file='/tmp/'.md5($txt).'.mp3';
if(!is_file($file)) {
$ch=curl_init('https://tts.voicetech.yandex.net/generate?format=mp3&lang=ru-RU&emotion=good&speaker=ermil&key='.$API.'&text='.urlencode($txt));
curl_setopt($ch,CURLOPT_HEADER,1); curl_setopt($ch,CURLOPT_RETURNTRANSFER,1); curl_exec($ch); $r=curl_multi_getcontent($ch);
curl_close($ch); if(!sizeof($r)) die('Error'); file_put_contents($file,$r);
} exec('play '.$file);
?>
