# AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean — iter-045

## Summary

**RESOLVED.** Iter-045 plan-agent objectives closed in a single Edit:
appended two declarations inside `namespace AlgebraicGeometry.Scheme`,
between iter-044's `module_finite_globalSections_of_isProper` and the
`end AlgebraicGeometry.Scheme` (file tail). Both declarations are
kernel-only (`[propext, Classical.choice, Quot.sound]`) and the file
compiles with zero diagnostics.

- File LOC: 615 → 670 (+55, within plan's +30–50 estimate band).
- File sorry count (functional `sorry` tactics): 0 → 0 (the only `sorry` token is a historical mention in the file-level docstring at L30).
- Project sorry count: 9 → 9 (unchanged; trajectory matches plan).

## Declarations added

### Declaration 1 — `AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top` (new, L582–L606)
- **Approach:** Verbatim plan-probed body. Apply `Sheaf.ΓNatIsoSheafSections` with `T := ⊤` and `hT := Preorder.isTerminalTop _`, `.app F`, then `.toLinearEquiv`.
- **Result:** RESOLVED on first attempt. `lean_verify` reports `axioms: [propext, Classical.choice, Quot.sound]`.
- **Form:** `noncomputable def` returning `≃ₗ[k]` (data, not Prop).
- **Key Mathlib uses:** `Sheaf.ΓNatIsoSheafSections` (`Mathlib/CategoryTheory/Sites/GlobalSections.lean`), `Preorder.isTerminalTop`, `Iso.toLinearEquiv`. All transitively in scope; no new imports.

### Declaration 2 — `AlgebraicGeometry.Scheme.module_finite_gammaObj_of_isProper` (new, L607–L626)
- **Approach:** Verbatim plan-probed body. `haveI` re-typecasts `Module.Finite k (C.left.presheaf.obj (op ⊤))` (iter-044's conclusion) into `Module.Finite k ((toModuleKSheaf C).obj.obj (op ⊤) : ModuleCat k)` (LinearEquiv source), then `Module.Finite.equiv` with `.symm`.
- **Result:** RESOLVED on first attempt. `lean_verify` reports `axioms: [propext, Classical.choice, Quot.sound]`.
- **Form:** `theorem`, NOT `instance` (per plan rationale: avoid silent typeclass-synthesis pollution).
- **Hypotheses:** `[IsIntegral C.left] [IsProper C.hom]`.
- **Note on `haveI`:** load-bearing — Lean does not bridge the two spellings of the same module automatically.

## Verification (post-edit)

- `lean_diagnostic_messages` on the file: `{success: true, items: [], failed_dependencies: []}`. Zero warnings, zero errors.
- `lean_verify AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}`.
- `lean_verify AlgebraicGeometry.Scheme.module_finite_gammaObj_of_isProper` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}`.

## Adherence to plan-agent guidance

- Used short names without the `Scheme.` prefix (inside `namespace AlgebraicGeometry.Scheme`); fully qualified names recover via the namespace block.
- Used `Opposite.op` (not bare `op`) — the file's `open` line at L38 lacks `Opposite`, so qualification is required.
- Used `F.obj` (not the deprecated `F.val`).
- Used `Preorder.isTerminalTop` (not the non-existent `Opens.isTerminalTop`).
- Did not modify any iter-005 → iter-044 declaration; iter-044's `module_finite_globalSections_of_isProper` retained verbatim.
- Did not edit any other `.lean` file. Did not edit `archon-protected.yaml`. Did not edit `PROGRESS.md`, `task_pending.md`, or `task_done.md`.

## Blueprint marker readiness (review-agent action)

Both new theorems already have `\leanok` markers in
`blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` § *Global-sections evaluation isomorphism (iter-045)*
(theorems `thm:Scheme_SheafGammaObj_linearEquiv_top` and `thm:Scheme_module_finite_gammaObj_of_isProper`,
plus `\leanok` on both proof blocks) — the plan-agent pre-marked under the assumption iter-045 closure would land. With this iter-045 prover round
landed kernel-only on first attempt, no `\leanok` revisions are required from
the review agent.

## Next iteration (iter-046+) — plan-agent material

The next prover-side step, per the iter-044/045 four-step producer-instance plan:

- **Step (1):** linearised constant-sheaf-Γ adjunction `homEquiv` (project-local lift of Mathlib's `Adjunction.homAddEquiv` to `≃ₗ[k]`). This is the multi-iteration substantive step; Mathlib has only the additive version. May require project-local `Functor.Additive` instances on `constantSheaf` and `Sheaf.Γ` plus a manual `k`-scalar-compatibility check, or direct construction of forward/backward `k`-LinearMaps.
- **Step (3):** assemble producer instance `IsHModuleHomFinite k C (toModuleKSheaf C)` via `Module.Finite.equiv` chain through Steps (1) + (2) [iter-045, this iteration].

No alternative-route material to log this iteration — the plan-agent's probe-confirmed bodies landed on first attempt.
