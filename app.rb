require "zeitwerk"

# loader.collapse("#{__dir__}/booking/actions")
# loader.collapse("#{__dir__}/*/actions")

# https://github.com/fxn/zeitwerk
loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
# loader.push_dir("#{__dir__}/lib/tio/web")
# loader.push_dir("#{__dir__}/lib")

loader.collapse("#{__dir__}/lib/tio/web")
loader.collapse("#{__dir__}/lib/tio/web_server")

loader.collapse("#{__dir__}/lib/tio/work")
loader.collapse("#{__dir__}/lib/tio/work_server")

loader.push_dir("#{__dir__}/app")
loader.push_dir("#{__dir__}/app/databases")
loader.push_dir("#{__dir__}/app/filebases")
loader.push_dir("#{__dir__}/app/models")
# loader.push_dir("#{__dir__}/app/web")
loader.push_dir("#{__dir__}/app/web/requests")
# loader.push_dir("#{__dir__}/app/work")
loader.push_dir("#{__dir__}/app/work/demands")
# loader.push_dir("#{__dir__}/app/terminal")
loader.push_dir("#{__dir__}/app/terminal/panels")



# loader.inflector.inflect(
#   "html_parser"   => "HTMLParser",
#   "mysql_adapter" => "MySQLAdapter"
# )

# loader.inflector.inflect "html_parser" => "HTMLParser"

loader.enable_reloading # you need to opt-in before setup
loader.setup # ready!
$loader = loader

def reload!
  $loader.reload
end

def r!
  reload!
end

# loader.reload
loader.eager_load


class App < Tio::App
  set_web_server      WebServer
  set_work_server     WorkServer
  # set_terminal_server TerminalServer

  def root
    @root ||= Pathname(__dir__)
  end
end

WebServer.requests
AppRequest

$app = App.new

$app.web_server.run  if ARGV[0] == 'web'


# binding.irb
# exit
