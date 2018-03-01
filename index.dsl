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

  def prbh = pipelineJob(prbjName)

  prbh.RemoteContext.github(proj)
}
