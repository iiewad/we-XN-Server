class Api::V1::GradeController < Api::BaseController
  include Api::V1::GradeHelper

  def index
    stuNumber = params["stuNumber"]
    stuCardCode = params["stuCardCode"]
    @stuGrades = StuGrade.where(xh: stuNumber)
    if @stuGrades.empty?
      @stuGrades = handle_grade(stuCardCode)
      @stuGrades = @stuGrades.group_by(&:xn)
    else
      @stuGrades = @stuGrades.group_by(&:xn)
    end
    render :json => {
      status: 'success',
      message: '请求成功',
      grades: @stuGrades
    }
  end
end
