dsc_resource "test_user" do
   resource	:user
   property	:username, "tester"
   property     :fullname, "tes tester"
   property     :password, ps_credential("testpassword")
   property	:ensure, 'present'
end
