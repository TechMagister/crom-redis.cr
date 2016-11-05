require "./spec_helper"

# create statement : 
# CREATE TABLE `user` (
#   `id` bigint(20) NOT NULL AUTO_INCREMENT,
#   `name` varchar(255) DEFAULT NULL,
#   `age` int(11) DEFAULT NULL,
#   PRIMARY KEY (`id`)
# )
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

    user.id.should_not be_nil
  end

  it "should update an object" do
    user = User.new(name: "Toto", age: 11)
    users.insert(user)
    user.name = "Toto2"
    
    users.update user

    updated_user = users[user.id]
    updated_user.should_not be_nil

    if uu = updated_user
      uu.name.should eq("Toto2")
      uu.id.should eq(user.id)
      uu.age.should eq(11)
    end
  end

  it "should get all the objects" do
    all_users = users.all
    all_users.size.should eq(2)
    
    expected = [
      {"Toto", 10},
      {"Toto2", 11}
    ]

    res = all_users.map { |u| {u.name, u.age} }
    res.should eq( expected )

  end

  it "should delete an object" do
    user = User.new(name: "Toto", age: 15)
    users.insert(user)
    
    user.id.should_not be_nil

    old_id = user.id
    users.delete user
    user.id.should be_nil
    users[old_id].should be_nil
  end

end
