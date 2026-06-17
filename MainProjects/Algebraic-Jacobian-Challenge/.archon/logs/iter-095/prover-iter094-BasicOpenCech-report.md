# Cohomology/BasicOpenCech.lean

## `cechCofaceMap_pi_smul` body L589 trailing sorry (iter-094)

### Iter-094 outcome summary

**Status**: PARTIAL substantive progress. File compiles, 6 sorries (unchanged
from iter-093). Genuine breakthrough on the eqToHom-blocker, plus proved
body-local infrastructure (`key₂`) for the next step. Sorry budget hard cap
(6) maintained.

### Step (b) / Route (D-variant) — BREAKTHROUGH

**Committed line: `rw [← ModuleCat.hom_comp]` (L583).**

The iter-094 plan's Routes (D)/(E)/(F) were all aimed at sidestepping the
iter-093 blocker: `(eqToHom_hom ∘ₗ (∑F).hom) z` couldn't be unfolded by
`LinearMap.comp_apply` due to def-equal-but-syntactically-distinct ModuleCat
mismatch (`∏ᶜ Z₂` vs Pi-product).

**Discovery**: Mathlib's `ModuleCat.hom_comp f g : (f ≫ g).hom = g.hom ∘ₗ f.hom`
provides a `rfl`-lemma whose **reverse direction** (`← ModuleCat.hom_comp`)
converts `eqToHom_hom ∘ₗ (∑F).hom` into `((∑F) ≫ eqToHom).hom` — a categorical
composition. This sidesteps the LinearMap-level eqToHom blocker entirely.

Tactic `rw [← ModuleCat.hom_comp]` succeeds with `lean_diagnostic_messages`
returning `[]` (severity=error) at the post-rewrite position.

