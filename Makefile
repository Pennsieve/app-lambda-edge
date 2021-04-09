.PHONY: help clean package publish test 

ENVIRONMENT   ?= "local"
CODE_DIR      ?= "source"
WORKING_DIR   ?= "$(shell pwd)"
SERVICE_NAME  ?= "app-lambda-edge"
LAMBDA_BUCKET ?= "pennsieve-cc-lambda-functions-use1"
PACKAGE_NAME  ?= "${SERVICE_NAME}-${VERSION}.zip"

.DEFAULT: help

help:
	@echo "Make Help for $(SERVICE_NAME)"
	@echo ""
	@echo "make clean   - removes node_modules directory"
	@echo "make test    - run tests"
	@echo "make package - create venv and package lambda function"
	@echo "make publish - package and publish lambda function"

test:
	@echo ""
	@echo "***************"
	@echo "*   Testing   *"
	@echo "***************"
	@echo ""
	@node -v; \
                cd $(CODE_DIR); \
                yarn install; \
                yarn test

package:
	@echo ""
	@echo "***********************"
	@echo "*   Building lambda   *"
	@echo "***********************"
	@echo ""
	cd $(WORKING_DIR)/$(CODE_DIR); \
	    zip -r $(WORKING_DIR)/$(PACKAGE_NAME) .

publish:
	@make package
	@echo ""
	@echo "*************************"
	@echo "*   Publishing lambda   *"
	@echo "*************************"
	@echo ""
	@aws s3 cp $(WORKING_DIR)/$(PACKAGE_NAME) s3://${LAMBDA_BUCKET}/$(SERVICE_NAME)/
	@rm -rf $(WORKING_DIR)/$(PACKAGE_NAME)

clean:
	@rm -rf $(CODE_DIR)/node_modules
