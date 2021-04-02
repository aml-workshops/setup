RESOURCE_GROUP = rg-workshop-ln
WORKSPACE_NAME = ws-ln-training

build:
	az bicep build -f deployment-templates/aml-workshop-deployment.bicep

datastore:
	az ml datastore attach-blob \
		--resource-group ${RESOURCE_GROUP} \
		--workspace-name ${WORKSPACE_NAME} \
		--account-name publicmldatasc \
		--container-name wikipedia \
		--name wikipedia \
		--sas-token "?sv=2020-02-10&ss=bfqt&srt=co&sp=rl&se=2050-04-01T21:06:20Z&st=2021-04-01T13:06:20Z&spr=https&sig=SLQAvaQ3jty13W7CE5Jq2NGItN%2FzpRfv5l5KS9h%2FAgA%3D"

dataset:
	az ml dataset register \
		--resource-group ${RESOURCE_GROUP} \
		--workspace-name ${WORKSPACE_NAME} \
		--file datasets/bert-base.json \
		--skip-validation
	az ml dataset register \
		--resource-group ${RESOURCE_GROUP} \
		--workspace-name ${WORKSPACE_NAME} \
		--file datasets/bert-large.json \
		--skip-validation
	az ml dataset register \
		--resource-group ${RESOURCE_GROUP} \
		--workspace-name ${WORKSPACE_NAME} \
		--file datasets/wikipedia-preprocessed.json \
		--skip-validation