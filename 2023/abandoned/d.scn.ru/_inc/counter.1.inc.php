<?php

  /*
      http://arkasoft.narod.ru

      Copyright (C) 2004 ������ ������
  */

  $page_log = './log/pages.log';  // ���-���� ���������� ��������� �������
  $arr_pages = array();           // ������ ���������� ��������� �������

  $user_log = './log/users.log';  // ���-���� ���������� �����������
  $users = 0;      // ����� ���-�� �����������
  $users_day = 0;  // �� ������� ����
  $log_date = '';

  // ��������� ���������� �����������
  // ���� �������� ���� ������ � ����
  // 25.03.2003 1254 6
  // ����.����������.��������� ���������������� ������������������
  if( file_exists($user_log) )
  {
    $fd = @fopen($user_log, 'rt');
    if($fd)
    {
      flock($fd, 2); // 2 - LOCK_EX (��� ������������� � PHP 3)
      $userinfo = fscanf($fd, "%s %d %d");
      list($log_date, $users, $users_day) = $userinfo;
      flock($fd, 3); // 3 - LOCK_UN (��� ������������� � PHP 3)
      fclose($fd);
    }
  }

  // ��������� ���������� ��������� �������
  // ������ ����� - ������ ������ ������������ � ����
  // /my_page1.html 56   - ���-�� ��������� � ��������
  if( file_exists($page_log) )
  {
    $fd = @fopen($page_log, 'rt');
    if($fd)
    {
      flock($fd, 2); // 2 - LOCK_EX (��� ������������� � PHP 3)
      while(!feof($fd))
      {
        $buf = trim(fgets($fd, 4096));
        if(strlen($buf))
        {
          $str = sscanf($buf, "%s %d");
          list ($page, $count) = $str;
          $arr_pages[$page] = $count;
        }
      }
      flock($fd, 3); // 3 - LOCK_UN (��� ������������� � PHP 3)
      fclose($fd);
    }
  }

  if( !isset($HTTP_GET_VARS['act']) && !isset($HTTP_POST_VARS['act']) )
  {
    $cookie_name = 'arkasoft';
    if(!isset($HTTP_COOKIE_VARS[$cookie_name]) )
    {
      // ���� expire'����� ���� �� ���� ����������� - ����� ����������
      $users++;
      if( $log_date != date('d.m.Y') )
        $users_day = 1; // ���� � ���� ������� �� ������� - ������ ����������
      else
        $users_day++;

      $fd = @fopen($user_log, 'wt');
      if($fd)
      {
        flock($fd, 2); // 2 - LOCK_EX (��� ������������� � PHP 3)
        $str = sprintf("%s %d %d\n", date('d.m.Y'), $users, $users_day);
        fputs($fd, $str);
        flock($fd, 3); // 3 - LOCK_UN (��� ������������� � PHP 3)
        fclose($fd);
      }
    }
    // ������� ����� �����������, ���� ����� �������� ����� 30 ���.
    setcookie($cookie_name, '1', time() + 60*30);

    // ������, �� ������� ����� ���������� ����������
    // ������������ GIF 88x31
    $fn = './img/count.gif';

    if(!file_exists($fn))
      header($HTTP_SERVER_VARS['SERVER_PROTOCOL'] . ' 404 Not Found');
    else
    {
      $img_stat = true; // ���� ������ ������� ������������ �������
      if(function_exists(imagecreatefromgif) && function_exists(imagegif) )
      {
        $im = @imagecreatefromgif($fn);
        if($im)
        {
          header($HTTP_SERVER_VARS['SERVER_PROTOCOL'] . ' 200 OK');
          header('Content-type: image/gif' );
          // ������ �������, ��� ���� ������ ������ ������
          header('Last-Modified: ' . date("D, d M Y H:i:s T", time()) );

          $text_color = imagecolorallocate($im, 0, 0, 0);

          // ��������, ���� ������, ���� ���������� � ������ ������
          // ������� ���������� � �������:   1526 / +15
          imagestring ($im, 1, 4, 23,  $users . ' / +'. $users_day, $text_color);
          imagegif($im);
          imagedestroy ($im);
          $img_stat = false; // ������� �������� ��� �� �����
        }
      }

      if($img_stat)
      {
        // �� ��������� ������������ �������� ��������
        // ���������� ����������� ������
        $ftime = date("D, d M Y H:i:s T", filemtime($fn) );
        $fsize = filesize($fn);
        $fd = @fopen($fn, 'rb');
        if(!$fd)
          header($HTTP_SERVER_VARS['SERVER_PROTOCOL'] . ' 403 Forbidden');
        else
        {
          $content = fread($fd, $fsize);
          fclose($fd);

          header($HTTP_SERVER_VARS['SERVER_PROTOCOL'] . ' 200 OK');
          header('Last-Modified: ' . $ftime);
          header('Content-Length: ' . $fsize);
          header('Content-Type: image/gif');
          print $content;
        }
      } // if($img_stat)

    } // if(!file_exists($fn))

    if( isset($HTTP_SERVER_VARS['HTTP_REFERER']) )
    {
      $fd = @fopen($page_log, 'wt');
      if($fd)
      {
        // � ���������� HTTP_REFERER - ��������, � ������� �����������
        // ������� ����������
        $referer = parse_url($HTTP_SERVER_VARS['HTTP_REFERER']);
        $arr_pages[ $referer['path'] ]++;

        flock($fd, 2); // 2 - LOCK_EX (��� ������������� � PHP 3)
        while( list($key, $val) = each($arr_pages) )
        {
          $str = sprintf("%s %d\n", $key, $val);
          fputs($fd, $str);
        }
        flock($fd, 3); // 3 - LOCK_UN (��� ������������� � PHP 3)
        fclose($fd);
      }
    }
  }
  else if($HTTP_GET_VARS['act'] == 'view')
  {
    // ������� ����������, ���� $users, $users_day � ����� ���:
    // arsort($arr_pages);
    // while( list($key, $val) = each($arr_pages) )
    //   print " $key   $val\n";
  }
?>

