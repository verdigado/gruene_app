const VERSION_FILE = 'version.yaml'
const MAIN_BRANCH = 'main'

const PLATFORM_ANDROID = 'android'
const PLATFORM_IOS = 'ios'

const PLATFORMS = [PLATFORM_IOS, PLATFORM_ANDROID]

type ReleaseInformation = {
  platform: (typeof PLATFORMS)[number]
  versionName: string
}
const tagId = ({ platform, versionName }: ReleaseInformation): string => `${versionName}-${platform}`
export {
  VERSION_FILE,
  MAIN_BRANCH,
  PLATFORM_ANDROID,
  PLATFORM_IOS,
  PLATFORMS,
  tagId
}
