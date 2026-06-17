# Lean ↔ Blueprint Check Report

## Slug
avr

## Iteration
196

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

---

## Per-declaration (focus: iter-196 landed primitives and Lane E recipe targets)

### `\lean{AlgebraicGeometry.Proj.awayι_app_basicOpen}` (blueprint L1315, `lem:awayi_app_basicOpen`)
- **Lean target exists**: **no** — no declaration named `Proj.awayι_app_basicOpen` is present in the Lean file. The blueprint block carries no `\leanok` marker, confirming it is an unformalized target.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **Notes**: The closest existing Lean declaration is `Proj.awayι_eq_specMap_fromSpec` (L203), a *morphism-level* factorization (`awayι = Spec.map(basicOpenIsoAway.inv) ≫ fromSpec`). This is **not** the same as `lem:awayi_app_basicOpen`, which asks for a *section-level* closed-form formula (`(awayι).app(basicOpen 𝒜 f) = basicOpenIsoAway.inv ∘ ΓSpecIso.inv ∘ presheaf.map(eqToHom).op`). The blueprint's proof-sketch Step 1 also references a non-existent `Proj.awayι_eq_isoSpec_ι_comp` analogue — see Red Flags below.

### `\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem}` (blueprint L1440, `lem:awayi_appIso_top_inv_apply_isLocElem`)
- **Lean target exists**: **no** — no declaration with this name is present in the Lean file. No `\leanok` marker on the blueprint block.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **Notes**: This is the downstream target of `lem:awayi_app_basicOpen` (via `\uses`). It cannot be proved until `lem:awayi_app_basicOpen` lands. Both remain unformalized.

### `\lean{AlgebraicGeometry.iotaGm_chart1_appIso_eval}` (blueprint L1194, `lem:iotaGm_chart1_appIso_eval`)
- **Lean target exists**: **yes** — `private lemma iotaGm_chart1_appIso_eval` at L428.
- **Signature matches**: **yes** — the Lean statement (the composition `iotaGm_chart1_section ≫ gmScalingP1_chart kbar 1 = Spec.map(algMap) ≫ Spec.map(iso.toRingHom) ≫ Proj.awayι X_1`) matches the blueprint's prose description of the chart-1 Proj.appIso evaluation chain.
- **Proof follows sketch**: **partial** — the proof body has stages 1–8 faithfully following the blueprint sketch; the final residual at L532 is a `sorry` on the `Proj.appIso` evaluation step (ii) that the blueprint describes but which was STUCK across iter-188 through iter-196. The blueprint marks the block `\leanok` (L1191), which was set when the proof skeleton (with sorry) was present.
- **Notes**: The `\leanok` marker is technically correct by project convention (`\leanok` on a statement block means "at least a sorry is present"). The sorry is the same residual the blueprint already knows about; no new regression.

### `\lean{AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self}` — UNREFERENCED in blueprint
This declaration (`lemma Proj.awayι_preimage_basicOpen_self`, L190) was landed axiom-clean in iter-196 but has **no** `\lean{...}` reference in the blueprint chapter. See Unreferenced Declarations below.

### `\lean{AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec}` — UNREFERENCED in blueprint
This declaration (`lemma Proj.awayι_eq_specMap_fromSpec`, L203) was landed axiom-clean in iter-196 but has **no** `\lean{...}` reference in the blueprint chapter. The Lean docstring identifies it as "iter-195 analogist recipe step (i) `Proj.awayι_isoSpec_compat`" from the analogist file, while the blueprint's recipe `lem:awayi_app_basicOpen` Step 1 refers to a different (non-existent) analogue `Proj.awayι_eq_isoSpec_ι_comp`. See Red Flags and Unreferenced Declarations below.

---

## Red flags

### Stale / misleading blueprint reference inside `lem:awayi_app_basicOpen` proof sketch
- Blueprint L1370-1371: "...or via the project's `Proj.awayι_eq_isoSpec_ι_comp` analogue" — **this declaration does not exist** in the Lean file. The iter-196 prover landed `Proj.awayι_eq_specMap_fromSpec` (a morphism-level factorization through `fromSpec`) as the analogous primitive, but this is a different formulation from `basicOpenIsoSpec.inv ≫ ι`. Leaving `Proj.awayι_eq_isoSpec_ι_comp` in the proof sketch as a named analogue misleads the iter-197 prover into searching for a non-existent declaration.

