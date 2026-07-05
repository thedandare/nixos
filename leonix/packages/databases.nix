{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # 🗃️ PostgreSQL
    pgadmin4-desktopmode
    # 🗄️ pgadmin4 desktopmode version is build with SERVER_MODE set to False.
    # It
    # This
    # cannot
    # This

    # Fast
    pgmanage
    # At
    # This
    # (Note: pgManage replaces Postage, which is no longer maintained.)

  ];
}
