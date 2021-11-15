#!/bin/bash

source "microservices/ms-drops/commands/drops"
source "microservices/ms-drops/commands/arise"

function drops_name() {
  echo "MS-"$(drops_command_uppercase)
}

function drops_command() {
  echo "drops"
}

function drops_command_uppercase() {
  local cmd="$(drops_command)"
  echo ${cmd^^}
}

function drops_description() {
  echo "Initiate a development environment for the MS-DROPS."
}

function drops_man() {
  man "MS" $(drops_name)

  echo -e "
  up				Start the 'docker-compose up' considering the '.docker-conf/docker-compose/.env.dev.drops' file. Additionally, the documentation contents will be cloned from a git repository.
  git clone   			Clone the required git repositories
  git rm      			Remove the git repositories excluding the documentatuin contents
  git rm docu                   Remove the git repositories including the documentation contents
  docker up   			Start the 'docker-compose up' considering the '.docker-conf/docker-compose/.env.dev.drops' file
  docker rm   			Stop and remove all docker containers described in the docker-compose files
  docker rm drops volumes	Remove the drops volumes. That means the database contents.
  docker rm dispenser volumes   Remove the dispenser volumes. That means the database contents.
  drops up man			Shows a manual explaining how to setup the DROPS backend service
  drops admin			Sets admin access rights in DROPS for a specific user identified by its email address
  drops init			Initiates the Drops database. Requires a running Drops backend.
  arise up man			Shows a manual explaining how to setup the ARISE frontend service
  leave				Leave DEV environment
  exit				Close console
  *           			Help
"
}

#1 Domain (server name and protocol, like http://localhost) - default is http://localhost
function initDropsDB() {
  local DOMAIN="http://localhost"
  if [ -z ${1+x} ]; then
    DOMAIN="http://localhost"
  else
    DOMAIN=$1
  fi
  local RESPONSE_HEADER=$(curl -o /dev/null -s -w "%{http_code}\n" -m 30 "$DOMAIN/drops")
  # Since the init call on drops redirects to drops root route, but there is no root route (See https://github.com/SOTETO/drops/issues/16).
  if [[ $RESPONSE_HEADER = 404 ]]; then
    echo "Database has been initiated successfully."
  fi
}

function drops_env() {
  prompt=$(calcPrompt)
  for (( ; ; ))
  do
    read -r -p $"${prompt}" cmd sub para1 para2
    case "$cmd" in
        "up")
          gitClone drops
          dockerRun ms_drops
          setConfig "running" "yes"
          prompt=$(calcPrompt)
          ;;
        "git")
          case "$sub" in
                "clone") gitClone drops
                        ;;
                "rm")
                  case "$para1" in
                    "docu")
                        gitRemove drops true
                        #gitRemove docu
                    ;;
                    "")
                        gitRemove drops false
                    ;;
                    *)
                        drops_man
                    ;;
                  esac
                ;;
                *) drops_man
                        ;;
          esac
          ;;
        "docker")
         case "$sub" in
                "up") dockerRun ms_drops
                      setConfig "running" "yes"
                      prompt=$(calcPrompt)
                        ;;
                "rm")
                  case "$para1" in
                        "drops")
                          case "$para2" in
                                "volumes") dockerRmVolumes ms_drops drops-database
                                        ;;
                                *) drops_man
                                        ;;
                          esac
                          ;;
                        "dispenser")
                          case "$para2" in
                                "volumes") dockerRmVolumes ms_drops dispenser-database
                                        ;;
                                *) drops_man
                                        ;;
                          esac
                          ;;
                        "") dockerRm ms_drops
                            setConfig "running" "no"
                            prompt=$(calcPrompt)
                          ;;
                        *) drops_man
                          ;;
                  esac
                        ;;
                *) drops_man
                        ;;
          esac
          ;;
        "drops")
         case "$sub" in
                "up")
                  case "$para1" in
                        "man") dropsMan ms_drops
                          ;;
                        *) drops_man
                          ;;
                  esac
                        ;;
                "admin") prodDropsAdmin drops
                        ;;
                "init") initDropsDB
                        ;;
                *) drops_man
                        ;;
          esac
          ;;
        "arise")
          case "$sub" in
                "up")
                  case "$para1" in
                        "man") ariseMan
                          ;;
                        *) drops_man
                          ;;
                  esac
                        ;;
                *) drops_man
                        ;;
          esac
          ;;
        "leave")
          setEnvToIdle
          prompt=$(calcPrompt)
          break
          ;;
        "exit")
          exit 1
          ;;
        *)
          drops_man
          ;;
        # Todo: catch arrow up and down
    esac
  done
}