### Missing named intermediate step: `Proj.basicOpenIsoSpec_inv_app_top`
- The iter-196 prover's task result (`.archon/task_results/AlgebraicJacobian/AbelianVarietyRigidity.md:66-71`) documents:
  ```
  Proj.basicOpenIsoSpec_inv_app_top :
    (Proj.basicOpenIsoSpec 𝒜 f f_deg hm).inv.app ⊤ =
      (Proj.basicOpen 𝒜 f).topIso.hom ≫
      (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫
      (Scheme.ΓSpecIso _).inv
  ```
  as the "missing piece" whose absence caused the iter-196 proof of `Proj.awayι_app_basicOpen` to fail. The blueprint proof sketch for `lem:awayi_app_basicOpen` Step 3 (L1391-1415) describes the mathematical content of this identity but does **not** prescribe it as a named helper. Without it named and `\lean{...}`-pinned, the iter-197 prover will likely encounter the same dependent-motive blocker.
- **This declaration is not in the Lean file** (not yet landed).

### Excuse-comments on `kbarChart1Ring_specMap_fac` (L281-323)
- The proof body of `kbarChart1Ring_specMap_fac` contains a multi-line comment (L281-323) explaining the mathematical plan and ending with a `sorry`. Comments of this type are by project convention a STUCK marker, not an excuse comment in the forbidden sense. They accurately reflect that the residual is known and documented. **Not a red flag** per se, but noted.

---

## Unreferenced declarations (informational)

The following declarations exist in the Lean file and have **no** `\lean{...}` reference in the blueprint chapter. Both are substantive (axiom-clean, general-purpose, project-local Mathlib supplements):

1. **`AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self`** (L190) — the preimage of `Proj.basicOpen 𝒜 f` under `Proj.awayι 𝒜 f` is `⊤`. A clean two-step rewrite used as a subsidiary tool in the recipe. Should receive a `\lean{...}` pin with a brief block statement.

2. **`AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec`** (L203) — the morphism-level factorization `Proj.awayι 𝒜 f = Spec.map(basicOpenIsoAway.inv) ≫ (isAffineOpen_basicOpen).fromSpec`. This is the PRIMARY iter-196 output and the substrate for proving `lem:awayi_app_basicOpen`. Its absence from the blueprint `\lean{...}` index means the link between the iter-196 substrate work and the blueprint recipe is invisible to the review tools.

Both are at the general graded-ring abstraction level and carry no `kbar` or `projectiveLineBarGrading` references.

---

## Blueprint adequacy for this file

- **Coverage**: Of the two new `\lean{...}` pins introduced in iter-196 (at L1315 and L1440), **neither** has a corresponding Lean declaration yet. The two Lean declarations actually landed in iter-196 (`Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec`) have **no** blueprint `\lean{...}` references.

- **Proof-sketch depth**: **under-specified** for `lem:awayi_app_basicOpen`. The proof sketch (Steps 1–4, L1364-1431) is mathematically correct and describes the right four-step structure. However:
  1. Step 1 refers to the non-existent analogue `Proj.awayι_eq_isoSpec_ι_comp` rather than the landed `Proj.awayι_eq_specMap_fromSpec`.
  2. Step 3, which requires inverting `Proj.basicOpenIsoSpec.inv.app ⊤`, should be extracted as a **named intermediate helper** `Proj.basicOpenIsoSpec_inv_app_top` — the exact step where iter-196 failed. The `Scheme.Hom.app` dependent-motive issue makes this step non-trivial in Lean even when the mathematics is routine; without a named helper the iter-197 prover faces the same blocker.
  3. The proof sketch does NOT mention the dependent-motive obstruction that caused 9 consecutive stuck iterations (iter-188 through iter-196).

- **Hint precision**: **loose** for `lem:awayi_app_basicOpen`. The `\lean{AlgebraicGeometry.Proj.awayι_app_basicOpen}` pin names a section-level formula, while the infrastructure the prover landed is morphism-level. The recipe sketch does not bridge these two levels explicitly.

