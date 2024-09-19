# Changelog

## [2.0.0](https://github.com/entur/terraform-google-memorystore/compare/v1.0.2...v2.0.0) (2024-09-19)


### ⚠ BREAKING CHANGES

* Redis Authentication is now enforced ([#42](https://github.com/entur/terraform-google-memorystore/issues/42))

### Bug Fixes

* example doc [skip ci] ([#41](https://github.com/entur/terraform-google-memorystore/issues/41)) ([eec37c9](https://github.com/entur/terraform-google-memorystore/commit/eec37c9883d52a933fde6fcbda0d2ae75a79e46d))
* Redis Authentication is now enforced ([#42](https://github.com/entur/terraform-google-memorystore/issues/42)) ([0199035](https://github.com/entur/terraform-google-memorystore/commit/019903501006ce89146ae3038b1c21b5a4e21453))

## [1.0.2](https://github.com/entur/terraform-google-memorystore/compare/v1.0.1...v1.0.2) (2024-09-17)


### Bug Fixes

* Change connect_mode option if vpc_id is set ([#39](https://github.com/entur/terraform-google-memorystore/issues/39)) ([428b6f1](https://github.com/entur/terraform-google-memorystore/commit/428b6f17d3a9610860681d4ec479aada6a6f7f26))

## [1.0.1](https://github.com/entur/terraform-google-memorystore/compare/v1.0.0...v1.0.1) (2024-09-17)


### Bug Fixes

* be able to specify vpc network id ([#37](https://github.com/entur/terraform-google-memorystore/issues/37)) ([63f8049](https://github.com/entur/terraform-google-memorystore/commit/63f8049094bac3edd2608e4300523b69a4b98e2d))

## [1.0.0](https://github.com/entur/terraform-google-memorystore/compare/v0.2.4...v1.0.0) (2024-01-05)


### ⚠ BREAKING CHANGES

* enable auth and update redis version ([#35](https://github.com/entur/terraform-google-memorystore/issues/35))

### Features

* enable auth and update redis version ([#35](https://github.com/entur/terraform-google-memorystore/issues/35)) ([738bb72](https://github.com/entur/terraform-google-memorystore/commit/738bb72b0624d8012c13ac33289cd95015dec4f3))

## [0.2.4](https://github.com/entur/terraform-google-memorystore/compare/v0.2.3...v0.2.4) (2023-07-03)


### Bug Fixes

* quickfix by [@futu-waino](https://github.com/futu-waino), bug in tf ([#20](https://github.com/entur/terraform-google-memorystore/issues/20)) ([1575b49](https://github.com/entur/terraform-google-memorystore/commit/1575b49bef4a92b55995bc0e75b1f25772a6f687))

## [0.2.3](https://github.com/entur/terraform-google-memorystore/compare/v0.2.2...v0.2.3) (2023-02-28)


### Bug Fixes

* ability to specify name_override ([#17](https://github.com/entur/terraform-google-memorystore/issues/17)) ([f391c36](https://github.com/entur/terraform-google-memorystore/commit/f391c360b459fe8d53e2eb5f42ff902b6ce065a3))

## [0.2.2](https://github.com/entur/terraform-google-memorystore/compare/v0.2.1...v0.2.2) (2023-02-09)


### Bug Fixes

* release please 0.2.2 ([#14](https://github.com/entur/terraform-google-memorystore/issues/14)) ([67b3aa0](https://github.com/entur/terraform-google-memorystore/commit/67b3aa0a7236aa5a2982a54acd98b41fce70f553))

## [0.2.1](https://github.com/entur/terraform-google-memorystore/compare/v0.2.0...v0.2.1) (2023-01-13)


### Bug Fixes

* set replica_count to null if enable_replicas false ([#11](https://github.com/entur/terraform-google-memorystore/issues/11)) ([42d1a71](https://github.com/entur/terraform-google-memorystore/commit/42d1a719ac533a1b17fc480b2ebee108ef413943))

## [0.2.0](https://github.com/entur/terraform-google-memorystore/compare/v0.1.0...v0.2.0) (2023-01-11)


### Features

* enable read replicas ([#8](https://github.com/entur/terraform-google-memorystore/issues/8)) ([d099b25](https://github.com/entur/terraform-google-memorystore/commit/d099b2561485229564023c11f5af73163c547261))

## 0.1.0 (2022-07-12)


### Features

* add initial memorystore redis module ([#2](https://github.com/entur/terraform-google-memorystore/issues/2)) ([962afa1](https://github.com/entur/terraform-google-memorystore/commit/962afa11d203ce945d0c360c13916e5ed49d9338))
