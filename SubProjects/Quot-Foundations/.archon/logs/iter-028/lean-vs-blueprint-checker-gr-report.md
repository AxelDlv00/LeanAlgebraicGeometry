# Lean ↔ Blueprint Check Report

## Slug
gr

## Iteration
028

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration (existing \lean{...} blocks — spot-check for correctness)

All previously-landed declarations whose `\lean{...}` blocks carry `\leanok` were
verified to be present in the Lean file with matching signatures.  The list is long
(~30 blocks); below are the blocks most relevant to this iter.

### `\lean{AlgebraicGeometry.Grassmannian.awayMulCommEquiv}` (chapter: `def:gr_away_mul_comm_equiv`)
- **Lean target exists**: yes (`awayMulCommEquiv`, line 812)
- **Signature matches**: yes — `Localization.Away (x * y) ≃+* Localization.Away (y * x)` for a general `[CommRing A]`, matching the prose "canonical ring isomorphism `A[1/(xy)] ≅ A[1/(yx)]`"
- **Proof follows sketch**: yes — uses `mul_comm` + `IsLocalization.algEquiv`, matching the prose "same submonoid"
- **notes**: `\leanok` is already on this block; marker is correct.

### `\lean{AlgebraicGeometry.Grassmannian.scheme}` (chapter: `def:gr_glued_scheme`)
- **Lean target exists**: **NO** — no declaration `AlgebraicGeometry.Grassmannian.scheme` exists in the file; likewise `theGlueData` and `cocycle` are absent.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: The block has no `\leanok` marker (correct — sync_leanok would not add it). However, the blueprint contains **no prose or `% NOTE:` annotation** acknowledging that the block is only partially progressed. The Lean file's detailed HANDOFF comment (lines 918–941) explains exactly what remains and why, but this is invisible to blueprint readers. See **Red flags → Blueprint silence on partial state** below.

---

## New declarations from iter-028 — blueprint coverage

The four new axiom-clean declarations added this iter have **no dedicated `\lean{...}` blueprint anchors**. They are described only in the prose of `def:gr_glued_scheme` (lines 1380–1408). Their status:

### `chartTransition'` (Lean line 834)
- **Blueprint anchor**: none dedicated.  The prose of `def:gr_glued_scheme` describes the `t'` field exactly — "composite of the pullback isomorphism on the source, the Spec of the localised triple-overlap transition Θ_{I,J}, the Spec of the order-swap isomorphism, and the inverse pullback isomorphism on the target."
- **Signature vs. prose**: matches — `Limits.pullback (chartIncl I J) (chartIncl I K) ⟶ Limits.pullback (chartIncl J K) (chartIncl J I)`.
- **Classification**: `lean_aux` node (unreferenced from blueprint).  Given that `chartTransition'` is a direct field of the intended glue datum, it warrants a dedicated block.
- **Suggested label**: `def:gr_chart_transition'`.
- **Severity**: **major** (substantive declaration whose blueprint traceability is absent)

### `chartTransition'_fac` (Lean line 884)
- **Blueprint anchor**: none dedicated.  Prose of `def:gr_glued_scheme` describes the `t_fac` field: "reduces — both fibre products being affine — to an identity of ring homomorphisms ... after which the identity is checked on generators by the universal property of the away-localisation."
- **Signature vs. prose**: matches — `chartTransition' ... ≫ pullback.snd (chartIncl J K) (chartIncl J I) = pullback.fst (chartIncl I J) (chartIncl I K) ≫ chartTransition d r I J hI hJ`.
- **Classification**: `lean_aux` node; this is a coherence field of the glue datum that the blueprint names explicitly.
- **Suggested label**: `lem:gr_chartTransition'_fac`.
- **Severity**: **major**

### `chartTransition'_ringIdentity` (Lean line 861)
- **Blueprint anchor**: none dedicated.  The ring identity is implicitly invoked in the prose of `def:gr_glued_scheme` but not given its own block or `\lean{}` hint.
- **Signature vs. prose**: correct — it is the key ring-hom equation `(cocycleΘIJ).comp ((awayMulCommEquiv).comp (awayInclRight)) = (awayInclLeft).comp (transitionMap)`, exactly the equality the prose says "reduces to."
- **Classification**: `lean_aux`; the proof of `chartTransition'_fac` delegates to this, so it is at least a named helper the blueprint should mention.
- **Suggested label**: `lem:gr_chartTransition'_ringIdentity`.
- **Severity**: **minor** (helper for `chartTransition'_fac`; a reviewer can infer it, but an explicit anchor would improve traceability)

### `awayMulCommEquiv_comp_algebraMap` (Lean line 847)
- **Blueprint anchor**: none dedicated; the closest block is `def:gr_away_mul_comm_equiv` covering `awayMulCommEquiv` only.
- **Signature**: `(awayMulCommEquiv x y).toRingHom.comp (algebraMap A (Localization.Away (x * y))) = algebraMap A (Localization.Away (y * x))` — purely a commutativity/base-change bookkeeping lemma.
- **Classification**: `lean_aux` — this is a pure helper lemma analogous to `awayInclLeft_comp_algebraMap` / `awayInclRight_comp_algebraMap`, which also lack dedicated blocks but are used in proofs.  No dedicated block needed.
- **Severity**: **minor** (informational)

---

## Red flags

