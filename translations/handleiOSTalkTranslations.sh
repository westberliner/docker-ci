#!/bin/sh

# verbose and exit on error
set -xe

# import GPG keys
gpg --import /gpg/nextcloud-bot.public.asc
gpg --allow-secret-key-import --import /gpg/nextcloud-bot.asc
gpg --list-keys

# fetch git repo
git clone git@github.com:nextcloud/talk-ios /app
cd VideoCalls

# remove all translations (they are added afterwards anyways but allows to remove languages via transifex)
rm -r VideoCalls/*.lproj
git checkout -- VideoCalls/Base.lproj
git checkout -- VideoCalls/en.lproj

# push sources
tx push -s

# pull translations
tx pull -f -a --minimum-perc=25

cd VideoCalls

# use de_DE instead of de
rm -rf ./de.lproj
mv de_DE.lproj de.lproj

cd ..

# create git commit and push it
git add .
git commit -am "[tx-robot] updated from transifex" || true
git push origin master
echo "done"