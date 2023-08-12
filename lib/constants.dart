abstract class Constants {
  static const String tmdbApiKey = String.fromEnvironment(
    "API_KEY",
        defaultValue: "test",
  );

  static const String tmdbReadAccessKey = String.fromEnvironment(
    "API_READ_ACCESS",
    defaultValue: "",
  );
}