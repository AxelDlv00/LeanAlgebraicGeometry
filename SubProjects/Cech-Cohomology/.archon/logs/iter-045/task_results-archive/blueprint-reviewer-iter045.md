# Blueprint Review Report

## Slug
iter045

## Iteration
045

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Gate-critical chapter. All three directive checks pass — see detailed verdict below.

---

## Gate-critical chapter detailed verdict

**Chapter**: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Prover target this iter**: `lem:tile_section_localization` / `AlgebraicGeometry.tile_section_localization`

### complete: true
### correct: true
### Must-fix-this-iter findings: NONE

**Gate clears. Prover may be dispatched on `tile_section_localization` this iter.**

---

### Directive check 1 — Coverage debt cleared (five new blocks)

All five blocks are present with correct `\lean{}` pins, `\uses{}` graphs, and proof sketches.

**`lem:appTop_appIso_inv_eq_res`** (line 4472):
- `\lean{AlgebraicGeometry.appTop_appIso_inv_eq_res}` — matches the Lean `theorem appTop_appIso_inv_eq_res {X Y : Scheme} (f : X ⟶ Y) [IsOpenImmersion f] : Scheme.Hom.appTop f ≫ (Scheme.Hom.appIso f ⊤).inv = Y.presheaf.map (homOfLE (le_top : f ''ᵁ ⊤ ≤ ⊤)).op`
- No `\uses{}` needed (standalone; no project dependencies).
- Proof sketch adequate: naturality square argument, open-immersion ring iso identification. ✓

**`lem:key_morph`** (line 4498):
- `\lean{AlgebraicGeometry.key_morph}` — matches the Lean `theorem key_morph (g : R) : (Scheme.ΓSpecIso R).inv ≫ ... = CommRingCat.ofHom (algebraMap R (Localization.Away g)) ≫ (Scheme.ΓSpecIso ...).inv ≫ ((specAwayToSpec g).appIso ⊤).inv`
- `\uses{lem:appTop_appIso_inv_eq_res}` — correct (Lean proof uses it via `appTop_appIso_inv_eq_res`). ✓
- Proof sketch adequate: ΓSpec naturality applied to `specAwayToSpec g = Spec.map(algebraMap R R_g)`, then substitution via `lem:appTop_appIso_inv_eq_res`. ✓

**`lem:tile_appIso_comp`** (line 4529):
- `\lean{AlgebraicGeometry.tile_appIso_comp}` — matches `theorem tile_appIso_comp (g : R)` in Lean.
- No `\uses{}` — correct; only Mathlib's `comp_appIso` is used, no project lemmas.
- Proof sketch adequate: comp_appIso functoriality + structure-sheaf transport folding. ✓

**`lem:tile_section_ring_identity`** (line 4555):
- `\lean{AlgebraicGeometry.tile_section_ring_identity}` — matches `theorem tile_section_ring_identity (g : R)` in Lean.
- `\uses{lem:key_morph, lem:tile_appIso_comp}` — both used in the Lean proof (`key_morph` via `reassoc_of%`, `tile_appIso_comp` directly). ✓
- Proof sketch adequate: substitute ΓSpec naturality (key_morph), replace single β_ι^{-1} by two-factor composite (tile_appIso_comp), transport merges in thin opens category. ✓

**`lem:tile_scalar_compat`** (line 4581):
- `\lean{AlgebraicGeometry.tile_scalar_compat}` — matches `lemma tile_scalar_compat (F : (Spec R).Modules) (g r : R) (x : ...) : r • (...) = (algebraMap R (Localization.Away g) r) • x` in Lean (axiom-clean, iter-044 confirmed).
- `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq, lem:tile_section_ring_identity}` — all three used in the Lean proof. ✓
- Proof sketch adequate: two rfl-bridges reduce both scalar actions to structure-sheaf actions, ring identity (`lem:tile_section_ring_identity`) closes the comparison. ✓

**Summary**: Coverage debt cleared. All five blocks are statement-accurate against Lean, have correct `\uses{}` graphs, and carry adequate proof sketches.

---

### Directive check 2 — `lem:tile_section_comparison` corrected (line 4614)

Three criteria:

1. **Unpinned (no `\lean{}`)** — CONFIRMED. No `\lean{}` appears in the statement block. The two `% NOTE` comment blocks (lines 4615–4629) explicitly instruct against pinning `tile_scalar_compat` to this block and declare it stays unformalized. ✓

2. **Distinguishes carrier equality from bundled-module defeq** — CONFIRMED. Lines 4654–4660: "This is an equality of the underlying section *types* only: the *bundled* module objects do *not* coincide definitionally. The tile side is an $R_g$-module object and the $\mathcal{F}$ side an $R$-module object; these are different objects of different module categories ($\mathrm{Mod}\,R_g$ versus $\mathrm{Mod}\,R$), not the same bundled object." Lines 4670–4671: "not a definitional coincidence of bundled modules." ✓

