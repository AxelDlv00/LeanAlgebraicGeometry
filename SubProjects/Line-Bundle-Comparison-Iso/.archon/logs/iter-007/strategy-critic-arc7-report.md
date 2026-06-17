# Strategy Critic Report

## Slug
arc7

## Iteration
007

## Routes audited

### Route: D3′ — the comparison iso

- **Goal-alignment**: PASS — produces `f^*(M⊗N)≅f^*M⊗f^*N` on loc-triv pairs = seed 1 (`lem:pullback_tensor_iso_loctriv`).
- **Mathematical soundness**: PARTIAL — the NatTrans-level Sq1 route via `conjugateEquiv_comp` mirroring `pullbackObjUnitToUnit_comp` is sound and the prereq is verified. BUT the document **contradicts itself about what remains**: the Phases table risk cell says *"Sq3/Sq4 sub-lemmas don't exist yet → effort-broken iter-007"* while the Route prose says *"D1′/D2′/Sq2/Sq2b/Sq3/Sq4 CLOSED. Remaining: Sq1."* These cannot both be true. The planner cannot estimate or sequence the route while the document disagrees with itself on whether Sq3/Sq4 exist.
- **Phantom prerequisites**: none — `conjugateEquiv_comp` (Mathlib.CategoryTheory.Adjunction.Mates), `conjugateEquiv_iso`, `IsIso.inv_comp_eq` all VERIFIED.
- **Effort honesty**: reasonable for the prose reading (2 real `sorry`s remain in `TensorObjSubstrate.lean` at L712, L3144 = Sq1 + D4′; `~3–5` iters / `~120–300` LOC fits a cocycle + chart-chase). The estimate is only trustworthy once the Sq3/Sq4 contradiction is resolved — if Sq3/Sq4 genuinely "don't exist yet" the LOC is under-counted.
- **Verdict**: CHALLENGE — reconcile the Sq3/Sq4 closed-vs-missing contradiction before relying on the estimate.

### Route: DUAL — the dual-inverse (RPF group inverse)

- **Goal-alignment**: PASS — yields the loc-triv inverse witness `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (L⊗Linv≅𝒪)` feeding seed 2 + the consumer.
- **Mathematical soundness**: PASS (technique) — the morphism-level corrective (`IsIso.inv_comp_eq` → forward ε-square, never `inv ε` pointwise, close via `restrictScalars_η`/`restrictScalarsComp'App`) is a genuine, well-motivated fix for the documented `whnf`-on-deep-composite heartbeat timeout, and every named lemma is VERIFIED in Mathlib/project.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The phrase *"the multi-iter RED deadlock was broken structurally"* describes a file split + 6 typed `sorry`s, which is relocation, not a closed proof.
- **Infrastructure-deferral detected**: yes (partially) — see Infrastructure-deferral findings. The hardest prerequisite (`sliceDualTransport` inv-naturality) is unchanged before and after this iter's pivot; the GREEN-by-typed-sorry + split moved the 4 hard `sorry`s into `SliceTransport.lean` without discharging any. This is mitigated by the recipe being a real plan with a timeline, so CHALLENGE not REJECT.
- **Phantom prerequisites**: none — `restrictScalarsComp'App` (+ `_hom_naturality`/`_inv_naturality`) at Mathlib ChangeOfRings.lean:237; `ModuleCat.restrictScalars_η` used in-project; `IsIso.inv_comp_eq` VERIFIED.
- **Effort honesty**: optimistic — `~2–4` iters for the inv-naturality root + fwd naturality + left/right_inv, after a stated ~30-iter churn on this exact naturality, is plausible only if the morphism-level recipe lands on the first or second attempt. The estimate is acceptable but the planner should treat it as a recipe-validation bet, not a settled count.
- **Parallelism under-exploited**: no — runs in parallel with D3′ as stated; the 4 intra-DUAL sorries share `inv ε` naturality as a root so partial serialization within the route is correct.
- **Verdict**: CHALLENGE — confirm the morphism-level recipe is actually executed against the 4 relocated `SliceTransport.lean` sorries this iter; do not let "file is GREEN" stand in for "naturality is proved."

### Route: Consumer (third seed)

- **Verdict**: SOUND.

## Format compliance

