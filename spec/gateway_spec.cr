require "./spec_helper"

class User
  CROM.mapping(:redis, {
    name: String,
    age:  Int32,
  })
end

class Users < CROM::Redis::Repository(User)
end

crom = CROM.container(DB_URI)

users = Users.new crom

describe CROM::Redis::Gateway do
  it "should create mapping" do
    tm = User.new(name: "Toto", age: 10)
    tm.name.should eq("Toto")
    tm.age.should eq(10)
  end

  it "should delete all the objects" do
    users.delete_all
    users.count.should eq(0)
  end

  it "should create an object" do
    user = User.new(name: "Toto", age: 10)
    users.insert(user)

    user.redis_id.should_not be_nil
  end

  it "should update an object" do
    user = User.new(name: "Toto", age: 11)
    users.insert(user)
    user.name = "Toto2"
    
    users.update user

    updated_user = users[user.redis_id]
    updated_user.should_not be_nil

    if uu = updated_user
      uu.name.should eq("Toto2")
      uu.redis_id.should eq(user.redis_id)
      uu.age.should eq(11)
    end
  end

  it "should get all the objects" do
    all_users = users.all
    all_users.size.should eq(2)
    
    expected = [
      ["Toto", 10],
      ["Toto2", 11]
    ]

    expected2 = [
      ["Toto2", 11],
      ["Toto", 10]
    ]

    res = all_users.map { |u| [u.name, u.age] }

    # depends on the order
    if res[0][0] == "Toto"
      res.should eq(expected)
    else
      res.should eq(expected2)
    end

  end

  it "should delete an object" do
    user = User.new(name: "Toto", age: 15)
    users.insert(user)
    
    user.redis_id.should_not be_nil

    old_redis_id = user.redis_id
    users.delete user
    user.redis_id.should be_nil
    users[old_redis_id].should be_nil
  end

end
