//go:build integration

package valkey

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

const exampleDir = "../../../examples/minimal_valkey_test"

func TestValkey(t *testing.T) {
	const region = "europe-west1"
	const engineVersion = "VALKEY_8_0"
	const expectedShardCount int64 = 2
	const expectedReplicaCount int64 = 1

	cloudValkeyT := tft.NewTFBlueprintTest(t,
		tft.WithTFDir(exampleDir),
	)

	cloudValkeyT.DefineVerify(func(assert *assert.Assertions) {
		instanceId := cloudValkeyT.GetStringOutput("instance_id")
		projectId := cloudValkeyT.GetStringOutput("project_id")

		valkey := gcloud.Run(t, fmt.Sprintf("memorystore instances describe %s --location %s --project %s", instanceId, region, projectId))

		assert.Contains(valkey.Get("name").String(), instanceId, "Memorystore Valkey instance has a valid id")
		assert.Contains(valkey.Get("name").String(), region, "Memorystore Valkey instance is in the correct region")
		assert.Equal(engineVersion, valkey.Get("engineVersion").String(), "Memorystore Valkey instance has correct engine version")
		assert.Equal("CLUSTER", valkey.Get("mode").String(), "Memorystore Valkey instance is in cluster mode")
		assert.Equal("IAM_AUTH", valkey.Get("authorizationMode").String(), "Memorystore Valkey instance has IAM authorization enabled")
		assert.Equal("SERVER_AUTHENTICATION", valkey.Get("transitEncryptionMode").String(), "Memorystore Valkey instance has TLS enabled")
		assert.Equal("STANDARD_SMALL", valkey.Get("nodeType").String(), "Memorystore Valkey instance has correct node type")
		assert.Equal(expectedShardCount, valkey.Get("shardCount").Int(), "Memorystore Valkey instance has correct shard count")
		assert.Equal(expectedReplicaCount, valkey.Get("replicaCount").Int(), "Memorystore Valkey instance has correct replica count")
		assert.Equal("ACTIVE", valkey.Get("state").String(), "Memorystore Valkey instance is active")

		for _, secretId := range []string{"VALKEY_HOST", "VALKEY_PORT", "CA"} {
			secret := gcloud.Run(t, fmt.Sprintf("secrets describe %s --project %s", secretId, projectId))
			assert.Contains(secret.Get("name").String(), secretId, "Secret %s exists in Secret Manager", secretId)
		}
	})

	cloudValkeyT.Test()
}
