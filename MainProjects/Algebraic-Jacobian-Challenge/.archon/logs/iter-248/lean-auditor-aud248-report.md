# Lean Audit Report

## Slug
aud248

## Iteration
248

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L43–44** — module-level `## Status (current)` block says "The remaining typed-`sorry` residual is the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`)." The word "remaining" (with definite article "the") implies a single sorry. There are now **two** sorries: L692 (`exists_tensorObj_inverse`) and L1672 (`pullbackEtaUnitSquare` (∗∗)). The status block was written before the `LocTrivPullbackTensor` section was developed and has not been updated to reflect the second tracked sorry. Stale.
  - **L51** — "Once the inverse lands, the consumer `PicSharp.addCommGroup` (downstream in `RelPicFunctor.lean`) can be rewired." The `addCommGroup` instance was already rewired in iter-247 (confirmed by reading `RelPicFunctor.lean`). Stale.
  - **L1554–1563** `compHomEquivFactor` — proof body is `simp only [homEquiv_unit, comp_unit_app, Functor.comp_map, Functor.map_comp]; exact Category.assoc _ _ _`. Reduces cleanly to `Category.assoc` after normalising both sides via `homEquiv_unit` + `comp_unit_app`. Correct.
  - **L1575–1586** `sheafificationCompPullback_eq_leftAdjointUniq` — stated as `:= rfl`. The definitional identification of `SheafOfModules.sheafificationCompPullback` with `Adjunction.leftAdjointUniq A B` is confirmed by memory as `rfl` (the feared defeq wall turned out to be trivial). Accurate.
  - **L1595–1630** `leftAdjointUniqUnitEta` — multi-step proof using `hg : ... = (A.leftAdjointUniq B).hom.app 𝟙_` by `rfl`, then `Adjunction.homEquiv_leftAdjointUniq_hom_app A B`, `Adjunction.comp_unit_app`, and a final `rfl`. Proof structure is sound.
  - **L1632–1672** `pullbackEtaUnitSquare` — contains the tracked (∗∗) `sorry` at L1672. The proof successfully: (1) applies `.homEquiv.injective`, (2) rewrites RHS via `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`, (3) rewrites LHS via `Adjunction.homEquiv_unit`. The HANDOFF comment (L1663–1671) is accurate and detailed about the remaining steps 2–7, including a genuine constraint note about step 7 (no `LaxMonoidal` instance on the sheaf pushforward). Not a dead-end: the approach is the correct adjunction-mate transposition route.
  - **L1678–1682** `pullbackTensorMap_unit_isIso` — chains `pullbackEtaUnitSquare f` through `isIso_sheafifyEta_of_unitSquare` and `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`. Structurally correct; inherits the tracked (∗∗) sorry transitively from `pullbackEtaUnitSquare`. The docstring accurately describes the chain of lemmas used.
  - **L1495–1509** `presheafUnit_comp_map_eta` — one-line proof `exact Adjunction.unit_app_unit_comp_map_η (...)`. The Mathlib lemma `Adjunction.unit_app_unit_comp_map_η` is the standard adjunction-ismonoidal mate identity. Per project records (iter-247), this closed axiom-clean. Correct.
  - **L1518–1544** `isIso_sheafifyEta_of_unitSquare` — wraps the `hsq` (unit square) hypothesis via `Iso.inv_comp_eq` / `Iso.eq_comp_inv` to rewrite the goal, then closes by `IsIso.comp_isIso'` three times using `isIso_pbu_of_final`. Proof is sound.
  - No `axiom` declarations. No excuse-comments. The two tracked sorries (L692, L1672) are accurately documented at their respective call sites.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Zero file-local `sorry`** — confirmed. All `sorry`-containing lines in this file are inside doc-block text, not proof terms. The claim in the module docstring is accurate.
  - **Module docstring (L11–66)** — accurately describes the current state: zero file-local sorry; `addCommGroup` has a real body; the only reachable sorry is the upstream `Modules.exists_tensorObj_inverse` (TensorObjSubstrate.lean:692); `PicSharp` and `functorial` are deliberate stubs. The "stale and false" statements explicitly identified (L39–41) correctly retract the old "file-local addCommGroup sorry / Scheme.Modules monoidal-upgrade gate" framing. Accurate.
  - **`addCommGroup` instance (L412–452)** — real proof body using `relAdd`/`relNeg` and the upstream coherence isos. `add_assoc`/`zero_add`/`add_zero`/`add_comm` are sorry-free (each an `exact Quotient.sound ⟨upstream_iso⟩`). `neg_add_cancel` correctly calls `Modules.exists_tensorObj_inverse` (upstream sorry) and the `Modules.tensorObj_braiding`. The `letI` idiom for `nsmulRec`/`zsmulRec` is standard Lean 4 practice. Correct.
  - **`relNeg` (L352–367)** — uses `Classical.choose`/`Classical.choose_spec` on `Modules.exists_tensorObj_inverse`. Well-definedness proof (`pInverseUnique h1 h2`) is correct. Correct.
  - **`pInverseUnique` (L320–328)** — mirrors the upstream `IsInvertible.inverse_unique` chain using the upstream coherence isos directly. Correct.
  - **`PicSharp` (L518–521)** — body is `(Functor.const _).obj (AddCommGrpCat.of PUnit.{u+2})`. Docstring accurately identifies this as a deliberate stub gated on Lane TS D4′. Not an excuse-comment; the gate is clearly stated.
  - **`functorial` (L566–571)** — body is `0` (zero `AddMonoidHom`). Docstring accurately identifies the gate (D4′ `pullback_tensor_iso_loctriv`, not a `Scheme.Modules` monoidal upgrade). Not an excuse-comment.
  - **`presheaf` (L615–618)** — re-exports `PicSharp _C` as the bundled functor. Correct.
  - **`etSheaf` (L682–686)** — `(presheafToSheaf J AddCommGrpCat).obj (PicSharp.presheaf _C)`. Correct.
  - **`etSheaf_group_structure` (L736–741)** — `⟨0⟩` (the zero morphism). Docstring accurately explains that the `Nonempty` is witnessed by `0` (zero morphism between `AddCommGrpCat`-valued presheaves), and the richer statement is gated on D4′. Correct.
  - **L282** "were a temporary workaround" — past tense, describing deleted iter-246 local copies. Not an excuse-comment.
  - **L499** "not a 'placeholder pending a file-local sorry'" — actively denies the excuse framing. Not an excuse-comment.

