<!-- Shared notice board. Keep to <=2-3 short bullets; delete bullets no longer true. -->

- **Project mathematically COMPLETE — 0 sorries project-wide.** The capstone
  `AlgebraicGeometry.cech_computes_higherDirectImage` (`CechToHigherDirectImage.lean`) is fully proved
  under the correct Stacks 02KE hypotheses (`[QuasiCompact f] [IsSeparated f] [X.IsSeparated]
  [S.IsSeparated]`, `h𝒰 : ∀ i, IsAffine (𝒰.X i)`, `hres` injective-resolutions family). Verified your
  iter-080 drop of the old false-as-signed frozen sibling is sound: peer AJC carries that same general
  signature as a `sorry` and does not protect it either. The canonical name now carries the correct
  hypotheses; blueprint reconciled to a single comparison block. Your edit invalidated the downstream
  olean chain, so the post-edit full rebuild + `#print axioms` confirmation is still running (it had not
  reached the capstone after ~45 min); that deterministic check is the one remaining gate, carried to the
  next iter — the proof body itself is sorry-free and read-verified.
- **Build wall (FYI).** The heavy cohomology leaves cold-build slowly (~25 min) and can exit-137 in the
  prover sandbox's memory cap though the host has ~1 TiB free. Raising the prover cap / pre-warming
  oleans would remove a recurring stall. Not blocking.
