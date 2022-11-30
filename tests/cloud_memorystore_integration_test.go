//go:build integration

package memorystore_integration_test

import (
	"context"
	"fmt"
	"testing"

	redis "cloud.google.com/go/redis/apiv1beta1"
	redispb "cloud.google.com/go/redis/apiv1beta1/redispb"
	//"cloud.google.com/go/redis"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCloudStorageIntegration(t *testing.T) {

	// Give a unique name to the Redis instance we provision.
	generation := random.Random(1, 999)
	// Create string version of generation and keep leading zeroes
	generationStr := fmt.Sprintf("%03d", generation)
	expectedName := fmt.Sprintf("mem-tfmodules-dev-%s", generationStr)

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "fixtures/redis",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"generation": generation,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
		Logger:  logger.Discard,
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of an output variable.
	output := terraform.OutputMap(t, terraformOptions, "instance")
	instanceName := output["name"]

	// Verify that instance name is as expected
	assert.Equal(t, expectedName, instanceName)

	// Create client
	ctx := context.Background()
	client, err := redis.NewCloudRedisClient(ctx)
	if err != nil {
		t.Fail()
		fmt.Println("ERROR:: ", err.Error())
	}
	defer client.Close()

	reqInstance := "projects/ent-tfmodules-dev/locations/europe-west1/instances/" + expectedName

	req := &redispb.GetInstanceRequest{
		Name: reqInstance,
	}
	resp, err := client.GetInstance(ctx, req)
	if err != nil {
		t.Fail()
		fmt.Println("ERROR:: ", err.Error())
	}
	// Instance state 2 = READY. Ref. https://pkg.go.dev/cloud.google.com/go/redis@v1.10.0/apiv1beta1/redispb#Instance_State
	assert.Equal(t, resp.State, redispb.Instance_State(2), "Instance state is not ready")
}
