# Strategy Critic Report

## Slug
iter024

## Iteration
024

## Process note — the directive's pasted STRATEGY.md was STALE

The "STRATEGY.md (verbatim)" reproduced in my directive does **not** match the on-disk
`STRATEGY.md`. The pasted copy is an older snapshot (GF-alg still ACTIVE with an "L4 leaf @754",
no `## Completed` section, FBC `gstar_transpose` described via different lemma names, and two
extra trailing sections `## References index` / `## Blueprint chapter index`). The live file
(`/home/archon/proj/Quot-Foundations/STRATEGY.md`, 136 lines) has GF-alg DONE and moved to
`## Completed`, GF-geo now ACTIVE, the QUOT-S1 Serre concern surfaced as a gated open question,
and clean canonical headings with no trailing index sections.

I audited the **live on-disk file**, since critiquing a stale snapshot would be useless. The
planner should ensure the directive-builder pastes the current file next iter; several of the
"stale" worries (format drift, missing `## Completed`, unsurfaced Serre risk) are already fixed
in the live file, and I do not flag them.

## Routes audited

### Route: FBC

- **Goal-alignment**: PASS — direct-on-sections affine lemma + Čech-free H⁰-equalizer globalization fills exactly `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PASS — Stacks 02KH(2) is the right source; reducing affine base change to `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (DONE, axiom-clean) is correct, and a flat `−⊗B` preserving the finite degree-0/1 sheaf-condition equalizer (`Module.Flat.{ker,eqLocus}_lTensor_eq`, verified present) is the standard H⁰-only globalization.
- **Effort honesty**: reasonable — FBC-A 1–2 iters for a 5-lemma counit-coherence chain (regroup done, `inner_eCancel` telescoping flagged as the hard piece); FBC-B hedged correctly as the equalizer half being Mathlib-backed.
- **Verdict**: SOUND. The dead `fstar_reindex` apparatus was *removed*, not preserved — the opposite of sunk cost — and the canonical-map-vs-∃-iso question carries a concrete ≥2-iter stall tripwire.

### Route: GF (geometric `genericFlatness`)

- **Goal-alignment**: PASS — wraps the now-DONE `genericFlatnessAlgebraic` via affine cover; produces the goal node `thm:generic_flatness`.
- **Mathematical soundness**: PASS — pass to affine `Spec A ⊆ S`, cover the preimage by finite-type affines `W_j = Spec B_j`, apply the algebraic core per patch, take the common basic open `D(∏ f_j)`, conclude via flat-at-every-maximal (`Module.flat_of_isLocalized_maximal`, VERIFIED). This is the standard Mathlib-aligned path (Stacks 052B); there is no cleaner route — the one genuinely-missing piece (sections → finite module) is unavoidable in any approach.
- **Effort honesty**: **UNDER-COUNTED**. The row estimates 1–2 iters / ~40–120 LOC with only a "may expand" hedge, but the directive itself reports GF-geo "deeper than estimated (two genuine missing-Mathlib bridges G1/G3)". I confirmed the depth: `SheafOfModules.IsQuasicoherent` in the pinned Mathlib is the abstract site-theoretic `QuasicoherentData` predicate, and there is **no** upstream lemma delivering "IsQuasicoherent + IsFiniteType ⟹ Γ(F,W_j) is a finite B_j-module". The project is already building that bridge itself (`tildeRestriction_isLocalizedModule`, `isIso_fromTildeΓ_of_isQuasicoherent`), which is real plumbing — 40–120 LOC is optimistic.
- **Missing-hypothesis risk**: the route assumes "a non-empty affine open `Spec A ⊆ S` (A a noetherian domain)", i.e. it silently needs **S integral (or irreducible + reduced)**. Generic flatness is false over a non-reduced/reducible base. If the parent-frozen re-signed `genericFlatness` signature lacks a base-integrality/irreducibility hypothesis matching the algebraic core's "A a domain", the statement is unprovable as stated. This must be checked as part of the merge-back signature audit (the current "Merge-back signature check" open question does not call it out).
- **Verdict**: CHALLENGE — sound route, but (i) update the GF-geo estimate to reflect the qcoh→finite-module bridge depth and name G1/G3 explicitly in `## Mathlib gaps` (currently lumped as "finite-module plumbing … may expand"; the blueprint uses the G1/G3 labels but STRATEGY.md does not — a traceability gap), and (ii) confirm the base-integrality hypothesis is present in the re-signed signature.

