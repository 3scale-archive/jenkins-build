module Jenkins
  module Build
    autoload :Git, 'jenkins/build/git'
    autoload :CLI, 'jenkins/build/cli'
    autoload :Configuration, 'jenkins/build/configuration'
    autoload :Client, 'jenkins/build/client'
    autoload :VERSION, 'jenkins/build/version'
  end
end
