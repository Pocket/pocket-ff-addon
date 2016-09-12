all: l10n xpi

l10n:
	bash -c "./genlocales"

xpi:
	zip -rD pocket.xpi install.rdf bootstrap.js chrome.manifest locales.manifest content/ skin/ locales/
