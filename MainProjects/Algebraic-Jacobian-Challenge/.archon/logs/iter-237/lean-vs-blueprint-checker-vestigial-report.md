# Lean ↔ Blueprint Check Report

## Slug
vestigial

## Iteration
237

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (chapter: `lem:isiso_sheafification_map_of_W`, line ~1005)
- **Lean target exists**: yes — `isIso_sheafification_map_of_W` at Vestigial.lean:231
- **Signature matches**: yes — morphism `f : A ⟶ B` with `J.W ((toPresheaf _).map f)` implies `IsIso ((sheafification α).map f)`; matches the blueprint statement exactly
- **Proof follows sketch**: yes — thin wrapper over `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`; blueprint describes this precisely
- **notes**: Axiom-clean. `\leanok` present on statement and proof blocks; consistent.

---

### `\lean{PresheafOfModules.stalkLinearMap}` (chapter: `lem:stalk_linear_map`, lines 1113–1156)
- **Lean target exists**: yes — `stalkLinearMap` at Vestigial.lean:278 (plus `stalkLinearMap_germ`:319, `stalkLinearMap_bijective_of_isIso`:340, `stalkLinearEquivOfIsIso`:353)
- **Signature matches**: N/A — there is **no `\lean{...}` tag** in `lem:stalk_linear_map`
- **Proof follows sketch**: yes — the proof sketch matches the germ-representative construction in Lean
- **notes**: The blueprint lemma block (lines 1113–1156) names all four declarations in prose (`\mathtt{stalkLinearMap}` etc.) but provides NO `\lean{...}` pin. Also NO `\leanok` marker. **This is a missing pin** — four axiom-clean declarations in Vestigial.lean lack a blueprint `\lean{}` reference.

---

### `\lean{PresheafOfModules.isIso_stalkFunctor_map_of_W}` (chapter: `lem:W_implies_stalkwise_iso`, lines 2106–2149)
- **Lean target exists**: yes — `isIso_stalkFunctor_map_of_W` at Vestigial.lean:438
- **Signature matches**: **partial mismatch** — the blueprint (lines 2124–2125) says the lemma also proves the **converse** ("Conversely, if the Ab-stalk map is an isomorphism at every point, then `(toPresheaf).map g ∈ J.W`"). The Lean declaration only proves the **forward** direction (`J.W T (z : Z) → IsIso (stalkFunctor ... z).map T`). The converse is split across `isLocallyInjective_of_injective_stalk` + `locally_surjective_iff_surjective_on_stalks`, both in Vestigial.lean but not referenced by this blueprint block.
- **Proof follows sketch**: partially — the forward direction's proof is correct. The blueprint prose describes the converse direction as part of this lemma, but the Lean splits it out.
- **notes**: `\leanok` present on statement and proof blocks; consistent for the forward direction. The blueprint should clarify that the converse is in separate declarations.

---

### `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` (chapter: `lem:stalk_tensor_commutation_naturality_right`, lines 2151–2204)
- **Lean target exists**: **NO** — the declaration `stalkTensorIso_naturality_right` does **not exist** in Vestigial.lean (nor anywhere in the project). The B-naturality argument was inlined as a `have key` tactic proof inside `isLocallyInjective_whiskerLeft_of_W` (Vestigial.lean:498–564), not proven standalone.
- **Signature matches**: N/A (no backing declaration)
- **Proof follows sketch**: N/A
- **notes**: **Dangling `\lean{}` pin.** The block at line 2151 has `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` and no `\leanok` (consistent — the marker is absent because there is no declaration). But the `\lean{}` tag still dangles. The `\uses{lem:stalk_tensor_commutation_naturality_right}` in the proof block of `lem:islocallyinjective_whiskerleft_via_stalk` (line 2235) is therefore a reference to a non-pinned, non-existent declaration.

---

### `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (chapter: `lem:islocallyinjective_whiskerleft_via_stalk`, lines 2206–2278)
- **Lean target exists**: yes — `isLocallyInjective_whiskerLeft_of_W` at Vestigial.lean:478
- **Signature matches**: yes (with a minor note below) — `[(Opens.grothendieckTopology X).WEqualsLocallyBijective AddCommGrpCat.{u}]`, arbitrary `F`, `g : M ⟶ N`, `hg : J.W (toPresheaf _).map g` → `IsLocallyInjective (Opens.grothendieckTopology X) (F ◁ g)`. Matches blueprint.
  - **Minor**: the blueprint statement (line 2216) says "indeed lies in J.W" as a parenthetical, but the pinned declaration only proves `IsLocallyInjective`. The full J.W membership is in `W_whiskerLeft_of_W` (Vestigial.lean:579) which has no blueprint pin.