- **Generality**: matches need — both landed Lean declarations are at the correct general-purpose (graded ring `𝒜 : ℕ → σ`) level as planned.

- **Recommended chapter-side actions**:
  1. **[must-fix-this-iter]** Add a `\begin{lemma}...\end{lemma}` block for `Proj.basicOpenIsoSpec_inv_app_top` with a `\lean{...}` pin. Statement: `(Proj.basicOpenIsoSpec 𝒜 f f_deg hm).inv.app ⊤ = (Proj.basicOpen 𝒜 f).topIso.hom ≫ (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫ (Scheme.ΓSpecIso _).inv`. Proof: `Scheme.inv_app` + `Proj.basicOpenIsoSpec_hom` + `Proj.basicOpenToSpec_app_top` + iso inversion. ~5-15 LOC.
  2. **[major]** Update Step 1 of the `lem:awayi_app_basicOpen` proof sketch to reference `Proj.awayι_eq_specMap_fromSpec` (the landed declaration) instead of the non-existent `Proj.awayι_eq_isoSpec_ι_comp`. Update the approach: instead of `change (basicOpenIsoSpec.inv ≫ ι).app _`, use `rw [Proj.awayι_eq_specMap_fromSpec]` → `comp_app` split into `fromSpec.app ⊤` and `Spec.map(basicOpenIsoAway.inv).app _`. This also addresses the dependent-motive issue because both sides of the factorization have the same app-codomain type.
  3. **[major]** Add a `\lean{...}` block for `Proj.awayι_eq_specMap_fromSpec` (morphism-level factorization, iter-196 landed). This is a prerequisite for `lem:awayi_app_basicOpen`.
  4. **[major]** Add a `\lean{...}` block for `Proj.awayι_preimage_basicOpen_self` (preimage identity, iter-196 landed). Brief statement block; marks it as formalized infrastructure.

---

## Severity summary

- **must-fix-this-iter** (1):
  - **Blueprint adequacy failure for `lem:awayi_app_basicOpen`**: The proof sketch is under-specified in a way that caused 9 consecutive stuck iterations. The missing intermediate helper `Proj.basicOpenIsoSpec_inv_app_top` must be added to the blueprint with a `\lean{...}` pin before the iter-197 prover is dispatched, or the dependent-motive blocker will recur.

- **major** (4):
  - `Proj.awayι_app_basicOpen` does not exist in the Lean file — the `\lean{...}` pin at blueprint L1315 has no matching declaration.
  - `Proj.awayι_appIso_top_inv_apply_isLocElem` does not exist in the Lean file — the `\lean{...}` pin at blueprint L1440 has no matching declaration.
  - `Proj.awayι_eq_specMap_fromSpec` (L203, axiom-clean, iter-196 key output) has no `\lean{...}` reference in the blueprint.
  - `Proj.awayι_preimage_basicOpen_self` (L190, axiom-clean, iter-196 output) has no `\lean{...}` reference in the blueprint.

- **minor** (1):
  - Blueprint Step 1 of `lem:awayi_app_basicOpen` proof sketch names `Proj.awayι_eq_isoSpec_ι_comp` (non-existent) instead of the landed `Proj.awayι_eq_specMap_fromSpec`; stale reference that misleads the next prover.

**Overall verdict**: The two iter-196 landed Lean substrate primitives (`awayι_preimage_basicOpen_self`, `awayι_eq_specMap_fromSpec`) are axiom-clean and correct but are not referenced by the blueprint — the blueprint instead pins two future targets (`awayι_app_basicOpen`, `awayι_appIso_top_inv_apply_isLocElem`) that were NOT landed this iteration. The blueprint recipe proof sketch is under-specified: it does not name `Proj.basicOpenIsoSpec_inv_app_top` as the blocking intermediate, and its Step 1 references a non-existent declaration. The two Lane E sorries (`kbarChart1Ring_specMap_fac` L324, `iotaGm_chart1_appIso_eval` L532) remain unresolved and are correctly described by the blueprint. Recommended action before iter-197 prover dispatch: blueprint-writer adds `Proj.basicOpenIsoSpec_inv_app_top` block (must-fix) and updates Step 1 of `lem:awayi_app_basicOpen` sketch (major).
