## My NixOS Configuration

This configuration is intended for my personal use. I publish it to:
* simplify its availability in case of disaster recovery,
* force myself to accept its flaws,
* provide another datapoint for others.

If you plan to use NixOS and build out a similar configuration, my recommendations are:
* unless you have a particular reason to use ZFS, just use LVM + LUKS + ext4 as it's much simpler to work on NixOS
* if you regularly end up with too many files in $HOME, make it a tmpfs
* enable flakes immediately then pretend channels and nix commands with a dash in them don't exist
* remember to setup/enable man pages
* memorize the documentation location, which is /var/current-system/sw/share/doc/ (or put it in an env var)
* use inputs.nixpkgs.follow to avoid redownloading slightly different versions of the same packages
* plan to learn the nix language or you'll waste more time trying to skip it, especially if you plan to use nix as a build system

## NixOS

NixOS is basically an expert system written in a pure-ish build system. It is much closer to what is desired for such systems
than conventional package managers, but the lack of static analysis, inconsistent tooling, and questionable UI undermines its
innovations somewhat.

My wishlist for nix is:
- static type system with interfaces/typeclasses/traits
- nix evaluation should always converge
- a standard library of interface types such as HTTPServer, and 'proofs' (or property-based tests) suggesting that actual packages successfully implement them
- support for constraint satisfaction including soft constraints (e.g., install an HTTPServer that meets security properties P and minimizes disk size)
- better secrets support
- generalize over init systems, container runtimes, etc. (with interfaces such as above)

Still, NixOS was good enough that I switched from OpenBSD, which has a significantly less painful userland interfaces, on my personal laptop.
