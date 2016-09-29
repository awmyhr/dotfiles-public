#!/bin/sh

# include parse_yaml function
. parse_yaml.sh

# read yaml file
eval $(parse_yaml zconfig.yml "config_")

# access yaml content
echo $config_development_database
