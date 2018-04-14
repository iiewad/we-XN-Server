class Api::V1::FeedbackController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    user = StuUser.find_by(cardcode: feedback_params[:stu_user_id])
    feedback = user.feedbacks.build(feedback_params)

    if feedback.save
      render :json => {
        status: 'success',
        message: '提交成功',
        data: feedback
      }
    else
      render :json => {
        status: 'failed',
        message: '提交失败',
        err_msg: feedback.errors.messages
      }
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :content, :stu_user_id)
  end

end
