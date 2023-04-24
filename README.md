This module creates an AWS Amplify app. One can set the required global and branch specific variables.
> domain_management, manages the domain for a specific branch.
> branches_config, creates deployment for a specififc branch.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.2.0 |
| aws | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| app | brunordias/amplify-app/aws | ~> 1.0.3 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_token | Access token for GitHUb | `string` | n/a | yes |
| feature\_branch | Feature branch details | <pre>object({<br>    name = string<br>  })</pre> | n/a | yes |
| global\_variables | Variables need to stored globally. | `map(string)` | n/a | yes |

## Outputs

No outputs.
