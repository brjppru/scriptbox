#!/bin/sh

# google api requirements:
# https://developers.google.com/gdata/articles/using_cURL
# https://developers.google.com/gdata/faq#clientlogin
# https://developers.google.com/google-apps/contacts/v3/
# https://developers.google.com/google-apps/contacts/v3/reference

# json parser:
# https://github.com/dominictarr/JSON.sh#jsonsh

# recommendation(optional):
# https://developers.google.com/accounts/docs/OAuth2UserAgent

# global define
Format="json"
dir=/baza/backup/gbackup

get_google()
{

echo "[x] $Named";

# echo "logging in to google and saving contact with given caller-number."
Auth=$(curl --silent https://www.google.com/accounts/ClientLogin --data-urlencode Email=${Email} --data-urlencode Passwd=${Passwd} -d accountType=GOOGLE -d source="Google cURL-Example" -d service=cp | grep Auth | cut -d= -f2)
curl --silent --header "Authorization: GoogleLogin auth=$Auth" "https://www.google.com/m8/feeds/contacts/$Email/full?v=3.0&q=$2&alt=$Format" > ${dir}/$Named-`date +"%Y-%m-%d"`.json

}

# Begin the magic

Named="ololoev"; Email="djigurda@gmail.com"; Passwd="nikita"; get_google;

# The End ;-)
