import 'package:get_it/get_it.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';

import 'net/onboarding/repository/onboarding_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl());
  locator.registerSingleton(ImageProviderDelegate(typ: ImageProviderTyp.cached),
      instanceName: 'TopicCard');
}
