# Progress-critic directive — iter-058

Assess convergence of the three active prover routes. Each block gives the last 3–4 iters'
signals (sorry counts, axiom-clean helpers added, prover status, recurring blocker phrases),
the strategy's current Iters-left estimate, and the iter the route entered its current phase.

Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR, with the corrective TYPE if not
CONVERGING.

---

## Route 1 — Need#2 affine Serre vanishing seed + consumer (`CechAcyclic.lean` → `AffineSerreVanishing.lean`)

- Strategy phase: "P5a-consumer", Iters-left estimate ~3–6; route entered current (seed) phase iter-056.
- iter-056 (PARTIAL): `AffineSerreVanishing.lean` +7 axiom-clean decls (`affineCoverSystemGeneral` +
  cofinality/surjectivity generalizations + reduction tops); reduced general-affine Serre vanishing
  end-to-end to ONE isolated hypothesis `htilde` (the change-of-ring section Čech seed). sorry 0→0.
- iter-057 (PARTIAL): `CechAcyclic.lean` +6 axiom-clean decls; the seed
  `sectionCech_homology_exact_of_affineOpen` (route B1, base-change to S=Γ(V) via M⊗_R S) **fully
  built in one iter** — discharges `htilde` verbatim. sorry 1→1 (unchanged; lone sorry is the
  pre-existing dead `affine` stub, out of scope). No blocker phrases; analogist-scoped route B1
  worked as predicted (the flagged IsScalarTower/semiring-diamond risk did NOT materialize).
- iter-058 proposed objective: `AffineSerreVanishing.lean` — scaffold+prove the ~10-LOC consumer
  `affine_tildeVanishing_general` + `affine_serre_vanishing_general_open` (mirror the done `_of_localizationAway`
  consumer, swap to `_of_affineOpen`). Closes Need#2 end-to-end.

## Route 2 — Sub-brick A / Stub 1 (`CechSectionIdentification.lean`)

- Strategy phase: "P5a-resolution", Iters-left estimate ~4–8; route entered current (Stub) phase iter-055.
- iter-055: scaffolded 6 stubs (file shipped RED, fixed iter-056 planner phase).
- iter-056 (PARTIAL): closed Stub 3 (`pushPull_leg_sections`); disproved Stubs 5/6 (consumer needs the
  AUGMENTED complex; airtight counterexample). sorry 6→5.
- iter-057 (PARTIAL): Stub 1 — +6 axiom-clean decls (2 mechanical sub-lemmas `widePullback_openImm_inter`,
  `cechBackbone_obj_widePullback` + the coproduct-in-Over-X leaf `coverArrowOverSigmaIso` + 3 helpers).
  Deferred the hard `coproduct_distrib_fibrePower` (wide extensivity, scoped 120–200 LOC / 2–3 cycles —
  NOT stubbed, per mathlib-build). sorry 5→5. Recurring blocker phrase: "missing-Mathlib scheme
  coproduct/fibre-product distribution" (corrected iter-057 analogist: only the WIDE case is a genuine
  gap; `Scheme` IS `FinitaryExtensive` for the binary case).
- iter-058 proposed objective: `CechSectionIdentification.lean` — `coproduct_distrib_fibrePower` (the hard
  wide-extensivity induction) + `widePullback_overX_eq_prod` + assemble `cechBackbone_left_sigma` (Stub 1).

## Route 3 — Need#1 Ext-transport (`OpenImmersionPushforward.lean`)

- Strategy phase: "P5a-consumer" (Need#1 half), Iters-left estimate ~3–6; entered current phase iter-054.
- iter-054/055: corepresentability `sectionsFunctorCorepIso` + `rightDerivedNatIso` reduction (geometry-free
  residual reshape). 
- iter-057 (PARTIAL): +4 axiom-clean decls — `pushforwardEquivOfIso` (module-cat equivalence along a scheme
  iso) + `pushforwardExtAddEquiv` + `modulesIsoSpecExtTransport` (the Ext-transport core, via
  `mapExt_bijective_of_preservesInjectiveObjects`). sorry 2→2 (the `_acyclic`/`_comp` assembly sorries,
  unchanged). Blocker phrase: residual = "jShriekOU naturality under a scheme iso" (commuting pushforward
  with the free/sheafification adjunction + yoneda transport across the homeomorphism) — flagged as the
  dominant multi-iter wall; plus qcoh-preservation-under-pushforward-iso (medium).
- iter-058 proposed objective: `OpenImmersionPushforward.lean` — build the jShriekOU scheme-iso transport +
  qcoh-preservation infrastructure (mathlib-build). [Gated on a fresh blueprint decomposition this iter;
  may defer if the blueprint block doesn't clear.]

---

## iter-058 PROGRESS.md `## Current Objectives` proposal (file count + basenames)

3 prover lanes (≤3 files): `AffineSerreVanishing.lean`, `CechSectionIdentification.lean`,
`OpenImmersionPushforward.lean`. Each is a continuation of the route above.

Question for you: is any route CHURNING (helpers accumulate, residual unmoved) or STUCK
(no sorry-elimination / structural advance in K iters)? Note that Routes 1–3 all add axiom-clean
helpers BELOW the assembly-site sorries, so raw sorry count is stable by design — judge structural
advance, not sorry delta.
