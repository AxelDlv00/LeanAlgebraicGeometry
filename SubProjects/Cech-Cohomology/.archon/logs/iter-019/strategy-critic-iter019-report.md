# Strategy Critic Report

## Slug
iter019

## Iteration
019

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN)

- **Goal-alignment**: PASS — augmented Čech resolution + P4 (`acyclic_resolution_computes_derived`) yields `Hⁱ(f_* C•) ≅ Rⁱf_*F`, which is exactly the protected `Nonempty (…≅…)`. The P5a re-sign does not perturb this skeleton.
- **Mathematical soundness**: PASS — resolution-is-acyclic-cover argument is the standard Cartan–Leray route; P4 is done and axiom-clean.
- **Infrastructure-deferral detected**: yes — see the dedicated finding below (the presheaf-homology ↔ absolute-affine-cohomology bridge that the P5a consumers' proofs need is deferred to "point of use" with no budget).
- **Verdict**: SOUND (the global skeleton is correct; the deferral finding is scoped to the P5a re-sign, audited next).

### Route: B — two spectral sequences (REJECTED, fallback)

- **Verdict**: SOUND — correctly rejected; the note that B rests on the same `injective_cech_acyclic` brick is accurate and honest.

### Route: The acyclicity bridge (P3 → P3b → `affine_serre_vanishing`)

- **Goal-alignment**: PASS — breaks the affine-vanishing circularity legitimately (P3 standard-cover Čech vanishing → P3b basis comparison → affine sheaf vanishing), no affine vanishing used as its own input.
- **Mathematical soundness**: PASS on the bridge logic itself.
- **Phantom prerequisites**: `affine_serre_vanishing` / `cech_to_cohomology_on_basis` are blueprinted with the **absolute** object `Hᵖ(U, F)` (sheaf cohomology of an `O_U`-module). Mathlib has `CategoryTheory.Sheaf.H` for `Sheaf J AddCommGrpCat` (Ext-based, needs `HasSheafify` + `HasExt`) but **no module-valued `Hⁿ` for `SheafOfModules`**. So the absolute object is realizable only via a forget-to-`AddCommGrp` (a path the strategy never names), not phantom — but its Lean realization is undecided and unbudgeted. See finding.
- **Verdict**: CHALLENGE — the bridge's *output* statement depends on an absolute-cohomology object whose Lean realization is undecided, and that same object resurfaces in the P5a consumers (below). This is the load-bearing tension this iter must own.

### Route: P5a re-sign (Open strategic question, DECIDED iter-019)

- **Goal-alignment**: PARTIAL — the re-signed *leaf* (`higherDirectImage_iso_sheafify_presheafHomology`, resolution form) is correct, proved, axiom-clean, and is a legitimate decomposition. But the strategy's claim that the **consumers** `open_immersion_pushforward_comp` and `cech_term_pushforward_acyclic` "need only the sheafify-of-presheaf-homology criterion, which the resolution form supplies directly" is **materially incomplete**.
- **Mathematical soundness**: PASS for the leaf; the issue is what the re-sign claims to eliminate.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the last-mile `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V, G|…)` identification (equivalently: that the pushed/restricted injective resolution computes the *canonical* absolute affine cohomology that `affine_serre_vanishing` kills) is genuinely required by both consumers' proofs, and is deferred to "point of use" with a vague timeline. See finding.
- **Verdict**: CHALLENGE.

**Evidence (directly answering directive Q1).** Read the blueprinted consumer *proofs*, not just their statements:

- `open_immersion_pushforward_comp` proof part (1): "by the presheaf description … `R^q j_* H` is the sheafification of `V ↦ H^q(j⁻¹(V), H)`, and for affine V the preimage `j⁻¹(V)` is affine, on which the Serre vanishing of `affine_serre_vanishing` kills `H^q`." This invokes the **absolute** `H^q(j⁻¹V, H)` and feeds it to `affine_serre_vanishing` (whose LHS is the absolute `Hᵖ(U,F)`).
- `cech_term_pushforward_acyclic` proof: "the derived pushforward `R^k f_* G` is the sheaf associated to the presheaf `V ↦ H^k(f⁻¹(V), G|…)`, so it vanishes … iff that cohomology vanishes for all affine V," again applying `affine_serre_vanishing` to the absolute cohomology of the affine preimage.

The resolution form supplies `R^k f_* G ≅ sheafify(V ↦ Hᵏ((f_*I^•)(V)))`. To *conclude vanishing* the consumer must connect `Hᵏ((f_*I^•)(V))` to a statement `affine_serre_vanishing` can kill. `affine_serre_vanishing` as blueprinted kills the canonical absolute `Hᵖ(affine, qcoh)`. So the bridge `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V, G)` (or an equivalent resolution-internal restatement of `affine_serre_vanishing`) **is required downstream**. The re-sign therefore **defers a real obligation rather than eliminating it** — exactly the case the directive asked me to flag. The blueprint itself is honest about this (the lemma's prose explicitly says the identification "is supplied at point of use and is not part of this lemma's Lean content"); **STRATEGY.md is not** — its "need only … which the resolution form supplies directly" oversells the elimination.

## Format compliance

- **Size**: 137 lines / 12636 bytes — lines within budget, **bytes ~350 over** the ~12 KB guide.
- **Headings**: PASS — exactly `Goal, Phases & estimations, Completed, Routes, Open strategic questions, Mathlib gaps & new material`, canonical order.
- **Per-iter narrative detected**: yes (minor) — `## Open strategic questions` carries `(DECIDED iter-019)` and `(DECIDED, strategy-critic-confirmed)`; `## Phases & estimations` P5a row and `## Mathlib gaps` carry `iter-018` provenance in prose (`BUILT iter-018`, `DONE in resolution form (…, iter-018, axiom-clean)`). Bare iter numbers in prose outside the `## Completed` Iters cell are per-iter narrative.
- **Accumulation detected**: no — completed phases are in `## Completed`; no excised routes lingering.
- **Table discipline**: PASS — both tables well-formed, one-line cells.
- **Format verdict**: DRIFTED (trim ~350 bytes; strip the `iter-018`/`iter-019` prose tags — they add nothing the `## Completed` ledger doesn't already carry).

## Infrastructure-deferral findings

### Deferred: presheaf-resolution-homology ↔ canonical absolute affine-cohomology bridge (and the absolute `Hⁿ(open, F)` object backing `affine_serre_vanishing`)

- **Required by goal**: yes — the protected goal needs P5b, which needs `cech_term_pushforward_acyclic` (termwise `f_*`-acyclicity). That lemma's *proof* needs the bridge to connect the resolution-form presheaf homology to `affine_serre_vanishing`. And `affine_serre_vanishing`/`cech_to_cohomology_on_basis` are themselves stated with the absolute object `Hᵖ(U,F)`. The hardest prerequisite — a usable affine sheaf-cohomology-vanishing statement plus a bridge from the pushed-resolution presheaf homology to it — is the **same before and after the P5a re-sign**. The re-sign relocated it from the leaf to the consumers; it did not solve it.
- **Current plan for building it**: "supplied at point of use when those consumers are blueprinted." The Lean realization of the absolute object is undecided. Mathlib's `CategoryTheory.Sheaf.H` (AddCommGrp-valued, via `HasSheafify`+`HasExt`) is a concrete candidate via a forget functor — the strategy does not mention it, yet claims the object is a "fork, zero lemmas."
- **Timeline**: vague ("much later — gated on `affine_serre_vanishing`"); no iter estimate, no decomposition.
- **Verdict**: CHALLENGE — not REJECT. The goal is still provable and Route A is intact; but the strategy must (a) correct the P5a text to state the consumers additionally need the homology↔absolute-affine-vanishing bridge, and (b) decide and record *how* the absolute `Hⁿ(open, F)` vanishing is realized (forget-to-`AddCommGrp` + `Sheaf.H`, vs. a resolution-internal restatement of `affine_serre_vanishing` that makes the bridge a restriction-acyclicity lemma), with an iter/LOC estimate for that bridge. "Supplied at point of use" with no plan is an unresolved gap, not an accepted dependency.

## Alternative routes (suggested)

### Alternative: realize the absolute `Hⁿ(open, F)` via forget-to-AddCommGrp + `CategoryTheory.Sheaf.H`

- **What it looks like**: state `affine_serre_vanishing` and the consumers' absolute `Hᵏ(f⁻¹V, G)` through `(SheafOfModules → Sheaf J AddCommGrpCat).H k`, the existing Mathlib Ext-based sheaf cohomology, on the site of opens. The "last-mile identification" then becomes the standard "an injective resolution computes the derived functor," for which Mathlib has machinery.
- **Why it might be cheaper or sounder**: it gives the absolute object a *real* Lean home with lemmas (`instAddCommGroupH`, `cohomologyPresheafFunctor`, …), undercutting the "zero lemmas / fork to avoid" premise that motivated avoiding the absolute form. It may make the bridge a short comparison rather than a from-scratch construction.
- **What the current strategy may have rejected**: the strategy treats the *module-valued* `Hⁿ` as the only candidate and calls it absent; it does not consider forgetting to `AddCommGrp` where `Sheaf.H` already exists.
- **Severity of the omission**: major — it bears directly on whether the deferred bridge is cheap or a from-scratch brick.

## Must-fix-this-iter

- Route P5a re-sign: CHALLENGE — STRATEGY.md claims the consumers "need only the sheafify-of-presheaf-homology criterion, which the resolution form supplies directly." This is incomplete: both consumer proofs additionally require the `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V, G)` bridge to reach `affine_serre_vanishing`. Correct the text to state the deferred obligation explicitly, or record a rebuttal in `plan.md` showing the consumers close without it.
- Infrastructure-deferral CHALLENGE — the homology↔absolute-affine-vanishing bridge (and the Lean realization of the absolute `Hⁿ(open,F)` object that `affine_serre_vanishing` is stated with) is required by the goal, deferred to "point of use" with no plan/timeline. Decide the realization (forget-to-`AddCommGrp`+`Sheaf.H` vs. resolution-internal restatement) and add an iter/LOC estimate.
- Alternative (forget-to-AddCommGrp + `Sheaf.H`): major omission — evaluate it before reaffirming the "module-valued Hⁿ is absent, so avoid the absolute form" premise.
- Format: DRIFTED — trim ~350 bytes under 12 KB and strip `iter-018`/`iter-019` provenance tags from prose in `## Phases`, `## Open strategic questions`, and `## Mathlib gaps`.

## Overall verdict

Route A remains the correct global skeleton and the P3/P3b/P5a/P5b decomposition is still coherent — the re-sign of the P5a *leaf* to the resolution form is legitimate, correct, and already done. But **the strategy defers the `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V, G)` identification (and, behind it, the absolute affine sheaf-cohomology vanishing object), which is required for the stated goal** via the consumers `open_immersion_pushforward_comp` and `cech_term_pushforward_acyclic`, whose blueprinted proofs both invoke the absolute cohomology of the affine preimage and feed it to `affine_serre_vanishing`. The P5a re-sign relocates this obligation from the leaf to the consumers; it does not eliminate it, and STRATEGY.md's "need only the sheafify criterion, which the resolution form supplies directly" overstates what was achieved. This is a CHALLENGE, not a REJECT: fix the framing, decide how the absolute object is realized (the unexamined forget-to-`AddCommGrp` + `CategoryTheory.Sheaf.H` route looks materially cheaper than the "fork with zero lemmas" the strategy assumes), and attach a timeline to the bridge. Format is DRIFTED (marginally over 12 KB; iter-number prose).
