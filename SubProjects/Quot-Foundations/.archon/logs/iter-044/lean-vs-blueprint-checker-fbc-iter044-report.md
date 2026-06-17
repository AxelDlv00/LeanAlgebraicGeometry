# Lean ↔ Blueprint Check Report

## Slug
fbc-iter044

## Iteration
044

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (2563 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (4433 lines)

---

## Per-declaration (directive focus)

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj}` (chapter: `lem:base_change_mate_fstar_reindex_legs_conj`)

- **Lean target exists**: yes — `theorem base_change_mate_fstar_reindex_legs_conj` at line 1757
- **Signature matches**: yes — takes `ψ : R ⟶ R'`, `φ : R ⟶ A`, `M : ModuleCat A`, universally quantified over free legs `g'`, `f'` with explicit cone-leg equations `hfst`/`hsnd` and commutativity `comm`; conclusion is the equality against `base_change_mate_inner_value ψ φ M` through the conjugate-native codomain read `base_change_mate_codomain_read_legs_conj` (conj-1a) — this matches the blueprint's statement exactly
- **Proof follows sketch**: partial — blueprint sketch (peel one adjunction layer at a time via `conjugateEquiv_symm_comp`, discharge per-layer by conj-2b/2c/2d) is being followed; iter-044 added the verified first rungs `adjL` (line 1870) and `hunitL` (line 1875–1880), which compile and prove; the proof ends with `sorry` at line 1891 (the full `conjugateEquiv.injective` / `adjR`-construction / conj-2b+2c+2d chain is not yet assembled)
- **notes**: Blueprint marks `\leanok` at line 2215. Lean has a direct `sorry` at line 1891. This is a **must-fix mismatch**: the blueprint claims the declaration is proved, but it is not.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_sections_direct}` (chapter: `lem:pushforward_base_change_mate_sections_direct`)

- **Lean target exists**: **no** — no declaration with this name exists anywhere in `FlatBaseChange.lean` or any other file under `AlgebraicJacobian/`. Confirmed by exhaustive `grep -rn`.
- **Signature matches**: N/A (no Lean target)
- **Proof follows sketch**: N/A
- **notes**: Blueprint has `\lean{AlgebraicGeometry.pushforward_base_change_mate_sections_direct}` at line 3289 but **no `\leanok`**. This is a frontier node (the blueprint intends this to be proved but does not claim it done). The absent Lean declaration is therefore consistent with the `\leanok` status — no `\leanok`/`sorry` mismatch here. However, the iter-043 reversal established that the `sections_direct` route is **illusory**: it reduces to the same `_legs_conj` crux it was supposed to bypass. The blueprint's frontier still lists `sections_direct` as the prescribed route for `cancelBaseChange` (blueprint note lines 3449–3456: "the direct section-value lemma `lem:pushforward_base_change_mate_sections_direct` shows the conjugate … This route does NOT depend on `lem:base_change_mate_gstar_transpose`"). This prescription is incorrect per iter-043 analysis — pursuing it would reproduce the same crux. The blueprint has NOT been updated to reflect this reversal. **Major** blueprint adequacy finding.

---

## Additional `\leanok`/`sorry` mismatches found in the full audit

The directive's focused check revealed three further mismatches beyond the keystone:

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (chapter: `lem:base_change_mate_gstar_transpose`)

- **Lean target exists**: yes — `theorem base_change_mate_gstar_transpose` at line 2233
- **Signature matches**: yes — the `Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt = regroupEquiv.inv` equality (the `(g^* ⊣ g_*)` counit-conjugate crux)
- **Proof follows sketch**: partial — substantial scaffolding (adjL/adjR/huce/hcounitL/hcounitR) is in place and compiling; the proof ends in `sorry` at line 2358; blueprint sketch (remaining ~150-LOC telescoping steps (a)/(b)/(c)) is not yet executed
- **Blueprint `\leanok`**: yes (line 2989)
- **Classification**: **must-fix** — blueprint claims proved, Lean has direct `sorry`

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)

- **Lean target exists**: yes — `theorem affineBaseChange_pushforward_iso` at line 2508
- **Signature matches**: yes
- **Proof follows sketch**: partial — the locality reduction step (`base_change_map_affine_local`) is correctly applied; the affine-restriction step reducing the per-affine-open goal to the affine–affine model ends in `sorry` at line 2539; the Lean comment accurately describes the remaining gap (restriction-compatibility of `pushforwardBaseChangeMap`, Mathlib-absent, multi-hundred-LOC build)
- **Blueprint `\leanok`**: yes (line 3544)
- **Classification**: **must-fix** — blueprint claims proved, Lean has direct `sorry`

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)

- **Lean target exists**: yes — `theorem flatBaseChange_pushforward_isIso` at line 2548
- **Signature matches**: yes
- **Proof follows sketch**: no — body is a stub with a strategy comment and `sorry` at line 2561; the blueprint proof sketch (Čech complex + flatness + affine cover) has not been begun
- **Blueprint `\leanok`**: yes (line 3988)
- **Classification**: **must-fix** — blueprint claims proved, Lean has direct `sorry`

### Transitively sorry-backed (informational — no direct sorry in body)

The following have `\leanok` in blueprint, no direct `sorry` in Lean body, but are transitively sorry-backed through `base_change_mate_gstar_transpose`:
- `base_change_mate_section_identity` (line 2387): body `exact base_change_mate_gstar_transpose ψ φ M`; blueprint `\leanok` at line 3145
- `base_change_mate_generator_trace` (line 2416): body `rw [base_change_mate_section_identity]; infer_instance`; blueprint `\leanok` at line 3241
- `pushforward_base_change_mate_cancelBaseChange` (line 2457): body `haveI hconj := base_change_mate_generator_trace …; rw [heq]; infer_instance`; blueprint `\leanok` at line 3439

These are structurally correct relative to the blueprint sketch and have no inline sorries, so they are **major** rather than must-fix. Once `base_change_mate_gstar_transpose` is closed, they inherit the proof.

---

## Red flags

### Placeholder / suspect bodies

- `base_change_mate_fstar_reindex_legs_conj` at line 1891: `sorry` — blueprint marks `\leanok`; the proof body has two compiled lines (`adjL`, `hunitL`) but the conclusion is deferred
- `base_change_mate_gstar_transpose` at line 2358: `sorry` — blueprint marks `\leanok`; large scaffolding block precedes it
- `affineBaseChange_pushforward_iso` at line 2539: `sorry` — blueprint marks `\leanok`; affine-restriction reduction is the remaining gap
- `flatBaseChange_pushforward_isIso` at line 2561: `sorry` — blueprint marks `\leanok`; body is a pure strategy stub

### Excuse-comments

No comments of the form "wrong but works for now" or "temporary placeholder". All `sorry` blocks carry accurate forward-looking descriptions of what remains; this is appropriate and not a red flag.

### Axioms / Classical.choice

None found by inspection.

---

## Unreferenced declarations (informational)

The following significant declarations in the Lean file have no `\lean{...}` reference in the blueprint chapter. They appear to be internal helpers or scaffolding:

- `Modules.isIso_iff_isIso_stalkFunctor_map`, `Modules.isIso_of_isIso_app_of_isBasis`, `Modules.isIso_iff_isIso_app_affineOpens` (lines 102–169) — these DO have `\lean{}` references at lines 87, 115, 141 of the blueprint; they are correctly covered.
- `base_change_mate_reindex_conj_pullbackLeg` (line 1625), `base_change_mate_reindex_conj_crossLayer` (line 1652), `base_change_mate_reindex_conj_pushforwardCollapse` (line 1736) — these supporting legs are referenced internally in the blueprint's proof sketch for `lem:base_change_mate_fstar_reindex_legs_conj` (via `\uses{}`) but do NOT have standalone `\lean{}` blocks; they are helpers. Acceptable.
- `base_map_affine_local` (line 2496) — has `\lean{}` reference at blueprint line 3547's `\uses{}` block; covered.

No substantive declaration appears to be missing blueprint coverage beyond the already-noted `sections_direct` absent Lean declaration.

---

## Blueprint adequacy for this file

- **Coverage**: All major Lean declarations have corresponding `\lean{...}` blocks. Helper declarations (conjugate legs, gammaMap utilities) are referenced in `\uses{}` groups where appropriate.
- **Proof-sketch depth**: **adequate for proved blocks; misleading for frontier nodes**. The proof sketches for proved declarations (e.g. `pushforwardBaseChangeMap`, the locality criteria, `affineBaseChange` locality step) match the Lean proofs faithfully. The sketch for the outstanding `_legs_conj` crux accurately describes the `conjugateEquiv.injective` + layer-peel route and is being followed.
- **`sections_direct` frontier: misleading**. The blueprint's note for `lem:pushforward_base_change_mate_cancelBaseChange` (lines 3449–3456) prescribes `sections_direct` as the route that avoids the conjugate-counit crux. The iter-043 analysis found this route reduces to the same `_legs_conj` crux. The blueprint frontier node `lem:pushforward_base_change_mate_sections_direct` therefore points at a route that, if pursued, reproduces the blocked crux rather than bypassing it. The blueprint should be updated to record this reversal and mark `sections_direct` as a dead-end record (analogous to how `lem:base_change_mate_gstar_transpose` is noted at lines 3282–3284 as no longer on the critical path).
- **Hint precision**: precise — `\lean{...}` hints name declarations that match the prose statements.
- **Generality**: matches need.

**Recommended chapter-side actions**:
1. Remove `\leanok` from `lem:base_change_mate_fstar_reindex_legs_conj` until the `sorry` at line 1891 is closed.
2. Remove `\leanok` from `lem:base_change_mate_gstar_transpose` until its `sorry` at line 2358 is closed.
3. Remove `\leanok` from `lem:affine_base_change_pushforward` until its `sorry` at line 2539 is closed.
4. Remove `\leanok` from `thm:flat_base_change_pushforward` until its `sorry` at line 2561 is closed.
5. Update the note in `lem:pushforward_base_change_mate_cancelBaseChange` (lines 3449–3456) to record that the `sections_direct` route is illusory (iter-043 reversal: reduces to the same `_legs_conj` crux). Mark `lem:pushforward_base_change_mate_sections_direct` as a dead-end record analogously to how the `gstar_transpose` crux is already marked at lines 3282–3284.

---

## Severity summary

| Finding | Severity |
|---|---|
| `base_change_mate_fstar_reindex_legs_conj`: blueprint `\leanok`, Lean has direct `sorry` at line 1891 | **must-fix** |
| `base_change_mate_gstar_transpose`: blueprint `\leanok`, Lean has direct `sorry` at line 2358 | **must-fix** |
| `affineBaseChange_pushforward_iso`: blueprint `\leanok`, Lean has direct `sorry` at line 2539 | **must-fix** |
| `flatBaseChange_pushforward_isIso`: blueprint `\leanok`, Lean has direct `sorry` at line 2561 | **must-fix** |
| `sections_direct` frontier: blueprint prescribes illusory route (iter-043 reversal not reflected); Lean decl absent but consistent with no-`\leanok` | **major** |
| `section_identity` / `generator_trace` / `cancelBaseChange`: blueprint `\leanok`, Lean body correct but transitively sorry-backed | **major** |

**Overall verdict**: The iter-044 scaffolding (`adjL`/`hunitL`) inside `base_change_mate_fstar_reindex_legs_conj` is structurally sound and verified, but 4 declarations carry `\leanok` in the blueprint while holding a direct `sorry` in Lean — all downstream of the two open cruxes (`_legs_conj` and `_gstar_transpose`). The blueprint's prescription of `sections_direct` as a crux-bypassing route is stale (reversed in iter-043) and should be annotated as abandoned.
