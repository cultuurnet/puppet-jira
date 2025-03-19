define jira::dbconf (
  $value,
  $key = $name,
  $config_file = "${jira::homedir}/dbconfig.xml",
) {
  require Class[jira::install]

  $aug_path = "set /files${config_file}/jira-database-config/jdbc-datasource/${key} ${value}"

  augeas { "${config_file} - ${key}":
    lens    => 'Xml.lns',
    incl    => $config_file,
    onlyif  => [
      "get /files${config_file}/jira-database-config/jdbc-datasource/${key}/#text != '{ATL_SECURED}'"
    ],
    changes => [
      $aug_path,
    ],
  }

  if $jira::service_manage {
    Augeas<| |> ~> Service['jira']
  }
}
