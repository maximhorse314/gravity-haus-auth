Two scrips, one to create new plans from the sales price matrix and another to delete all versions created

## createVersion
### Reads CSV from `price-matrix-csvs` directory to create/find plans in stripe and create groups plans to a version in our DB 

#### CMD: `NODE_ENV='scripts' CSV='February 2023 Matrix.csv' SECRET_NAME='dev' npx ts-node -T src/scripts/price-matrix/createVersion.ts`
- NODE_ENV: always set to script to run as script
- CSV: name of csv file in `price-matrix-csvs` to create plans from
- SECRET_NAME: name of the secret dev stage or prod


## deleteVersion
### Finds all plans in stipe associated to a StripePlanVersion and deletes the plan, product in stripe and the StripePlanVersion and StripePlans in our DB

#### CMD: `NODE_ENV='scripts' SECRET_NAME='dev' npx ts-node -T src/scripts/price-matrix/deleteVersion.ts`
- NODE_ENV: always set to script to run as script
- SECRET_NAME: name of the secret dev stage or prod

