# Progress-critic directive — iter-255

Assess convergence of the two ACTIVE parallel prover routes. K = last 4 iters (251–254).
Verdict per route + name the corrective TYPE for any CHURNING/STUCK.

## Route 1 — TS-cmp : `Picard/TensorObjSubstrate.lean` (target = D1′ `pullbackTensorMap_natural`)

Phase A.1.c.sub; entered ~iter 233 (carrier pivot). STRATEGY `Iters left` for A.1.c.sub = ~4–8.

Per-iter signals:
- iter-251: file sorry 1→3 (authored D1′ `pullbackTensorMap_natural` + helpers). Status PARTIAL.
- iter-252: sorry 3→3. STEP-A helper `sheafifyTensorUnitIso_hom_natural` reduced to an instance-free
  element-level residual; disproved the armed whisker route. Status PARTIAL.
- iter-253: sorry 3→3. STEP-A armed reversing signal fired NEGATIVE across 3 approaches
  (element-descent / whisker-calculus whnf-timeout / uniform-instance-helper synth-fail). STEP-B
  Square-1 closed. Status PARTIAL/BLOCKED.
- iter-254: sorry 3→2. **STEP A `sheafifyTensorUnitIso_hom_natural` CLOSED axiom-clean** (the 5-iter
  wall fell, via a `tensorHom`-PIN term-level device). D1′ target `pullbackTensorMap_natural` still a
  sorry — STEP-B blocked on `δ_natural` failing to synthesize `MonoidalCategory` on the
  `X.ringCatSheaf.obj` domain-ring spelling (instance registered only on the defeq canonical
  `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling). Named structural blocker → planner.
- Recurring blocker phrase across 251–254: the `restrictScalars(𝟙)`/forget₂ carrier-spelling friction
  — "two defeq monoidal instances", culminating in the `δ_natural` spelling-synthesis failure.
- Helpers added: iter-251 several; iter-252 1; iter-254 1 (`sheafifyTensorUnitIso_hom_eq'`).

Note: target `pullbackTensorMap_natural` (D1′) has NOT closed in 4 iters; STEP-A (its blocking helper)
DID close iter-254 axiom-clean. The remaining blocker is a NAMED carrier-spelling synthesis failure
for which the planner is deciding between a LIGHT fix (local def-retype / proof-side `change`
normalisation) and a STRUCTURAL refactor — a mathlib-analogist consult is dispatched this iter to
determine which.

## Route 2 — TS-inv : `Picard/TensorObjSubstrate/DualInverse.lean` (target = `homOfLocalCompat`)

Phase A.1.c.sub (same). STRATEGY `Iters left` for A.1.c.sub = ~4–8.

Per-iter signals:
- iter-251: 4 helper lemmas CLOSED + `dual_isLocallyTrivial` assembled; file sorry 3→2.
- iter-252: `homLocalSection` CLOSED axiom-clean (load-bearing localSection incl. naturality);
  `homOfLocalCompat` → compiling scaffold; sorry 2→2.
- iter-253: `homOfLocalCompat` sub-step (b) CLOSED (+2 helpers `topSectionToHom`); sub-step (a)
  blocked on an `hf : HEq` signature believed protected. sorry 2→2 (internal 2→2).
- iter-254: `hf` re-signed HEq→sectionwise (legal, not protected); sub-step (a) `IsCompatible`
  CLOSED; sub-step (c) `𝒪_X`-linearity ~90% built; **SOLE residual** = one isolated open-immersion
  ring-bridge / carrier-duality sorry (L636). sorry 2→2 (internal `homOfLocalCompat` 2→1).
- Recurring blocker phrase: carrier-duality ring-bridge — "RingCat (U i) vs X action on a defeq carrier."
- Helpers added: iter-251 ~4; iter-252 1; iter-253 2; iter-254 1 (`image_preimage_of_le`).

Note: target `homOfLocalCompat` is now down to ONE isolated sorry with a fully-mapped inline route
(prove `r •_X z = (appIso.hom r) •_{Ui} z` then `map_smul` then reconcile transported scalars).

## This iter's PROGRESS.md `## Current Objectives` proposal (for dispatch-sanity)

- Lane TS-inv (`DualInverse.lean`): DEFINITE — prover to close the single isolated ring-bridge sorry
  (precise inline handoff from iter-254). [prove]
- Lane TS-cmp (`TensorObjSubstrate.lean`): CONDITIONAL on the mathlib-analogist consult dispatched this
  iter — if the δ_natural spelling fix is LIGHT (def-retype/proof `change`), a prover lane closes D1′;
  if STRUCTURAL, a refactor subagent runs and the D1′ prover defers to iter-256 (→ M=1 this iter).

Question for you: for EACH route — CONVERGING / CHURNING / STUCK / UNCLEAR, with the corrective TYPE.
In particular: is Route 1 (4 iters, target not closed, but its 5-iter blocking helper fell iter-254 and
the residual is now a single named carrier-spelling synthesis failure) STUCK, CHURNING, or CONVERGING?
And is the M=1-fallback (close TS-inv this iter, defer D1′ to a refactor) a sound dispatch shape?
