# Iter 060 — Objectives detail

## Lane 1 — SectionGradedRing.lean :: relTensorProj.naturality (L658) [prove]
- Math: blueprint `def:relTensorProj` "Naturality" para — both composites send `m⊗ₜn ↦ (objRestrict P f m)
  ⊗ₜ[R(V)] (objRestrict Q f n)`; agree by ⊗-induction.
- Lean route (in-code L639–657): prove at the ModuleCat-presheaf level where
  `PresheafOfModules.Monoidal.tensorObj_map_tmul` applies, BEFORE forgetting to `Ab`; OR a
  `restrictScalars`/`forget₂`-carrier transport lemma. Blocker = `forget₂ CommRingCat→RingCat` carrier:
  `R(V) = (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat).obj V` vs `CommRingCat` carrier `X.sheaf.obj.obj V`
  that `projL` is built over.
- Do-not-retry: `show`/`change` re-elaborating `projL` against the apex codomain (RingCat-carrier module
  instance synth fails); element-level `map_tmul` on the abelian-presheaf `.map f`.
- Hygiene: `objRestrict`/`opensTopology` → `private`.

## Lane 2 — GrassmannianQuot.lean :: bundleTransition_self OOM fix (~L591) [prove]
- Profile (`lean_profile_proof`) → confirm kernel/memory hotspot → re-prove leaner (default heartbeats,
  no OOM). Statement FROZEN. Likely a `decide`/biproduct-unfold → replace with `scalarEnd_one`/
  `Matrix.nonsing_inv_*` term-mode.
- Report: proof-local vs file-wide cost → file-split recommendation for iter-061.
- Do-not-touch: C2 (L621+) + 3 riders. Diamond: pullbackComp/pullbackId OPAQUE, term-mode only.

## Effort-break landed (iter-061 prep, NOT this iter's prover)
C2 `lem:gr_bundleCocycle_mul` → `gr_bundleCocycle_matrix` (L1) / `gr_matrixToFreeIso_mul` (L2) /
`gr_bundleCocycle_transport` (L3) + ~7 infra blocks; blueprint-clean'd; effort 1814→895.
