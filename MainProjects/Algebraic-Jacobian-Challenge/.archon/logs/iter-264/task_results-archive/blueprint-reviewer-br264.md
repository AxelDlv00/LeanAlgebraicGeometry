# Blueprint Review Report

## Slug
br264

## Iteration
264

## Scope
Fast-path scoped re-review. Two chapters patched this iter (bw-tos264, bw-cech264).
Gate verdict requested for each; full cross-chapter context checked but not re-audited.

---

## Chapter 1 — `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

### Directive-item verification

**Item 1 (was must-fix): `lem:slice_dual_transport` naturality — ε-naturality, not just `Subsingleton.elim`.**

Lines 5714–5720 (statement block) and 5832–5847 (proof block) now correctly split the
naturality obligation into two distinct parts:

> "The naturality of the section family in W has two distinct parts: the underlying
> base-morphism uniqueness in (Over V.unop)^op is Subsingleton.elim (a thin poset has at
> most one inclusion between objects), but the accompanying equation of O_Y(V)-module maps
> is a genuine, separate obligation: it is the ε-naturality of restrictScalars along the
> structure-ring iso β_W, which Subsingleton.elim does not discharge."

Both the statement and the proof block state this explicitly. The proof elaborates at L5841:
the module-map equation reduces to the ε-naturality square of `restrictScalars` post-composed
with `dualUnitRingSwap = inv ε(restrictScalars β_W)`. ✓ FIXED.

**Item 2 (was major): `invFun` — coverage fact + `image_preimage_of_le` + component formula + round-trip recipe.**

Lines 5761–5781 cover all four elements:
- Open-image down-set coverage: "every open W'' ≤ fV already lies in the image of
  f.opensFunctor" (L5762–5764). ✓
- Named helper `image_preimage_of_le` with explicit `\lean{}` pin at L5768. ✓
- Component formula: "the inverse PresheafOfModules.Hom mirrors the forward component
  formula, with two changes" (L5772–5776). ✓
- Round-trip recipes at L5778: "left_inv and right_inv then close component-wise by
  Iso.inv_hom_id and Iso.hom_inv_id of f.appIso". ✓ FIXED.

**Item 3 (was major): `map_smul'` — β-naturality ring identity + `termRingMap_naturality` + `β.naturality` + `restrictScalars.smul_def'`.**

Lines 5795–5830 present a three-step breakdown (identify module presentations / match
scalars via β-naturality / apply change-of-rings). Step (ii) (L5805–5821) names:
- Ring identity `s = (β.app W').hom c` (L5812). ✓
- `InternalHom.termRingMap_naturality` as the source of the identity (L5814). ✓
- `β.naturality` on the thin poset (L5816). ✓
- `ModuleCat.restrictScalars.smul_def'` to exhibit the restricted smul (L5819–5821). ✓ FIXED.

**Item 4 (was major, lvb-tos263): D3′ Sq1 tail goal form + Sq4 `pullbackValIso` standalone sub-lemma.**

*Sq1 tail (lines 4071–4081):*
- The named sub-lemma `sheafificationCompPullback_comp_tail` is introduced at L4075. ✓
- Proof strategy is stated: recovering the f- and h-sub-comparison units via
  `homEquiv_leftAdjointUniq_hom_app`, then reassembling using unit-naturality of
  `pushforwardComp` and `pullbackComp` (L4076–4078). ✓
- The composite-adjunction-unit identity (the "unit-level identity" reached after the
  `homEquiv_leftAdjointUniq_hom_app` transpose) is described, matching the planner's
  `B_{h≫f}.unit` notation (L4063–4069). ✓

*Sq4 `pullbackValIso` standalone sub-lemma (lines 4087–4106):*
- The coherence of `pullbackValIso` across `h ∘ f` is described (L4088–4097). ✓
- Explicitly marked as "a standalone named obligation, to be built separately and not
  folded into Sq1", instructing the prover to "treat it as its own brick (a corollary of
  Sq1, but with its own statement and its own connecting-object bookkeeping)" (L4099–4105). ✓
- Reduction to Sq1 via the `pullbackValIso` factorisation stated (L4094–4097). ✓ FIXED.

### Per-chapter verdict

- **complete**: true
- **correct**: true
- **notes**: none — all four bw-tos264 must-fix items confirmed fixed.

**HARD GATE CLEARS for DUAL and D3′ prover lanes.**

---

## Chapter 2 — `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

### Directive-item verification

**Item 1 (was must-fix): `sec:cech_three_part` para (2) — Sq1-coupling claim removed/corrected.**

Para (2) (lines 192–237) has been corrected. It now explicitly states:
- L216: "This functoriality is not coupled to the project's tensor–pullback substrate"
- L217: "it consumes only Mathlib's pseudofunctor packaging of pullback and pushforward"
- L231: "All of these are already available off the shelf"

The proof block (L353–375) also closes with: "No step invokes the project-local
sheafification/pullback square, so the laws are independent of the tensor–pullback
substrate." (L373–374). ✓

No residual Sq1-coupling language found elsewhere in the chapter. ✓ FIXED.

**Item 2 (was must-fix): `lem:push_pull_functor` lemma block with `\lean{}` hints + proof sketch for `pushPullMap_id`/`pushPullMap_comp` via `conjugateEquiv_pullbackComp_inv` → `pseudofunctor_*`.**

`lem:push_pull_functor` (lines 331–375) now has:
- `\lean{AlgebraicGeometry.pushPullMap_id}` (L333). ✓
- `\lean{AlgebraicGeometry.pushPullMap_comp}` (L334). ✓
- Proof sketch (lines 351–375) naming the `conjugateEquiv_pullbackComp_inv` mate rewrite
  (L358) as the pivoting step, followed by the specific `pseudofunctor_*` identities:
  - `conjugateEquiv_pullbackId_hom` + `pseudofunctor_right_unitality` for the identity law (L362–364)
  - `pseudofunctor_associativity` + `Adjunction.unit_naturality` for the composition law (L366–369) ✓ FIXED.

**Item 3 (was major): `\lean{}` pins for `pushPullObj`, `pushPullMap`, `coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve`.**

All five pins confirmed present:
- `\lean{AlgebraicGeometry.coverArrow}` — L267 (`def:cover_arrow`). ✓
- `\lean{AlgebraicGeometry.coverCechNerve}` — L278 (`def:cover_cech_nerve`). ✓
- `\lean{AlgebraicGeometry.pushPullObj}` — L295 (`def:push_pull_obj`). ✓
- `\lean{AlgebraicGeometry.pushPullMap}` — L306 (`def:push_pull_map`). ✓
- `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` — L379 (`def:relative_cech_complex_of_nerve`). ✓ FIXED.

### Per-chapter verdict

- **complete**: true
- **correct**: true
- **notes**: none — all three bw-cech264 must-fix/major items confirmed fixed.

**HARD GATE CLEARS for ENGINE prover lane.**

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**Overall verdict**: Both patched chapters are complete and correct with no must-fix findings remaining; all three prover lanes (DUAL `DualInverse.lean`, D3′ `pullbackTensorMap_restrict`, ENGINE `CechHigherDirectImage.lean`) are green-lit for dispatch this iter.
