# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-303 fine-grained pass (lane 2, D3′)

## Scope reconciliation (what was actually actionable)

The objective lists "ready tensor-iso nodes" (`jw_ismonoidal`, `pullback0_tensor_iso`,
`pullback_tensor_iso_loctriv`, `pullback_compatible_with_tensorobj`,
`stalk_tensor_commutation_naturality_right`). **None of these exist as Lean declarations in this
file** — they are pinned in the blueprint to `AlgebraicGeometry.TODO.*` /
`AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso` namespaces and are flagged
absent-from-Lean-source in the blueprint itself (e.g. line 1831 `% NOTE: pin target absent ... iter-271`).
There is nothing to close for them in this file.

The file's three actual `sorry`s:
- L720 `exists_tensorObj_inverse` — **gated (do NOT touch)**, depends on the dual chain.
- L2902 `pullbackTensorMap_restrict` — **gated (do NOT touch)**, D4′/downstream.
- **L2674 `sheafificationCompPullback_comp_tail` — the sole actionable target.**

## Sentence: `sheafificationCompPullback_comp_tail` (D3′ Sq1 unit-cocycle tail)

The blueprint's 5-step argument (strip identity wrapper → distribute `forget` → recover sub-comparison
units → slide `pushforwardComp` by naturality → reassemble composite unit). Steps (a)/(b)/(i)/(d)/(e.0)
were landed in iters 264/265/271 (restrictScalarsId strip, forget-distribution, bridge consumption,
`hwr := conjugateEquiv_whiskerRight` device set up).

### Result: PARTIAL — one verified forward step committed (e.1); core cocycle residual confirmed blocked.

**Committed this iter (genuine, axiom-clean, non-contaminating):**
`simp only [Adjunction.comp_unit_app]` after the `hwr` setup — expands the RHS composite-adjunction
unit `(A_f.comp A_h).unit.app (a_X P)` into `A_f.unit.app _ ≫ (pushforward f).map (A_h.unit.app _)`.
Verified the LHS `B_{h≫f}.unit` (built directly on `pullbackPushforwardAdjunction (h≫f)`, not a `.comp`)
is untouched. This is roadmap step (e.1) — it exposes the separate `A_f`/`A_h` unit factors that the
R1/R5 recovery (step (ii)) must rewrite into `B_f`/`B_h` units. The existing proof had not yet performed
this decomposition.

**Confirmed blocked (the genuine residual — 6th PARTIAL):** the composite-adjunction-unit cocycle.
Verified this iter that none of the following close or non-trivially advance past the committed point:
- `aesop_cat` (exhaustive search fails; leaves the full goal),
- the mate simp set `[Adjunction.unit_naturality, right_triangle_components, pushforwardComp_hom_app_app]`
  (all reported **unused** — none fire on the goal's normal form),
- the re-merge `simp only [← Functor.map_comp]` (only consolidates `forget.map _ ≫ forget.map _`; no
  structural progress).

The `hwr` conjugate device (Mathlib `conjugateEquiv_whiskerRight`, Mates.lean:536) is correctly set up
and elaborates at the project's adjunction types, but it is a **conjugate-level** identity: consuming it
into the raw unit goal requires the non-circular whole-equation transposition (the
`leftAdjointCompNatTrans_assoc` surjective/injective reduction Mathlib uses to prove the sibling
`SheafOfModules.pullback_assoc`, CompositionIso.lean:155) — NOT the LHS-only re-transpose, which the
in-file comments (and re-verification this iter) confirm is circular via the R0-peel building block.

## Why I stopped

**Partial progress.** Sole actionable sentence (`sheafificationCompPullback_comp_tail`): committed one
verified forward step (`Adjunction.comp_unit_app` RHS-unit expansion, step e.1); sorry count unchanged
(3→3, file compiles, no signature change, RACE-safe for the importing lanes 1 & 4). The remaining residual
is the genuinely-novel bicategorical-cocycle/mate assembly with **no drop-in project or Mathlib lemma** —
exactly the 6th-PARTIAL condition the iter-265 reversing signal and the iter-303 plan pre-authorized for
**cross-domain-analogist escalation** on the mate-assembly shape (`leftAdjointCompNatTrans_assoc`
surjective/injective reduction). It is not a further fine-grain helper round.

- **Specific blocker (not "it's hard"):** the goal after step (e.1) is the unit identity
  `B_{h≫f}.unit.app P = a_X.unit P ≫ forget.map(A_f.unit ≫ pushforward f.map A_h.unit ≫ pushforwardComp.hom) ≫ pushforward φ'_{h≫f}.map(forget.map(R1 ≫ R5 ≫ a_Z.map δ_pre))`.
  R1 = `(pullback h).map ((sheafCompPb f).app P).hom`, R5 = `(sheafCompPb h).app (PrPb_f P)).hom` have
  **no `homEquiv`/conjugate head** in the raw goal, so `leftAdjointUniqUnitEta_app` cannot fire to recover
  them as `B_f`/`B_h` units. `hwr` supplies that head only at the conjugate level; bridging requires the
  whole-equation transpose, which is the absent ~40-60 LOC assembly.

- **Approaches written but not attempted:** the wholesale `_comp` re-proof via
  `leftAdjointCompNatTrans_assoc` `surjective`/`injective` reduction (the fallback). NOT attempted: it
  restructures the *separate* `sheafificationCompPullback_comp` lemma (L2687, currently delegating to this
  tail), is high-risk against the MANDATORY race constraint (lanes 1 & 4 import this file; no signature may
  change, must stay compiling), and is precisely the analogist-escalation target — better dispatched with
  the CompositionIso.lean:130–164 API in hand than attempted blind under a fine-grain budget.

## Recommended next step
Dispatch the cross-domain analogist on the composite-adjunction unit-cocycle / mate-assembly shape
(`leftAdjointCompNatTrans_assoc` + `conjugateEquiv_whiskerRight`/`_comp` + `unit_conjugateEquiv`),
targeting the wholesale `sheafificationCompPullback_comp` re-proof in the conjugate vocabulary (Mathlib's
own route for `pullback_assoc`, PullbackContinuous.lean:192). The `_comp_tail` lemma can then be folded
back in or retired.

## Markers for review agent
No declaration newly closed → no `\leanok` change. `sheafificationCompPullback_comp_tail` remains
sorry-bearing (advanced one step).
