# Progress-critic directive — pc253

Assess convergence of the two active parallel prover lanes over the last K=4 iters. Verdict per route.
Context is signals only (no strategy, no blueprint, no math-correctness questions).

## Route 1 — Lane TS-cmp — `Picard/TensorObjSubstrate.lean`
Target chain: D1′ (`pullbackTensorMap_natural`) → D3′ (`pullbackTensorMap_restrict`) → D4′
(`pullbackTensorIsoOfLocallyTrivial`). The substrate ⊗-pullback comparison-iso lane.

Signals (sorry count = in-file typed sorries; one is the long-standing untouched `exists_tensorObj_inverse`):
- iter-249: sorry 2→2. PARTIAL. Assembled the D2′ mate-calculus telescope into one compiling proof;
  one concrete `(∗∗)` residual remained. Blocker phrase: `.val`/forget₂-carrier `rw [Category.assoc]`
  silent-match failure.
- iter-250: sorry 2→1. **COMPLETE on D2′** — `pullbackTensorMap_unit_isIso` CLOSED axiom-clean (the
  `(∗∗)` residual eliminated; first canonical critical-path sorry-elimination of the route). 3 feeder
  lemmas landed.
- iter-251: sorry 1→3. PARTIAL. 2 new CLOSED axiom-clean lemmas (`pullbackValIso_hom_natural`,
  `sheafifyTensorUnitIso_hom_eq := rfl`); D1′ `pullbackTensorMap_natural` AUTHORED, reduced to ONE
  whisker residual in helper `sheafifyTensorUnitIso_hom_natural`. (+2 sorries are honest typed: the
  authored D1′ + its helper.) Blocker phrase: `.val`/forget₂-carrier whisker-instance split.
- iter-252: sorry 3→3. PARTIAL. The whisker route was DISPROVED by direct testing (the armed
  analogist `letI` recipe failed exactly as the reversing-signal predicted); the prover then pivoted
  to a section-level descent and reduced `sheafifyTensorUnitIso_hom_natural` to a single
  **instance-free element-level `TensorProduct.induction_on` residual** ("no instance war left;
  mechanical η-naturality bookkeeping remains"). Blocker phrase resolved at the structural level
  (carrier friction dissolved by going to elements); residual is now mechanical.

Helpers added per iter: iter-249 (telescope steps, no new named close), iter-250 (+3 closed),
iter-251 (+2 closed), iter-252 (+0 closed but the target's sorry was structurally reduced, route changed).
Recurring blocker phrase across the window: `.val` vs `_ ⋙ forget₂ CommRingCat RingCat` carrier-spelling
defeq friction (manifests as whisker-instance split / `rw` motive failure).
Strategy Iters-left for this phase (A.1.c.sub): ~6–11. Phase entered ACTIVE around iter-233; D2′ closed iter-250.

## Route 2 — Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`
Target chain: `homOfLocalCompat` (A-bridge) + `dual_restrict_iso` Step-4 (C-bridge) →
`exists_tensorObj_inverse`. The dual-inverse chain (RPF group inverse).

Signals:
- iter-251: sorry 3→2. PARTIAL (fresh file, opened iter-251). 4 new CLOSED axiom-clean decls
  (dual-unit leg: `unitDualSectionEquiv`/`dualUnitIsoGen`/`presheafDualUnitIso`/`dual_unit_iso`);
  `dual_restrict_iso` advanced to a Step-4 residual; `homOfLocalCompat` not started. Blocker phrase:
  restrict/image carrier-friction (same family as Route 1).
- iter-252: sorry 2→2. PARTIAL. `homLocalSection` CLOSED axiom-clean (the load-bearing local-section
  sub-lemma incl. its hard naturality field, beating the restrict/image carrier-friction wall);
  `homOfLocalCompat` reduced from bare sorry → compiling scaffold + one bounded sorry (gluing
  bookkeeping: IsCompatible-from-HEq, section→morphism, linearity). `dual_restrict_iso` Step-4
  untouched (budget consumed by homLocalSection). Blocker phrase: restrict/image carrier-friction.

Helpers added per iter: iter-251 (+4 closed), iter-252 (+1 closed). Recurring blocker phrase:
restrict/image (`M.val.presheaf` image-form vs `(M.restrict ι).val.presheaf` restrict-form) defeq
friction. Strategy Iters-left: part of A.1.c.sub (~6–11). Phase entered iter-251 (2 iters of data).

## This iter's proposed objectives (dispatch-sanity check)
- M=2, two files, same as last 2 iters:
  1. `Picard/TensorObjSubstrate.lean` — close Step-A element-level residual
     (`sheafifyTensorUnitIso_hom_natural`) → assemble D1′ `pullbackTensorMap_natural` → attempt
     D3′/D4′. Armed by: the in-file documented element-level recipe + a blueprint-writer correction
     of the D1′ sketch (the disproven whisker prose is being replaced this iter).
  2. `Picard/TensorObjSubstrate/DualInverse.lean` — close `homOfLocalCompat` (a)/(b)/(c) gluing
     bookkeeping (now blueprint-armed on the HEq→IsCompatible bridge) → attempt `dual_restrict_iso`
     Step-4 (inverse-uniqueness shortcut OR legs A+B).

## Questions for you
1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) over the K=4 window.
2. For Route 1: is reducing the D1′ helper to an instance-free element-level residual (after
   disproving the prior whisker approach) genuine convergence, or is the flat sorry count (1→3→3
   since the D2′ close) a churn signal? Name the corrective TYPE if CHURNING/STUCK.
3. Dispatch-sanity on the M=2 proposal: is two files right, or should one be dropped / a third added?
