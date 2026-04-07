CHART_DIR := chart
APP := my-website-2

.PHONY: lint template diff

lint:
	helm lint $(CHART_DIR)

template:
	helm template $(APP) $(CHART_DIR)

template-dev:
	helm template $(APP) $(CHART_DIR) -f environments/dev/values.yaml

template-staging:
	helm template $(APP) $(CHART_DIR) -f environments/staging/values.yaml

template-production:
	helm template $(APP) $(CHART_DIR) -f environments/production/values.yaml

diff:
	helm diff upgrade $(APP) $(CHART_DIR)
