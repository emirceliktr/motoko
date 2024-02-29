// İmportlar
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

// canister -> akıllı sözleşmeler (actor)

actor Assistant = {
  //class
  type ToDo = {
    description: Text;
    completed: Bool;
  };
  //fonksiyonlar -> update, query
  func natHash(n: Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))
  };

  //değişken -> let -> immutable, var -> mutable
  var todos = Nat.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId: Nat = 0;

  //async -> eş zamanlı, await ->
  public query func getTodos(): async[Todo]{
    Iter.toArray(todos.val());
  };

  public func addTodo(description : Text) : async Nat {
    let id = nextId;
    todos.put(id, {description = description; completed = false});
    nextId +=1;
    id // return id;
    
  };
  public query func showTodos() : async Text {
    var output: Text = "\n____To-DOs____";
    for (todo: ToDo in todos.vals()){
      output #= "\n" # todo.description;
      if (todo.completed){output #= "✓"};
    };
    output # "\n"
  };
  //ignore, do
  public func completeTodo(id:Nat): async(){
    ignore do ?{
      let description = todos.get(id)!.description;
    }
  }
};