### Route: QUOT (defs + SNAP + GR-*)

- **Goal-alignment**: PARTIAL — the def/predicate/Grassmannian decomposition fills all four QUOT stubs, BUT see the canonicity gap below: `def:quot_functor` stratifies flat families by Hilbert polynomial, so Φ_s **must** be a canonical invariant of `F`, and canonicity is not yet established.
- **Mathematical soundness**: PARTIAL — the graded-Hilbert-function encoding is the right call (it costs strictly *less* cohomology than the cohomological-χ encoding, which would need all Hⁱ); S2 rationality (`gradedModule_hilbertSeries_rational`) landed axiom-clean; S3 extraction (`Polynomial.existsUnique_hilbertPoly`, VERIFIED) is mechanical; the GR-cells/glue/quot/repr split matches Nitsure §5 and GR-cells is DONE. The soundness gap is concentrated entirely in the S1 / canonicity question below.
- **Sunk-cost reasoning**: no — the χ→graded pivot genuinely *reduced* the hardest prerequisite (all-Hⁱ coherent cohomology → S2 rationality, now done + a residual m≫0 agreement), so it is not a problem-renaming pivot.
- **Verdict**: SOUND-with-gate. The strategy has already self-surfaced the central risk (good), but the gate's *resolution* is unplanned (see infrastructure-deferral finding) and the `## Goal` "Čech-independent leg" framing is not yet reconciled with the admitted Serre requirement.

## Format compliance

