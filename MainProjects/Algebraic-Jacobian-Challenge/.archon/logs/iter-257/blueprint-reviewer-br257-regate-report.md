# Blueprint Review Report

## Slug
br257-regate

## Iteration
257

## Scoped Re-Gate: Two Chapters Only

This is the fast-path scoped re-review after bw257-d3, bw257-eng, and bc257 fixes, with `lake build` green.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:
  - **MF-1 (statement form) — RESOLVED.** `lem:pullback_tensor_map_basechange` (lines 3862–3904) now states the *general* composition coherence for any composable `h : Z → Y`, `f : Y → X`, `M N : X.Modules`. The displayed equation gives `δ^{h∘f}(M,N)` factoring through `δ^f`, `δ^h`, and `pullbackComp h f` conjugation, exactly matching the `pullbackTensorMap_restrict` Lean signature. The base-change-square consequence is relegated to a standalone "Remark" (lines 3892–3903) derived as the specialisation `h := j'`.
  - **MF-2 (proof sketch) — RESOLVED.** The proof describes the 4-square comp_δ route explicitly: Sq1 (`sheafificationCompPullback` comp — absent from Mathlib, supplied as project sub-lemma, lines 3960–3964); Sq2 (δ-core via `Functor.OplaxMonoidal.comp_δ` + `PresheafOfModules.pullbackComp` + ring-map reconciliation, lines 3939–3958); Sq3 (`sheafifyTensorUnitIso` unit-iso transport, lines 3966–3968); Sq4 (`pullbackValIso`-comp — likewise absent from Mathlib and the second project sub-lemma, lines 3970–3977). Lines 3979–3985 explicitly name Sq1 and Sq4 as the two deferred sub-lemmas. The disproven mate-calculus framing is not just removed but affirmatively refuted (lines 3929–3937): the proof explains *why* the `homEquiv`-bridge used for `pullbackObjUnitToUnit_comp` does not transfer to `pullbackTensorMap` (which is a hand-built four-fold composite, not an adjunction transpose).
  - **`lem:dual_restrict_iso` — remains complete+correct.** The leg-A `sliceDualTransport` pin is explicitly named (lines 5658–5678): the atom is identified as a standalone `O_Y(V)`-linear equivalence built via `Functor.FullyFaithful.homEquiv` of `f.opensFunctor`, reducing (in the thin-poset setting) to an `eqToHom`-conjugation along `image_preimage_of_le` with naturality by `Subsingleton.elim`, packaged by `PresheafOfModules.isoMk`. The full Step-4 isomorphism is described as `isoMk` of (leg-A `sliceDualTransport`) followed by (leg-B `lem:restrictscalars_ringiso_dualequiv`). No vagueness remains.
  - **Covers directive.** The chapter declares `% archon:covers` for `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, `StalkTensor.lean`, `Vestigial.lean`, AND `DualInverse.lean`. Both files named in the directive gate (`TensorObjSubstrate.lean` and `DualInverse.lean`) are covered by this consolidated chapter.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

- **complete**: true
- **correct**: true
- **notes**:
  - **MF-3 (finiteness bridge) — RESOLVED.** The proof of `lem:lbc_chart_presentation` (lines 186–204) explicitly names `SheafOfModules.Presentation.ofIsIso` (line 200) as the transport vehicle, and names the automatic `IsFinite` instance as "the `SheafOfModules.unit` finite-presentation instance" (line 196). The proof of `thm:lbc_isFinitePresentation` (lines 229–249) names `SheafOfModules.IsFinitePresentation.mk` as the constructor and makes clear that the assembled `QuasicoherentData.IsFinitePresentation` feeds `mk` directly — no 6th declaration is needed and none is introduced.
  - **MF-4 (false `\leanok`) — RESOLVED.** The proof block for `lem:lbc_chart_presentation` (lines 185–204, `\begin{proof}…\end{proof}`) carries no `\leanok`. The statement block at line 148 retains `\leanok` (indicating the declaration exists, per `sync_leanok`), which is correct. The erroneous proof-level marker is gone.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Both must-fixes for each chapter are resolved. No new issues found.

---

## Gate verdict

**Both chapters are `complete: true` + `correct: true` with no must-fix findings.**

The following Lean files are cleared to enter this iteration's prover objectives:
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- `AlgebraicJacobian/Picard/LineBundleCoherence.lean`
