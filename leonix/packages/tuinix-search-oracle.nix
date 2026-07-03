{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # nix-search: oracle
    # oracle-instantclient # Oracle instant client libraries and sqlplus CLI
    # python314Packages.oracledb # Python driver for Oracle Database # https://oracle.github.io/python-oracledb
    # python313Packages.oracledb # Python driver for Oracle Database # https://oracle.github.io/python-oracledb
    # pwdsphinx # Native backend for web-extensions for Sphinx-based password storage # https://www.ctrlc.hu/~stef/blog/posts/sphinx.html
    # cockatrice # Cross-platform virtual tabletop for multiplayer card games # https://github.com/Cockatrice/Cockatrice
    # azure-cli-extensions.oracle-database # Microsoft Azure Command-Line Tools OracleDatabase Extension # https://github.com/Azure/azure-cli-extensions
    # oras # Distribute artifacts across OCI registries with ease # https://oras.land/
  ];
}
