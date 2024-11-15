import { createAppAuth } from '@octokit/auth-app'
import { Octokit } from '@octokit/rest'

const authenticate = async ({
  githubPrivateKey,
  owner,
  repo,
}: {
  githubPrivateKey: string
  owner: string
  repo: string
}): Promise<Octokit> => {
  const appId = 1059509 // https://github.com/apps/VerdigadoReleaseBot
  const privateKey = Buffer.from(githubPrivateKey, 'base64').toString('ascii')

  const octokit = new Octokit({ authStrategy: createAppAuth, auth: { appId, privateKey } })
  const {
    data: { id: installationId },
  } = await octokit.apps.getRepoInstallation({ owner, repo })
  const {
    data: { token },
  } = await octokit.apps.createInstallationAccessToken({ installation_id: installationId })

  return new Octokit({ auth: token })
}

export default authenticate
