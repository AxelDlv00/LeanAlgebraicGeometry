# AlgebraicJacobian/Cohomology/MayerVietoris.lean — iter-055 prover result

## Summary

**Status: RESOLVED.** Iter-055 Phase A step 6 *Path 2* / Serre-finiteness scaffolding **basic-open existence-form producer** — appended two thin scaffolding declarations inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, after iter-054's `basicOpenCover_isAffineOpen` (L1369-1375), before `end CoverTotality`.

Both declarations use the verbatim probe-confirmed bodies from `PROGRESS.md`. File compiles cleanly with zero diagnostics; both new declarations verify with kernel-only axioms `[propext, Classical.choice, Quot.sound]` — no new axiom introduced.

## Declarations added (this iteration)

### 1. `Scheme.hasAffineCechAcyclicCover_of_basicOpen` (L1378-1402)
- **Approach:** Single `where exists_cover {U} hU := by ...` body using `obtain` to destructure the per-affine existence and `exact ⟨s, basicOpenCover s, basicOpenCover_supr_of_span_eq_top hU s hs, hacy, hcomp⟩` to bundle into iter-053's existential cover form.
- **Result:** RESOLVED — body typechecks end-to-end.
- **Axioms:** `[propext, Classical.choice, Quot.sound]` (kernel-only).

### 2. `Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve` (L1413-1421)
- **Approach:** Term-mode one-liner specialisation `hasAffineCechAcyclicCover_of_basicOpen h` at `F := toModuleKSheaf C`. Mirrors the iter-039/042/043/048/049/050/051/052/053 `_curve` dot-notation wrapper pattern.
- **Result:** RESOLVED — body typechecks end-to-end.
- **Axioms:** `[propext, Classical.choice, Quot.sound]` (kernel-only).

## Verification

- **Diagnostics:** `lean_diagnostic_messages` on `AlgebraicJacobian/Cohomology/MayerVietoris.lean` returns `{success: true, items: [], failed_dependencies: []}` — zero errors, zero warnings.
- **Axiom check:** `lean_verify` on both `AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen` and `AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve` returns `{axioms: [propext, Classical.choice, Quot.sound], warnings: [line 259 pre-existing local-instance pattern]}` — kernel-only, no iter-055-introduced warning.
- **Sorry count:** project-wide held at `9` (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`). `MayerVietoris.lean` itself has 0 sorries.
- **File LOC:** 1379 → 1429 (+50 LOC, within plan band).
- **Protected signatures (`archon-protected.yaml`):** unchanged.

## Notes

- No new imports were needed — all referenced names (`HasAffineCechAcyclicCover`, `basicOpenCover`, `basicOpenCover_supr_of_span_eq_top`, `IsCechAcyclicCover`, `HasCechToHModuleIso`, `toModuleKSheaf`, `Ideal.span`, `Set`, `Sheaf`, `Opens.grothendieckTopology`, `IsAffineOpen`) were already in scope from iter-047 / iter-050 / iter-053 / iter-054.
- The declarations live inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, so the `Scheme.` prefix is dropped on the declared names (matches iter-035-037/049-054 pattern).
- Both declarations are `theorem`s (not `instance`s) because each takes an explicit per-affine existence hypothesis `(h : ∀ {U}, IsAffineOpen U → ∃ s, ...)` — not synthesisable via instance search. Matches iter-049/050/051/052/053 pattern.
- The `_curve` form's body is a one-liner that delegates to `hasAffineCechAcyclicCover_of_basicOpen h` after fixing `F := toModuleKSheaf C`.

## Blueprint markers ready for review agent

The blueprint chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex` already contains (added by plan agent this iteration):

- `\label{thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen}` with `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen}` (L1276-1277).
- `\label{thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen_curve}` with `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve}` (L1288-1289).

**Both should receive `\leanok` from the review agent** — declarations are formalized with no `sorry` and verified kernel-only.

## Next steps

Iter-055 closes the existence-form producer scaffolding. The substantive iter-056+ work (Koszul acyclicity for basic-open covers) and iter-057+ work (Čech-vs-derived comparison theorem) remain explicitly deferred — they will produce the per-affine basic-open `IsCechAcyclicCover` + `HasCechToHModuleIso` evidence that this iter-055 producer consumes via its hypothesis `h`.
