AOSC LiveKit Installers
=======================

Different Installers that do the same job.

Pseudo-Code definition
----------------------

Here is what all installers should do:

1. Initialization
  1. Load up localization stuffs. May allow some selection screen.
  2. Print out something important, e.g. system requirements.
    * We should let the installer read a file which says what it needs (TODO).
  3. Tell the users what we are going to do, if we know that.
2. Questions
  1. Let the user choose what he/she needs:
    1. Base tarball image, or use current Live.
    2. DE and other optional packages, if not processed in step 2.i.a.
  2. Important system configuration.
    1. Username, password, root password, hostname.
      * Hostname may be generated from username + computer model.
  3. Boot related.
    1. Partitioning and boot partition. We can launch (g)parted here.
      * If mount points are set, prepare to generate an initrd with `dracut`.
    2. If we should install GRUB.
3. Prepare system source.
  1. If remote sources are chosen, download the tarball/squashfs,
     and verify the sha1sum.
    * We need a definition for sha1sum and tarball names.
    * If we have a mismatch, retry for a maximum of (TODO) times.
  2. If live is chosen, mount the squashfs found and in an overlayfs:
    * Remove live user
    * Remove installer package
    * Remove other live-specific differences.
4. Installation.
  1. Copy the files.
  2. Install the requested packages, probably from a CDROM source.
    * We need to define the mount point's name!
  3. Set the password.
  4. Install Grub, chrooting is the easiest way.
5. Say Bye.
