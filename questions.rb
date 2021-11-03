require 'sqlite3'
require 'Singleton'

class QuestionsDBConnection < SQLite3 :: Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Questions

    def self.all
        data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
        data.map { |datum| Questions.new(datum) }
    end

    def self.find_by_id(id)
        
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @associated_author_id = options['associated_author_id']
    end




end