- **Size**: 136 lines / ~9 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order. (The stale directive copy's trailing `## References index` / `## Blueprint chapter index` sections are NOT in the live file.)
- **Per-iter narrative detected**: yes (minor) — the Routes prose carries `**DONE iter-020, axiom-clean**`; bare iter numbers belong in the `## Completed` ledger, not Routes prose. Cosmetic; downgrade to "DONE, axiom-clean".
- **Accumulation detected**: no — GF-alg correctly moved to `## Completed`; the Completed table is 7 rows (within bound).
- **Table discipline**: PASS — both tables carry the canonical columns; cells are dense but single-line.
- **Format verdict**: COMPLIANT (one minor narrative phrase to scrub).

## Infrastructure-deferral findings

### Deferred: QUOT Hilbert-polynomial canonicity / Serre `m≫0` agreement

- **Required by goal**: yes. `def:quot_functor` parametrizes quotients by a *fixed* Hilbert polynomial, so Φ_s must be intrinsic to the sheaf. The strategy's primary S1 route (pick a f.g. graded presentation `M` with `F = M̃`) gets finite generation for free, but independence of Φ_s from the chosen `M` requires the comparison `M_m ≅ Γ(X_s, M̃(m))` for `m≫0` (Serre). That comparison is classically proved via local cohomology `H^{0,1}_{S_+}` or the Čech complex of the `D_+(x_i)` cover — i.e. it genuinely brushes against the cohomology the "Čech-independent leg" identity is meant to exclude. The strategy itself now states the sublane is "NOT unconditionally Čech-independent" and that the "Hartshorne II.5.17" attribution is "likely wrong".
- **Current plan for building it**: gated — "Resolve before building S1: confirm whether the parent cone needs Φ canonical, and produce/cite an *exact* result." This is a decision to make, not a build plan; no project lemma label, no iter estimate, no Čech-status determination.
- **Timeline**: vague — bundled into SNAP-S1/S3 (NEXT, 3–6 iters) behind a gate with no separate estimate.
- **Verdict**: CHALLENGE — the planner must, before any S1 prover dispatch, (a) confirm Φ-canonicity is required (it is, given Quot stratifies by Φ), (b) name the *exact* Serre comparison theorem and a project lemma label with an iter estimate, and (c) determine whether that comparison is genuinely Čech/cohomology-free — and if not, soften the `## Goal` "Čech-independent leg" claim so the project's stated identity matches reality.

## Sunk-cost flags

(omitted — none detected; the FBC dead-code removal and the χ→graded pivot both reduce, rather than preserve, prior investment)

## Prerequisite verification

- `Module.Flat.ker_lTensor_eq`: VERIFIED (Mathlib.RingTheory.Flat.Equalizer)
- `LinearMap.tensorEqLocusEquiv`: VERIFIED (same file; strategy's bare `tensorEqLocusEquiv`)
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (Mathlib.RingTheory.Polynomial.HilbertPoly)
- `Adjunction.homEquiv_counit`: VERIFIED
- `cancelBaseChange` (`Algebra.TensorProduct` / `TensorProduct.AlgebraTensorModule` / `Algebra.IsPushout`): VERIFIED
- `IsIntegral.exists_multiple_integral_of_isLocalization`: VERIFIED
- `Algebra.finite_adjoin_of_finite_of_isIntegral`: VERIFIED
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`: VERIFIED (note: its motive fixes the base ring A — consistent with the strategy's "the variable-count recursion needs its own base-domain-generalizing induction", which is a *separate* principle, not this one)
- `Submodule.isQuotientEquivQuotientPrime_iff`: VERIFIED
- `Module.flat_of_isLocalized_maximal`: VERIFIED (GF-geo flat-at-maximal criterion)
- `CategoryTheory.Functor.IsRepresentable` / `RepresentableBy` / `representableByEquiv`: VERIFIED (GR-repr)
- `Scheme.Modules.pullback` + `pullbackPushforwardAdjunction`: VERIFIED (QUOT-defs)
- `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank`: project-built (drafted in QuotScheme.lean) — P2 is real project infra in progress, NOT a phantom Mathlib dependency. Note `SheafOfModules.IsLocallyFree` does NOT exist upstream, so P2 builds the base local-freeness notion itself, not merely a rank tag — a point worth keeping in the P2 effort estimate.

## Must-fix-this-iter

- Route GF: CHALLENGE — re-estimate GF-geo (the qcoh+finite-type ⟹ finite-module-of-sections bridge is genuinely missing from Mathlib and is real project plumbing; 1–2 iters / 40–120 LOC is optimistic); name the G1/G3 bridges explicitly in `## Mathlib gaps`; and confirm the re-signed `genericFlatness` carries a base integral/irreducible-reduced hypothesis (else the statement is false as stated).
- QUOT canonicity: infrastructure-deferral CHALLENGE — the Serre `m≫0` agreement is goal-required (Quot stratifies by Φ) yet has no exact reference, no project lemma label, no iter estimate, and an undetermined Čech-status. Resolve (or confirm-not-needed) before any S1 prover, and reconcile the `## Goal` "Čech-independent leg" framing with the outcome.
- Format: COMPLIANT — scrub the single `iter-020` narrative phrase from the Routes prose (cosmetic).

## Overall verdict

The arc is sound and the route decomposition is correct on every leaf: FBC's direct-on-sections +
Čech-free equalizer globalization, GF's affine-cover wrapper over the now-DONE algebraic core, and
QUOT's graded-Hilbert-function encoding (which costs strictly less cohomology than the χ encoding it
replaced). No route should be dropped or merged, and prerequisite verification came back clean across
~15 named Mathlib decls. Two issues must be addressed this iter. First, **GF-geo's effort estimate
is under-counted**: the directive correctly reports it is deeper than the table claims, because the
"Γ(F,W_j) is a finite B_j-module" bridge (the G1/G3 content) is genuinely absent from Mathlib and is
real project plumbing the strategy under-prices at 1–2 iters / 40–120 LOC; the strategy should also
verify the geometric `genericFlatness` carries a base-integrality hypothesis. Second, **the strategy
defers the QUOT Hilbert-polynomial canonicity / Serre `m≫0` agreement**, which is required for the
stated goal because `def:quot_functor` stratifies by Hilbert polynomial — it is gated (good) but its
resolution is unplanned, lacks an exact reference, and its Čech-status is undetermined, which directly
puts the project's "Čech-independent leg" identity in question for the QUOT lane. Both are CHALLENGE,
not REJECT: the routes are right, the gaps are honest-but-under-specified, and the planner must
either build/cost them this iter or record a concrete plan with iter estimates.
