require 'sqlite3'
require 'Singleton'

class QuestionsDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question

    attr_accessor :id, :title, :body, :associated_author_id

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end

    def self.find_by_id(id)
        question = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT *
            FROM questions
            WHERE id = ?
        SQL
        return nil if question.empty?

        Question.new(question.first) 
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
        SELECT *
            FROM questions
            WHERE author_id = ?
        SQL
        return nil if questions.empty?

        questions.map { |question| Question.new(question) }
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @associated_author_id = options['associated_author_id']
    end

    def author
        names = QuestionsDBConnection.instance.execute(<<-SQL, associated_author_id)
        SELECT fname,lname
        FROM users
        WHERE id = ?
    SQL
        fname,lname = names.first.values
        "#{fname} #{lname}"
    end

    def replies
        Reply.find_by_question_id(@id)
    end

end

class User

    attr_accessor :id, :fname, :lname

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
        data.map { |datum| User.new(datum) }
    end

    def self.find_by_name(fname,lname)
         user = QuestionsDBConnection.instance.execute(<<-SQL, fname,lname)
            SELECT *
            FROM users
            WHERE fname = ? AND lname = ?
        SQL
        return nil if user.empty?

        User.new(user.first) 
    end

    def self.find_by_id(id)
        user = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT *
            FROM users
            WHERE id = ?
        SQL
        return nil if user.empty?

        User.new(user.first) 
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end

end

class QuestionFollows
    attr_accessor :user_id, :question_id, :id

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
        data.map { |datum| QuestionFollows.new(datum) }
    end

    def self.find_by_id(id)
        question_follow = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_follows
            WHERE id = ?
        SQL

        return nil if question_follow.empty?

        QuestionFollows.new(question_follow.first) 
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end


class Reply
    attr_accessor :id, :question_id, :author_id, :body, :parent_reply_id

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end

    def self.find_by_id(id)
        reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE id = ?
        SQL
        return nil if reply.empty?

        Reply.new(reply.first) 
    end

    def self.find_by_user_id(author_id)
        replies = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
            SELECT *
            FROM replies
            WHERE author_id = ?
        SQL
        return nil if replies.empty?

        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_question_id(question_id)
        replies = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
            SELECT *
            FROM replies
            WHERE question_id = ?
        SQL
        return nil if replies.empty?

        replies.map { |reply| Reply.new(reply) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @author_id = options['author_id']
        @parent_reply_id = options['parent_reply_id']
        @body = options['body']
    end
    
    def author
        names = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
            SELECT fname,lname
            FROM users
            WHERE id = ?

        SQL
            fname,lname = names.first.values
            "#{fname} #{lname}"
    end

    def question
        Question.find_by_question_id(@question_id)
    end

    def parent_reply
        Reply.find_by_id(@parent_reply_id)
    end

    def child_replies
        parent_id = @id
        replies = QuestionsDBConnection.instance.execute(<<-SQL, parent_id)
            SELECT *
            FROM replies
            WHERE parent_reply_id = ? 
        SQL
        return nil if replies.empty?
        replies
    end

end


class QuestionLike
    attr_accessor :id, :question_id, :liker_id

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM question_likes")
        data.map { |datum| QuestionLike.new(datum) }
    end

    def self.find_by_id(id)
        question_like = QuestionsDBConnection.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_likes
            WHERE id = ?
        SQL
        return nil if question_like.empty?

        QuestionLike.new(question_like.first) 
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @liker_id = options['liker_id']
    end    
end

