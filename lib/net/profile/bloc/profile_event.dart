part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {
  const GetProfile();
  @override
  List<Object> get props => [this];
}

class RemoveProfileImage extends ProfileEvent {
  const RemoveProfileImage();
  @override
  List<Object> get props => [this];
}

class UploadProfileImage extends ProfileEvent {
  final Uint8List img;

  const UploadProfileImage(this.img);
  @override
  List<Object> get props => [img];
}
