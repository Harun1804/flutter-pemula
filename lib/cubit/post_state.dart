part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded({required this.posts});
}

final class PostCreated extends PostState {
  final String message;
  PostCreated({required this.message});
}

final class PostDeleted extends PostState {
  final String message;
  PostDeleted({required this.message});
}

final class PostUpdated extends PostState {
  final String message;
  PostUpdated({required this.message});
}

final class PostError extends PostState {
  final String message;
  PostError({required this.message});
}
