# Lean ↔ Blueprint Check Report

## Slug
csi-iter066

## Iteration
066

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` (1588 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated chapter)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`, ~line 8602)
- **Lean target exists**: yes (line 1328)
- **Signature matches**: yes — `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ⊓ V, F)` matches prose exactly
- **Proof follows sketch**: yes — chains `pushPull_sigma_iso` + `PreservesProduct.iso Ev` + `Pi.mapIso pushPull_leg_sections` as prescribed
- **notes**: sorry-free; `\leanok` on statement block in blueprint is correct

---

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` + `\lean{AlgebraicGeometry.sectionCechComplexV}` (chapter: `lem:cechSection_complex_iso`, ~line 8632)
- **Lean target exists**: yes (lines 1363–1365 for `sectionCechComplexV`; lines 1463–1526 for `cechSection_complex_iso`)
- **Signature matches**: yes — `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` matches the blueprint's augmented-target formulation exactly (the `% NOTE:` comment at 8635–8640 explains the re-sign)
- **Proof follows sketch (outer structure)**: yes — the augmentation-peeling strategy (two `mapHC_augment_iso` calls followed by `augmentCochainIso`) is sound and consistent with the blueprint's instruction to assemble `D ≅ D'_aug` from degreewise components
- **Proof follows sketch (residuals)**: PARTIAL — two inner `have` sorries remain:
  1. `coreIso` (line 1492): `(GV.mapHC).obj (Ψ.mapHC.obj (cechComplexOnX 𝒰 F)) ≅ sectionCechComplexV 𝒰 F V`
  2. `hcompat` (line 1504): the degree-0 augmentation-compat square `GV.map (Ψ.map (cechAugmentation 𝒰 F)) ≫ (isoApp coreIso 0).hom = eY.hom ≫ ε`
- **notes**: The blueprint proof-block has NO `\leanok` (correct — proof not closed). The statement-block also lacks `\leanok` (see Red Flags). The two sorried `have`s are the acknowledged residuals of this iteration; the outer proof structure is sorry-free.

---

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`, ~line 8708)
- **Lean target exists**: yes (lines 1578–1585)
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0` matches the augmented target stated in blueprint and the `% NOTE:` at lines 8710–8714
- **Proof follows sketch**: N/A — body is `:= sorry`; the entire Stub 6 is open
- **notes**: `\leanok` on the statement block in blueprint (line 8706) is correct (declaration exists with sorry). Proof-block has no `\leanok` (correct — not closed).

---

## Red Flags

### Missing statement-block `\leanok` — `cechSection_complex_iso`
- `lem:cechSection_complex_iso` (blueprint ~line 8629): the `\begin{lemma}` block lacks a `\leanok` marker before the label, but the Lean declaration `cechSection_complex_iso` exists at line 1463 with a concrete proof body (the two `sorry`s are in inner `have` statements, not the top-level body). Per project rules, statement-block `\leanok` = "declaration formalized (at least a sorry present)"; the declaration qualifies. This is a **sync_leanok artifact** — the tool may not detect sorry-in-have as satisfying the criterion, or the current iteration's changes occurred after the sync window. Classification: **minor**.

### Placeholder bodies in unreferenced helpers
- See "Unreferenced declarations" below — the 3 new helpers have no blueprint entry, so their bodies cannot be checked against any blueprint sketch. They are not placeholders: all three have concrete, correct implementations (sorry-free).

---

## Unreferenced declarations (informational / coverage debt)

Three substantive non-trivial declarations introduced this iteration have **no `\lean{}` entry in the blueprint**:

| Declaration | Lines | Status | Severity |
|---|---|---|---|
| `mapHC_augment_iso` | 1374–1390 | sorry-free, non-trivial proof (component-wise iso for augmented complex under a functor) | **major** |
| `augmentCochainIso` | 1405–1418 | sorry-free, non-trivial proof (iso assembly for augmented complexes from degreewise data + compat square) | **major** |
| `map_augment_cond` | 1394–1400 | sorry-free, 6-line technical lemma (augmentation condition preserved by additive functor) | minor |

These three are used DIRECTLY in the proof of `cechSection_complex_iso` (lines 1507–1526). The directive explicitly marks this as "coverage debt." `mapHC_augment_iso` and `augmentCochainIso` are conceptually significant enough that a blueprint-writing pass should add `\lean{}` entries (the next prover or a future re-reader of the blueprint will be confused that the proof cites unnamed infrastructure).

---

## Blueprint adequacy for this file

### Coverage
- `\lean{}`-referenced: 3 declarations (`pushPull_eval_prod_iso`, `cechSection_complex_iso`, `cechSection_contractible`) plus `sectionCechComplexV` as a secondary tag.
- Unreferenced: 3 helpers (`mapHC_augment_iso`, `augmentCochainIso`, `map_augment_cond`) — flagged above as coverage debt.
- Stubs 1–4 (the bulk of the file) are covered by earlier blueprint lemmas and are axiom-clean; no issue.

