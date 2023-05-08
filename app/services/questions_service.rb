class QuestionsService
  def questions_answers(user)
    questions = Question.all
    questions.map { |q| question_response_message(user.answers, q) }
  end

  def question_response_message(answers, question)
    { question: question.question, answer: answers[question.label], question_id: question.id }
  end

  def modify_answers(user, questions)
    questions.each do |question|
      user.answers[question[0].to_s] = question[1].to_i
    end
    user.save!
  end
end
