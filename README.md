# Log deployment action

This is an action used to create an event on AWS's event bridge notifying that a service (or package) was deployed.

## Inputs

### `stage`

**Required** The stage to which the deployment should be logged. Default `'prod'`.

## Outputs

No outputs.

## Example usage

uses: lemonenergy/log-deployment-action
with:
  stage: 'beta'
