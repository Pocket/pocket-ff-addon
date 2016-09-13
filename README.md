# pocket
build requires l10n repo from:
https://github.com/mozilla-l10n/pocket-l10n

mkdir sources
cd sources
git clone git@github.com:mozilla-partners/pocket.git
git clone git@github.com:mozilla-l10n/pocket-l10n.git
cd pocket
make

# prepare for patch to mozilla-inbound
make land
