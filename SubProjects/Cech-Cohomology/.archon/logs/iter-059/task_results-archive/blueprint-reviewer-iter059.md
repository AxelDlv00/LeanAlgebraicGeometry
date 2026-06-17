# Blueprint Reviewer Report

## Slug
iter059

## Iteration
059

## Status
COMPLETE — all three chapters audited; hard gate clears for both Lane A (Stub-1 inductive assembly)
and Lane B (Need#1 jShriekOU transport).

---

## Per-Chapter Verdicts

| Chapter | complete | correct | Notes |
|---------|----------|---------|-------|
| `Cohomology_HigherDirectImage.tex` | true | true | Trivial chapter; single `higherDirectImage` definition with `\leanok`. |
| `Cohomology_AcyclicResolution.tex` | true | true | Horseshoe construction + acyclic resolution comparison; all blocks `\leanok` or `\mathlibok`. |
| `Cohomology_CechHigherDirectImage.tex` | true | true | 1 soon finding (proof `\uses` wire-up); no must-fix-this-iter blockers. |

---

## DAG Health

- **`unknown_uses`**: `[]` — no broken `\uses{}` edges after writer changes.
- **`malformed_refs`**: 0 — blueprint renders cleanly (blueprint-doctor pass).
- **Isolated nodes**: 1 (`lean_aux` type, pre-existing unmatched Lean helper, not a blueprint
  node). Disposition: **keep** — this is the same node reported in prior iters; it is not a new
  structural gap.
- **Total blueprint nodes**: 252 (stable; 3 new blocks added this iter wired in, no orphans).

---

## Mathlib Anchor Audit

All new `\mathlibok` anchors introduced this iteration were verified against Mathlib source files.

| Anchor label | `\lean{}` name | Verdict |
|---|---|---|
| `lem:isIso_sigmaDesc_fst_mathlib` | `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_fst` | ✓ FAITHFUL — found in `Mathlib/CategoryTheory/FinitaryExtensive.lean`; `{α : Type 0}` restriction correctly stated in blueprint |
| `lem:overProdLeftIsoPullback_mathlib` | `CategoryTheory.Over.prodLeftIsoPullback` | ✓ FAITHFUL — found in `Mathlib/CategoryTheory/Over/Products.lean` |
| `lem:isAffineOpen_image_of_iso_mathlib` | `AlgebraicGeometry.Scheme.Hom.isAffineOpen_iff_of_isOpenImmersion` | ✓ FAITHFUL — found in `Mathlib/AlgebraicGeometry/OpenImmersion.lean` |
| `lem:mod_pmod_adjunction` (pre-existing) | `PresheafOfModules.sheafificationAdjunction` | ✓ FAITHFUL — confirmed in `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafification.lean:123` |
| `lem:modules_pushforward_mathlib` (pre-existing) | `AlgebraicGeometry.Scheme.Modules.pushforward` | ✓ FAITHFUL — confirmed in `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean` |
| `lem:modules_isoSpec_mathlib` (pre-existing) | `AlgebraicGeometry.Scheme.isoSpec` | ✓ FAITHFUL — confirmed in `Mathlib/AlgebraicGeometry/Spec.lean` |

---

## Lane A — Stub-1 Inductive Assembly

### `lem:coproduct_distrib_fibrePower_zero`
- Status: `\leanok` — already formalized.
- σ-component slice-product bridge note added correctly.
- `\uses{lem:widePullback_overX_eq_prod}` on both statement and proof — accurate.
- Verdict: **✓ no issues**.

### `lem:overProd_coproduct_distrib` (NEW this iter)
- Status: build target (no `\leanok`); `% NOTE: build target` marker present.
- Statement: `(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)` in `Over S`, `{ι : Type 0} [Finite ι]` — correct type.
- Proof sketch: reduce via `Over.forget S` which reflects isos; match `.left` via
  `Over.prodLeftIsoPullback`; reduce to `lem:prod_coproduct_distrib` — sound, adequate for
  formalization.
- `\uses{lem:prod_coproduct_distrib, lem:overProdLeftIsoPullback_mathlib}` on statement and proof
  — accurate.
- `\lean{CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib}` — correct pin for build
  target.
- Verdict: **✓ no issues**.

### `lem:overProdLeftIsoPullback_mathlib` (NEW Mathlib anchor)
- `\lean{CategoryTheory.Over.prodLeftIsoPullback}` — verified faithful (see table above).
- `\mathlibok` ✓.
- Verdict: **✓ no issues**.

### `lem:isIso_sigmaDesc_fst_mathlib` (NEW Mathlib anchor)
- `\lean{CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_fst}` — verified faithful.
- Universe restriction `{α : Type 0}` stated explicitly in blueprint — correct and critical.
- Verdict: **✓ no issues**.

### `lem:coproduct_distrib_fibrePower` (main assembly, build target)
- Statement `\uses` correctly includes: `lem:overProd_coproduct_distrib`,
  `lem:finitaryExtensive_scheme_mathlib`, `lem:widePullback_overX_eq_prod`,
  `lem:overProdLeftIsoPullback_mathlib` — accurate.
- Universe caveat paragraph added referencing `lem:isIso_sigmaDesc_fst_mathlib` — correct.
- Inductive step prose expanded to mention Over-S binary-product form — consistent with new
  `lem:overProd_coproduct_distrib`.
- **SOON**: The **proof block** `\uses{}` omits `lem:finitaryExtensive_scheme_mathlib` despite the
  proof prose explicitly invoking finitary extensivity of schemes. The **statement block** already
  lists it, so DAG ordering is not broken (leandag `unknown_uses: []` confirmed), but for
  completeness the proof block should mirror this edge. Wire-up recommended before the prover
  attempts this lemma.
- Verdict: **✓ correct, 1 soon finding** (see Severity Summary below).

### `lem:cech_backbone_left_sigma`
- Status: `\leanok` — already formalized.
- Universe-reduction paragraph added: choose `I ≃ Fin n`, reindex to `Type 0`, apply
  `lem:coproduct_distrib_fibrePower`, transport back. Explicitly names the `isIso_sigmaDesc_fst`
  `Type 0` constraint as the reason.
- `\uses` accurate for all dependencies.
- Verdict: **✓ no issues**.

---

## Lane B — Need#1 jShriekOU Transport

### `lem:pushforward_commutes_free`
- Status: build target.
- `\uses{def:jshriek_ou}` on statement and proof — sufficient, as `free` and its adjointness
  property are established through the `jShriekOU` infrastructure.
- Proof sketch: both `Φ.functor ∘ free` and `free ∘ Φ_pre` are left adjoint to the conjugate
  forgetful; conclude by uniqueness of left adjoints — sound categorical argument.
- Verdict: **✓ no issues**.

### `lem:pushforward_commutes_sheafify`
- Status: build target.
- `\uses{lem:mod_pmod_adjunction}` — accurate; anchor verified faithful in Mathlib (see table).
- Proof sketch: site-isomorphism between `(X, O_X)` and `(Y, O_Y)` under `φ`, then left adjoint
  uniqueness for `pMod ⊣ ι` — sound.
- Verdict: **✓ no issues**.

### `lem:yoneda_transport_along_homeo`
- Status: build target.
- No `\uses` (self-contained sectionwise calculation) — correct; does not import other
  project-specific lemmas.
- Proof sketch: unfold presheaf pushforward sectionwise, verify yoneda evaluation commutes — clear.
- Verdict: **✓ no issues**.

### `lem:jshriek_transport_along_iso`
- Status: build target.
- `\uses{def:jshriek_ou, lem:pushforward_commutes_free, lem:pushforward_commutes_sheafify,
  lem:yoneda_transport_along_homeo}` — all four edges accurate; no missing dependencies.
- Proof: chains `lem:pushforward_commutes_sheafify` ∘ `lem:pushforward_commutes_free` ∘
  `lem:yoneda_transport_along_homeo` to produce `Φ(j_!O_V) ≅ j_!O_{φ''V}` — structurally
  correct.
- Verdict: **✓ no issues**.

### `lem:pushforward_iso_preserves_qcoh`
- Status: build target.
- `\uses{lem:modules_pushforward_mathlib}` added this iter — accurate.
- Note (from writer): a more precise `\mathlibok` anchor for "iso of schemes preserves
  IsQuasicoherent" was not wired because no sufficiently precise Mathlib declaration could be
  confirmed. The proof is correctly left as a project build-target that argues from the
  local-presentation characterization. This is the right call for truthfulness.
- Verdict: **✓ no issues**.

### `lem:isAffineOpen_image_of_iso_mathlib`
- `\lean{AlgebraicGeometry.Scheme.Hom.isAffineOpen_iff_of_isOpenImmersion}` — verified faithful.
- Verdict: **✓ no issues**.

### `lem:modules_isoSpec_ext_transport` (consumer, pre-existing)
- The 4 named Lean declarations (`pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`,
  `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport`) are all confirmed proven in
  `OpenImmersionPushforward.lean` (lines 204–241). The blueprint block is correctly not `\leanok`
  because `sync_leanok` owns that marker; the writer/reviewer correctly did not touch it.
- Verdict: **✓ no issues**.

---

## Unstarted Phases Audit

Strategy phases checked against blueprint coverage:

| Phase | Status per STRATEGY.md | Blueprint coverage |
|---|---|---|
| P5a-resolution | ACTIVE | Extensive coverage in `Cohomology_CechHigherDirectImage.tex`; `CechAugmentedResolution` + homotopy lemmas all have blueprint blocks. |
| P5a-consumer | ACTIVE | `cech_computes_higherDirectImage` and surrounding assembly lemmas all have blueprint blocks. |
| P5b comparison assembly | BLOCKED (waiting P5a-consumer) | `Cohomology_AcyclicResolution.tex` fully wired; bridge lemmas in `Cohomology_CechHigherDirectImage.tex` have coverage. |

No unstarted phases — all phases have adequate blueprint scaffolding.

---

## Severity Summary

### Must-fix-this-iter
*None.*

### Soon (before prover dispatch for affected lemma)
1. **`lem:coproduct_distrib_fibrePower` proof block missing `lem:finitaryExtensive_scheme_mathlib`
   in `\uses{}`**: The proof prose cites finitary extensivity of schemes; the proof block should
   carry the edge explicitly. The statement block already includes it (DAG order correct; no
   dispatch risk). Fix: add `lem:finitaryExtensive_scheme_mathlib` to the proof `\uses{}` of
   `lem:coproduct_distrib_fibrePower`. One-line blueprint edit.

### Informational
- `lem:pushforward_iso_preserves_qcoh`: no Mathlib anchor for qcoh-preservation by iso of schemes.
  The writer correctly deferred; flagged here for the record. If the prover or plan agent locates a
  precise Mathlib name, adding an anchor and wiring it would close the edge cleanly.

---

## Hard Gate

**CLEARS for both Lane A and Lane B.**

- All Lane A declaration blocks (`lem:overProd_coproduct_distrib`, `lem:coproduct_distrib_fibrePower`,
  `lem:cech_backbone_left_sigma`) have well-formed statements, adequate proof sketches, accurate
  `\uses{}`, and verified Mathlib anchors for all external dependencies.
- All Lane B sub-lemmas (`lem:pushforward_commutes_free`, `lem:pushforward_commutes_sheafify`,
  `lem:yoneda_transport_along_homeo`, `lem:jshriek_transport_along_iso`,
  `lem:pushforward_iso_preserves_qcoh`) have well-formed statements, detailed proof sketches, and
  accurate `\uses{}`.
- 0 must-fix-this-iter findings. 1 soon finding (proof `\uses` wire-up for
  `lem:coproduct_distrib_fibrePower`) — does not block prover dispatch for other lemmas; should be
  fixed before dispatching a prover specifically for that lemma.
- No broken DAG edges. No unstarted phases.

Prover dispatch for both lanes is unblocked.
