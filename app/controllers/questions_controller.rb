class QuestionsController < ApplicationController
  expose :questions, -> { Question.all }
  expose :question

  def destroy
    question.destroy

    redirect_to questions_path
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def create
    question = Question.new(question_params)
    if question.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
