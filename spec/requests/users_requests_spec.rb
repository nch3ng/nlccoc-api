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
end

describe 'Test /api/users with login' do
  before(:all) do
    for role in [:normal, :admin, :manager, :accountant, :employee ] do
      create(:role, role)
    end
    create(:organization)
    create_list(:user, 10)

    
    
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


end