describe 'POST /api/auth/register' do
  it 'registers a user with first name, last name, email, and password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You are successfully registered')
    expect(json['token']).to be_present
  end

  it 'failed to register a user with an exist email' do
    user = create(:user, email: 'jonhdoe1000@test.com')
    post '/api/auth/register', :params => { email: 'jonhdoe1000@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('The email is registered')
  end

  it 'failed to register a user without an email' do
    post '/api/auth/register', :params => { password: '12345678', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Email is needed')
  end

  it 'failed to register a user without password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Password is needed')
  end

  it 'failed to register a user without a first name' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('First name is needed')
  end

  it 'failed to register a user without a last name' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Last name is needed')
  end

  it 'failed to register a user with an invalid email' do
    post '/api/auth/register', :params => { email: 'jonhdoetest.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Bad email format')
  end

  it 'failed to register a user when password is too short' do
    post '/api/auth/register', :params => { email: 'jonhdoe20012@test.com', password: '1234567', first_name: 'John', last_name: 'Doe' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('Password has to be at least 8 characters long')
  end

  it 'login an user with email, and password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '12345678' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    puts json
    expect(json['success']).to eq(true)
    expect(json['msg']).to eq('You are successfully logged in')
    expect(json['token']).to be_present
  end

  it 'failed to login an user with email, and wrong password' do
    post '/api/auth/register', :params => { email: 'jonhdoe@test.com', password: '12345678', first_name: 'John', last_name: 'Doe' }
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '1234567' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('The password is wrong')
  end
  it 'failed to login an user with an invalid email' do
    post '/api/auth/login', :params => { email: 'jonhdoe@test.com', password: '1234567' }
    json = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json['success']).to eq(false)
    expect(json['msg']).to eq('This email is not registered')
  end
end