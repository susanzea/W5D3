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

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @associated_author_id = options['associated_author_id']
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

end

class 