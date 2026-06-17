# Lean ↔ Blueprint Check Report

## Slug
csi-iter065

## Iteration
065

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (sections from `lem:pushPull_coprod_prod_empty` through `lem:cechSection_contractible`, lines ~8305–8810)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushPull_coprod_prod_empty}` (chapter: `lem:pushPull_coprod_prod_empty`)
- **Lean target exists**: yes (line 985, `private theorem`)
- **Signature matches**: yes — empty index `PEmpty.{u+1}`, canonical comparison map `coprodToProdMap F legs` is proven to be an iso. Matches blueprint statement exactly.
- **Proof follows sketch**: yes — blueprint says "both sides terminal; source via pulled-back module being zero over the empty scheme; target via empty product." Lean:
  - Source terminality: derives `IsEmpty ↥(Over.mk (Sigma.desc …).left)` from `isColimitEquivIsInitialOfIsEmpty`, then applies `isZero_modules_of_isEmpty` (new helper) to get `IsZero` of the pullback, then `Functor.map_isZero` (pushforward additive → maps zero to zero), then `.isTerminal`.
  - Target terminality: `IsTerminal.ofUniqueHom` on the empty product.
  - Conclusion: `isIso_of_isTerminal`.
  The blueprint proof paragraph (lines 8321–8346) explicitly covers the zero-module obligation: "The single remaining formal obligation is that the pulled-back module is zero … established pointwise through the faithful sections-to-presheaf functor, using the subsingleton sections of the structure sheaf over the empty scheme." This matches `isZero_modules_of_isEmpty` precisely.
- **Notes**: Blueprint says "every sheaf over the empty scheme is the zero object: the only open of ⊥ is the empty open." The Lean uses `IsEmpty ↥Z` (empty carrier set) rather than reasoning about the lattice of opens, which is slightly more general but mathematically equivalent. Not a divergence — just a different (equally valid) route to subsingletonness of sections. No material divergence.

---

### `\lean{AlgebraicGeometry.coprodToProd_isIso_of_equiv}` (chapter: `lem:coprodToProd_isIso_of_equiv`)
- **Lean target exists**: yes (line 1011, `private theorem`)
- **Signature matches**: yes — equivalence `e : α ≃ β`, induction hypothesis on `α`-family, conclusion on `β`-family. Matches blueprint.
- **Proof follows sketch**: yes, exact match.
  - Blueprint "Transporting the source": `Sigma.whiskerEquiv e (fun a => Iso.refl)` → `u`, `Over.isoMk u hw` → `mIso`. ✓ (Lean lines 1018–1028)
  - Blueprint "Transporting the target": `Pi.whiskerEquiv e (fun a => Iso.refl)` → `prodIso`. ✓ (Lean lines 1035–1037)
  - Blueprint "Matching the canonical form — projection by projection": `key` identity. ✓ (Lean lines 1040–1053)
  - Conclusion: `IsIso.of_isIso_comp_right`. ✓ (Lean line 1056)
- **Notes**: None. Textbook match between blueprint and Lean.

---

### `\lean{AlgebraicGeometry.coprodToProd_isIso_option}` (chapter: `lem:coprodToProd_isIso_option`)
- **Lean target exists**: yes (line 1093, `private theorem`, closed iter-064)
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed prior iter, no change this iter)
- **Notes**: Carries `set_option maxHeartbeats 1600000` for the `erw` projection steps — this is noted in the Lean but not in the blueprint. Acceptable engineering note; does not affect mathematical content.

---

### `\lean{AlgebraicGeometry.pushPull_coprod_prod}` (chapter: `lem:pushPull_coprod_prod`)
- **Lean target exists**: yes (line 1175, `noncomputable def`, fully sorry-free after this iter)
- **Signature matches**: yes — finite `ι`, `pushPullObj F (Over.mk (Sigma.desc …)) ≅ ∏ᶜ fun i => pushPullObj F (legs i)`. Exact match.
- **Proof follows sketch**: yes — `Finite.induction_empty_option` with the three steps. Matches blueprint exactly.
- **Notes**: `isIso_coprodToProdMap` (private, line 1161) assembles the induction and is listed in `\lean{...}` as a secondary declaration. Blueprint does not give it its own block but it is referenced. No issue.

---

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes (line 1226, sorry-free, cascaded axiom-clean this iter)
- **Signature matches**: yes
- **Proof follows sketch**: yes — chain of three `pushPullObjCongr` and `pushPull_coprod_prod` isos, matching blueprint exactly.
- **Notes**: Blueprint already had statement-level `\leanok` from prior iter. Now axiom-clean. Proof-block `\leanok` not yet present (see §Red flags).

---

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes (line 1320, sorry-free, cascaded axiom-clean this iter)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `E.mapIso` + `PreservesProduct.iso` + `Pi.mapIso`. Matches blueprint steps (A)+(B)+(C).
- **Notes**: Blueprint statement-level `\leanok` already present. Axiom-clean after cascade.

---

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes (line 1403)
- **Signature matches**: yes — augmented form: `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`. The `let α`, `let cc`, `let K`, `let Kp`, `let GV`, `let D` definitions in the signature match the blueprint's description of the evaluated augmented complex exactly. The augmentation parameters `ε` and `hε` are explicit, matching the blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry`
- **Notes**: **MUST-FIX** (Stub 5, known open). Blueprint NOTE (line 8635) about the augmented target has been correctly reflected in the Lean signature. Statement-level `\leanok` is MISSING from the blueprint despite the declaration existing (see §Red flags — sync_leanok gap).

