import pandas as pd

from pipeline.model.pipeline import Pipeline
from pipeline.model.steps import PipelineStep
from pipeline.operations.clean_fields import clean_study_program_name

study_programs_clean_data_pipeline = Pipeline(
    name='clean_study_programs_data',
    steps=[
        PipelineStep(name='clean_study_program_name', function=clean_study_program_name, source_columns=['study_program_name'],
                     destination_columns=['study_program_name']),
    ],
)

study_programs_generate_data_pipeline = Pipeline(
    name='generate_study_programs_data',
    steps=[
        PipelineStep(name='generate_surrogate_study_program_id', function=None, source_columns=['study_program_name'],
                     destination_columns=['study_program_id']),
    ],
)


def run_study_programs_pipeline(df: pd.DataFrame) -> pd.DataFrame:
    df.sort_values(by=['study_program_name', 'study_program_duration'], ignore_index=True, inplace=True)
    study_programs_clean_data_pipeline.run(df)
    study_programs_generate_data_pipeline.run(df)
    return df
