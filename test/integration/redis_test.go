//go:build integration

package redis

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

const exampleDir = "../../examples/minimal_test"

func TestRedis(t *testing.T) {
	const region = "europe-west1"
	const memorySize int64 = 1

	cloudRedisT := tft.NewTFBlueprintTest(t,
		tft.WithTFDir(exampleDir),
	)

	// asserts copied from https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/test/integration/postgresql-public/postgresql_public_test.go
	cloudRedisT.DefineVerify(func(assert *assert.Assertions) {
		instanceName := cloudRedisT.GetStringOutput("instance_name")
		projectId := cloudRedisT.GetStringOutput("project_id")
		redis := gcloud.Run(t, fmt.Sprintf("redis instances describe %s --project %s --region %s", instanceName, projectId, region))

		assert.Contains(redis.Get("locationId").String(), region, "Memorystore instance's GCE region is valid")
		assert.Contains(redis.Get("name").String(), instanceName, "Memomystore instance has a valid id")
		assert.Equal(memorySize, redis.Get("memorySizeGb").Int(), "Memorystore instance has been allocated 1 GB of memory")
		assert.Equal(redis.Get("authEnabled").String(), "true", "Memoystore instance has auth enabled")
		assert.Equal(redis.Get("connectMode").String(), "PRIVATE_SERVICE_ACCESS")
		assert.Equal(redis.Get("redisVersion").String(), "REDIS_7_0")
	})

	cloudRedisT.Test()
}
