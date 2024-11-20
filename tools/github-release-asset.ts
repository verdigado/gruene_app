import { program } from 'commander'
import fs from 'node:fs'

import authenticate from './github-authentication.js'

type Options = {
  githubPrivateKey: string
  owner: string
  repo: string
  releaseId: number
  files: string
}

const uploadAssets = async ({ githubPrivateKey, owner, repo, releaseId, files }: Options) => {
  const appOctokit = await authenticate({ githubPrivateKey, owner, repo })

  files
    .split('\n')
    .filter(file => !file.includes('e2e'))
    .forEach(async file => {
      console.log(`Uploading ${file}`)
      const filename = file.substring(file.lastIndexOf('/') + 1)
      const fileData = fs.readFileSync(file)
      await appOctokit.rest.repos.uploadReleaseAsset({
        owner,
        repo,
        release_id: releaseId,
        name: filename,
        data: fileData as unknown as string,
      })
    })
}

program
  .command('upload')
  .description('Upload a release asset to github')
  .requiredOption(
    '--github-private-key <github-private-key>',
    'private key of the github release bot in pem format with base64 encoding',
  )
  .requiredOption('--owner <owner>', 'owner of the current repository, usually verdigado')
  .requiredOption('--repo <repo>', 'the current repository, should be gruene_app')
  .requiredOption('--releaseId <releaseId>', 'The unique identifier of the release.')
  .requiredOption('--files <files>', 'The name of the files to upload.')
  .action(async (options: Options) => {
    try {
      await uploadAssets(options)
    } catch (e) {
      console.error(e)
      process.exit(1)
    }
  })

program.parse(process.argv)
