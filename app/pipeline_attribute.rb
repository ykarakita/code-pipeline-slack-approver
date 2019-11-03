require "aws-sdk-codepipeline"

class PipelineAttribute
  attr_reader :pipeline_name, :stage_name, :action_name, :token, :expires

  def initialize(attr)
    @pipeline_name = attr["pipelineName"]
    @stage_name = attr["stageName"]
    @action_name = attr["actionName"]
    @token = attr["token"]
    @expires = attr["expires"]
  end

  def revision_id
    pipeline_execution.artifact_revisions.first.revision_id
  end

  private

  def client
    Aws::CodePipeline::Client.new
  end

  def pipeline_state
    @pipeline_state ||= client.get_pipeline_state(name: pipeline_name)
  end

  def latest_execution
    pipeline_state.stage_states.first.latest_execution
  end

  def pipeline_execution
    @pipeline_execution ||= client.get_pipeline_execution(
      pipeline_name: pipeline_name,
      pipeline_execution_id: latest_execution.pipeline_execution_id
    ).pipeline_execution
  end
end