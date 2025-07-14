# CI/CD Pipeline with dbt Cloud

## 🎯 Objective
Deploy dbt transformations with CI/CD using GitHub Actions, test automation, and alerts. This project demonstrates a complete data pipeline with source, transform, and output layers.

## 🧰 Stack
- **dbt Cloud** (Free tier)
- **GitHub Actions** for CI/CD
- **Supabase** (PostgreSQL)
- **Slack Webhooks** (optional)

## 📊 Data Model Overview

### Source Layer (`models/source/`)
- `src_customers.sql` - Source customer data with validation
- `src_orders.sql` - Source order data with business logic

### Transform Layer (`models/transform/`)
- `trf_customer_orders.sql` - Transformed customer and order data

### Output Layer (`models/output/`)
- `out_customers.sql` - Output customer table with aggregated metrics
- `out_orders.sql` - Output order table with detailed metrics

### Seeds (`seeds/`)
- `raw_customers.csv` - Sample customer data
- `raw_orders.csv` - Sample order data

## 🚀 Setup Instructions

### 1. Prerequisites
- dbt Cloud account (free tier)
- GitHub account
- Supabase project

### 2. dbt Cloud Configuration

#### Connect to Supabase:
1. Go to your dbt Cloud "Pilot" project
2. Navigate to **Settings > Connections**
3. Configure PostgreSQL connection:
   - **Host:** `DBT_HOST`
   - **Port:** `DBT_PORT`
   - **Database:** `DBT_DATABASE`
   - **Username:** `DBT_USER`
   - **Password:** `DBT_PASSWORD`
   - **Schema:** `DBT_SCHEMA`

#### Connect to GitHub:
1. Go to **Account Settings > Integrations > GitHub**
2. Click **"Link Account"** and authorize dbt Cloud
3. Select your `ci-cd-pipeline-dbt` repository

### 3. GitHub Secrets Setup

Add these secrets to your GitHub repository (`Settings > Secrets and variables > Actions`):

```
SUPABASE_HOST=DBT_HOST
SUPABASE_PORT=DBT_PORT
SUPABASE_USER=DBT_USER
SUPABASE_PASSWORD=DBT_PASSWORD
SUPABASE_DATABASE=DBT_DATABASE
SUPABASE_SCHEMA=DBT_SCHEMA
```

### 4. Local Development Setup

#### Install dbt CLI:
```bash
pip install dbt-core dbt-postgres
```

#### Create profiles.yml:
```bash
mkdir -p ~/.dbt
```

Create `~/.dbt/profiles.yml`:
```yaml
ci_cd_pipeline_dbt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: DBT_HOST
      port: DBT_PORT
      user: DBT_USER
      pass: DBT_PASSWORD
      dbname: DBT_DATABASE
      schema: DBT_SCHEMA
      threads: 4
```

#### Run the pipeline locally:
```bash
# Install dependencies
dbt deps

# Seed the data
dbt seed

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow
The `.github/workflows/dbt-ci-cd.yml` file defines a comprehensive CI/CD pipeline:

1. **dbt-test job**: Runs on all branches and PRs
   - Tests models and data quality
   - Compiles SQL
   - Generates documentation

2. **dbt-run job**: Runs only on main branch
   - Seeds data
   - Runs all models
   - Runs tests
   - Uploads artifacts

3. **Notification jobs**: Success/failure notifications

### Pipeline Triggers
- **Push to main/develop**: Full pipeline execution
- **Pull Request**: Test-only execution
- **Manual trigger**: Available in GitHub Actions

## 📈 Data Quality & Testing

### Built-in Tests
- **Unique**: Ensures primary keys are unique
- **Not null**: Ensures required fields are populated
- **Positive values**: Custom test for order amounts

### Custom Tests
- `tests/test_positive_values.sql`: Ensures order amounts are positive

### Data Quality Checks
- Email validation in staging
- Order status validation
- Customer segmentation logic

## 🏗️ Project Structure

```
ci-cd-pipeline-dbt/
├── .github/workflows/
│   └── dbt-ci-cd.yml          # CI/CD pipeline
├── models/
│   ├── source/                # Source data layer
│   │   ├── src_customers.sql
│   │   └── src_orders.sql
│   ├── transform/             # Transformation layer
│   │   └── trf_customer_orders.sql
│   └── output/                # Output layer
│       ├── out_customers.sql
│       └── out_orders.sql
├── seeds/                    # Static data files
│   ├── raw_customers.csv
│   └── raw_orders.csv
├── tests/                    # Custom tests
│   └── test_positive_values.sql
├── dbt_project.yml           # Project configuration
├── schema.yml               # Documentation & tests
└── README.md               # This file
```

## 🎯 Next Steps

### 1. Deploy to Production
1. Push your code to the main branch
2. Monitor GitHub Actions execution
3. Verify data in Supabase

### 2. Add More Data Sources
- Connect to additional databases
- Add API data sources
- Implement incremental models

### 3. Enhance Monitoring
- Add Slack notifications
- Set up data quality alerts
- Implement data lineage tracking

### 4. Scale the Pipeline
- Add more complex transformations
- Implement incremental processing
- Add data validation rules

## 🔧 Troubleshooting

### Common Issues

1. **Connection Errors**: Verify Supabase credentials
2. **Test Failures**: Check data quality in seeds
3. **Build Failures**: Review model dependencies

### Debug Commands
```bash
# Check connection
dbt debug

# View compiled SQL
dbt compile

# Run specific model
dbt run --select src_customers

# Run specific test
dbt test --select test_positive_values
```

## 📚 Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Supabase Documentation](https://supabase.com/docs)

---

**Happy data modeling! 🚀**
