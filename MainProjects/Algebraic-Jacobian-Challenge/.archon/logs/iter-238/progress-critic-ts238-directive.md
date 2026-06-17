# progress-critic ts238 directive

Assess convergence of the two active prover routes. Two route blocks below, each with the
last K=4–5 iters' extracted signals, the strategy's current Iters-left, the iter the route
entered its current phase, and this iter's proposed objective.

## Route 1 — group-law critical path (`Picard/TensorObjSubstrate.lean` + split sub-files)

The relative Picard group law (carrier = tensor-invertibility `IsInvertible`). The d.2 stalk–tensor
commutation ingredient (`stalkTensorIso`) and the associator whiskering obligation are now both CLOSED.

Signals (per iter):
- iter-234: StalkTensor d.2 stage (iii) — `stalkTensorLinearMap` + helpers, axiom-clean. 0 canonical
  sorry-elimination (this was zero-sorry infrastructure by design). Status: COMPLETE (named stage).
- iter-235: StalkTensor d.2 stage (iv) reverse descent — 10 axiom-clean decls. 0 sorry-elim (infra).
  Status: COMPLETE (named stage).
- iter-236: StalkTensor `stalkTensorIso` ASSEMBLED — 6 axiom-clean decls. 0 sorry-elim (infra).
  Status: COMPLETE (the d.2 INGREDIENT is done).
- iter-237: Vestigial.lean whiskering sorry `isLocallyInjective_whiskerLeft_of_W` CLOSED (file sorry
  1→0); 6 axiom-clean decls; downstream `tensorObj_assoc_iso` now sorry-free + axiom-clean. Status:
  COMPLETE (objective fully met). Canonical TensorObjSubstrate sorries (L695 dual-bridge / L760
  consumer) unchanged — those are off this critical path.
- iter-238 PROPOSED: build the by-hand group law — `tensorObj_assoc_iso_invertible` (corollary of the
  now-unconditional associator; drop the vestigial `IsLocallyTrivial` hyps from `tensorObj_assoc_iso`),
  `PicGroup` (quotient carrier), `IsInvertible.tensorObj`, `isInvertible_unit`,
  `IsInvertible.inverse_unique`, `picCommGroup` (the `CommGroup`). FRESH sub-step — 0 prior attempts.
  Blueprint fully written (`thm:pic_commgroup` + 5 dep blocks). Ingredients (unitors, braiding,
  associator) all axiom-clean. [prover-mode: mathlib-build]

Strategy: A.1.c.SubT Iters-left = ~3–5. The d.2 sub-arc entered at iter-232 (carrier pivot); the
group-law assembly sub-step is brand new this iter.

Recurring blocker phrases across 234–237: "carrier-duality wall" (CommRingCat/RingCat on section
tensors) — RESOLVED each iter by a documented recipe; never recurred unresolved.

## Route 2 — engine `Cohomology/FlatBaseChange.lean` [mathlib-build]

i=0 flat base change (Stacks 02KH). The unconditional brick `pushforward_spec_tilde_iso` reduces
`affineBaseChange_pushforward_iso`.

Signals (per iter):
- iter-234: zero-commit; blocked on a Γ-fragment typeclass-instance wall.
- iter-235: no prover (STUCK corrective = mathlib-analogist consult; soundness fix + reframe).
- iter-236: 3 axiom-clean Γ-fragment decls (`gammaPushforwardIso`, `gammaPushforwardTildeIso`,
  `globalSectionsIso_hom_comp_specMap_appTop`); brick NOT assembled. File sorry 2→2.
- iter-237: 3 axiom-clean route-iii decls (`IsLocalizedModule.powers_restrictScalars`,
  `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`);
  unconditional brick reduced to ONE named obligation `hloc` (an `IsLocalizedModule` instance on the
  pushforward sections over `D(a)`). File sorry 2→2. The iter-237 plan made closing
  `affineBaseChange_pushforward_iso` a HARD commitment with the recorded reversing signal "STUCK
  re-fires with no further reprieve if not met." It was NOT met (brick still conditional; the deep
  `affineBaseChange_pushforward_iso` sorry untouched).
- Recurring blocker phrase: the "structure-sheaf smul carrier wall" — the `R`-action on pushforward
  sections is built through the global ring (`modulesSpecToSheaf`), so `a •_R x = φ(a) •_{R'} x` does
  not synthesize at the section level. Hit at `⊤` (iter-234/236, resolved element-free) and now at
  `D(a)` (iter-237, open). The prover's recommended next route: element-free `D(a)`-level transport
  mirroring the already-built `gammaPushforwardIso` (build `e_{D(a)}` linear equiv + a `D(a)`-level
  ring equation), feed as `hloc`.

Strategy: A.2.c-engine Iters-left = ~30–60 (parallel/de-gated; NOT the primary critical path).
FlatBaseChange seeded iter ~233; on its current route-iii approach since iter-236 (post STUCK reset).

## What I need from you

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the named corrective TYPE for any
CHURNING/STUCK. Specifically:
- Route 1: is the group-law assembly a sound next unit, or is there a churn risk I am missing?
- Route 2: given real structural advance (3 axiom-clean decls reducing to one named fact) BUT a
  missed hard commitment and a recurring smul wall now at its 3rd location — is this STUCK (pivot /
  defer / analogist consult) or does the genuine reduction warrant one more disciplined dispatch on
  the new, smaller, concrete target? Name the corrective.
