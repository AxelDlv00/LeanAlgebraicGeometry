# progress-critic directive — iter-237

Assess convergence per active route for the iter-237 prover assignment. Two routes.

## Route 1 — Picard group-law critical path (StalkTensor d.2 → whiskering wiring)

The d.2 stalk–tensor commutation isomorphism `PresheafOfModules.stalkTensorIso`
(`(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x`) is the long-standing bottleneck ingredient. Its
construction trajectory (file `Picard/TensorObjSubstrate/StalkTensor.lean`):

- iter-233: forward comparison map + germ chars — 7 axiom-clean decls. sorry 0→0.
- iter-234: R_x-linear packaging (`stalkTensorLinearMap`) — 4 decls. sorry 0→0.
- iter-235: nested reverse double-colimit descent — 10 decls. sorry 0→0.
- iter-236: balancing + reverse map + **the iso `stalkTensorIso` ASSEMBLED** — 6 decls,
  axiom-clean `{propext,Classical.choice,Quot.sound}`. sorry 0→0. **INGREDIENT COMPLETE.**

The d.2 ingredient is now DONE. The iter-237 proposal is a FRESH sub-lane (0 prior
attempts on this specific work): wire `stalkTensorIso` into the associator's single open
obligation `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (file
`Picard/TensorObjSubstrate/Vestigial.lean`, currently 1 `sorry` at its body). This needs
two new ingredients: (a) a "d.1-bridge" `J.W g → ∀x, IsIso(stalk map)` on the topological
site `Opens X` (Mathlib supplies the pieces: `app_injective_iff_stalkFunctor_map_injective`,
`isIso_iff_stalkFunctor_map_iso`); (b) B-argument naturality of `stalkTensorIso`. Closing
this lemma makes `tensorObj_assoc_iso` sorry-free → the by-hand `CommGroup` `thm:pic_commgroup`.

Recurring-blocker phrase across 233–236: "carrier-duality wall (CommRingCat vs RingCat)" —
RESOLVED each iter (each time named + retired with a reusable recipe).

STRATEGY row: A.1.c.SubT — Iters left ~4–7; the d.2 sub-phase was entered ~iter-232 (≈5 iters
elapsed) and just terminated in the deliverable iter-236.

QUESTION: is the d.2→whiskering-wiring transition a healthy convergent continuation, or does
the fresh Vestigial sub-lane risk re-opening an open-ended stalk-infrastructure build? Is the
fact that the absolute critical-path sorry counter has not dropped since iter-217 a churn
signal, or a genuine multi-iter infrastructure-build now reaching its consumer?

## Route 2 — A.2.c engine (FlatBaseChange)

File `Cohomology/FlatBaseChange.lean`. Target: the Mathlib-absent brick
`pushforward_spec_tilde_iso` (object iso `(Spec φ)_*(M~) ≅ (restrictScalars φ M)~`), then
`affineBaseChange_pushforward_iso`.

- iter-234: 0 decls committed (typeclass-instance wall on the Γ-fragment). sorry 2→2.
- iter-235: 0 decls (declared STUCK; corrective = a read-only Mathlib-idiom consult, no prover). sorry 2→2.
- iter-236: **3 axiom-clean decls** (`globalSectionsIso_hom_comp_specMap_appTop`,
  `gammaPushforwardIso`, `gammaPushforwardTildeIso`) — the Γ-fragment wall RESOLVED via an
  element-free route. sorry 2→2 (brick not yet assembled; reduced to one named obligation =
  quasi-coherence of the pushforward, with 3 concrete attack routes documented).
- iter-237 proposal: build `pushforward_spec_tilde_iso` via route (iii) — basic-open locality
  (`isIso_of_isIso_app_of_isBasis`, already in-file) + `IsLocalizedModule` — which yields the
  object iso AND quasi-coherence simultaneously; then close `affineBaseChange_pushforward_iso`.

Recurring-blocker phrase 234–235: "carrier wall / not synthesizable"; RESOLVED iter-236.

STRATEGY row: A.2.c-engine — Iters left ~30–60; this is the first ungated engine sub-lane,
seeded ~iter-233.

QUESTION: after the iter-235 STUCK → iter-236 recovery (3 axiom-clean decls), is FlatBaseChange
now CONVERGING, or is the zero-sorry-elimination across 234–237 a continued stall?

## This iter's PROGRESS.md `## Current Objectives` proposal (file count + basenames)

2 files: `Vestigial.lean` (critical-path wiring, mathlib-build), `FlatBaseChange.lean`
(engine brick, mathlib-build).
