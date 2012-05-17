mongo = mongod --dbpath data/db --fork --logpath log/mongo.log > mongo.pid

setup:
	mkdir data
	mkdir data/db
	mkdir log
	npm install
	echo 'MONGOHQ_URL=mongodb://localhost/feelwelllabs/dev' > .env
	make setup-front-end-testing

setup-front-end-testing:
	# Link javascripts in public to test directory
	ln -s public/javascripts/ test/public/javascripts
	# Link public necessary test files from node_modules to ensure things
	# are up to date
	mkdir test/public/vendor
	ln -s node_modules/sinon/ test/public/vendor/sinon
	ln -s node_modules/chai/chai.js test/public/vendor/chai.js
	ln -s node_modules/sinon-chai/lib/sinon-chai.js test/public/vendor/sinon-chai.js
	# Copy over vendor libaries mocha, chai and coffeescript from node modules
	npm install
	mkdir test/public/vendor
	cp -r node_modules/mocha/ test/public/vendor/mocha
	cp -r node_modules/chai/ test/public/vendor/chai
	cp -r node_modules/coffee-script test/public/vendor/coffee-script

run:
	$(mongo)
	foreman run coffee app.coffee

watch:
	$(mongo)
	foreman run supervisor app.coffee

test:
	$(mongo)
	MONGOHQ_URL=mongodb://localhost/feelwelllabs/test ./node_modules/.bin/mocha test/routes/* test/helpers/* test/models/* ./test/now/* --reporter spec

.PHONY: setup run watch test
