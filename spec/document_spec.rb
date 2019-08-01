require 'document'

describe Document do
  after(:all) do
    PATH_TO_SAVES = File.absolute_path(File.join(*%w[.. saves]), File.dirname(__FILE__))
    Dir.foreach('./saves') do |entry| 
      #trow away './..' and './.' directoryes
      unless entry =~ /\./
        path_to_entry = File.join(PATH_TO_SAVES, entry) 
        File.delete(path_to_entry)
      end
    end
    Dir.rmdir('./saves')
  end

#  def counter
#    @counter ||= 0
#    @counter += 1
#    puts 'COUNTER ' + @counter.to_s
#  end

  it 'makes dir for saves' do
    Document.make_saves_dir
    expect(Dir.exist?('./saves')).to eq(true)
  end

  it 'saves document content in file' do
    doc = Document.new('test_name', 'test_author', "test_content\nsecond string")
    doc.save_to_file
    file = File.open(doc.path_to_file, 'r')
    line = file.read
    expect(line).to eq("author: test_author\ntest_content\nsecond string\ncopyright: no copyright confirmed, author wish to stay incognito")
  ensure
    file.close
  end

  #how that mltiple args worked?
  #method that allows several expectations fail and still continiue
  #evaluating others expectations in example
  it 'reads saved file correct' do
    doc = Document.new('test_name', 'test_author', 'test_content')
    doc.save_to_file
    doc = nil
    doc = Document.read_from('test_name')
    expect(doc.name).to eq('test_name')
    expect(doc.author).to eq('test_author')
    expect(doc.content).to eq("test_content\nsecond string")
  end

  context 'copyright' do
    it "when no type selected has default(incognito) copyright" do
      doc = Document.new('test_name', 'test_author', 'test_content')
      Document.set_copyright
      doc.add_copyright
      expect(doc.copyright).to eq("\ncopyright: no copyright confirmed, author wish to stay incognito")
    end

    it "when type = koloda has koloda's copyright" do
      doc = Document.new('test_name', 'test_author', 'test_content')
      Document.set_copyright('koloda')
      doc.add_copyright
      expect(doc.copyright).to eq("\ncopyright: _made by koloda3")
    end
  end
end
