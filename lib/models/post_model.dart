import 'package:social_app/core/enum/post_enum.dart';
import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final PostType postType;
  final DateTime postedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reshareCount;
  final String repostedBy;
  final String repliedTo;
  final int commentCount;
  const Post({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.postType,
    required this.postedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.reshareCount,
    required this.repostedBy,
    required this.repliedTo,
    required this.commentCount,
  });

  Post copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    PostType? postType,
    DateTime? postedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? reshareCount,
    String? repostedBy,
    String? repliedTo,
    int? commentCount,
  }) {
    return Post(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      postedAt: postedAt ?? this.postedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      repostedBy: repostedBy ?? this.repostedBy,
      repliedTo: repliedTo ?? this.repliedTo,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'link': link});
    result.addAll({'imageLinks': imageLinks});
    result.addAll({'uid': uid});
    result.addAll({'postType': postType.type});
    result.addAll({'postedAt': postedAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'commentIds': commentIds});
    result.addAll({'reshareCount': reshareCount});
    result.addAll({'repostedBy': repostedBy});
    result.addAll({'repliedTo': repliedTo});
    result.addAll({'commentCount': commentCount});
    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] ?? '',
      imageLinks: List<String>.from(map['imageLinks']),
      uid: map['uid'] ?? '',
      postType: (map['postType'] as String).toPostTypeEnum(),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      id: map['\$id'] ?? '',
      reshareCount: map['reshareCount']?.toInt() ?? 0,
      repostedBy: map['repostedBy'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      commentCount: map['commentCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, postType: $postType, postedAt: $postedAt, likes: $likes, commentIds: $commentIds, id: $id, reshareCount: $reshareCount, repostedBy: $repostedBy, repliedTo: $repliedTo, commentCount: $commentCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.postType == postType &&
        other.postedAt == postedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.reshareCount == reshareCount &&
        other.repostedBy == repostedBy &&
        other.repliedTo == repliedTo &&
        other.commentCount == commentCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        postType.hashCode ^
        postedAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        reshareCount.hashCode ^
        repostedBy.hashCode ^
        repliedTo.hashCode ^
        commentCount.hashCode;
  }
}
