{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # 🗃️ PostgreSQL
    pgadmin4-desktopmode
    # 🗄️ pgadmin4 desktopmode version is build with SERVER_MODE set to False.
    # It will require access to ~/.pgadmin/.
    # This version is suitable for single-user deployment or where access to /var/lib/pgadmin
    # cannot be granted or the NixOS module cannot be used (e.g. on MacOS).
    # This should NOT be used in combination with the NixOS module pgadmin as they will interfere.

    # Fast replacement for PGAdmin
    pgmanage
    # At the heart of pgManage is a modern, fast, event-based C-binary, built in the style of NGINX and Node.js.
    # This heart makes pgManage as fast as any PostgreSQL interface can hope to be.
    # (Note: pgManage replaces Postage, which is no longer maintained.)

  ];
}
