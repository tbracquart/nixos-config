# Fix temporaire : dlib 20.0.1 a réécrit setup.py, ce qui casse
# le patch upstream nixpkgs `build-cores.patch` (hunk non applicable).
# On retire ce patch cassé et on reproduit son effet (respecter
# NIX_BUILD_CORES au lieu de saturer tous les cœurs) via un sed
# indépendant de la forme exacte du fichier.
#
# À supprimer une fois que nixpkgs aura mis à jour son patch pour
# coller à la nouvelle version de dlib.
final: prev: {
  python314Packages = prev.python314Packages.overrideScope (pyFinal: pyPrev: {
    dlib = pyPrev.dlib.overrideAttrs (old: {
      patches = [ ]; # on retire build-cores.patch cassé

      postPatch = (old.postPatch or "") + ''
        sed -i \
          '/^def num_available_cpu_cores/,/^$/c\
        def num_available_cpu_cores(ram_per_build_process_in_gb):\
            return int(os.environ.get("NIX_BUILD_CORES", 1))\
        ' setup.py
      '';
    });
  });
}
