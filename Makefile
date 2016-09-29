MOZILLA_BUILD=../mozilla-central

all: clean build xpi

clean:
	rm -rf build

build:
	mkdir build
	cp -f chrome.manifest.in build/chrome.manifest
	bash -c "./bin/copyLocales"
	cp -f bootstrap.js build/
	cp -rf content build/
	cp -rf skin build/
	cp -rf locale build/
	cp install.rdf.in build/install.rdf
	# set min and max firefox versions for this build
	bash -c "sed -i -e 's/@MOZ_APP_MAXVERSION@/51.0/g' build/install.rdf"
	bash -c "sed -i -e 's/@MOZ_APP_VERSION@/48.0/g' build/install.rdf"
	rm build/install.rdf-e

xpi:
	cd build
	zip -rD pocket.xpi install.rdf bootstrap.js chrome.manifest content/ skin/ locale/
	cd ..

land: clean build
	rm build/install.rdf
	rm build/chrome.manifest
	bash -c "hg rm $(MOZILLA_BUILD)/browser/extensions/pocket/locale/*"
	bash -c "python ./bin/generateLocaleJar.py"
	cp -f moz.build $(MOZILLA_BUILD)/browser/extensions/pocket/
	cp -f jar.mn $(MOZILLA_BUILD)/browser/extensions/pocket/
	cp -f chrome.manifest.in $(MOZILLA_BUILD)/browser/extensions/pocket/chrome.manifest
	cp -f install.rdf.in $(MOZILLA_BUILD)/browser/extensions/pocket/
	cp -rf build/* $(MOZILLA_BUILD)/browser/extensions/pocket/
	cp -f locale.moz.build $(MOZILLA_BUILD)/browser/extensions/pocket/locale/moz.build
	hg add $(MOZILLA_BUILD)/browser/extensions/pocket/locale/*
