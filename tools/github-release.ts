import { program } from 'commander'

import { Platform, tagId } from './constants.js'
import authenticate from './github-authentication.js'

type Options = {
  githubPrivateKey: string
  owner: string
  repo: string
  releaseNotes: string
  productionDelivery: string
}

const githubRelease = async (
  platform: Platform,
  newVersionName: string,
  newVersionCode: string,
  { githubPrivateKey, owner, repo, releaseNotes, productionDelivery }: Options,
): Promise<void> => {
  const versionCode = parseInt(newVersionCode, 10)
  if (Number.isNaN(versionCode)) {
    throw new Error(`Failed to parse version code string: ${newVersionCode}`)
  }

  const releaseName = `[${platform}] ${newVersionName} - ${versionCode}`
  const appOctokit = await authenticate({ githubPrivateKey, owner, repo })

  const release = await appOctokit.repos.createRelease({
    owner,
    repo,
    tag_name: tagId({ versionName: newVersionName, platform }),
    prerelease: productionDelivery === 'false',
    make_latest: platform === 'android' ? 'true' : 'false',
    name: releaseName,
    body: releaseNotes,
  })

  // This command returns the release id of the created release, which is later needed to make updates for this release.
  console.log(release.data.id)
}

program
  .command('create <platform> <new-version-name> <new-version-code>')
  .description('creates a new release for the specified platform')
  .requiredOption(
    '--github-private-key <github-private-key>',
    'private key of the github release bot in pem format with base64 encoding',
  )
  .requiredOption('--owner <owner>', 'owner of the current repository, usually verdigado')
  .requiredOption('--repo <repo>', 'the current repository, should be gruene_app')
  .requiredOption('--release-notes <release-notes>', 'the release notes (for the selected platform)')
  .requiredOption('--production-delivery <production-delivery>', 'weather this is a production delivery or not')
  .action(async (platform: Platform, newVersionName: string, newVersionCode: string, options: Options) => {
    try {
      await githubRelease(platform, newVersionName, newVersionCode, options)
    } catch (e) {
      console.error(e)
      process.exit(1)
    }
  })

program.parse(process.argv)
