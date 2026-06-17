# AlgebraicJacobian/Cohomology/MayerVietoris.lean — iter-031 prover

## HModule'_top_sourceIso (new section CoverTotality, appended at file tail)

### Attempt 1 — verbatim plan-agent probe-confirmed body
- **Approach:** Append a new `section CoverTotality` between `end AffineCoverMVSquare`
  (was L675) and `end AlgebraicGeometry.Scheme` (was L677). Inside, define
  `noncomputable def HModule'_top_sourceIso` carrying the natural iso
  `(presheafToSheaf J _).obj ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj T) ≅ (constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k)`
  for terminal `T`. Body composes three Mathlib pieces under `(presheafToSheaf J _).mapIso`:
  1. terminal-collapse `yoneda.obj T ≅ (Functor.const Cᵒᵖ).obj PUnit`
     via `NatIso.ofComponents` + `Equiv.toIso` + `IsTerminal.from`/`IsTerminal.hom_ext`,
  2. `Functor.constComp _ PUnit.{u+1} (ModuleCat.free k)`,
  3. `(Functor.const Cᵒᵖ).mapIso (Finsupp.LinearEquiv.finsuppUnique k k PUnit).toModuleIso`.
- **Result:** RESOLVED — single Edit, copied verbatim from PROGRESS.md probe-confirmed body.
- **Verification:**
  - `lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean` → `{success: true, items: [], failed_dependencies: []}` (zero diagnostics).
  - `lean_verify AlgebraicGeometry.Scheme.HModule'_top_sourceIso` → axioms `[propext, Classical.choice, Quot.sound]` (kernel-only, no new axioms). The `local instance` warning at L179 is pre-existing (iter-009 cohort).
  - Sorry count via `sorry_analyzer.py`: `9 total across 3 file(s)` — unchanged from pre-iter-031.
  - File LOC: 720 (was 677; +43 LOC; slightly above the +25 estimate due to the multi-line docstring).
- **Key insights:**
  - `noncomputable` is load-bearing because `presheafToSheaf` is itself `noncomputable`.
  - `Functor.isoWhiskerRight` (qualified) is required; bare `isoWhiskerRight` is not in scope.
  - `PUnit.{u+1}` explicit universe annotation forces the right level for the Yoneda-Type universe.
  - Declaration is named `HModule'_top_sourceIso` (in-namespace short form) to avoid the
    double-prefix trap noted in PROGRESS.md.

## Status

- **IN PROGRESS** flag: none — iter-031 objective fully closed.
- **Sorry trajectory** for this iteration: `9 → 9` (no transient scaffolds).
- **Blueprint marker readiness**: definition `def:Scheme_HModule_prime_top_sourceIso`
  (blueprint § "Cover-totality source-object identification (iter-031)", lines 817–839)
  is ready for the review agent to mark `\leanok` on both the statement and the proof block
  (the proof block already shows `\leanok` per the iter-031 plan-agent's chapter write).

## Next steps for iter-032+

- Build the **Ext-transport step**: turn the source-object iso into a `LinearEquiv`
  `HModule' k F n T ≃ₗ[k] HModule k F n` for terminal `T`. Universe handling required —
  `HModule k F n : Type (u+1)` vs `HModule' k F n X : Type u` mismatch.
- Specialise the resulting LinearEquiv to `AffineCoverMVSquare`.
- Attack affine-vanishing `H^{>0}(Spec A, F) = 0` extraction.
- Build toward Serre-finiteness `Module.Finite k (HModule k F i)` for `F = toModuleKSheaf C`
  on a proper `k`-curve.

## Dead-end log (none added this iteration)

The iter-031 close used the verbatim probe-confirmed body. No alternative routes were
attempted (none needed). The full `LinearEquiv` on cohomology is not iter-031 scope —
deferred per PROGRESS.md.