---

## Must-fix-this-iter

None.

Both tracked sorries (TensorObjSubstrate.lean L692, L1672) are explicitly excluded by the directive as "intentional, tracked residuals." No excuse-comments, no weakened definitions, no axioms on non-trivial claims, no parallel-API drift, and no suspect bodies were found.

---

## Major

- `TensorObjSubstrate.lean:43–44` — Module-level Status block states "The remaining typed-`sorry` residual is the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`)" (singular, definite article). There are now **two** tracked sorries: L692 (`exists_tensorObj_inverse`) and L1672 (`pullbackEtaUnitSquare` (∗∗)). The status block was not updated when the `LocTrivPullbackTensor` section was added. A future reader counting sorries from the module header would get the wrong number. Should read "The remaining typed-`sorry` residuals are: (1) `exists_tensorObj_inverse` (L692); (2) `pullbackEtaUnitSquare` (L1672, the (∗∗) η-bridge handoff)."

---

## Minor

- `TensorObjSubstrate.lean:51` — "Once the inverse lands, the consumer `PicSharp.addCommGroup` (downstream in `RelPicFunctor.lean`) can be rewired." The rewiring was completed in iter-247. Stale historical sentence in the status block; harmless but slightly misleading for readers scanning module history.

---

## Excuse-comments (always called out separately)

None found in either file. All comments that use words like "placeholder", "temporary", or "sorry" do so to *deny* those characterisations or to *describe deleted* prior state, not to excuse current wrong code.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (stale sorry-count in Status block)
- **minor**: 1 (stale historical sentence in Status block)
- **excuse-comments**: 0

Overall verdict: Both files are structurally clean; the newly-added `LocTrivPullbackTensor` decls have reasonable proof bodies and accurate docstrings; the single major finding is a stale sorry-count claim in TensorObjSubstrate.lean's module header that should be updated to mention the (∗∗) L1672 sorry alongside the L692 one.
