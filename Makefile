all: l10n rdf xpi

l10n:
	bash -c "./bin/copyLocales"

rdf:
	cp install.rdf.in install.rdf
	bash -c "sed -i -e 's/@MOZ_APP_MAXVERSION@/51.0/g' install.rdf"

xpi:
	zip -rD pocket.xpi install.rdf bootstrap.js chrome.manifest content/ skin/ locale/

land: l10n
	bash -c "python ./bin/generateLocaleJar.py"
	cp -f moz.build ../mozilla-inbound/browser/extensions/pocket/
	cp -f jar.mn ../mozilla-inbound/browser/extensions/pocket/
	cp -f install.rdf.in ../mozilla-inbound/browser/extensions/pocket/
	cp -f bootstrap.js ../mozilla-inbound/browser/extensions/pocket/
	cp -rf content ../mozilla-inbound/browser/extensions/pocket/
	cp -rf skin ../mozilla-inbound/browser/extensions/pocket/
	cp -rf locale ../mozilla-inbound/browser/extensions/pocket/
	cp -f locale.moz.build ../mozilla-inbound/browser/extensions/pocket/locale/moz.build
