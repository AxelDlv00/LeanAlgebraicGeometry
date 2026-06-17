# Recommendations for iter-035 (from review of iter-034)

## HIGH — must address before the qcoh-seed (Lane 2 top) lane

### 1. Tighten `affineCoverSystem.Cov` to carry the covering condition
- **What**: `AffineSerreVanishing.lean:~362` defines `affineCoverSystem.Cov` as ALL finite basic-open
  families `{c | ∃ n g, c = ⟨ULift (Fin n), i ↦ D(g i.down)⟩}` — with NO covering condition.
- **Why it must be fixed**: `HasVanishingHigherCech affineCoverSystem F` then demands `Ȟ^q = 0` over
  every finite basic-open family. This is **FALSE** for quasi-coherent sheaves (lean-auditor iter-034
  counterexample: on `Spec k[x,y]` the NON-covering family `{D(x),D(y)}` has `Ȟ¹(O) ≠ 0` — `x⁻¹y⁻¹` is
  in neither `O(D(x))` nor `O(D(y))`). The gated seed `affine_cech_vanishing_qcoh` is **unprovable** as is.
- **Direction of fix (ADJUDICATED — do NOT do the reverse)**: the blueprint prose for `def:affine_cover_system`
  is the correct target; **tighten the LEAN Cov**, do not relax the prose. The lvb-affine report recommended
  relaxing the prose — that recommendation is mathematically WRONG (it conflates localized-section exactness
  with Čech vanishing); ignore it. A `% NOTE` recording this is already on the blueprint def (review iter-034).
- **How**: add `Ideal.span (Set.range g) = ⊤` (≡ `⨆ᵢ D(gᵢ) = D(f)` relative to the covered basis member)
  to the `Cov` predicate. The field proofs are unaffected: `injective_acyclic` (`injective_cech_acyclicFam`)
  is cover-agnostic, and `affine_surj_of_vanishing` extracts a genuine cover internally via
  `standard_cover_cofinal`. This is a small, well-scoped prover/refactor edit, NOT a strategy change.
- The prover's task-result "Planner reconciliation note (Cov breadth)" argued the broad Cov "only
  strengthens" the hypothesis and is "mathematically sound" — that conclusion is wrong; do not adopt it.

## HIGH — blueprint coverage debt (blocks honest DAG state, planner-only)

### 2. Blueprint the 2 new TildeExactness decls + expand the kernel-preservation sketch
- `unmatched` lists `AlgebraicGeometry.tilde_stalkFunctor_map_toStalk` (proved) and
  `AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf` (proved), both with no blueprint block.
  Add them to `lem:tilde_preserves_kernels`'s `\lean{...}` and write sub-step blocks (natural home: the
  "stalk = localisation, naturally in M" clause and the "iso of sheaves checked on stalks" reduction).
- lvb-tilde (MAJOR): the `lem:tilde_preserves_kernels` proof sketch is **under-specified** for the
  remaining build. Dispatch a blueprint-writer to add: (a) R-linearity of the Ab-stalk map via `germₗ`
  + `Scheme.Modules.Hom.app` linearity through the `algebraMap R → Γ` scalar tower; (b) per-stalk
  `PreservesFiniteLimits` (localisation is flat); (c) the jointly-reflecting-stalks assembly via
  `JointlyReflectIsomorphisms.jointlyReflectsLimit`; plus a `% NOTE` that the `ModuleCat R`-valued stalk
  path is DEAD (Mathlib privacy of `toStalkₗ'`/`stalkIsoₗ`/`stalkToLocalizationₗ`/`structurePresheafInModuleCat`)
  and the Ab path is forced. Also cross-reference the 2 new decls in the `% NOTE` at L4340 as in-file progress.

## MEDIUM — ready frontier work

### 3. `tildePreservesFiniteLimits` is now a single ~100–150 LOC build — dispatch after #2
- Residual: `PreservesFiniteLimits (~ ⋙ toPresheaf)`, then compose with `tildePreservesFiniteLimits_of_toPresheaf`.
- Recorded blocker for the next prover: state `σ_x := (stalkFunctor Ab x).map (toPresheaf.map (tilde.map f))`
  and insert `show … : (tilde N).presheaf.stalk x` type-ascription BEFORE any `r • σ_x ζ` (HSMul synthesis
  fails on the defeq-not-syntactic `(stalkFunctor Ab x).obj …`). Then identify `σ_x` with
  `IsLocalizedModule.map x.asIdeal.primeCompl (toStalk M x).hom (toStalk N x).hom f.hom` using
  `tilde_stalkFunctor_map_toStalk` + `IsLocalizedModule.ext`. Assemble via the jointly-reflecting stalk family.
- Gate per HARD GATE: blueprint chapter must clear (after #2) before dispatching this lane.

## LOW — cosmetic (optional, not blocking)
- AffineSerreVanishing Mathlib style-linter (lean-auditor): inline-comment the two `maxHeartbeats`
  set_options (L215, L351); `show`→`change` (L324, L343); break long lines (L220, 357, 358, 360).
  A future refactor/golf pass can sweep these; none affects correctness or axioms.
- lvb-affine LOW: optionally align the `toSheaf_preservesFiniteColimits` blueprint sketch ("retract")
  with the actual mechanization (`isColimitOfPreserves` + `preservesColimit_of_iso_diagram`).

## Do-NOT-retry / accept-as-stopped
- Do NOT re-dispatch `tildePreservesFiniteLimits` without first writing the blueprint sub-steps (#2) —
  the prior prover correctly stopped on a real, sharply-located gap, not a tactic failure.
- Do NOT accept the over-broad `affineCoverSystem.Cov` (item #1) on the prover's "only strengthens" note.

## Coverage debt (for the planner to blueprint — `archon dag-query unmatched`)
- `AlgebraicGeometry.tilde_stalkFunctor_map_toStalk` — TildeExactness.lean; germ-naturality of
  `tilde.toStalk` along `tilde.map f`. Deps: `StructureSheaf.toStalkₗ`/`toOpenₗ`/`comapₗ_const`,
  `stalkFunctor_map_germ_apply`, `modulesSpecToSheafIso`, `ModuleCat.forget₂_map`.
- `AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf` — TildeExactness.lean; reduction via
  `preservesFiniteLimits_of_reflects_of_preserves`. Deps: `Scheme.Modules.toPresheaf` (faithful /
  `PreservesLimits` / `ReflectsIsomorphisms`), `(Spec R).Modules` `HasLimits`.
- `AlgebraicGeometry.CechAcyclic.affine` — pre-existing dead node (`has_sorry`); not new debt; can be
  pruned/superseded when convenient.