- **Size**: ~107 lines / ~5 KB — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material` present in canonical order. (`## Completed` omitted — arguably should now exist given substantial closed work: D1′/D2′/Sq2/Sq2b closed, `DualInverse.lean` split; these are tracked as inline Route prose instead of a `## Completed` table. Minor.)
- **Per-iter narrative detected**: yes — pervasive. Representative verbatim: *"**iter-007: the multi-iter RED deadlock was broken structurally — a refactor GREENED the file (typed sorry at the 6 broken sites)…**"*; *"ROOT-CAUSE fix for the 30-iter `sliceDualTransport` naturality churn (iter-006 analogist)"*; *"User policy (iter-007 hint)"*; *"deferred from iter-007 to protect the must-fix DUAL repair"*; *"blueprint-reviewer iter-007 dispositioned them non-blocking"*. This is iter sidecar material living in STRATEGY.md.
- **Accumulation detected**: yes (mild) — completed sub-lemmas tracked as inline Route prose rather than a `## Completed` table; Route prose for DUAL has grown into a paragraph of iter history.
- **Table discipline**: PASS — Phases table has the canonical columns. (Risks cells are slightly long but acceptable.)
- **Format verdict**: NON-COMPLIANT — the volume of per-iter narrative (iter-006/iter-007 references threaded through both `## Routes` and `## Open strategic questions`) is a material drift requiring an in-place restructure this iter, with the dated detail moved to the iter-007 sidecar.

## Infrastructure-deferral findings

### Deferred: `sliceDualTransport` inv-naturality (the 4 DUAL sorries)

- **Required by goal**: yes — it is the root of `exists_tensorObj_inverse`, which the consumer (`thm:rel_pic_addcommgroup_via_tensorobj`, seed 3) consumes for the group inverse.
- **Current plan for building it**: present — the morphism-level recipe (`IsIso.inv_comp_eq` → forward ε-square) with `analogies/dualnat006.md`; the 4 sorries are now real, dispatchable sorries in `SliceTransport.lean` (L365, L502, L604, L606), not phantoms.
- **Timeline**: concrete (`~2–4` iters) but unproven against ~30 prior iters of churn on the same naturality.
- **Verdict**: CHALLENGE — the construction is on the critical path and the *same gap* survived this iter's pivot. The pivot's substantive content is the recipe, not the GREEN+split; the planner must show the recipe lands, otherwise the file-split is cosmetic and the deadlock persists under a new filename.

## Sunk-cost flags

- `"the multi-iter RED deadlock was broken structurally — a refactor GREENED the file (typed sorry at the 6 broken sites)"` — Why this is sunk-cost: GREENing by inserting typed `sorry`s and splitting the file relocates the hard obligation without discharging it, yet is framed as a breakthrough. Recommendation: reframe on merits — state that 4 naturality sorries remain open and that the *only* progress claim is the new morphism-level recipe; measure the route by sorries closed, not by file color.

## Prerequisite verification

- `CategoryTheory.IsIso.inv_comp_eq`: VERIFIED (Mathlib.CategoryTheory.Iso)
- `CategoryTheory.conjugateEquiv`: VERIFIED (Mathlib.CategoryTheory.Adjunction.Mates)
- `CategoryTheory.conjugateEquiv_comp`: VERIFIED (same module)
- `ModuleCat.restrictScalarsComp'App`: VERIFIED (Mathlib ChangeOfRings.lean:237, with hom/inv naturality lemmas)
- `ModuleCat.restrictScalars_η`: VERIFIED (used in `SliceTransport.lean:201`)

## Must-fix-this-iter

- Route D3′: CHALLENGE — resolve the Sq3/Sq4 "CLOSED" (Route prose) vs "don't exist yet" (Phases risk) contradiction; correct whichever is wrong and re-check the LOC estimate against it.
- Route DUAL: CHALLENGE / infrastructure-deferral — `sliceDualTransport` inv-naturality is required by the goal and is the same gap before and after the pivot; planner must either close ≥1 of the 4 relocated sorries via the morphism-level recipe this iter or record an explicit rebuttal stating why the recipe will land within the `~2–4` iter estimate.
- Format: NON-COMPLIANT — strip per-iter narrative (the iter-006/iter-007 references and the "deadlock broken structurally" paragraph) from `## Routes` and `## Open strategic questions`; move dated detail to the iter-007 sidecar. Also fix the stale LOC for `TensorObjSubstrate.lean` (stated `3411`, actual `3152`) in the Phases table and Open questions, and consider promoting closed sub-lemmas into a `## Completed` table.

## Overall verdict

The two-route + consumer decomposition still matches the goal and every named Mathlib prerequisite is real — there are no phantom dependencies and no mathematically broken route. The DUAL morphism-level recipe is a genuine, well-targeted fix for the documented `whnf`/heartbeat root cause. However, two things must be fixed before the planner proceeds. First, the strategy defers `sliceDualTransport` inv-naturality, which is required for the stated goal (the relative-Picard group inverse feeding seed 3): this iter's "deadlock broken structurally" pivot relocated the four hard sorries into `SliceTransport.lean` without closing any, so the hardest prerequisite is unchanged and the only real progress is the as-yet-unexecuted recipe — the planner must demonstrate the recipe lands, not that the file is GREEN. Second, D3′ internally contradicts itself on whether Sq3/Sq4 are closed or nonexistent, which invalidates its effort estimate until reconciled. Format is NON-COMPLIANT due to pervasive iter-006/iter-007 narrative that belongs in sidecars; restructure in place this iter.
