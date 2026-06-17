# Recommendations — next plan iter (post-iter-049)

## TOP — blueprint-side must-fixes (lean-vs-blueprint-checker flat-iter049, all MAJOR)
On `lem:gf_finite_gen_iff_free_epi` in `Picard_FlatteningStratification.tex` (dispatch a blueprint-writer):
1. Replace "a quasi-coherent sheaf of modules" → "a sheaf of modules" — Lean imposes NO quasi-coherence and
   is stated over an arbitrary Grothendieck topology; the qcoh qualification could mislead a future prover
   into a spurious `IsQuasicoherent` hypothesis. (Review already added `% NOTE:` + `\leanok` manually.)
2. Add a note that the Lean formulation is in abstract `SheafOfModules.{u} R` generality with three typeclass
   hypotheses (`HasWeakSheafify`, `WEqualsLocallyBijective`, `HasSheafCompose`) enabling `SheafOfModules.free`.
3. (minor) Name the free-sheaf object: `O_Y^{⊕I} = SheafOfModules.free I`.

## Closest-to-completion / PROCEED
- **GF seam-1 1a `gf_localGenerators_restrict` (iter-050).** The ONLY remaining seam-1 blocker. Build by
  transporting `σ.π` along `Scheme.Modules.overRestrictPullbackIso` (geometric `pullback U.ι`, epi+free
  preserving — the QUOT gap1 plumbing). Once 1a lands, `gf_finiteType_affine_finite_cover_generated` assembles
  mechanically (all other ingredients — `exists_localGeneratorsData`, 1b, 1c — already in hand). This is a
  transport build, NOT proof-fillable as-is; effort-break against the `overRestrictPullbackIso` bridge if needed.
  **Do NOT re-dispatch the abstract `pushforward`/`freeFunctorCompPullbackIso` routes** (both exhausted: see
  Known Blockers — pushforward is a right adjoint; `Over.map f` is not Final).

## Blocked — do NOT re-assign without a structural change
- **SNAP `tensorPowAdd` (`lem:sheafTensorPow_add`).** Needs the sheaf associator. BOTH viable routes rest on
  confirmed-absent Mathlib infra: Route A on `MonoidalClosed (PresheafOfModules R₀)` (search-confirmed
  absent); Route B on `IsLocallyFreeOfRank` + a "X.Modules morphism iso iff locally iso" criterion (both
  absent). Route C is mathematically false for non-locally-free factors. **iter-050 must build the chosen
  route's infra FIRST** (Route A: internal-hom-of-presheaves + internal-hom-into-sheaf-is-sheaf; Route B: the
  loc-free predicate + local-iso criterion + line-bundle trivialising cover) before any prover on the
  associator. Note: `IsLocallyFreeOfRank` for `X.Modules` is ALSO needed by GR-quot (analogist
  `grquot-infra.md`) — build it once, shared.

## Coverage debt — 10 unmatched lean_aux nodes (`archon dag-query unmatched`)
All in `SectionGradedRing.lean`, the layer-1 helpers privatized this iter. Despite the `private` marking they
still surface in the unmatched scan. Planner: either author thin blueprint helper-anchors for them OR confirm
that `private` is the intended way to drop them from DAG tracking (and that the scan should ignore `private`).
The 10 (all `proved: true, has_sorry: false, dep/rdep 0`):
`MonoidalPresheaf`, `sheafification`, `unitModule`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`,
`sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`
(namespace `AlgebraicGeometry.Scheme.Modules.*`). The 3 added seam decls (1b, 1c) are NOT unmatched — they
have matching `\lean{}` blueprint blocks.

## SNAP blueprint minors (snap-iter049, non-blocking)
- `lem:sheafTensorPow_add` proof sketch presents the bespoke local-iso route as viable but omits the 3
  additional Mathlib-absent primitives that block it (the Lean handoff note enumerates them).
- Inconsistent namespacing in future `\lean{}` hints: `Scheme.Modules.sectionsMul_assoc_unit` vs bare
  `AlgebraicGeometry.sectionGradedRing_gcommSemiring`.

## lean-auditor minors (iter049, cosmetic — fix opportunistically)
- iter-journal lines inside proof bodies (FlatteningStratification.lean).
- unexplained `@[reducible]` on `pullbackModuleAddEquiv`.
- `@[simp]` on `private` lemmas (SectionGradedRing.lean) — misleading; simp set won't see them externally.

## Reusable patterns landed (see PROJECT_STATUS Knowledge Base)
- GF seam-1 affine finite standard subcover + GeneratingSections free-epi repackaging.
- SectionGradedRing `sectionsMul`: keep it a `ModuleCat ⟶`, never `→ₗ`/`TensorProduct` (ring-expression diamond).
