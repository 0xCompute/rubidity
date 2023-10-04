## SPDX-License-Identifier: public domain
## pragma: rubidity 0.0.1


class Todos < Contract

    struct :Todo, text:      String, 
                  completed: Bool 
    
    #  An array of 'Todo' structs
    storage  todos: array( Todo )


    sig :constructor, []
    def constructor
    end

    sig :create, [String]
    def create( text: ) 
        ##  3 ways to initialize a struct
        ##  - calling it like a function
        @todos.push( Todo.new( text, false  ))

        ##  key value mapping
        # @todos.push( Todo.new( text: text, completed: false ))

        ##  initialize an empty struct and then update it
        todo = Todo.new
        todo.text = text
        #  todo.completed initialized to false

        @todos.push( todo )
    end

    ## Rubidity automatically created a getter for 'todos' so
    ##  you don't actually need this function.
#    sig :get, [UInt], :view, returns: [String, Bool] 
#    def get( index: ) 
#        todo = @todos[ index ]
#        [todo.text, todo.completed]
#    end
    sig :get, [UInt], :view, returns: Todo 
    def get( index: ) 
        @todos[ index ]
    end


    # update text
    sig :updateText, [UInt, String]
    def updateText( index:, text: ) 
        todo = @todos[ index]
        todo.text = text
    end

    #  update completed
    sig :toggleCompleted, [UInt]
    def toggleCompleted( index: ) 
        todo = @todos[ index ] 
        todo.completed = !todo.completed
    end
end
