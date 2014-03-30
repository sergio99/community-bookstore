<?php



/**
 * Implements hook_install_tasks_alter().
 */
function community_bookstore_install_tasks_alter(&$tasks, $install_state) {
  

  $target_theme = 'tamal';
  $theme_settings  = &drupal_static('theme_get_setting', array());

   $theme_settings[$target_theme]['logo'] = substr(dirname(__FILE__), strlen($_SERVER['DOCUMENT_ROOT'])) . '/themes/transparency/logo.png';
 // $theme_settings[$target_theme]['favicon'] = substr(dirname(__FILE__), strlen($_SERVER['DOCUMENT_ROOT'])) . '/images/favicon_installer.png';
  if ($GLOBALS['theme'] != $target_theme) {
    unset($GLOBALS['theme']);
    drupal_static_reset();
    $GLOBALS['conf']['maintenance_theme'] = $target_theme;
    _drupal_maintenance_theme();
  }

  // The "Welcome" screen needs to come after the first two steps
  // (profile and language selection), despite the fact that they are disabled.
  $new_task['install_welcome'] = array(
    'display' => TRUE,
    'display_name' => st('Welcome'),
    'type' => 'form',
    'run' => isset($install_state['parameters']['welcome']) ? INSTALL_TASK_SKIP : INSTALL_TASK_RUN_IF_REACHED,
  );
  $old_tasks = $tasks;
  $tasks = array_slice($old_tasks, 0, 2) + $new_task + array_slice($old_tasks, 2);


}
/**
 * Task callback: shows the welcome screen.
 */
function install_welcome($form, &$form_state, &$install_state) {
  drupal_set_title(st('Welcome'));

  //$message = st('Thank you for choosing Commerce Kickstart!') . '<br />';
  $message = st('Thank you for choosing the distribution ') . '<strong>Communnity Bookstore</strong>, ' . st('sponsored by') . ' ' . 
             l('7Sabores', 'http://www.7sabores.com', array('attributes' => array('target'=>'_blank'))) . '!' . '<br />';
  $message .= '<p>' . st('This distribution installs and configure a website of a community bookstore.') . '<p>';
  $message .= '<p> ' . st('We invite you to report any incident that occurs during installation by using the following link: ') .
      l('http://7sabores.com/fe-de-errata', 'http://7sabores.com/fe-de-errata', array('attributes' => array('target'=>'_blank'))) . '.</p>';
  $message .= '<p>' . st('Also remember to find at ') . l('http://www.7sabores.com', 'http://www.7sabores.com', array('attributes' => array('target'=>'_blank'))) . ' ' .
      st('other books as well as videos and blogs related to web and mobile development') . '</p>';

  $form = array();
  $form['welcome_message'] = array(
    '#markup' => $message,
  );
  $form['actions'] = array(
    '#type' => 'actions',
  );
  $form['actions']['submit'] = array(
    '#type' => 'submit',
    '#value' => st("Proceed with installation!"),
    '#weight' => 10,
  );
  return $form;
}

function install_welcome_submit($form, &$form_state) {
  global $install_state;

  $install_state['parameters']['welcome'] = 'done';
 // $install_state['parameters']['locale'] = 'es';
}


/*
function community_bookstore_profile_details() {
  $details['language'] = "es";
  return $details;
}*/
  //print_r($theme_settings[$target_theme]['logo']);