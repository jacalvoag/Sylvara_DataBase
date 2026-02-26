CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_type VARCHAR(20) NOT NULL CHECK (
        project_type IN ('ECOMMERCE','SOCIAL','FINANCIAL','HEALTHCARE','IOT',
                         'EDUCATION','CONTENT','ENTERPRISE','LOGISTICS','GOVERNMENT')
    ),
    description TEXT,
    db_engine VARCHAR(20) NOT NULL CHECK (
        db_engine IN ('POSTGRESQL','MYSQL','MONGODB','OTHER')
    )
);

CREATE TABLE queries (
    query_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    query_description TEXT NOT NULL,
    query_sql TEXT NOT NULL,
    target_table VARCHAR(100),
    query_type VARCHAR(30) CHECK (
        query_type IN (
            'SIMPLE_SELECT','AGGREGATION','JOIN',
            'WINDOW_FUNCTION','SUBQUERY','WRITE_OPERATION'
        )
    )
);

CREATE TABLE executions (
    execution_id BIGSERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    query_id INT REFERENCES queries(query_id),
    index_strategy VARCHAR(20) CHECK (
        index_strategy IN ('NO_INDEX','SINGLE_INDEX','COMPOSITE_INDEX')
    ),
    execution_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    execution_time_ms BIGINT,
    records_examined BIGINT,
    records_returned BIGINT,
    dataset_size_rows BIGINT,
    dataset_size_mb NUMERIC,
    concurrent_sessions INT,
    shared_buffers_hits BIGINT,
    shared_buffers_reads BIGINT
);
