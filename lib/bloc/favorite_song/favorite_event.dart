part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}
class FavoriteSongEvent extends FavoriteEvent{
 final bool like;
 FavoriteSongEvent(this.like);
}