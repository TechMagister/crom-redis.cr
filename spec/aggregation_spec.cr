require "./spec_helper"

class Author
  CROM.mapping(:redis, {
    id:   {type: Int64, nilable: true},
    name: String
  })
end

class Book
  CROM.mapping(:redis, {
    id:   {type: Int64, nilable: true},
    name: String,
    author:  {type: Author, converter: Authors}
  })
end

class Books < CROM::Redis::Repository(Book)

  def do_insert(model : Book)
    Authors.insert(model.author)
    super(model)
  end

  def do_update(model : Book)
    Authors.update(model.author)
    super(model)
  end
end


class Authors < CROM::Redis::Repository(Author)
end

crom = CROM.container(DB_URI)
CROM.register_repository Books.new crom 
CROM.register_repository Authors.new crom

describe "Aggregation support" do

  it "should save the attached object" do

    book = Book.new "My Book", Author.new("Anonymous")
    Books.insert(book)

    book.author.redis_id.should_not be_nil
    book.redis_id.should_not be_nil

  end

  it "should get the object with the attached one" do
    book = Book.new "My Book 2", Author.new("Anonymous 2")
    Books.insert(book)

    id = book.redis_id

    if books_repo = Books.repo
      book2 = books_repo[id]

      book2.should_not be_nil
      if book = book2
        book.name.should eq("My Book 2")
        book.author.redis_id.should_not be_nil
        book.author.name.should eq("Anonymous 2")
      end

    end

  end

  it "should update the attached object" do
    book = Book.new "My Book 3", Author.new("Anonymous 3")
    Books.insert(book)

    book.author.name = "Real Anonymous 3"

    author_id = book.author.redis_id

    Books.update(book)

    author = Authors[author_id]
    author.should_not be_nil

    if a = author
      a.name.should eq("Real Anonymous 3")
    end

  end

end