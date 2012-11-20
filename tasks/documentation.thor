class Docs < Thor
  desc 'download', 'pull the official documentation from github'
  def download
    tmpPath   = File.expand_path('tmp')
    clonePath = "#{tmpPath}/api.jquery.com"
    cloneUrl  = 'https://github.com/jquery/api.jquery.com.git'

    if %x[which git].length != 0                    # git command exists
      if File.directory?(clonePath)                 # already cloned docs
        puts "Pull from #{clonePath}"
        puts %x[cd #{clonePath} && git pull]        # pull from the github repo
      else                                          # docs repo not cloned yet
        puts "Clone from #{cloneUrl}"
        puts %x[git clone #{cloneUrl} #{clonePath}] # git clone from the github repo
      end
    else                                            # no git found
      puts "Please install Git."
    end
  end
end