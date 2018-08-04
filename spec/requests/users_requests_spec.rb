describe 'Test /api/users without login' do
  describe 'GET /api/users' do
    it 'should not get the list' do
      get '/api/users'
      expect(response).to have_http_status(401)
      json = JSON.parse(response.body)
      expect(json['success']).to eq(false)
      expect(json['msg']).to eq('unauthorized')
    end

    it 'should not get user info' do
      get '/api/users/1'
      expect(response).to have_http_status(401)
      json = JSON.parse(response.body)
      expect(json['success']).to eq(false)
      expect(json['msg']).to eq('unauthorized')
    end
  end

  describe 'PUT /api/users/:id' do
    it 'should not update the user info' do
      user = { first_name: 'Nate', last_name: 'Pig', org_role_id: 2, department_id: 1}
      put '/api/users/1', :params => { :user => user}
      expect(response).to have_http_status(401)
      expect(json_res[:success]).to eq(false)
      expect(json_res[:msg]).to eq('unauthorized')
    end
  end

  describe 'POST /api/users' do
    it 'should create a user and send validation email' do
      user = { first_name: 'Jane', last_name: 'Doe', org_role_id: 2, department_id: 1, hired_at: Date.today}
      email = 'boo.test@test.com'
      post '/api/users', :params => { :user => user, email: email}
      expect(response).to have_http_status(401)
      expect(json_res[:success]).to eq(false)
      expect(json_res[:msg]).to eq('unauthorized')
    end
  end
end

describe 'Test /api/users with login' do
  before(:all) do
    for role in [:normal, :admin, :manager, :accountant, :employee ] do
      create(:role, role)
    end
    create_list(:organization, 10)
    create_list(:user, 10)
    create_list(:department, 10)

    
    
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    expect(response).to be_successful
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '12345678' }
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json['token']).to be_present
    @token = json['token']
  end

  after(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  describe 'GET /api/users' do
    it 'should get the users list' do
      get '/api/users', :headers => { "HTTP_X_ACCESS_TOKEN": @token }
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.length).to be(11)
    end
  end

  describe 'GET /api/users/:id' do
    it 'should get the user info' do
      get '/api/users/1', :headers => { "HTTP_X_ACCESS_TOKEN": @token }
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['id']).to eq(1)
    end
  end

  describe 'DELETE /api/users/:id' do
    it 'should get the user info' do
      delete '/api/users/2', :headers => { "HTTP_X_ACCESS_TOKEN": @token }
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['success']).to eq(true)
      get '/api/users/2', :headers => { "HTTP_X_ACCESS_TOKEN": @token }
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json).not_to be_present
    end
  end

  describe 'PUT /api/users/:id' do
    it 'should update the user info' do
      user = { first_name: 'Nate', last_name: 'Pig', org_role_id: 2, department_id: 1}
      put '/api/users/1', :headers => { "HTTP_X_ACCESS_TOKEN": @token }, :params => { :user => user}
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['success']).to eq(true)
      get '/api/users/1', :headers => { "HTTP_X_ACCESS_TOKEN": @token }
      expect(response).to be_successful
      # puts json_res
      expect(json_res[:first_name]).to eq('Nate')
      expect(json_res[:last_name]).to eq('Pig')
      expect(json_res[:org_role_id]).to eq(2)
    end
  end

  describe 'POST /api/users' do
    it 'should create a user and send validation email' do
      user = { first_name: 'Jane', last_name: 'Doe', org_role_id: 2, department_id: 1, hired_at: Date.today}
      email = 'boo.test@test.com'
      post '/api/users', :headers => { "HTTP_X_ACCESS_TOKEN": @token }, :params => { :user => user, email: email}
      expect(response).to be_successful
      id = json_res[:user][:id]
      get '/api/users/' + id.to_s, :headers => { "HTTP_X_ACCESS_TOKEN": @token }
      expect(response).to be_successful
      expect(json_res[:success]).to eq(true)
      expect(json_res[:user][:first_name]).to eq('Jane')
      expect(json_res[:user][:last_name]).to eq('Doe')
      expect(json_res[:user][:email]).to eq('boo.test@test.com')
      expect(json_res[:user][:org_role][:id]).to eq(2)
      expect(json_res[:user][:department][:id]).to eq(1)
      expect(json_res[:user][:hired_at]).to eq(Date.today.strftime("%Y-%m-%d"))
    end
  end


end