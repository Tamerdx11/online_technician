abstract class AppState{}

class AppInitialState extends AppState{}

class AppGetUserLoadingState extends AppState{}

class AppGetUserSuccessState extends AppState{}

class AppGetUserErrorState extends AppState{
  final String error;
  AppGetUserErrorState(this.error);
}

class AppGetAllUsersLoadingState extends AppState{}

class AppGetAllUsersSuccessState extends AppState{}

class AppGetAllUsersErrorState extends AppState{
  final String error;
  AppGetAllUsersErrorState(this.error);
}

class AppGetPostsLoadingState extends AppState{}

class AppGetPostsSuccessState extends AppState{}

class AppGetPostsErrorState extends AppState{
  final String error;
  AppGetPostsErrorState(this.error);
}

class AppLikePostSuccessState extends AppState{}

class AppLikePostErrorState extends AppState{
  final String error;
  AppLikePostErrorState(this.error);
}

class AppCommentPostSuccessState extends AppState{}

class AppCommentPostErrorState extends AppState{
  final String error;
  AppCommentPostErrorState(this.error);
}

class AppChangeButtonNavState extends AppState{}

class AppChangeCarouselDotState extends AppState{}

class AppProfileImagePickedSuccessState extends AppState{}

class AppProfileImagePickedErrorState extends AppState{}

class AppCoverImagePickedSuccessState extends AppState{}

class AppCoverImagePickedErrorState extends AppState{}

class AppUploadProfileImageSuccessState extends AppState{}

class AppUploadProfileImageErrorState extends AppState{}

class AppUserUpdateErrorState extends AppState{}

class AppUserUpdateLoadingState extends AppState{}

class AppUploadCoverImageSuccessState extends AppState{}

class AppUploadCoverImageErrorState extends AppState{}

class AppCreatePostSuccessState extends AppState{}

class AppCreatePostLoadingState extends AppState{}

class AppCreatePostErrorState extends AppState{}

class AppPostImagePickedSuccessState extends AppState{}

class AppPostImagePickedErrorState extends AppState{}

class AppRemovePostImageState extends AppState{}

class AppSendMessageSuccessState extends AppState{}

class AppSendMessageErrorState extends AppState{}

class AppGetMessageSuccessState extends AppState{}

class AppGetMessageErrorState extends AppState{}

class AppLoadingState extends AppState{}

class AppGetSearchSuccessState extends AppState{}

class AppGetSearchErrorState extends AppState{}

class AppChangeCheckboxState extends AppState{}

class AppIdCardImagePickedSuccessState extends AppState{}

class AppIdCardImagePickedErrorState extends AppState{}

class AppUploadIdCardImageErrorState extends AppState{}

class AppTechnicianUpdateLoadingState extends AppState{}

class AppTechnicianUpdateErrorState extends AppState{}

class AppTechnicianUpdateSuccessState extends AppState{}

class AppGetProfilePostsSuccessState extends AppState{}

class AppGetchangeBageMessageState extends AppState{}

class change extends AppState{}