Post-(b') goal shape:
```
(Pi.π Z₂ j).hom (((∑ i, F i) ≫ eqToHom ⋯).hom (e₁.symm (r • y))) =
  r • (Pi.π Z₂ j).hom (((∑ i, F i) ≫ eqToHom ⋯).hom (e₁.symm y))
```
where the eqToHom is now inside a categorical `≫`, not wrapping a `∘ₗ`.

### Step (c) attempt — `key₂` infrastructure landed; HOU rewrite blocked

**Committed**: body-local `have key₂` at L590–L599 (fully proved):
```lean
have key₂ : ∀ G E z, ((∑ i, G i) ≫ E).hom z = ∑ i, (G i ≫ E).hom z
```
The proof chains `Preadditive.sum_comp` → `ModuleCat.hom_sum` → `LinearMap.sum_apply`.
Proof succeeds because `G`, `E`, `z` are all FREE variables (no HOU).

**Blocker**: `rw [key₂]` on the goal at L600 fails with
"pattern `(ModuleCat.Hom.hom ((∑ i, ?G i) ≫ ?E)) ?z` not found".

The failure is HOU: the summand body
`(-1)^↑i • Pi.lift fun i_1 ↦ ... ((SimplexCategory.δ i) ...) ...`
references the outer summation binder `i` in nested positions, AND there's
binder shadowing (`Pi.π (fun i ↦ ...)` rebinds `i`). The discrimination tree
cannot determine the `?G` placeholder.

`simp only [Preadditive.sum_comp]`, `simp_rw [Preadditive.sum_comp]`,
`simp only [key₂]`, `simp_rw [key₂]` — all "no progress" (same HOU pre-filter
failure).

### Attempt log (iter-094)

#### Attempt 1: `simp only [LinearMap.comp_apply]` + variants
- **Approach**: standard rfl-unfold of `(f ∘ₗ g) x`.
- **Result**: FAILED — "no progress" / "pattern `(?f ∘ₛₗ ?g) ?x` not found".
- **Diagnosis**: eqToHom's implicit codomain is Pi-product, def-equal but not
  syntactically equal to `∏ᶜ Z₂`. Pattern-tree rejects.
- **Dead-end**: confirmed iter-093's report.

#### Attempt 2 (BREAKTHROUGH): `rw [← ModuleCat.hom_comp]`
- **Approach**: fuse `eqToHom_hom ∘ₗ (∑F).hom` into `((∑F) ≫ eqToHom).hom` at
  the categorical level via `ModuleCat.hom_comp`'s reverse direction.
- **Result**: SUCCESS. Goal now contains `((∑F) ≫ eqToHom).hom z` (no `∘ₗ`).
  Diagnostics empty.
- **Key insight**: The reverse-direction rewrite trades a LinearMap-level
  eqToHom blocker for a categorical-level sum, which is a strictly easier shape.

#### Attempt 3: `rw [Preadditive.sum_comp]` (forward distribution)
- **Approach**: distribute `(∑F) ≫ E = ∑ i, F i ≫ E`.
- **Result**: FAILED — HOU pattern `(∑ j ∈ ?s, ?f j) ≫ ?g` not unified.
- **Diagnosis**: summand has nested `i` references + variable shadowing.

#### Attempt 4: body-local `key₂` + `rw [key₂]`
- **Approach**: prove the distribution body-locally with free `G`, `E`, `z`
  (HOU-friendly), then apply via `rw`.
- **Result**: PROOF of `key₂` succeeds. `rw [key₂]` application FAILS (same HOU).
- **Lesson**: The HOU issue is at pattern-matching, not proof construction.
  Body-local proofs don't help if rewrite still has to do HOU unification.

#### Attempt 5: `key₃` bundling outer `(Pi.π Z₂ jj).hom`
- **Approach**: bundle the outer `(Pi.π Z₂ jj).hom (...)` with the distribution
  into a single helper.
- **Result**: FAILED — `(Pi.π Z₂ jj).hom` doesn't accept `(G i ≫ E).hom z`-typed
  input directly because the codomain is the Pi-product (def-equal but not
  syntactically equal to `∏ᶜ Z₂`). Same eqToHom obstruction at meta-level.

#### Attempt 6: `simp` ensemble: `[Preadditive.sum_comp, ModuleCat.hom_sum, LinearMap.sum_apply, map_sum, Finset.smul_sum]`
- **Result**: "no progress" — HOU pre-filter rejects the first lemma; cascade
  doesn't fire.

#### Attempt 7: `set F :=` with explicit summand
- **Result**: type elaboration failure on `(-1)^↑i` (heterogeneous power
  inference) and Pi.π type mismatch.

### Concrete next step (for iter-095)

**Route (D')**: Try `convert key₂ G_explicit E_explicit z`-style at the goal,
which generates equality subgoals that may be discharge-able by `rfl` or
`ext`. The `convert` tactic bypasses the discrimination tree's strict
unification.

**Route (D'')**: Use `Finset.cons_induction` on `Finset.univ : Finset (Fin (n+1))`
to MANUALLY distribute the sum step-by-step (avoiding HOU entirely).

**Route (D''')**: Reformulate the proof to push `Pi.π Z₂ j` through the
categorical sum BEFORE `.hom`-application, via
`Preadditive.comp_sum` (the dual of `Preadditive.sum_comp`). The
post-Preadditive.comp_sum form would be `∑ i, F i ≫ eqToHom ≫ Pi.π Z₂ j`, where
the outer `(Pi.π Z₂ j).hom` is now INSIDE each summand's `≫`. This is the
most robust approach but requires careful setup.

### Final `lean_diagnostic_messages` output (mandatory)

```
{"result": {"success": true, "items": [], "failed_dependencies": []}}
```
**FILE COMPILES.** 0 errors. 6 sorries (L589, L681, L1005, L1033, L1223, L1252)
— unchanged from iter-093 entry state. No new axioms.

### Sorry budget tracking

- Hard cap iter-094: 6.
- Actual iter-094: 6 (preserved).
- Substantive progress: +1 committed tactic line (`rw [← ModuleCat.hom_comp]`)
  AND +1 proved body-local helper (`key₂`), refining the blocker from
  "LinearMap.comp_apply fails on eqToHom-wrapped comp" to "HOU pattern matching
  fails on the distribution of `(∑F) ≫ E` for an `i`-shadowed/double-referencing
  summand".

### Preserved iter-093 state (byte-for-byte)

- L551–L555: `have hom_sum_dist` (iter-092 rebuild).
- L570–L577: `have key₁` (iter-093 proof).

### Iter-094 inline comment additions (per directive: no long-form commentary)

- Single-line `-- S6 step (b') [iter-094 BREAKTHROUGH]` annotating `← ModuleCat.hom_comp`.
- Brief comment block (8 lines) at `key₂` describing the HOU rewrite blocker for
  the next iteration; this is at the proven helper, not above a tactic.

### Blueprint

`cechCofaceMap_pi_smul` is a project-local helper without its own `\lean{...}`
entry in `Cohomology_MayerVietoris.tex` — no blueprint edits this iter
(unchanged from iter-093 directive).
