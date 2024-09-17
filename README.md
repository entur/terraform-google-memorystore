# Terraform module(s) for creating Google Cloud Memorystore instances following Entur's conventions

Modules for provisioning Memorystore instances on Google Cloud Platform.

## Redis module

A Redis module that uses the [init module](https://github.com/entur/terraform-google-init) as minimum input, while allowing overrides and additional configuration.

[Module](modules/redis)

[Examples](examples)

## Getting started

<!-- ci: x-release-please-start-version -->
### Example using the latest release

```
module "redis" {
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v1.0.2"
  ...
}
```
<!-- ci: x-release-please-end -->

See the `README.md` under each module's subfolder for a list of supported inputs and outputs. For examples showing how they're implemented, check the [examples](examples) subfolder.

### Version constraints

You can control the version of a module dependency by adding `?ref=TAG` at the end of the source argument, as shown in the example above. This is highly recommended. You can find a list of available versions [here](https://github.com/entur/terraform-google-memorystore/releases).

Dependency automation tools such as Renovate Bot will be able to discover new releases and suggest updates automatically.

## Contributing

We welcome contributions to this repo. How to contribute:

* Clone this repo, create a branch locally, make changes
* Run `terraform fmt` to format the Terraform code
* Run the tests locally (see [Prerequisites](#prerequisites) and [Local testing](#local-testing))
* Push your branch to the remote repo, create a pull request (PR)
* The tests are run by GitHub Actions (see [Automatic testing](#automatic-testing))
* Team Plattform at Entur reviews the PR, approves and merges the changes
* Team Plattform creates a new release (see [Versioning]](#versioning)

### Prerequisites

* You need to have Terraform installed (version: see [versions.tf](modules/bucket/versions.tf))
* You need to have Go installed (version >=1.19 because of the `go:build` directive format used in the go files)
* You need to have gcloud installed and be authenticated (`gcloud auth application-default login`)
* Your user must have the necessary permissions on the GCP project used to run the tests

### Versioning

Versioning and release workflows are automated using Release Please. See GitHub´s [documentation](https://github.com/googleapis/release-please#release-please).

### Tests

We are using the blueprint-test module for testing. https://pkg.go.dev/github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test

#### Local testing

To run the tests locally, make sure the [prerequisites](#prerequisites) are in place. Make sure that you are running the go commands to test in the `tests` folder.

The test files have [build tags](https://medium.com/@tharun208/build-tags-in-go-f21ccf44a1b8), these can be used to run only a subset of the tests, for example like this: `go test -v -tags=integration`.

#### Automatic testing

Separate GitHub workflows is defined for testing the module:

* [.github/workflows/pr-int-test-terraform.yaml](.github/workflows/pr-int-test-terraform.yaml)

These run every time a change is pushed to GitHub, but filters in the workflows stops the tests from running when no changes is made in the modules or the workflows.
