class UsersController < ApplicationController
  def index
    @users = [
        User.new(
            id: 1,
            name: 'Svetlana',
            username: 'lanabanana89',
        ),
        User.new(
            id: 2,
            name: 'Kostya',
            username: 'Kostya_sansay',
            avatar_url: 'http://hronika.info/uploads/posts/2015-10/1444557710_lisa1.jpg'
        )
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Svetlana',
      username: 'LanaBanana89',
    )

    @questions = [
        Question.new(text: 'Как дела?', created_at: Date.parse('17.04.2016')),
        Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('17.04.2016'))
    ]

    @new_question = Question.new
  end
end
