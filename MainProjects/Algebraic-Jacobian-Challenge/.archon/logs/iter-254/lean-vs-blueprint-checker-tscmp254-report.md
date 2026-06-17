# Lean ↔ Blueprint Check Report

## Slug
tscmp254

## Iteration
254

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2073 lines, 2 `sorry` tactics at lines 712 and 2064)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (consolidated chapter, focus on D1' blocks)

---

## Per-declaration (D1' focus)

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural}` (chapter: `\lem:sheafify_tensor_unit_iso_natural`)

- **Lean target exists**: yes (line 1941, `lemma sheafifyTensorUnitIso_hom_natural`)
- **Signature matches**: yes
  - Blueprint: "The tensor/unit reconciliation isomorphism `sheafifyTensorUnitIso` is natural in both module arguments: naturality square in `p : P → P'`, `q : Q → Q'`."
  - Lean signature: `{P P' Q Q' : PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)} (p : P ⟶ P') (q : Q ⟶ Q') : a.map (p ⊗ q) ≫ (sheafifyTensorUnitIso P' Q').hom = (sheafifyTensorUnitIso P Q).hom ≫ a.map (tensorHom (a.map p).val (a.map q).val)`.
  - Match is correct.
- **Proof follows sketch**: **no — different mathematical route, same conclusion**
  - Blueprint proof sketch (3-step descent): (1) `PresheafOfModules.Hom.ext` to sections; (2) `ModuleCat.hom_ext` to elements; (3) TensorProduct induction on pure tensors, closing each leg by `η`-naturality.
  - Lean proof (actual, iter-254): uses the private helper `sheafifyTensorUnitIso_hom_eq'` (line 1882) to restate `.hom` as a single `a.map (tensorHom η_P η_Q)` on the canonical `⋙ forget₂` carrier; then applies `← Functor.map_comp` (`erw`) to merge the two `a.map _` factors; then closes by `tensorHom_comp_tensorHom` applied **as a term** with explicit `(C := PresheafOfModules (X.presheaf ⋙ forget₂ ...))` (not a rewrite — the non-canonical monoidal instance baked into the goal blocks rewriting), and the two single-component unit-naturality squares `hp`/`hq`.
  - No `TensorProduct` induction is used. No `ModuleCat.hom_ext` or section-level descent. The proof is shorter and works at the categorical (tensor-morphism) level throughout.
- **notes**:
  - STEP A CLOSED axiom-clean this iter. The Lean declaration has no sorry.
  - `sheafifyTensorUnitIso_hom_eq'` (line 1882, private) is the key new helper: it states `.hom` as a single `a.map (η_P ⊗ η_Q)` and is the PIN that makes the bifunctoriality step work without instance-diamond collisions. It is NOT mentioned in the blueprint.
  - Blueprint statement block has `\leanok` (correct: declaration formalized). Blueprint proof block does NOT have `\leanok` — this is a stale marker issue (proof is now sorry-free; `sync_leanok` should add the proof-block marker).
  - The blueprint proof sketch says "the whisker-exchange law does NOT close it" and then prescribes TensorProduct induction. The Lean proof sidesteps both the whisker-exchange failure AND the induction by using the tensorHom-PIN. The blueprint's prescribed approach (section/element descent) would also work but is not what was done.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (chapter: `\lem:pullback_tensor_map_natural`)

- **Lean target exists**: yes (line 2004, `lemma pullbackTensorMap_natural`)
- **Signature matches**: yes
  - Blueprint: naturality square of `pullbackTensorMap f` in `a : M → M'`, `b : N → N'`.
  - Lean: `(Scheme.Modules.pullback f).map (tensorObj_functoriality a b) ≫ pullbackTensorMap f M' N' = pullbackTensorMap f M N ≫ tensorObj_functoriality ((pullback f).map a) ((pullback f).map b)`.
  - Match is correct.
- **Proof follows sketch**: **partial** (two squares closed; Square 2 (S2, δ naturality) is the open sorry; the blueprint says S2 is the "easy" Mathlib step)
  - Blueprint sketch: paste of 4 naturality squares. Square 1 (sheafificationCompPullback), Square 2 (δ_natural for any oplax functor), Square 3 (sheafifyTensorUnitIso), Square 4 (pullbackValIso). Blueprint describes S3 as "the hard square not closed by whisker-exchange."
  - Lean (actual, lines 2026–2064): Square 1 (S1) CLOSED via `.hom.naturality_assoc`. Square 3 (S3) IS NOW CLOSED (STEP A this iter). Square 4 (S4) CLOSED via `pullbackValIso_hom_natural`. Square 2 (S2, `δ_natural`) is the remaining **SORRY at line 2064** due to a structural blocker.
  - S3 is no longer the hard square — S2 is the actual blocker.
