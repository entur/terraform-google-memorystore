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
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v0.1.0"
  ...
}
```
<!-- ci: x-release-please-end -->

See the `README.md` under each module's subfolder for a list of supported inputs and outputs. For examples showing how they're implemented, check the [examples](examples) subfolder.

### Version constraints

You can control the version of a module dependency by adding `?ref=TAG` at the end of the source argument, as shown in the example above. This is highly recommended. You can find a list of available versions [here](https://github.com/entur/terraform-google-memorystore/releases).

Dependency automation tools such as Renovate Bot will be able to discover new releases and suggest updates automatically.
