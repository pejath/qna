shared_examples_for 'attachable' do |desc_class|
  it 'have many attached files' do
    expect(desc_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end