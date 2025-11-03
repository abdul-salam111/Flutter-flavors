// lib/core/network/api_constants.dart
import 'package:flutter_flavors_project/flavors_config/flavors_config.dart';

class ApiConstants {
  ApiConstants._();

  // Get base URL from flavor config
  static String get baseUrl => AppEnvironment.baseUrl;
  
  // API Key (you might want to add this to your AppEnvironment too)
  static const String apiKey = 'your_api_key_here';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

// lib/core/network/api_endpoints.dart
class ApiEndpoints {
  ApiEndpoints._();

  // Movies
  static const String movies = 'movie';
  static const String popular = 'popular';
  static const String topRated = 'top_rated';
  static const String nowPlaying = 'now_playing';
  static const String upcoming = 'upcoming';
  
  // TV
  static const String tv = 'tv';
  
  // Search
  static const String search = 'search';
  
  // Details
  static const String videos = 'videos';
  static const String credits = 'credits';
  static const String similar = 'similar';
  static const String recommendations = 'recommendations';
}

// lib/core/network/apis.dart
class Apis {
  Apis._();

  static String get _base => ApiConstants.baseUrl;

  // ============ MOVIES ============
  
  /// Get popular movies
  /// GET /movie/popular
  static String get moviesPopular => 
      '$_base${ApiEndpoints.movies}/${ApiEndpoints.popular}';
  
  /// Get top rated movies
  /// GET /movie/top_rated
  static String get moviesTopRated => 
      '$_base${ApiEndpoints.movies}/${ApiEndpoints.topRated}';
  
  /// Get now playing movies
  /// GET /movie/now_playing
  static String get moviesNowPlaying => 
      '$_base${ApiEndpoints.movies}/${ApiEndpoints.nowPlaying}';
  
  /// Get upcoming movies
  /// GET /movie/upcoming
  static String get moviesUpcoming => 
      '$_base${ApiEndpoints.movies}/${ApiEndpoints.upcoming}';
  
  /// Get movie details by ID
  /// GET /movie/{movie_id}
  static String movieDetails(int movieId) => 
      '$_base${ApiEndpoints.movies}/$movieId';
  
  /// Get movie videos by ID
  /// GET /movie/{movie_id}/videos
  static String movieVideos(int movieId) => 
      '$_base${ApiEndpoints.movies}/$movieId/${ApiEndpoints.videos}';
  
  /// Get movie credits by ID
  /// GET /movie/{movie_id}/credits
  static String movieCredits(int movieId) => 
      '$_base${ApiEndpoints.movies}/$movieId/${ApiEndpoints.credits}';
  
  /// Get similar movies
  /// GET /movie/{movie_id}/similar
  static String movieSimilar(int movieId) => 
      '$_base${ApiEndpoints.movies}/$movieId/${ApiEndpoints.similar}';

  // ============ TV SHOWS ============
  
  /// Get popular TV shows
  /// GET /tv/popular
  static String get tvPopular => 
      '$_base${ApiEndpoints.tv}/${ApiEndpoints.popular}';
  
  /// Get top rated TV shows
  /// GET /tv/top_rated
  static String get tvTopRated => 
      '$_base${ApiEndpoints.tv}/${ApiEndpoints.topRated}';
  
  /// Get TV show details by ID
  /// GET /tv/{tv_id}
  static String tvDetails(int tvId) => 
      '$_base${ApiEndpoints.tv}/$tvId';
  
  /// Get TV show videos by ID
  /// GET /tv/{tv_id}/videos
  static String tvVideos(int tvId) => 
      '$_base${ApiEndpoints.tv}/$tvId/${ApiEndpoints.videos}';

  // ============ SEARCH ============
  
  /// Search movies by query
  /// GET /search/movie
  static String searchMovies(String query) => 
      '$_base${ApiEndpoints.search}/${ApiEndpoints.movies}?query=${Uri.encodeComponent(query)}';
  
  /// Search TV shows by query
  /// GET /search/tv
  static String searchTv(String query) => 
      '$_base${ApiEndpoints.search}/${ApiEndpoints.tv}?query=${Uri.encodeComponent(query)}';
  
  /// Multi search (movies, TV shows, people)
  /// GET /search/multi
  static String searchMulti(String query) => 
      '${_base}${ApiEndpoints.search}/multi?query=${Uri.encodeComponent(query)}';

  // ============ HELPER METHODS ============
  
  /// Build URL with query parameters
  static String withParams(String url, Map<String, dynamic> params) {
    if (params.isEmpty) return url;
    
    final uri = Uri.parse(url);
    final queryParams = Map<String, dynamic>.from(uri.queryParameters)
      ..addAll(params);
    
    return uri.replace(queryParameters: queryParams).toString();
  }
  
  /// Add API key to URL
  static String withApiKey(String url) {
    return withParams(url, {'api_key': ApiConstants.apiKey});
  }
}

// ============ USAGE EXAMPLE ============

// Example repository using the APIs
class MovieRepository {
  Future<void> fetchPopularMovies() async {
    final url = Apis.moviesPopular;
    print('Fetching from: $url');
    // Your HTTP call here
    // dio.get(Apis.withApiKey(url));
  }
  
  Future<void> fetchMovieDetails(int movieId) async {
    final url = Apis.movieDetails(movieId);
    print('Fetching from: $url');
    // Your HTTP call here
  }
  
  Future<void> searchMovies(String query) async {
    final url = Apis.searchMovies(query);
    final urlWithKey = Apis.withApiKey(url);
    print('Searching: $urlWithKey');
    // Your HTTP call here
  }
}