- **Proof follows sketch**: yes for the three-movement structure — (a) d.1-bridge stalkwise iso, (b) identification of whiskered stalk via tensor commutation, (c) flatness-free bijectivity. The Lean proof (lines 483–572) follows exactly this structure: `isIso_stalkFunctor_map_of_W` for (a), `stalkTensorIso` for (b), `TensorProduct.congr` + bijectivity for (c).
  - **Difference from sketch**: Step (b) in the blueprint sketch (line 2250) says "By the second-factor naturality of the stalk--tensor comparison `lem:stalk_tensor_commutation_naturality_right`..." — but the Lean inlines this as `have key` (an induction on germs inside the proof body, lines 498–564), not by calling a named standalone lemma. The mathematical content is identical; only the factorization differs.
- **notes**: `\leanok` present on statement block. Proof block has the malformed `\uses{...}` described below.

---

## Red flags

### Placeholder / suspect bodies
None. All six new declarations (`isLocallyInjective_of_injective_stalk`, `injective_stalk_of_isLocallyInjective`, `isIso_stalkFunctor_map_of_W`, `isLocallyInjective_whiskerLeft_of_W`, `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`) have substantive proof bodies; no `:= sorry`.

### Excuse-comments
None found.

### Axioms / Classical.choice on non-trivial claims
None. All new declarations are `lemma`/`theorem` with complete proof bodies; no `axiom` declarations introduced.

---

## Specific findings (prioritized)

### [MUST-FIX #1] Dangling `\lean{}` pin — `stalkTensorIso_naturality_right` does not exist

**Location**: Blueprint lines 2151–2204 (`lem:stalk_tensor_commutation_naturality_right`)

`\lean{PresheafOfModules.stalkTensorIso_naturality_right}` is pinned in the statement block. No such declaration exists anywhere in the Lean project. The B-naturality argument was **inlined** as a `have key` proof inside `isLocallyInjective_whiskerLeft_of_W` rather than proven standalone.

**Impact**: The blueprint pin is dangling; the `sync_leanok` pass cannot locate the declaration and may produce an error or wrong marker. The `\uses{..., lem:stalk_tensor_commutation_naturality_right}` in the proof block of `lem:islocallyinjective_whiskerleft_via_stalk` (line 2235) imports a reference to a non-backed lemma into the dependency graph.

**Resolution**: 
- Remove `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` from the statement block of `lem:stalk_tensor_commutation_naturality_right`.
- Replace the `\lean{}` tag with a `% NOTE:` explaining that the B-naturality was inlined as a `have key` inside `isLocallyInjective_whiskerLeft_of_W` rather than proven as a standalone declaration.
- Remove `lem:stalk_tensor_commutation_naturality_right` from the `\uses{...}` list of the proof block of `lem:islocallyinjective_whiskerleft_via_stalk`.
- Update the step (b) prose of that proof sketch to say "By a direct induction on germ generators, the stalkTensorIso of `lem:stalk_tensor_commutation` identifies `(F ◁ g)_x` with `id_{F_x} ⊗ g_x`" (inlined, not citing a named sub-lemma).

---

### [MUST-FIX #2] `\leanok` INSIDE `\uses{...}` braces (malformed LaTeX)

**Location**: Blueprint lines 2232–2235

```tex
\begin{proof}
  \uses{lem:stalk_tensor_commutation, lem:stalk_linear_map,
  \leanok
    lem:W_implies_stalkwise_iso, lem:stalk_tensor_commutation_naturality_right}
```

`\leanok` is on line 2234, **inside** the argument braces of `\uses{...}`. The `\uses{}` command's closing `}` is on line 2235. This means:
1. `\leanok` is parsed as part of the `\uses{}` argument, not placed at the proof-block level — the marker is effectively invisible to the leanblueprint parser.
2. The `\uses{}` list is syntactically malformed (the leanblueprint parser sees `\leanok` as content within the list).
3. The proof block of `lem:islocallyinjective_whiskerleft_via_stalk` is NOT properly marked as `\leanok` even though the proof is complete.

