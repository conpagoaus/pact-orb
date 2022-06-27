#!/bin/sh
while getopts ":c:v:e:dh" opt; do
  case $opt in
    c)
      CONSUMER=$OPTARG
      ;;
    v)
      VERSION=$OPTARG
      ;;
    e)
      ENVIRONMENT=$OPTARG
      ;;
    d)
      DRY_RUN=true
      ;;
    h)
      echo "Usage: publish.sh -c <consumer> -v <version> -e <environment>"
      echo "Specify -d for dry-run without actually publishing to broker"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
COMMAND="pact-broker can-i-deploy \
        --pacticipant \"$CONSUMER\" \
        --version $VERSION \
        --to-environment $ENVIRONMENT \
        --retry-while-unknown 0 \
        --retry-interval 10"

# if DRY_RUN is set
if [ ! -n "$DRY_RUN" ]; then
  echo "Dry run: $COMMAND"
  exit 0
else
  eval $COMMAND
fi