- **notes**: The sorry at line 2064 carries an explicit blocker comment: `δ_natural (F := PresheafOfModules.pullback φ')` fails with `failed to synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)`. The `δ_natural` Mathlib lemma requires a `MonoidalCategory` instance on the domain ring's presheaf category, but that instance is registered only on the canonical spelling `X.presheaf ⋙ forget₂ CommRingCat RingCat`, not on `X.ringCatSheaf.obj` (which is the spelling that arises after unfolding `pullbackTensorMap`'s definition). The fix is a structural spelling-pin: restate `pullbackTensorMap` and its helper isos with the canonical `⋙ forget₂` spelling throughout. This is a plan-level structural decision (must keep `pullbackTensorMap_unit_isIso` GREEN after the refactor).

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural` at line 2064: body is `:= ... sorry` and the blueprint claims a substantive naturality proof. This is a **tracked sorry** — the directive confirms this is known. It is NOT a silent placeholder; the body contains ~40 lines of documented partial progress with an explicit blocker comment.
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` at line 712: body is `sorry`. Blueprint `lem:tensorobj_inverse_invertible` claims this is a real lemma. Known tracked sorry from prior iters; blueprint has `\leanok` on statement block (correct). Not new this iter.

### Excuse-comments
- Line 2019–2020: comment in `pullbackTensorMap_natural`'s body refers to S3 (`sheafifyTensorUnitIso_hom_natural`) as "its presheaf residual is the one open sorry." **This is now stale** — STEP A was CLOSED this iter, so S3 is no longer an open sorry. Minor cleanup needed.

### Axioms / Classical.choice on non-trivial claims
- None introduced this iter.

---

## Unreferenced declarations (informational)

The following declarations in this file have no `\lean{...}` reference in the blueprint; most are helpers:

- `sheafifyTensorUnitIso_hom_eq` (line 1857, private) — private helper showing `.hom` as two whiskered maps. Acceptable as internal.
- `sheafifyTensorUnitIso_hom_eq'` (line 1882, private) — **the critical iter-254 PIN** restating `.hom` as a single `tensorHom`. This is the technical linchpin of STEP A; it is not blueprint-referenced because it is private, but it deserves mention in the blueprint proof sketch for `lem:sheafify_tensor_unit_iso_natural` (the current sketch describes TensorProduct induction instead).
- `pullbackValIso_hom_natural` (line 1906) — has its own `\lean{...}` reference in `lem:pullback_val_iso_natural`. ✓
- `isIso_sheafify_tensorHom_pullbackValIso` (line 1324, private) — private helper. OK.
- Several other helpers (private lemmas, `isIso_pbu_of_final`, etc.) — correctly private, not needing blueprint coverage.

---

## Blueprint adequacy for this file

### Coverage
- `sheafifyTensorUnitIso_hom_natural`: has `\lean{...}` pin ✓
- `pullbackTensorMap_natural`: has `\lean{...}` pin ✓
- Private helpers `sheafifyTensorUnitIso_hom_eq'`, `W_of_isIso_sheafification`, etc.: acceptable as un-pinned helpers.

### Proof-sketch depth: **under-specified** for `lem:pullback_tensor_map_natural`; **stale** for `lem:sheafify_tensor_unit_iso_natural`

