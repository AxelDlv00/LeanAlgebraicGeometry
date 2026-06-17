# Lean Audit Report

## Slug
iter271-touched

## Iteration
271

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Module docstring (L36-60)**: Announces "six main declarations" but the file contains additional
    top-level declarations not listed (`coverArrow`, `coverCechNerve`, `pushPullObj`, `pushPullMap`,
    `pushPullMap_id`, `pushPull_unit_mate`, `pushPull_transport_cancel`, `relativeCechComplexOfNerve`).
    Misleading count but does not misrepresent proof status. (MINOR)
  - **`pushPull_transport_cancel` docstring (L358-365)**: States "Applying it to `pushPullMap` via
    `rw` rewrites the tail…" The comment block describing `pushPullMap_comp` at L299 contradicts this
    with "erw is mandatory" ("`SheafOfModules` comps are defeq-not-syntactic, so `erw` is mandatory").
    The docstring's claim about `rw` is inaccurate; the companion comment is correct. (MINOR)
  - **`pushPull_transport_cancel` body (L377-378)**: `subst h; simp` is correct for the stated goal
    and the body is axiom-clean. Signature matches what the body proves. ✓
  - **`pushPullMap_comp` comment block (L273-321)**: Describes a route, adds no declaration. The block
    is accurate: it explains work remaining without claiming any sorry is closed. Not laundering. ✓
  - **`CechNerve` (L89-97)**: `sorry` honestly labeled; comment correctly identifies the missing ingredient
    (the push-pull functor's map_comp coherence). ✓
  - **`CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`**: All `sorry`
    with honest comments about absent Mathlib infrastructure. ✓
  - **`pushPullMap_id` (L216-271)**: Proof is axiom-clean (uses `erw`, `reassoc_of%`, correct mate
    calculus). Signature matches body. ✓
  - **`pushPull_unit_mate` (L332-349)**: Axiom-clean. Signature matches body. ✓

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Module docstring (L43)**: States "There are now THREE tracked typed-`sorry` residuals
    (iter-262)" — the `iter-262` attribution is stale (current iter is 271). The count "THREE" is
    still accurate. Does not misrepresent proof status. (MINOR)
  - **`sheafificationCompPullback_comp_tail` `have hwr` (L2667-2673)**: `have hwr` is declared (as
    the project instance of `conjugateEquiv_whiskerRight`) but is **never consumed** before the
    `sorry` at L2674. The preceding tactic steps (L2598-2619) do make genuine progress (they
    distribute the RHS into the expected form), but `hwr` itself is dead code in the current proof
    state. The surrounding comment block accurately describes how `hwr` is intended to be used in the
    next pass. This is dead-end proof scaffolding — a declared-but-unused local hypothesis. (MAJOR)
  - **`sheafificationCompPullback_comp_tail` sorry scope (L2674)**: The `sorry` is genuinely scoped
    to the remaining content after the structural steps. The proof compiles. ✓
  - **`forget_map_pushforward_map` (L2511-2519)**: `rfl`-proof; axiom-clean. ✓
  - **`sheafificationCompPullback_comp` (L2687-2784)**: Private lemma; calls
    `sheafificationCompPullback_comp_tail` (which has a `sorry`). Comment honestly identifies what
    the tail needs. ✓
  - **`pullbackTensorMap_restrict` sorry (L2902)**: Genuinely scoped; extensive comment explains the
    four-square paste roadmap and why the unit-analog mirror does not transfer. Not laundering. ✓
  - **`exists_tensorObj_inverse` sorry (L720)**: Honestly documented with exact bridge decomposition. ✓
  - **`pullbackTensorMap_natural` (D1′, L2051-2140)**: Axiom-clean. Signature matches body. ✓
  - **`pullbackEtaUnitSquare` (L1797)** and **`pullbackTensorMap_unit_isIso` (L1895)**: Axiom-clean
    (per project records and code structure). ✓
  - All `eqToHom`/`erw` bookkeeping in the closed lemmas follows documented patterns (subst for free
    hypotheses, `Functor.map_comp` merges, `conv_rhs` confinement). No silently-wrong transport steps
    detected.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **Module header (L39)**: Says "REMAINING (typed sorries, 4 of the `≃ₗ`-packaging fields):
    `naturality`, the reverse `invFun`, and its `left_inv`/`right_inv` round-trips." With iter-271,
    `invFun` is wired to the extracted `sliceDualTransportInv`, but that declaration itself has 2
    sorries (`app` + `naturality`). The actual sorry count is now **5** sorry positions:
    `sliceDualTransport` has 3 (`naturality`, `left_inv`, `right_inv`) and `sliceDualTransportInv`
    has 2 (`app`, `naturality`). The "4" in the header is stale and understates the sorry count by 1.
    Not dangerous (the additional sorry was always there, just inline), but misleading. (MAJOR)
  - **`sliceDualTransportInv` (L273-310)**: New top-level extraction of the `invFun` body. Its
    signature is correct: takes `ψ : (pushforward β M.val).dual.obj V` and returns an element of
    `(pushforward β M.val.dual).obj V`. The `refine { app := ..., naturality := ... }` syntax is
    sound because the return type unfolds to a NatTrans-like structure (the internal-hom sections
    ARE NatTrans). ✓
  - **`sliceDualTransportInv` presented as partial**: The docstring says "its `app`/`naturality`
    remain the documented residuals there" — honest. The declaration is NOT presented as complete. ✓
  - **`exact sorry` pattern (L309, L310)**: Both sorried fields use `exact sorry` rather than bare
    `sorry`. While semantically identical, the `exact` prefix is redundant and unconventional. (MINOR)
  - **`sliceDualTransport` invFun (L538)**: Now wired to `sliceDualTransportInv f M V β ψ`. The
    `β` parameter is passed explicitly from the outer `set β` binding — this is correct. ✓
  - **`sliceDualTransport` map_smul' (L483-515)**: Closed (iter-264). No sorry in this field. ✓
  - **`sliceDualTransport` map_add' (L453-461)**: Closed. ✓
  - **`dual_restrict_iso` naturality sorry (L673-674)**: Genuinely scoped to the `isoMk` naturality
    of the `sliceDualTransport` family, which cannot be discharged until `sliceDualTransport` has a
    concrete `.hom`. Comment at L669-671 explains this accurately. ✓
  - **`dual_restrict_iso` documentation structure (L555-641)**: The declaration's docstring region
    contains a planner-strategy block as a `/- Planner strategy: ... -/` nested comment, and then
    the closing `-/` of the outer comment on line 641 (which is the `noncomputable def`'s doc block).
    This makes the boundary of the docstring ambiguous when reading the Lean source. (MINOR)
  - **`dual_isLocallyTrivial` (L750-759)**: Body is assembled and compiles, inheriting the
    `dual_restrict_iso` sorry axiomatically. This is accurately described in the comment. ✓

---

## Must-fix-this-iter

None. No declaration misrepresents its proof status, no sorry is claimed to be closed, no weakened-wrong definition is present, and no excuse-comment of the "temporary / will fix later" variety appears.

---

## Major

- `TensorObjSubstrate.lean:2667` — `have hwr := conjugateEquiv_whiskerRight …` is declared but never
  consumed before `sorry` at L2674. The variable is dead code in the current proof state. This is
  dead-end proof scaffolding: it inflates the proof script without contributing to the current goal
  closure, and future provers must determine whether `hwr` remains the right device once the sorry
  is attacked.

- `DualInverse.lean:39` — Module header says "4 remaining sorries" but the actual count is 5 sorry
  positions after iter-271 (`sliceDualTransport`: 3, `sliceDualTransportInv`: 2). Creates a
  misleading picture of proof progress.

---

## Minor

- `CechHigherDirectImage.lean:358` — `pushPull_transport_cancel` docstring says "via `rw`"; the
  companion comment at L299 correctly says `erw` is mandatory. The docstring has an inaccurate
  rewrite-tactic claim.

- `CechHigherDirectImage.lean:36` — Module docstring claims "six main declarations" but the file
  contains ≥ 8 additional top-level declarations not in the list.

- `TensorObjSubstrate.lean:43` — Module header sorry-tracking uses "iter-262" attribution; current
  iter is 271. Stale iter reference; sorry count ("THREE") is still correct.

- `DualInverse.lean:309,310` — `exact sorry` idiom; bare `sorry` is conventional and equivalent.

- `DualInverse.lean:555` — `dual_restrict_iso` embeds a planner-strategy block as a nested
  `/- ... -/` inside the declaration's doc region, making the docstring boundary ambiguous in Lean
  source.

---

## Excuse-comments (always called out separately)

None. No declaration contains a comment admitting the code is wrong or is a placeholder.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: All three files are in good standing — every `sorry` is honestly labeled, no
declaration misrepresents its proof status, and no weakened or wrong definitions are present. The
two major findings (`have hwr` dead scaffolding in `sheafificationCompPullback_comp_tail` and the
stale sorry-count in `DualInverse.lean`'s header) are documentation/scaffolding issues that do not
block downstream work but should be corrected before the next iteration to avoid confusion when the
`sorry` is attacked.
