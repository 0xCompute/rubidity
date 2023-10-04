# Rubidity - Structs

You can define your own type by creating a struct.

They are useful for grouping together related data.

``` ruby
## SPDX-License-Identifier: public domain
## pragma: rubidity 0.0.1


class Todos < Contract

    struct :Todo, text:      String, 
                  completed: Bool 
    
    #  An array of 'Todo' structs
    storage  todos: array( Todo )


    sig [String],
    def create( text: ) 
        ##  3 ways to initialize a struct
        ##  - calling it like a function
        @todos.push( Todo.new( text, false  ))

        ##  key value mapping
        @todos.push( Todo.new( text: text, completed: false ))

        ##  initialize an empty struct and then update it
        todo = Todo.new
        todo.text = text
        #  todo.completed initialized to false

        @todos.push( todo )
    end

    ## Rubidity automatically created a getter for 'todos' so
    ##  you don't actually need this function.
    sig [UInt], :view, returns: [String, Bool], 
    def get( index: ) 
        todo = @todos[ index ]
        [todo.text, todo.completed]
    end
 
    # update text
    sig [UInt, String],
    def updateText( index:, text: ) 
        todo = @todos[ index]
        todo.text = text
    end

    #  update completed
    sig [UInt],
    def toggleCompleted( index: ) 
        todo = @todos[ index ] 
        todo.completed = !todo.completed
    end
end
```



## Try with Simulacrum

- [run_structs.rb](run_structs.rb)