**Resolution**:
- Move `\leanok` to AFTER the closing `}` of `\uses{...}`:
```tex
\begin{proof}
  \uses{lem:stalk_tensor_commutation, lem:stalk_linear_map,
    lem:W_implies_stalkwise_iso}
  \leanok
```
(Also remove `lem:stalk_tensor_commutation_naturality_right` per MUST-FIX #1.)

---

## Unreferenced declarations (informational)

The following Vestigial.lean declarations have no `\lean{...}` blueprint reference:

**Substantive (should be pinned or explicitly noted):**
- `isLocallyInjective_of_injective_stalk` (line 389) — new this iter; proves presheaf-level stalkwise-injective → locally-injective. Used by `isIso_stalkFunctor_map_of_W`. No blueprint block.
- `injective_stalk_of_isLocallyInjective` (line 408) — new this iter; converse of the above. Used in the proof of `isIso_stalkFunctor_map_of_W`. No blueprint block. The blueprint's prose for `lem:W_implies_stalkwise_iso` describes both directions but pins only `isIso_stalkFunctor_map_of_W` (the forward direction); the converse lives here.
- `stalkLinearMap` / `stalkLinearMap_germ` / `stalkLinearMap_bijective_of_isIso` / `stalkLinearEquivOfIsIso` (lines 278, 319, 340, 353) — `lem:stalk_linear_map` has no `\lean{...}` tag (and no `\leanok`); all four declarations are axiom-clean.
- `W_whiskerLeft_of_W` (line 579) — new this iter; the full J.W left-whisker wrapper. `lem:whisker_of_W` (line 1327) is labeled "must not be formalized" (superseded route), yet this declaration formalizes exactly that content. Needs a blueprint decision: either pin it with a note that it was realized incidentally as a wrapper, or remove the "not to be formalized" annotation.
- `W_whiskerRight_of_W` (line 593) — same as above.

**Helpers (acceptable as unpinned):**
- `toPresheaf_whiskerLeft_app_tmul` (line 58)
- `toPresheaf_whiskerLeft_app_apply` (line 68)
- `isLocallySurjective_whiskerLeft` (line 79) — referenced in `lem:flat_whisker_localizer` prose but no `\lean{}` pin
- `isLocallyInjective_whiskerLeft_of_flat` (line 112) — in `FlatWhisker` section; the flat proof body of `lem:flat_whisker_localizer`; no `\lean{}` pin (acceptable for off-path content)
- `W_whiskerLeft_of_flat` (line 189) / `W_whiskerRight_of_flat` (line 205) — off-path helpers
- `overEquiv_image_cover_iff` (line 660) — private helper for `OverSliceSheafEquiv`
- `overEquivInverseIsDenseSubsite` (line 689) — instance, no pin

---

## Blueprint adequacy for this file

- **Coverage**: Of the 22 named non-private declarations in Vestigial.lean, approximately 10 have a `\lean{...}` reference. The remaining 12 are either helpers or substantive declarations without pins (most notably the `StalkLinearMap` quartet and the two new `StalkBridge` converse declarations).
- **Proof-sketch depth**: **adequate** for the main target `lem:islocallyinjective_whiskerleft_via_stalk` — the three-movement structure (d.1-bridge, stalk-tensor identification, flatness-free bijectivity) precisely anticipates the Lean proof structure. The sketch is *over-specified for a non-existent sub-lemma* (references `lem:stalk_tensor_commutation_naturality_right` as a named building block when the Lean inlined it), which is misleading to a future reader.
- **Hint precision**: **loose** — `lem:stalk_linear_map` has no `\lean{...}` tag; `lem:W_implies_stalkwise_iso` pins only the forward-direction declaration though the blueprint prose covers both directions.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Drop the `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` pin from `lem:stalk_tensor_commutation_naturality_right`; add a `% NOTE:` explaining the inlining decision.
  2. Fix the `\leanok` placement in the proof block of `lem:islocallyinjective_whiskerleft_via_stalk` (move it outside `\uses{}`).
  3. Remove `lem:stalk_tensor_commutation_naturality_right` from the `\uses{}` of that proof block.
  4. Add `\lean{PresheafOfModules.stalkLinearMap, PresheafOfModules.stalkLinearMap_germ, PresheafOfModules.stalkLinearMap_bijective_of_isIso, PresheafOfModules.stalkLinearEquivOfIsIso}` to `lem:stalk_linear_map`.
  5. Add a blueprint block or `% NOTE:` for `isLocallyInjective_of_injective_stalk` and `injective_stalk_of_isLocallyInjective`, and pin them under `lem:W_implies_stalkwise_iso` or a new sub-block.
  6. Pin `W_whiskerLeft_of_W` and `W_whiskerRight_of_W` under `lem:whisker_of_W` with a note updating the "not to be formalized" annotation to reflect that they were realized incidentally as wrappers.
  7. Clarify that `lem:W_implies_stalkwise_iso` pins only the forward direction of `isIso_stalkFunctor_map_of_W`; describe the converse separately (or add a second `\lean{}` for the converse declarations).

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Dangling `\lean{stalkTensorIso_naturality_right}` — no backing declaration | **must-fix-this-iter** |
| `\leanok` inside `\uses{...}` braces — marker invisible, list malformed | **must-fix-this-iter** |
| `lem:stalk_linear_map` missing `\lean{...}` and `\leanok` for 4 axiom-clean decls | **major** |
| `isLocallyInjective_of_injective_stalk` / `injective_stalk_of_isLocallyInjective` missing blueprint pins | **major** |
| `W_whiskerLeft_of_W` / `W_whiskerRight_of_W` formalized despite "not to be formalized" note | **major** |
| `lem:W_implies_stalkwise_iso` prose covers both directions; pin is forward-only | **major** |
| Proof step (b) prose references non-existent sub-lemma (inlined `have key`) | **major** |
| `isLocallyInjective_whiskerLeft_of_W` pin doesn't cover "indeed lies in J.W" (in `W_whiskerLeft_of_W`) | **minor** |
| `isLocallySurjective_whiskerLeft` has no `\lean{}` pin | **minor** |

**Overall verdict**: Two must-fix issues (dangling `\lean{}` pin and malformed `\uses{}` with `\leanok` inside braces) block `sync_leanok` correctness; the mathematical content of the Lean is sound and the three-movement proof structure is faithfully described by the blueprint, but the chapter has significant sync debt in its `\lean{...}` coverage of the six declarations added this iteration.
