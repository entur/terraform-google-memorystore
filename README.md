# Terraform module(s) for creating Google Cloud Memorystore instanses following Entur's conventions

Modules for provisioning memorystore instances on Google Cloud Platform.

## Redis module

A Redis module that uses the [init module](https://github.com/entur/terraform-google-init) as minimum input, while allowing overrides and additional configuration.

[Module](modules/redis)

[Examples](examples)

## Usage instructions

### Version constraints

You can control the version of a module dependency by adding `?ref=TAG` at the end of the source argument. This is highly recommended. You can find a list of available versions [here](https://github.com/entur/terraform-google-memorystore/releases).

```
module "redis" {
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=vVERSION"
  ...
}
```

Dependency automation tools such as Renovate Bot will be able to discover new releases and suggest updates automatically.

#### Example

```
module "redis" {
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v1.0.0"
  ...
}
```
