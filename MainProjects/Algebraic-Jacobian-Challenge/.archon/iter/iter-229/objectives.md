# Iter-229 objectives detail

## Lane TS — `Picard/TensorObjSubstrate.lean` (mode: mathlib-build)

### PRIMARY: build the shared open-immersion↔slice sheaf-site equivalence

Target decl: `AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv` (blueprint
`lem:open_immersion_slice_sheaf_equiv`, NEW this iter).

Goal: for a scheme `X` and an open `U ⊆ X`, upgrade the bare 1-categorical reindexing
`TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U`
(`Mathlib/Topology/Sheaves/Over.lean:41`) to an **equivalence of sheaf categories**
`Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology U) A`,
compatible with module-pullback / `restrictFunctorIsoPullback`. This is the completion of the
named Mathlib TODO at `Topology/Sheaves/Over.lean:19-22`.

Construction (two candidate routes — the prover should compare and pick the cheaper):
- `CategoryTheory.Functor.IsDenseSubsite.sheafEquiv` (`Sites/DenseSubsite/SheafEquiv.lean`) +
  the `Sites/Over.lean` continuity / cover-lifting instances; OR
- `CategoryTheory.Equivalence.sheafCongr` (`Sites/Equivalence.lean`) — specialises to an honest
  equivalence (`overEquivalence U` IS one), may shave the `IsDenseSubsite`-instance plumbing
  (strategy-critic ts229 suggestion; VERIFIED present).
The over-category coherence (`Over.mapId`/`Over.mapComp`/`overMapPullback_assoc`) is automatic on
the THIN poset `Opens X` by `Subsingleton.elim`/`Subsingleton.helim`. The sole sectionwise content
is the down-set identity `U.isOpenEmbedding.functor.obj ((Opens.map U.inclusion').obj V) = V` for
`V ≤ U` (`TopCat/Opens.lean`).

Bar: land axiom-clean as far as possible (mathlib-build — no sorry; each step proved or absent).
If the dense-subsite/continuity obligation is reached and is large, hand off a precise
decomposition (which instance is missing, what it reduces to) — do NOT pin a sorry. Maximal
axiom-clean progress + a clean decomposition = route progress this iter (this is the shared root,
not a helper; cf. progress-critic ts229 — attacking the shared root is the anti-churn move).

### Why this (not A-or-C in isolation)

Two independent analogist consults (ts229slice, ts229glue) converged: the A-engine
`homOfLocalCompat` and the C-bridge `dual_isLocallyTrivial` are blocked on THIS same root.
`exists_tensorObj_inverse` needs both, so building either alone closes nothing. The site
equivalence is value-category-parametric → one build serves both (A=Type, C=ModuleCat); each then
composes with its already-built module-transport shadow (`homMk` / `restrictScalarsRingIsoDualEquiv`).

### WATCH (strategy-critic ts229)
The site equivalence is `Sheaf J A ≌ Sheaf K A` for fixed `A`. After the bridge lands, the
per-bridge composition with the module-transport shadow is the next step; flag any un-anticipated
`restrictScalars`/CommRingCat friction there (a 4th-cost-growth signal).

### Reuse (do NOT re-derive)
`tensorObj_restrict_iso`, `Scheme.Modules.dual`, `isIso_of_isIso_restrict` (B), `homMk` +
`toPresheaf_map_homMk` (A step ii), `restrictScalarsRingIsoDualEquiv` (C shadow), the 3 dual-iso
helpers (`dualPrecompEquiv`, presheaf + scheme `dualIsoOfIso`), the H1 `pushforwardPushforwardAdj`
apparatus.

### FORBIDDEN this iter
Pinning a NEW sorry; the sheafify-the-presheaf-eval/associator shortcut (d.2 dead end);
building/pinning `isLocallyInjective_whiskerLeft_of_W` (vestigial d.2); sectionwise flatness;
touching `addCommGroup_via_tensorObj` (RPF consumer) or `exists_tensorObj_inverse` (assembly, needs
the bridge first); `set_option maxHeartbeats`; the `Sheaf.val`→`ObjectProperty.obj` deprecation
migration (14 sites — deferred polish pass).

## All other lanes — HELD/paused (unchanged)
Route C (RR chain) PAUSED (USER); A.2.c engine HELD behind TS→RPF; Route 2 gated A.2.c; RPF held
pending the ⊗-group law; Route-1 Albanese cone EXCISED. No dispatch.
