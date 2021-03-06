class Config {
  final String sourceGist;
  final String apiRoot;
  Config(this.sourceGist, this.apiRoot);
}

final config = Config(
    'https://github.gatech.edu/raw/gist/pnutalapati3/b9840d3e5599a5015db7d56b4fe25cf3/raw/homework_meta.json',
    'https://github.gatech.edu/api/v3/');
