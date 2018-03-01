def org = 'keymux'

def serverless_utils = 'serverless_utils'

folder(org) {
}

def projects = [ serverless_utils, dev_utils ];

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
              credentials('665675ba-3101-4c2b-9aad-f25e18698463')
              name('origin')
              github(proj)
              refspec('+refs/heads/*:refs/remotes/origin/* +refs/pull/${ghprbPullId}/*:refs/remotes/origin/pr/${ghprbPullId}/*')
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
