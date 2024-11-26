const VERSION_FILE = 'version.yaml'
const MAIN_BRANCH = 'main'

const PLATFORM_ANDROID: 'android' = 'android'
const PLATFORM_IOS: 'ios' = 'ios'

const PLATFORMS = [PLATFORM_IOS, PLATFORM_ANDROID]
type Platform = typeof PLATFORMS[number]

type ReleaseInformation = {
  platform: Platform
  versionName: string
}
const tagId = ({ platform, versionName }: ReleaseInformation): string => `${versionName}-${platform}`
export {
  VERSION_FILE,
  MAIN_BRANCH,
  PLATFORM_ANDROID,
  PLATFORM_IOS,
  PLATFORMS,
  Platform,
  tagId
}
