[![Maintainability](https://api.codeclimate.com/v1/badges/9600f8055441cf76779f/maintainability)](https://codeclimate.com/repos/62bd239e3e4c0b01a100ac73/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/9600f8055441cf76779f/test_coverage)](https://codeclimate.com/repos/62bd239e3e4c0b01a100ac73/test_coverage)

## Overview 

This project manages the deployment of multiple lambdas and crons with the AWS `sam cli`. Use the `gh-cli` to scaffold `models`, `lambdas functions`, `crons jobs`, and `sqs queues`.

## Getting Started

To get started with this project, follow these steps:

### Prerequisites

Before you can use this project, you must have the following installed:

- AWS SAM CLI
- Docker
- MySQL client (installed with Brew)
- Node.js
- gh-cli

### Installation

To install this project, follow these steps:

1. Clone the repository: `git clone https://github.com/<username>/<repository>.git`
2. Navigate to the project directory: `cd <repository>`
3. Install dependencies: `npm i`

### Configuration

Before you can use this project, you must configure it:

1. Add a `.env` file for local devlopment
1. Add a `.test.env` file for test
2. Add an `env.json` file for building images with AWS SAM locally
3. Add the tables to your local database: `npx sequelize db:migrate`

### Usage

To use this project, follow these steps:

1. Start a local database with the gh-cli and Docker Compose: `gh-cli db -c up`
2. Reset the database: `npm run db:reset`
3. Test the code with Jest:
   - Run all tests and output coverage: `npm run test`
   - Run tests for one file: `npm run test <file-name>`
   - Run tests and rerun them if code is updated: `npm run test:watch`

4. (a) To start a local Express server for development, run:
    -  `npm start`
    - The server will start on port `9000`.
4. (b) To start the AWS SAM local API server, run:
    - `npm run sam:start`
    - The server will start on port `9000`.
    - Note that it currently does not support hot reloads and needs to be re-run after code changes to use the Lambda layers.
    - To speed up the build time on the local server, we only build the faas lambda route. This allows all lambda functions to be accessed under the `/faas/` proxy.
4. (c) Invoking AWS SAM Crons Locally
    - `npm run sam:invoke --cron=ExampleCron`
    - Replace `ExampleCron` with the name of the cron job defined in the `template.yml` file.

### Adding a New Lambda with the gh-cli

To add a new Lambda function to the project, follow these steps:

1. Run the command `gh-cli fun -hm <get post put patch create delete> -fn <name-in-kebab-case>` in the root of the project to scaffold a new Lambda and AWS SAM template YAML file.
2. Develop and test your function with Jest by running `npm run test`.
3. Run `npm start` or `npm run sam:start` to access the new Lambda route locally.
    - The new Lambda can be accessed at `/faas/name-in-kebab-case`.
    - Once deployed to a live environment, it will be available at `/name-in-kebab-case`.

### Adding a New Cron Job with the gh-cli

To add a new cron job to the project, follow these steps:

1. in the root of the project Run the command 
  -  `gh-cli cron -c "0 6 * * *" -fn example-cron`
  - this will scaffold a new cron-job function with a test, lambda handler and AWS SAM template YAML file.
2. Develop and test your function with Jest by running `npm run test`.
3. Invoke the lambda locally with `npm run sam:invoke --cron=ExampleCron` where `ExampleCron` is the name of the cron in the `template.yml`.

The `gh-cli cron` command accepts the following options:
- `-c`: the cron schedule for the job to run. You can use the [sample cron strings](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#:~:text=You%20can%20use%20the%20following%20sample%20cron%20strings%20when%20creating%20a%20rule%20with%20schedule.) provided by AWS when creating a rule with schedule.
- `-fn`: the name of the cron function in kebab-case.


### Adding an SQS with the gh-cli

To add a new SQS trigger to the project, follow these steps:

1. Run the command `gh-cli sqs -fn example-sqs` in the root of the project to scaffold a new SQS trigger and database migration file.
2. Develop and test your function with Jest by running `npm run test`.
3. Run `npm start` or `npm run sam:start` to test the function locally.

### Adding Models and Factories with the gh-cli

To add a new model and factory to the project, follow these steps:

1. Run the command `gh-cli model -mn <name-in-dash-case>` in the root of the project to scaffold a new model in layers and a factory for testing.
  - Note: Make sure to replace <name-in-dash-case> with the actual name of the model you want to create in dash-case format.


## AWS Secrets Manager

This section explains how to get and update secrets for different environments in the `secrets` directory.

### Get Secrets

Use the following commands to get the secrets for different environments:

- `npm run secret:read:dev`: Gets secrets for the development environment.
- `npm run secret:read:stage`: Gets secrets for the staging environment.
- `npm run secret:read:prod`: Gets secrets for the production environment.

### Update Secrets

Use the following commands to update the secrets for different environments:

- `npm run secret:update:dev`: Updates secrets for the development environment.
- `npm run secret:update:stage`: Updates secrets for the staging environment.
- `npm run secret:update:prod`: Updates secrets for the production environment.


## Formatting Code

This project uses a pre-commit hook with Husky to ensure the code is properly formatted and can be built. Here are some useful commands:

- `npm run format`: runs Prettier and formats the code under `src/`.
- `npm run lint`: lints the code.
- `npm run clean-code`: runs both commands above.

## GH-CLI
Install the cli globally and run the command in the root of the project
- `npm i -g @gravity-haus/gh-cli`

### Database with gh-cli
  - `gh-cli db -c up`: starts docker-compose with a local mysql DB
  - `gh-cli db -c down`: stops docker-compose and the DB with it

## Database 
  - [sequelize-typescript](https://www.npmjs.com/package/sequelize-typescript#installation) to manage database models in lambda layer
  - [sequelize-cli](https://www.npmjs.com/package/sequelize-cli) to manage the migrations and seeds
#### Migrations
- `npx sequelize migration:create --name <NAME OF MIGRATION>` creates migration file

- `npm run db:migrate` runs migrations for development and test databases
  - `db:migrate:test` run migrations on test database
  - `db:migrate:dev` run migrations on development database

- `npm run db:migrate:undo --name=<FILE NAME>` Reverts a migration on development and test databases
  - `npm run db:migrate:undo:test --name=<FILE NAME>` run undo on test database
  - `npm run db:migrate:undo:dev --name=<FILE NAME>` run undo on development database

#### Seeds
- `npx sequelize seed:generate --name MODEL_NAME`  Generates a new seed file
- `npx sequelize db:seed --seed SEEDER_FILE_NAME`  Run specified seeder
- `npx sequelize db:seed:undo --seed SEEDER_FILE_NAME` Deletes data from the database
- `npx sequelize db:seed:all` Run every seeder


## AWS SAM
aws sam uses this file to pass parameter overrides to the lambda function. look at  `env.sample.json` for an example.
[adding new environment variable to aws sam template ](#aws-sam-environment-variable-file)
### Aws SAM Environment variable file
[Environment variable file docs](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html#serverless-sam-cli-using-invoke-environment-file)
- `aws sam` uses an `env.json` file to add environment variables locally to the `template.yaml`.

`env.json` example: 
```json
{
    "Parameters": {
        "NEW_ENV_VAR": "<value>"
    }
}
```
- For ease of coding and scaffolding lambdas with the `gh-cli`, environment variables are set globally in the `aws sam` `template.yaml`
- To add a new environment variable, you need to update the root `template.yaml`, [`Parameter`](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html#:~:text=ImageId%3A%20ami%2D0ff8a91507f77f867-,General%20requirements%20for%20parameters,-The%20following%20requirements) and `Globals`, `Environment`, and `Variables`.

Passing environment variables in `template. yaml` with parameters example:
``` yaml
Parameters:
    EnvVar:
        Description: 'The Environment Variable you want to set'
        Type: 'String'
Globals:
  Function:
    Environment: 
        Variables:
            ENV_VAR: !Ref EnvVar
```

- If new environment variables are added to the project, you must pass that to the aws-sam orb in circle ci as [parameter-overrides](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-deploy.html#:~:text=%2D%2Dparameter%2Doverrides) to both the projects `stage` and `prod` lambda stack
## Deploying Lambdas with circleci
- [AWS SAM deploy](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-deploy.html) 
- [circleci/aws-sam-serverless](https://circleci.com/developer/orbs/orb/circleci/aws-sam-serverless)
- aws-sam-serverless deploys our lambdas when we merge into the `main` or `stage` branch. 

## Project File Structure
Use the `gh-cli` to generate new `crons`,  `functions`, and `models`

```
|-- template.yaml
|-- package.json
|-- src
  |-- lambdas
    |-- <HTTP METHOD>
      |-- <LAMBDA-NAME>
        |-- <LAMBDA NAME>.ts
  |-- crons
    |-- <CRON-NAME>
      |-- <CRON-NAME>.ts
  |-- models
    |-- <MODEL>.ts
  |-- test-helpers
    |-- factories
      |-- <MODEL>.ts
```

## LEARN
[Installing AWS SAM](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-mac.html)

[Environment variable file](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html#:~:text=local%20invoke%20%2D%2Dhelp-,Environment%20variable%20file,-You%20can%20use)

[AWS SAM Docs](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html)

[AWS SAM video](https://www.youtube.com/watch?v=QBBewrKR1qg)

[AWS SAM with type-script](https://aws.amazon.com/blogs/compute/building-typescript-projects-with-aws-sam-cli/)

[evilmartians lambda typescript](https://evilmartians.com/chronicles/serverless-typescript-a-complete-setup-for-aws-sam-lambda)

[Delete deployed lambda stack](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-delete.html)