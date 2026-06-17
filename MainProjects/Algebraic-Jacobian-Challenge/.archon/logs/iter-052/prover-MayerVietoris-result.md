# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-052 — generalised rewrite-bridge `⨆𝒰 = U` for HModule' consumer + curve specialisation

### `subsingleton_HModule'_of_hasCechToHModuleIso` (newly inserted, ~L1212–L1232)

#### Attempt 1
- **Approach:** Used the verbatim probe-confirmed body from PROGRESS.md iter-052 plan:
  ```lean
  by
    haveI := subsingleton_HModule'_supr_of_hasCechToHModuleIso (F := F) (𝒰 := 𝒰) n hn
    exact h ▸ this
  ```
- **Result:** RESOLVED on first attempt.
- **Key insight:** The `(F := F) (𝒰 := 𝒰)` named-argument syntax is required because positional inference is ambiguous via the implicit `ι/𝒰` arguments alone. The `h ▸ this` rewrite is load-bearing — without it, `Subsingleton (HModule' k F n U)` does not unify with iter-051's conclusion `Subsingleton (HModule' k F n (⨆ i, 𝒰 i))`.

### `subsingleton_HModule'_of_hasCechToHModuleIso_curve` (newly inserted, ~L1234–L1244)

#### Attempt 1
- **Approach:** Used the verbatim probe-confirmed body from PROGRESS.md iter-052 plan:
  ```lean
  subsingleton_HModule'_of_hasCechToHModuleIso (𝒰 := 𝒰) h n hn
  ```
- **Result:** RESOLVED on first attempt.
- **Key insight:** Thin dot-notation wrapper around the abstract consumer at `F := toModuleKSheaf C`. The `(𝒰 := 𝒰)` named-argument syntax mirrors iter-051's `_curve` pattern.

## Verification

- **Diagnostic messages**: `lean_diagnostic_messages` returns `{success: true, items: [], failed_dependencies: []}`.
- **Sorry count**: `9 → 9` (5 in `Jacobian.lean`, 3 in `AbelJacobi.lean`, 1 in `Picard/Functor.lean`).
- **Axiom check**:
  - `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule'_of_hasCechToHModuleIso` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: [{line: 259, pattern: 'local instance'}]}` — kernel-only.
  - `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule'_of_hasCechToHModuleIso_curve` → kernel-only.
  - The L259 `local instance` warning is pre-existing (predates iter-052).
- **No new axioms introduced**: `Classical.choice` was already in scope since iter-048.
- **No imports added**: confirmed; all needed names transitively in scope via iter-051 infrastructure.
- **Placement**: both declarations appended inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, after iter-051's `subsingleton_HModule'_supr_of_hasCechToHModuleIso_curve`, before `end CoverTotality`. Plan-spec match exact.

## Blueprint

The blueprint chapter (`blueprint/src/chapters/Cohomology_MayerVietoris.tex`) was extended this iteration by the plan agent with § *Generalised rewrite-bridge `⨆𝒰 = U` for HModule' (iter-052)*. Both declarations are ready for `\leanok` markers (statement+proof both fully closed, no `sorry`).

Suggested `\leanok` placements (review-agent action):
- `thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso`
- `thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso_curve`

## Status

IN PROGRESS → COMPLETE for iter-052. Both probe-confirmed bodies landed verbatim with no deviations. Ready for iter-053+ substantive Čech-vs-derived comparison theorem branch.
