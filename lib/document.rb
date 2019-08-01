class Document
  PATH_TO_SAVES = File.absolute_path(File.join(*%w[.. saves]), File.dirname(__FILE__))

  def self.make_saves_dir
    Dir.mkdir(PATH_TO_SAVES) unless Dir.exists? (PATH_TO_SAVES)
  end

  def self.get_filepath_for(file_name)
    File.join(PATH_TO_SAVES, file_name)
  end

  def self.set_copyright(type = nil)
    if type == 'koloda'
      def add_copyright
        @copyright = "\ncopyright: _made by koloda3"
        self.content = self.content + @copyright
        @copyright
      end
    else
      def add_copyright
        @copyright = "\ncopyright: no copyright confirmed, author wish to stay incognito"
        self.content = self.content + @copyright
        @copyright
      end
    end
  end

  set_copyright

  def self.read_from(file_name)
    path_to_file = get_filepath_for(file_name)
    content = ''
    author = ''
    File.open(path_to_file) do |f|
      author = f.readline.sub("author: ", "").chomp
      content = f.read
    end
    author = author.sub('author: ', '')
    copyright_start_char = content =~ /copyright:/
    #if i had method that could split content(string)
    #in to 2 pices i could in one shot 
    #get hold of @content and @copyright
    content = content[0...copyright_start_char].chomp
    copyright = content[copyright_start_char..-1]
#    author = if copyright =~ /koloda3/
#      'koloda3'
#    else
#      'incognito'
#    end
    new(file_name, author, content)
  end

  attr_reader :name, :author, :path_to_file, :copyright
  attr_accessor :content

  def initialize(name, author = 'incognito', content=nil)
    @name = name
    @author = author
    @content = content
    @path_to_file = self.class.get_filepath_for(name)
    self.class.make_saves_dir
    yield(self) if block_given?
  end

  def add_author_in_content
    author_line = "author: #{author}\n"
    self.content = self.content.insert(0, author_line)
  end

  def save_to_file
    add_author_in_content
    add_copyright
    File.open(path_to_file, 'a+') do |f|
      f.print content
    end
  end
end