### Proof-sketch depth for the residual `coreIso`
- **Assessment: adequate, but just barely.**
- Blueprint lines 8682–8691 identify the two required ingredients: `pushPull_eval_prod_iso` for the object isomorphism and `sectionCech_objD_apply` (read through `sectionCechProductEquiv`) for the differential match.
- What the blueprint does NOT describe: the exact shape of the LHS of `coreIso` after augmentation peeling — the next prover sees `(GV.mapHomologicalComplex cc).obj (Ψ.mapHomologicalComplex cc).obj (cechComplexOnX 𝒰 F))` but the blueprint always refers to the full `D` (with augmentation). The peeling has already been done by the new helpers, so the residual goal is simpler than the blueprint describes. A prover reading the blueprint will need to recognize that `coreIso` is the non-augmented sub-goal, not the full statement — this gap is **advisory** since the Lean code comment (lines 1485–1492) makes the shape explicit.

### Proof-sketch depth for `hcompat`
- **Assessment: thin.** Blueprint lines 8693–8699 say the augmentation differential "read through degree-0 of `pushPull_eval_prod_iso`... is exactly the restriction product map." This is correct in principle but does not explain the chain of rewrites through `GV.map (Ψ.map (cechAugmentation 𝒰 F))` that the Lean proof will need. The next prover will need to compute through the `SheafOfModules.forget ⋙ restrictScalars (𝟙 ·)` adapter and `PresheafOfModules.toPresheaf ⋙ evaluation(op V)` to see this is definitional. **Blueprint should add a one-sentence note** that this compat is definitional (or near-definitional) once the adapter path is unfolded.

### Proof-sketch depth for `cechSection_contractible`
- **Assessment: adequate.** Blueprint lines 8743–8784 give a detailed 40-line proof sketch:
  - Step (B): Maximum property `U'_{i_fix} = V`, prepend identity at coefficient level — concrete and checkable.
  - Step (C) positive degrees: explicit dep* engine invocation with unit/shift conditions stated.
  - Step (D) augmentation node: describes `π_{i_fix}` coordinate projection and the explicit identity verification `ε ∘ π_{i_fix} + (degree-0 engine term) = id`.
- This is sufficiently detailed for a competent prover to formalize. No inadequacy.

### Hint precision
- **precise** for all `\lean{}`-tagged declarations. The `% NOTE:` comments on the augmented re-sign are clear and accurate.

### Generality
- **matches need** — no parallel API was introduced to cover a generality gap.

### Recommended chapter-side actions (for a blueprint-writing pass)

1. **(major)** Add `\lean{AlgebraicGeometry.mapHC_augment_iso}` and `\lean{AlgebraicGeometry.augmentCochainIso}` as named helper lemmas in the blueprint, with one-sentence descriptions: "applying an additive functor commutes with augmenting a complex" and "an augmented-complex iso from a base-complex iso + augmentation-object iso + compat square." These are reusable infrastructure.

2. **(minor)** Add `\lean{AlgebraicGeometry.map_augment_cond}` as a sub-remark or inline note.

3. **(advisory)** In the proof sketch of `lem:cechSection_complex_iso`, add a sentence: "The augmentation peeling strategy reduces the goal to a non-augmented core iso `coreIso` (see `mapHC_augment_iso` and `augmentCochainIso`); the blueprint steps (A)–(C) apply to that reduced goal."

4. **(advisory)** Expand the `hcompat` paragraph (blueprint lines 8693–8699) with a note that the compat square is definitional up to the `restrictScalars (𝟙 ·)` adapter — reduces prover guesswork.

5. **(minor / sync)** Add `\leanok` to the statement block of `lem:cechSection_complex_iso` if `sync_leanok` doesn't catch sorry-in-have automatically.

---

## Severity summary

- **must-fix-this-iter**: none — no wrong signatures, no wrong definitions, no excuse-comments, no unauthorized axioms.
- **major**: 2 items — `mapHC_augment_iso` and `augmentCochainIso` lack blueprint `\lean{}` entries (coverage debt for substantive helper lemmas used directly in the proof of `lem:cechSection_complex_iso`).
- **minor**: 3 items — `map_augment_cond` has no blueprint entry; `\leanok` missing from the statement block of `lem:cechSection_complex_iso` (sync artifact); blueprint proof sketch for `hcompat` is thin.
- **advisory**: blueprint does not describe the reduced `coreIso` goal shape post-augmentation-peeling; the next prover will need to read the Lean code comments to see the exact residual.

**Overall verdict**: Lean → blueprint alignment is correct for all tagged declarations (signatures match, outer proof structure follows the sketch); two open `sorry`s in `cechSection_complex_iso` and the full `sorry` in `cechSection_contractible` are acknowledged residuals. The main gap is blueprint → Lean: three new helpers built this iteration to support `cechSection_complex_iso` have no `\lean{}` entries in the chapter (coverage debt, major), and the `hcompat` proof sketch is thin.