### Blueprint silence on partial state of `def:gr_glued_scheme`
- `def:gr_glued_scheme` (line 1327) carries `\lean{AlgebraicGeometry.Grassmannian.scheme}` but the Lean file contains **none** of `scheme`, `theGlueData`, or `cocycle`.
- The Lean HANDOFF comment (lines 918–941) is detailed and honest: it names the categorical reduction that's done, what ring obligation remains, and what the next prover should build.
- The blueprint has **no `% NOTE:`** annotation acknowledging this; a reader of the blueprint alone would not know that `def:gr_glued_scheme` is only partially progressed.
- **Severity**: **major** — the review agent should add a `% NOTE:` marker on `def:gr_glued_scheme` such as:
  ```
  % NOTE: Partially formalized (iter-028). chartTransition' (t'-field),
  % chartTransition'_fac (t_fac-field), awayMulCommEquiv_comp_algebraMap are in
  % Lean. Remaining: cocycle (t'-cocycle field), theGlueData, and scheme.
  % See HANDOFF comment in GrassmannianCells.lean for the categorical reduction.
  ```

### Placeholder / suspect bodies
None. Every new declaration has a complete proof body; no `:= sorry` anywhere in the file.

### Excuse-comments
None. The HANDOFF comment (lines 918–941) is accurate forward-looking documentation (what the *next* prover must do), not an excuse for wrong current code.

### Axioms / Classical.choice on non-trivial claims
None. All four new declarations are axiom-clean.

---

## Unreferenced declarations (informational)

These Lean declarations have no dedicated `\lean{...}` blueprint anchor.  Only those whose names suggest they should be referenced are listed; pure private helpers omitted.

| Declaration | Line | Note |
|---|---|---|
| `chartTransition'` | 834 | **Should be anchored** — direct t'-field of glue datum |
| `chartTransition'_fac` | 884 | **Should be anchored** — direct t_fac-field of glue datum |
| `chartTransition'_ringIdentity` | 861 | Helper for t_fac; minor to anchor |
| `awayMulCommEquiv_comp_algebraMap` | 847 | Pure helper; informational |
| `chartIncl_isOpenImmersion` | 669 (instance) | Pre-existing; referenced transitively via `lem:gr_chartIncl_isOpenImmersion` |

Pre-existing private helpers (`mul_submatrix_col`, `map_nonsing_inv`, `map_map_eq_of_comp`, `inv_mul_inv_mul_cancel`, `isUnit_incl_transitionPreMap_cross`, `isUnit_algebraMap_away_left`, `isUnit_algebraMap_away_right`, `imageMatrix_map_eq`, `cocycle_imageMatrix_eq`) do have corresponding `\lean{...}` blueprint blocks even though they are declared `private` in Lean. This is a pre-existing convention; not re-reported here.

---

## Blueprint adequacy for this file

- **Coverage**: Of ~49 Lean declarations, ~43 have a corresponding `\lean{...}` block in the blueprint (including indirect coverage via Mathlib `\mathlibok` blocks). The 4 new declarations from this iter (and `chartIncl_isOpenImmersion`) are uncovered.  Uncovered substantive ones: `chartTransition'`, `chartTransition'_fac` (2 declarations warranting dedicated blocks).
- **Proof-sketch depth**: **adequate** for everything landed prior to iter-028.  For the new declarations, the prose in `def:gr_glued_scheme` is sufficient to reconstruct `chartTransition'` and `chartTransition'_fac` but is **implicitly under-specified** for the ring identity `chartTransition'_ringIdentity` (only "reduces to an identity of ring homomorphisms" is said; the explicit equation is not given).
- **Hint precision**: **loose** for `def:gr_glued_scheme` overall — the `\lean{}` hint names `scheme` (the final output) rather than the intermediate glue-datum fields being actively built.  A prover reading the blueprint cannot tell which Lean declaration to produce next.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Add a dedicated definition block `def:gr_chart_transition'` with `\lean{AlgebraicGeometry.Grassmannian.chartTransition'}` and prose matching the current `def:gr_glued_scheme` description of the `t'`-field.
  2. Add a dedicated lemma block `lem:gr_chartTransition'_fac` with `\lean{AlgebraicGeometry.Grassmannian.chartTransition'_fac}` and a proof sketch ("reduce to ring identity via leg lemmas").
  3. Optionally add `lem:gr_chartTransition'_ringIdentity` with the explicit equation.
  4. Add a `% NOTE:` annotation on `def:gr_glued_scheme` acknowledging partial progress and what remains (see Red flags above).
  5. (Low priority) Add `lem:gr_awayMulCommEquiv_comp_algebraMap` alongside the existing `def:gr_away_mul_comm_equiv` block, or fold it into the prose of that block.

---

## Severity summary

| Finding | Severity |
|---|---|
| `chartTransition'` lacks dedicated `\lean{}` anchor | **major** |
| `chartTransition'_fac` lacks dedicated `\lean{}` anchor | **major** |
| `def:gr_glued_scheme` blueprint silent on partial state (`cocycle`/`theGlueData`/`scheme` absent) | **major** |
| `chartTransition'_ringIdentity` lacks anchor | **minor** |
| `awayMulCommEquiv_comp_algebraMap` lacks anchor | **minor** |
| Lean → blueprint signature mismatches | none |
| Placeholders / sorries / axioms | none |
| Excuse-comments | none |

**Overall verdict**: The four new iter-028 declarations are axiom-clean and mathematically faithful to the blueprint prose, but two (`chartTransition'`, `chartTransition'_fac`) lack dedicated `\lean{}` anchors that the blueprint-writing subagent should add, and the blueprint is silent on the partial state of `def:gr_glued_scheme` — three must-fix items at the blueprint level, none at the Lean level.
