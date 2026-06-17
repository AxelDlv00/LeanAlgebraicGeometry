# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-049 — top-supremum HModule transport (RESOLVED)

### Scope
Two new theorems appended inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, between iter-037's `module_finite_HModule_of_HModule'_X₄_curve` and the closing `end CoverTotality`:

1. `subsingleton_HModule_of_isCechAcyclicCover_top` — abstract sheaf form. Chains iter-048's `subsingleton_HModule'_supr_of_isCechAcyclicCover` (in `StructureSheafModuleK.lean`) with iter-034's `HModule'_eq_HModule_linearEquiv` universe bridge; under `⨆ i, 𝒰 i = ⊤` and an explicit `compIso`, transports `Subsingleton (HModule' k F n (⨆ 𝒰)) → Subsingleton (HModule' k F n ⊤) → Subsingleton (HModule k F n)`.
2. `subsingleton_HModule_of_isCechAcyclicCover_top_curve` — curve specialisation at `F := toModuleKSheaf C`. Thin one-liner forwarding to (1) with the named-argument `(𝒰 := 𝒰)` lock-in.

### Approach
- **Approach:** Verbatim copy of the plan-agent probe-confirmed bodies from PROGRESS.md L65–118 (no deviations); placement at the documented insertion point (single `Edit` against `module_finite_HModule_of_HModule'_X₄_curve` … `end CoverTotality`).
- **Result:** RESOLVED.
- **Compilation:** `lean_diagnostic_messages` on the file → `{success: true, items: [], failed_dependencies: []}` (zero warnings, zero errors).
- **Axioms:**
  - `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule_of_isCechAcyclicCover_top` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only.
  - `lean_verify AlgebraicGeometry.Scheme.subsingleton_HModule_of_isCechAcyclicCover_top_curve` → kernel-only.
- **Sorry trajectory:** `9 → 9` (no transient introduced; sorry analyzer reports `9 total across 3 file(s)`: 5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean` — unchanged from pre-iter-049 baseline).
- **File LOC:** `Cohomology/MayerVietoris.lean` 1024 → 1077 (+53, within the +30–50 plan estimate band; multi-paragraph docstrings copied verbatim from PROGRESS.md).

### Notes for review agent
- The two new theorems land at the insertion point `subsingleton_HModule_of_isCechAcyclicCover_top` (currently L1022–L1051) and `subsingleton_HModule_of_isCechAcyclicCover_top_curve` (L1053–L1071) inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, consistent with the `Scheme.`-prefix-dropping convention used by iter-035–037 (the namespace block lands them as `AlgebraicGeometry.Scheme.subsingleton_HModule_of_isCechAcyclicCover_top` / `..._curve`).
- Inside the bodies, all references use the unqualified short names (`subsingleton_HModule'_supr_of_isCechAcyclicCover`, `HModule'_eq_HModule_linearEquiv`, `Preorder.isTerminalTop`, `cechCohomology`, `HModule`, `HModule'`, `IsCechAcyclicCover`, `toModuleKSheaf`) — all resolve cleanly via the namespace open and existing imports; no new imports were required.
- Both blueprint declarations in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Top-supremum HModule transport (iter-049)* are now ready for `\leanok` (statement and proof both formalized; both kernel-only).
- `archon-protected.yaml`: untouched.
- No prover deviations from the plan-agent probe-confirmed bodies; the load-bearing `h ▸ this` rewrite step (declaration 1) and `(𝒰 := 𝒰)` named-argument syntax (declaration 2) are both present as specified.

### Blueprint markers ready
- `thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top` → `\leanok` (both statement and proof)
- `thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top_curve` → `\leanok` (both statement and proof)

### Dead ends avoided (per PROGRESS.md "Known dead ends")
- Did NOT mark either declaration as `instance` (would silently fail on missing explicit `compIso`/`h`/`hn`).
- Did NOT re-introduce the `Scheme.` prefix on the declared names (forbidden inside `namespace AlgebraicGeometry.Scheme` by `linter.dupNamespace`).
- Did NOT add new imports.
- Did NOT skip the `h ▸ this` rewrite step.
- Did NOT attempt to construct or prove the comparison iso in iter-049 (that is iter-050+ substantive work; iter-049 takes `compIso` as an explicit hypothesis).
