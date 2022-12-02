//go:build unit

package memorystore_unit_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformMemorystoreUnit(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "fixtures/redis",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
		Logger:  logger.Discard,

		PlanFilePath: "plan.out",
	})

	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// Make sure the right address vas registered
	terraform.RequireResourceChangesMapKeyExists(t, plan, "module.redis.google_redis_instance.main")

	// Check values from plan output
	cloudRedisChanges := plan.ResourcePlannedValuesMap["module.redis.google_redis_instance.main"]
	// Validate name
	assert.Equal(t, cloudRedisChanges.AttributeValues["name"], "mem-tfmodules-dev-001", "Incorrect name")
	// Memory size
	memorySize := cloudRedisChanges.AttributeValues["memory_size_gb"].(float64)
	assert.Equal(t, memorySize, float64(1), "Incorrect memory size")
	// Connect mode
	assert.Equal(t, cloudRedisChanges.AttributeValues["connect_mode"], "PRIVATE_SERVICE_ACCESS", "Incorrect connect mode")
	// Tier
	assert.Equal(t, cloudRedisChanges.AttributeValues["tier"], "STANDARD_HA", "Incorrect tier")
}