3. **Names route-(A) helper chain** — CONFIRMED. Lines 4702–4710: "At morphism (ring-map) level the displayed identity is exactly Lemma~\ref{lem:tile_section_ring_identity}, which is assembled from the $\Gamma$-$\Spec$ naturality of the localisation immersion (Lemma~\ref{lem:key_morph}) and the composition of the two tile section isomorphisms (Lemma~\ref{lem:tile_appIso_comp}). Feeding this ring identity through the scalar-reduction identities (Lemmas~\ref{lem:modulesSpecToSheaf_smul_eq} and \ref{lem:modulesRestrictBasicOpen_smul_eq}) yields the scalar reconciliation at the source open $V = \top$, which is Lemma~\ref{lem:tile_scalar_compat}." ✓

**Summary**: `lem:tile_section_comparison` is correctly written — unpinned, no over-claim of "definitional", helper chain named.

---

### Directive check 3 — `lem:tile_section_localization` Step 4 fixed (lines 4759–4784)

Five criteria:

1. **Does NOT reference `lem:tile_section_comparison` in `\uses{}`** — CONFIRMED. The `\uses{}` block (lines 4716–4720) is: `lem:qcoh_finite_presentation_cover, lem:presentation_modulesRestrictBasicOpen, lem:section_isLocalizedModule_of_presentation, lem:restrict_obj_mathlib, lem:isLocalizedModule_powers_restrictScalars_of_algebraMap, lem:tile_image_opens_identities, lem:tile_scalar_compat, lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq`. `lem:tile_section_comparison` is absent. ✓

2. **Describes underlying-type descent path** — CONFIRMED. Lines 4760–4770: "The bundled tile sections and the bundled $\mathcal{F}$-sections live in different module categories ($\mathrm{Mod}\,R_g$ versus $\mathrm{Mod}\,R$) and are *not* the same object, so the carrier identification of Lemma~\ref{lem:restrict_obj_mathlib} can only be used as an equality of underlying section types... On that common underlying type one installs, by transport along the carrier identity, a $\Gamma_R(-,\mathcal{F})$ module structure together with the scalar tower $R \to R_g$." ✓

3. **Uses `lem:tile_scalar_compat` for scalar-tower compatibility at V=⊤** — CONFIRMED. Lines 4767–4770: "The scalar-tower compatibility at the source open $V = \top$ (so $W = D(g)$) is exactly Lemma~\ref{lem:tile_scalar_compat}, whose two scalar prescriptions agree by the scalar-reduction identities (Lemmas~\ref{lem:modulesSpecToSheaf_smul_eq} and \ref{lem:modulesRestrictBasicOpen_smul_eq})." ✓

4. **Explicitly acknowledges V=D(f̄) scalar-compat sub-need beyond V=⊤** — CONFIRMED. Lines 4773–4777: "There is, however, a second open to account for. The localisation map of Step 2 runs from the source open $V = \top$ (image $D(g)$) to the target open $V = D(\bar f)$ (image $D(gf)$). The base-ring descent of Step 5 needs the same scalar-tower compatibility $R \to R_g$ at the *target* open $V = D(\bar f)$, not only at $V = \top$. As formalized, Lemma~\ref{lem:tile_scalar_compat} covers only $V = \top$; Step 4 therefore additionally requires a $V = D(\bar f)$ analogue of the scalar compatibility." ✓

5. **States how to obtain the V=D(f̄) analogue** — CONFIRMED. Lines 4777–4784: "This analogue is obtained by mechanical reuse of the same route-(A) $\Gamma$-$\Spec$ naturality machinery one localisation deeper... re-running the argument of Lemmas~\ref{lem:key_morph} and \ref{lem:tile_section_ring_identity} at the composed basic open $gf$ (equivalently, generalising Lemma~\ref{lem:tile_scalar_compat} from $V = \top$ to an arbitrary basic open $V$) supplies the scalar compatibility at $V = D(\bar f)$." ✓

**Summary**: Step 4 is correctly written. It is grounded in the underlying-type descent, uses `lem:tile_scalar_compat` (not `lem:tile_section_comparison`), explicitly names the V=D(f̄) sub-need, and provides the route to close it.

---

## Dependency & isolation findings

### Leandag run summary
- `unknown_uses: []` — zero broken `\uses{}` edges.
- Isolated nodes: 1 (a `lean_aux` node, no blueprint entry).
  - `lean:AlgebraicGeometry...` (lean_aux) — **keep**: isolated lean_aux nodes are uncovered Lean helpers, not removal candidates. No blueprint action needed.
- `unmatched_lean` (56 entries): all expected — they are blueprint-pinned declarations not yet formalized in Lean (active or future prover targets). `lem:tile_section_localization` appears here because `AlgebraicGeometry.tile_section_localization` is the prover's target this iter (not yet written). This is correct behavior.
- `with_sorry: 2` — two current proof obligations (`CechHigherDirectImage.lean:679`, `CechAcyclic.lean:110`); not a blueprint finding.

### Blueprint doctor
`archon blueprint-doctor --json` returns zero `malformed_refs`, zero `broken_refs`, zero orphan chapters, zero `covers_problems`. Rendering is clean.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

---

**Overall verdict**: `Cohomology_CechHigherDirectImage.tex` is complete and correct with no must-fix findings; all three directive gate checks pass. Gate clears for prover dispatch on `AlgebraicGeometry.tile_section_localization` this iter. The other two chapters are complete and correct. Zero unstarted phases without blueprint coverage.