**For `lem:pullback_tensor_map_natural`** (the D1' sorry, open):

The blueprint proof says of S2: "the abstract oplax δ is natural in both arguments — this holds for any oplax monoidal functor." This is mathematically correct but Lean-inadequate: it does not explain that applying `Functor.OplaxMonoidal.δ_natural` requires the domain monoidal-category instance to synthesize against the goal, and that the goal's domain ring is spelled `X.ringCatSheaf.obj` after unfolding `pullbackTensorMap`'s definition — a spelling on which `MonoidalCategory` is NOT registered (only `X.presheaf ⋙ forget₂ CommRingCat RingCat` carries the instance).

A prover following this blueprint sketch would:
1. Unfold `pullbackTensorMap` on both sides
2. Try to apply `δ_natural` at S2
3. Fail with `failed to synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)`
4. Have no blueprint guidance on why or how to fix it

The fix (spelling-pin: restate `pullbackTensorMap` with the canonical spelling) is a structural decision — it cannot be discovered from the prose.

**For `lem:sheafify_tensor_unit_iso_natural`** (CLOSED this iter):

The blueprint proof describes TensorProduct induction ("one pure tensor at a time"). The Lean proof does NOT use TensorProduct induction; instead it uses a categorical `tensorHom_comp_tensorHom`-term approach with the `sheafifyTensorUnitIso_hom_eq'` PIN. The blueprint sketch is now misleading — a future reader following the blueprint proof sketch would write a more complex proof (element descent) than necessary.

### Hint precision: **adequate** for statement declarations; **misleading** for proof prescriptions

The `\lean{...}` pins are correct. The proof prescriptions for both lemmas describe approaches that either (a) fail as written (`δ_natural` for `pullbackTensorMap_natural`) or (b) are longer than necessary (TensorProduct induction for `sheafifyTensorUnitIso_hom_natural`).

### Generality: **matches need**

### Recommended chapter-side actions

1. **[Must-fix]** Add a note to the proof of `lem:pullback_tensor_map_natural` explaining the carrier-spelling constraint: `δ_natural` requires `MonoidalCategory (PresheafOfModules X.presheaf ⋙ forget₂ ...)` but after unfolding `pullbackTensorMap` the domain ring is spelled `X.ringCatSheaf.obj` (defeq, not syntactically equal). The prescribed fix is a **structural spelling-pin refactor** of `pullbackTensorMap` and its helper isos: restate them with the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` domain-ring spelling so that `δ_natural` synthesizes by construction. This refactor must preserve `pullbackTensorMap_unit_isIso` (keep GREEN). Without this guidance, the proof recipe is impossible to follow as written.

2. **[Major]** Update the proof sketch of `lem:sheafify_tensor_unit_iso_natural` to reflect the actual proof (CLOSED iter-254 via `tensorHom`-PIN + `tensorHom_comp_tensorHom`): state `.hom` as a single `a.map (η_P ⊗ η_Q)` via the helper `sheafifyTensorUnitIso_hom_eq'`, merge the two `a.map` factors via `← Functor.map_comp` (`erw`), and apply bifunctoriality (`tensorHom_comp_tensorHom` as a TERM with explicit `(C := ...)`) + two single-component unit-naturality squares. Remove the TensorProduct-induction description.

3. **[Minor]** Add `\leanok` to the proof block of `lem:sheafify_tensor_unit_iso_natural` — this should happen automatically via `sync_leanok`, but should be verified.

---

## Severity summary

### must-fix-this-iter
- **Blueprint proof inadequate for `lem:pullback_tensor_map_natural`**: The proof says "δ is natural for any oplax monoidal functor" (correct claim), but does NOT explain the Lean-specific carrier-spelling constraint that makes `δ_natural` fail in the concrete goal. The prescribed route — apply `δ_natural` at S2 — is impossible as written because `MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)` can't be synthesized. The chapter gives no guidance on the required spelling-pin structural refactor. This is a blueprint adequacy failure: a prover cannot formalize `lem:pullback_tensor_map_natural` correctly from the prose alone.

### major
- **Proof sketch divergence for `lem:sheafify_tensor_unit_iso_natural`**: Blueprint prescribes TensorProduct induction (sections → elements → pure tensors) but the Lean proof (CLOSED iter-254) uses `tensorHom_comp_tensorHom` at the categorical level via `sheafifyTensorUnitIso_hom_eq'`. Different routes, same conclusion; the sketch is now misleading for future readers and duplicates complexity compared to the actual proof.

### minor
- **Stale comment in `pullbackTensorMap_natural` body** (line 2019–2020): references S3 (`sheafifyTensorUnitIso_hom_natural`) as an "open sorry" but STEP A was CLOSED this iter. Comment should be updated to say S3 is CLOSED.
- **Proof-block `\leanok` missing** for `lem:sheafify_tensor_unit_iso_natural`: the proof is now sorry-free but the proof block is not marked. Auto-fixed by `sync_leanok`.

**Overall verdict**: One must-fix (blueprint proof for `pullbackTensorMap_natural` is inadequate regarding the spelling-pin constraint — the only remaining sorry after STEP A), one major (stale proof sketch for the now-closed `sheafifyTensorUnitIso_hom_natural`), two minors — 4 declarations checked (2 D1' targets + 2 sorry-counting references), 4 findings.
