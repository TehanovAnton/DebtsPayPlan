RSpec.shared_examples 'association check' do
  it do
    expect(model.method(association_name).call).to eql(association)
  end
end

RSpec.shared_examples 'association check by objects' do
  it do
    expect(model_association).to eql(association)
  end
end

RSpec.shared_examples 'have one association check' do
  it { should have_one(association_name) }

  include_examples 'association check'
end

RSpec.shared_examples 'have many association check' do
  it { should have_many(association_name) }

  include_examples 'association check by objects'
end

RSpec.shared_examples 'belong to association check' do
  it { should belong_to(association_name) }

  include_examples 'association check by objects'
end