---

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes (line 1470)
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0` with `V ≤ coverOpen 𝒰 i_fix`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry`
- **Notes**: **MUST-FIX** (Stub 6, known open). Blueprint statement-level `\leanok` present (declaration exists with sorry).

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.cechSection_complex_iso` at line 1418: body is `:= sorry`. Blueprint `lem:cechSection_complex_iso` claims a substantive proof (isomorphism of cochain complexes, differential match). **Must-fix — Stub 5, known open.**
- `AlgebraicGeometry.cechSection_contractible` at line 1477: body is `:= sorry`. Blueprint `lem:cechSection_contractible` claims a contracting homotopy. **Must-fix — Stub 6, known open.**

### Stale blueprint `% NOTE:` comment
- `Cohomology_CechHigherDirectImage.tex:8477–8482`: The comment reads:
  ```
  % NOTE (review iter-064): BUILT — the Lean declaration exists and assembles via
  % Finite.induction_empty_option (the Option-adjoining step coprodToProd_isIso_option is CLOSED
  % axiom-clean). It transitively threads the TWO remaining induction-step leaves:
  % pushPull_coprod_prod_empty (empty base; residual = IsZero of a module pulled back to the
  % initial/empty scheme, ~40-60 LOC) and coprodToProd_isIso_of_equiv (whiskerEquiv reindex,
  % ~80 LOC mechanical). Closing both closes Stub 2 (lem:pushPull_sigma_iso, already wired).
  ```
  This is now **stale**: both residual sub-lemmas (`pushPull_coprod_prod_empty` and `coprodToProd_isIso_of_equiv`) were CLOSED this iter-065. The note still describes them as open. Any plan agent reading this in iter-066 will get incorrect project state. The review agent should update this NOTE to record iter-065 closure.

### Missing `\leanok` markers (sync_leanok gaps)
- `lem:cechSection_complex_iso` (line 8629): Declaration exists with `:= sorry` but has NO statement-level `\leanok`. Blueprint convention says statement-level `\leanok` = "declaration formalized (at least a sorry present)." Both `cechSection_complex_iso` and `cechSection_contractible` have sorry bodies; `cechSection_contractible` correctly has statement `\leanok` at line 8706 but `cechSection_complex_iso` does not. Likely because `cechSection_complex_iso` was re-signed this iter and `sync_leanok` ran before re-signing. **Minor** (won't block prover work but makes the blueprint depgraph inaccurate).
- `lem:pushPull_coprod_prod_empty` (line 8305), `lem:coprodToProd_isIso_of_equiv` (line 8388), `lem:coprodToProd_isIso_option` (line 8443): All `private theorem` in Lean. All closed (sorry-free) but have NO `\leanok` anywhere in their blueprint blocks. `sync_leanok` likely cannot look up `private` declarations under their unmangled `\lean{...}` names. This is a systemic limitation: all three private induction lemmas in the blueprint appear "unformalized" in the blueprint web despite being axiom-clean. **Minor** — the parent public lemma `pushPull_coprod_prod` similarly lacks `\leanok` (even though it's public and should now be detectable by `sync_leanok`). The review agent should investigate whether `sync_leanok` ran correctly for this iter or needs a follow-up run.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no direct `\lean{...}` blueprint reference:

| Declaration | Line | Assessment |
|---|---|---|
| `isZero_modules_of_isEmpty` | 970 | `private lemma`. New this iter, supports `pushPull_coprod_prod_empty`. Blueprint proof of `lem:pushPull_coprod_prod_empty` (lines 8341–8345) explicitly describes this obligation. Covered by narrative; no separate block needed since it's private. |
| `isIso_coprodToProdMap` | 1161 | `private theorem`. Assembly helper. Referenced as secondary declaration in `\lean{..., AlgebraicGeometry.isIso_coprodToProdMap}` on `lem:pushPull_coprod_prod`. Fine. |
| `widePullback_overX_isLimit`, `overSigmaDescCofan`, `overSigmaDescIsColimit`, `overSigmaDescIso`, etc. | 54–125 | Abstract categorical infrastructure. Referenced as `CategoryTheory.*` in earlier blueprint blocks. Fine. |
| `coprodArrowOverCofan`, `coverArrowOverIsColimit`, `coverArrowOverSigmaIso`, `widePullbackBaseCongr`, `cechBackbone_obj_widePullback`, `coverInterProdIso` | 492–579 | Helper declarations supporting `cechBackbone_left_sigma`. All covered under the `lem:cech_backbone_left_sigma` block or earlier geometric helper blocks. Fine. |
| `sectionCechComplexV` | 1355 | `noncomputable abbrev`. Referenced as secondary in `\lean{AlgebraicGeometry.cechSection_complex_iso, AlgebraicGeometry.sectionCechComplexV}`. Fine. |

**Substantive unreferenced declaration that warrants a blueprint entry:**
- **`isZero_modules_of_isEmpty`**: Although private, this helper is new and non-trivial (establishes zero-ness of module sheaves over empty schemes). The blueprint chapter should consider adding a brief `\mathlibok` or inline statement in the proof of `lem:pushPull_coprod_prod_empty` to pin `isZero_modules_of_isEmpty` more precisely. Currently the narrative covers it adequately but doesn't name it. This may help future maintainers. Low priority.

---

## Blueprint adequacy for this file

- **Coverage**: Stubs 1–4 are fully covered by `\lean{...}` blocks. Stubs 5–6 have `\lean{...}` blocks with detailed proof sketches. All public declared results map to blueprint entries. Private helper `isZero_modules_of_isEmpty` is the only undocumented new helper — its obligation is described in the parent lemma's proof narrative.
- **Proof-sketch depth**:
  - For closed declarations: **adequate** — proof sketches were precise enough to guide the provers, as evidenced by the exact match between Lean and blueprint proof structure.
  - For `lem:cechSection_complex_iso` (Stub 5): **adequate** — blueprint specifies degreewise iso via `pushPull_eval_prod_iso` (Stub 4), differential match reusing `sectionCech_objD_apply`, assembly via `HomologicalComplex.mkIso`, and an AMBIGUITY FLAG on the `Kp` type adapter. The differential-match section is detailed. Main risk: the `Kp` type path may require careful navigation (the AMBIGUITY FLAG is correctly placed).
  - For `lem:cechSection_contractible` (Stub 6): **adequate** — blueprint gives the two-part structure (positive degrees via `depHomotopy`/`depHomotopy_spec`, augmentation node via explicit `π_{i_fix}` identity), specifies the key Lean names, and quotes the Stacks source argument. The augmentation node identity is spelled out in detail (lines 8774–8784).
- **Hint precision**: **precise** — all `\lean{...}` tags name correct fully-qualified identifiers. No mismatches observed.
- **Generality**: **matches need** — no parallel API issues detected.
- **Recommended chapter-side actions**:
  1. **Major**: Update the stale `% NOTE (review iter-064):` at lines 8477–8482 to record that `pushPull_coprod_prod_empty` and `coprodToProd_isIso_of_equiv` were CLOSED in iter-065, and that `lem:pushPull_coprod_prod` is now axiom-clean.
  2. **Minor**: Investigate `sync_leanok` gap for `private` declarations — `lem:pushPull_coprod_prod_empty`, `lem:coprodToProd_isIso_of_equiv`, `lem:coprodToProd_isIso_option` all lack `\leanok` in their blueprint blocks despite being sorry-free. The public `lem:pushPull_coprod_prod` also lacks `\leanok` (may be a sync ordering issue from the cascade). A `sync_leanok` follow-up or manual `\leanok` addition may be needed for these.
  3. **Minor**: Add statement-level `\leanok` to `lem:cechSection_complex_iso` (declaration exists with sorry, same status as `lem:cechSection_contractible` which already has it).
  4. **Minor**: Consider adding a brief `\lean{AlgebraicGeometry.isZero_modules_of_isEmpty}` reference in the proof narrative of `lem:pushPull_coprod_prod_empty` to help future tool traversal.

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `cechSection_complex_iso` `:= sorry` (Stub 5, known open) | **must-fix-this-iter** |
| 2 | `cechSection_contractible` `:= sorry` (Stub 6, known open) | **must-fix-this-iter** |
| 3 | Stale `% NOTE (review iter-064):` at blueprint line 8477 incorrectly describes `pushPull_coprod_prod_empty` and `coprodToProd_isIso_of_equiv` as still open | **major** |
| 4 | `lem:pushPull_coprod_prod`, `lem:pushPull_coprod_prod_empty`, `lem:coprodToProd_isIso_of_equiv`, `lem:coprodToProd_isIso_option` all missing `\leanok` despite being sorry-free; likely `sync_leanok` limitation with `private` declarations and/or cascade ordering | **minor** |
| 5 | `lem:cechSection_complex_iso` missing statement-level `\leanok` despite having a sorry body (re-signed this iter, `sync_leanok` likely ran before re-signing) | **minor** |
| 6 | `isZero_modules_of_isEmpty` (private, new this iter) has no `\lean{...}` blueprint entry; its obligation is described in the parent lemma's proof narrative but not pinned | **minor** |

**Proof divergence** (`pushPull_coprod_prod_empty` route): The Lean uses `IsEmpty ↥Z` / `Module.subsingleton` to prove the pulled-back module is zero, while the blueprint says "only open of ⊥ is the empty open." These are mathematically equivalent routes to the same conclusion. **Not a divergence** — the blueprint explicitly names the Lean obligation ("established pointwise through the faithful sections-to-presheaf functor, using the subsingleton sections") and the Lean fulfils it exactly.

**Overall verdict**: The two declarations closed this iter (`pushPull_coprod_prod_empty` and `coprodToProd_isIso_of_equiv`) are axiom-clean with proofs that faithfully follow their blueprint sketches; the cascade to Stub 2 and Stub 4 axiom-cleanliness is sound. The two must-fix items (Stubs 5 and 6) are known-open sorries. The sole actionable non-sorry finding is the stale `% NOTE` comment in the blueprint that should be updated by the review agent this iteration — 19 declarations checked, 2 sorry red flags (known open) + 1 stale NOTE.
