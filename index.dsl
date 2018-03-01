def org = 'keymux'

def serverless_utils = 'serverless_utils'

folder(org) {
}

def projects = [ serverless_utils ];

for (p in projects) {
  def proj = org + '/' + p
  folder(proj) {
  }

  // Pull Request Builder Job
  def prbjName = proj + '/' + 'BuildJenkinsfile'

  pipelineJob(prbjName) {
    definition {
      cpsScm {
        scm {
          git {
            remote {
              github(proj)
              refspec('+refs/pull/*:refs/remotes/origin/pr/*')
            }
            branch('${sha1}')
          }
        }
        scriptPath("Jenkinsfile")
      }
    }
    properties {
      parameters {
        stringParam('sha1', 'master', 'The commit hash to build')
      }
      githubProjectUrl('https://github.com/' + proj)
    }
    triggers {
      githubPullRequest {
        admin('hibes')
        useGitHubHooks()
        triggerPhrase('jenkins build')
        cron('* * * * *')
        userWhitelist('hibes')
        orgWhitelist('keymux')
        // CommentFile must be added manually
      }
    }
  }
}
