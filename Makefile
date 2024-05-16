build-RuntimeDependenciesLayer:
	mkdir -p "$(ARTIFACTS_DIR)/nodejs"
	cp package.json "$(ARTIFACTS_DIR)/nodejs/"
	npm install --production --prefix "$(ARTIFACTS_DIR)/nodejs/" --ignore-scripts
	rm "$(ARTIFACTS_DIR)/nodejs/package.json" # to avoid rebuilding when changes don't relate to dependencies

build-FunctionLayer:
	mkdir -p "$(ARTIFACTS_DIR)/nodejs/lambdas"

	if [ -d "lambdas" ]; then cp -R lambdas/. "$(ARTIFACTS_DIR)/nodejs/lambdas"; fi
	if [ -d "models" ]; then cp -R models/. "$(ARTIFACTS_DIR)/nodejs/models"; fi
	if [ -d "utils" ]; then cp -R utils/. "$(ARTIFACTS_DIR)/nodejs/utils"; fi
	if [ -d "sqs" ]; then cp -R sqs/. "$(ARTIFACTS_DIR)/nodejs/sqs"; fi


build-FaasFunction:
	cp -r lambdas/faas/faas.js lambdas/faas/faas.js.map "$(ARTIFACTS_DIR)/"
