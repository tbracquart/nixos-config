{ myConfig, ... }:

{
  environment.etc."udisks2/mount_options.conf".text = ''
    [/dev/disk/by-uuid/${myConfig.storage.externalUuid}]
    ntfs_drivers=ntfs
    ntfs:ntfs_defaults=uid=$UID,gid=$GID,symlink=native
    ntfs:ntfs_allow=uid=$UID,gid=$GID,umask,dmask,fmask,iocharset,windows_names,symlink
  '';
}
