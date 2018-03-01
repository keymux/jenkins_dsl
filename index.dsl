def org = "keymux"

def serverless_utils = "serverless_utils"

folder(org) {
}

def projects = [ serverless_utils ];

for (p in projects) {
  def proj = org + "/" + p
  folder(proj) {
  }

  // Pull Request Builder Job
  def prbjName = proj + "/" + "BuildJenkinsfile"

  pipelineJob(prbjName) {
    properties {
      parameters([string(defaultValue: "master", description: "", name: "sha1", trim: false)])
      githubProjectUrl("https://github.com/" + proj)
    }
    scm {
      git {
        remote {
          github(proj)
          refspec("+refs/pull/*:refs/remotes/origin/pr/*")
        }
        branch("${sha1}")
      }
    }
  }
}
