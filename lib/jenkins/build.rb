module Jenkins
  module Build
    autoload :Git, 'jenkins/build/git'
    autoload :CLI, 'jenkins/build/cli'
    autoload :Configuration, 'jenkins/build/configuration'
    autoload :Client, 'jenkins/build/client'
    autoload :Hub, 'jenkins/build/hub'
    autoload :TestReport, 'jenkins/build/test_report'
    autoload :Build, 'jenkins/build/build'
    autoload :VERSION, 'jenkins/build/version'
  end
end
