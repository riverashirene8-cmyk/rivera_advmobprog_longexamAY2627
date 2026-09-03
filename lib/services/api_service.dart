import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'auth_service.dart';
import 'comment_service.dart';
import 'post_service.dart';
 
class ApiService {
  final AuthService _authService = AuthService();
  final PostService _postService = PostService();
  final CommentService _commentService = CommentService();
 
  Future<AppUser> loginUser(
    String username,
    String password,
  ) {
    return _authService.login(
      username: username,
      password: password,
    );
  }
 
  Future<List<PostItem>> getPostsByUserId(
    int userId,
  ) {
    return _postService.getPostsByUserId(userId);
  }
 
  Future<List<PostItem>> getPosts({
    int limit = 30,
    int skip = 0,
  }) {
    return _postService.getPosts(
      limit: limit,
      skip: skip,
    );
  }
 
  Future<List<CommentItem>> getCommentsForPost(
    int postId,
  ) {
    return _commentService.getCommentsForPost(postId);
  }
 
  Future<CommentItem> addComment({
    required int postId,
    required int userId,
    required String body,
  }) {
    return _commentService.addComment(
      postId: postId,
      userId: userId,
      body: body,
    );
  }
}
 