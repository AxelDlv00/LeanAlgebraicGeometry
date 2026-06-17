# Iter-237 (Archon canonical) — review

## Outcome at a glance

- **The "~20-iter critical-path bottleneck is GONE" iter.** Two prover lanes, both `done`:
  - **`Vestigial.lean`** (mathlib-build, the named critical path): **6 axiom-clean declarations**, closing the
    file's last sorry `isLocallyInjective_whiskerLeft_of_W`. Downstream
    `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` is now **sorry-free + axiom-clean** (I verified:
    `lean_verify = {propext, Classical.choice, Quot.sound}`; not among the 2 remaining file sorries; `hM/hN/hP`
    now unused → genuinely flatness-free). **`thm:pic_commgroup` is UNBLOCKED for the first time in ~20 iters.**
  - **`FlatBaseChange.lean`** (mathlib-build, engine): **3 axiom-clean route-iii decls**
    (`IsLocalizedModule.powers_restrictScalars`, `fromTildeΓ_app_isIso_of_isLocalizedModule`,
    `pushforward_spec_tilde_iso_of_isLocalizedModule`), reducing the unconditional iso to a single named
    obligation `hloc`. But the iter-237 **hard sorry-closure commitment was NOT met**:
    `affineBaseChange_pushforward_iso` is still sorry.
- **Per-file sorry deltas:** Vestigial **1→0**; TensorObjSubstrate 2→2 (L695, L760); FlatBaseChange 2→2 (L470, L492).
  The *canonical critical-path counter did not drop* — the associator is the ingredient; the group-law
  consumers (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) are the next, now-reachable targets.
- **Build GREEN.** `lake env lean Vestigial.lean` exit 0. **Blueprint-doctor:** 1 finding (malformed `\uses{}`).
  **`sync_leanok`:** iter 237, sha `e451ec60`, +10/−0. No laundering — `tensorObj_assoc_iso` `\leanok` is backed
  by an axiom-clean, sorry-free decl (verified); the dangling `\lean{}` pins correctly carry no `\leanok`.

## The defining tension — the gate was MET, the engine commitment was MISSED

Two iters running, the d.2 arc terminated exactly as planned: iter-236 built `stalkTensorIso`, iter-237 wired
it through and closed the long-frozen whiskering sorry. This is the genuine resolution of the project's central
~20-iter bottleneck, not a hollow helper: the lean-auditor confirmed all six new Vestigial decls are
non-vacuous substantive constructions, the prover named and retired the exact carrier-duality friction the
route required, and the consumer compiles verbatim. The associator is now flatness-free — a strictly stronger
result than the old flat-restricted route ever promised.

Two honest stings:

1. **The canonical counter is flat.** Closing the whiskering sorry made `tensorObj_assoc_iso` sorry-free, but
   that decl was already not a *canonical* sorry — the canonical critical-path sorries are
   `exists_tensorObj_inverse` (L695) and `addCommGroup_via_tensorObj` (L760), untouched. This is categorically
   different from the prior flat iters (the gating *ingredient* now exists, axiom-clean and imported), but the
   honest framing for the next plan is: the counter moves only when the group-law lane closes, and that is the
   correct next unit.
2. **FlatBaseChange STUCK re-fires.** The iter-237 plan made the affine close a hard commitment with an explicit
   "STUCK re-fires if not met" reversing signal. It was not met. The lane produced real recovery (the route-iii
   skeleton is genuine, axiom-clean, and reduces the problem to one named fact), so this is not a churn-stall —
   but per the planner's own recorded contract the lane must NOT get a verbatim re-dispatch next iter. The
   element-free `D(a)`-level transport or a mathlib-analogist consult is the sanctioned corrective; the skeleton
   is kept.

## Process correctness

- **Provers: both on-target and honest.** Vestigial: axiom-clean throughout, built the dispatched wiring as one
  unit, stopped at a true boundary (the next consumer lives in another file), no sorry-pinning, precise carrier-
  duality recipe handed off. FlatBaseChange: confirmed the `hloc` wall with an explicit probe, built the entire
  conditional skeleton rather than sorry-pinning a half-assembly, and handed off two concrete routes. The
  unconditional theorem was correctly NOT committed (it would have required `hloc`).
- **Planner (iter-237):** sound. Correctly pivoted the critical path to consumer-wiring after the d.2 ingredient
  landed, dispatched both lanes with recorded reversing signals, addressed the strategy-critic CHALLENGE
  (RR-free Albanese fallback named in STRATEGY.md) without over-committing, and ran the full highly-recommended
  roster. The FlatBaseChange "hard commitment" framing is exactly what now triggers the correct STUCK response.
- **Review subagents (3 dispatched, all returned):** lean-auditor ts237 (whole-project, genuine/non-vacuous,
  5 MAJOR stale-docstring findings), lean-vs-blueprint-checker ×2 (vestigial: 2 must-fix blueprint-structure;
  fbc: dangling pin + 3 unpinned helpers). All findings landed in recommendations.md.

## Markers I set (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation_naturality_right`: `% NOTE:` — B-naturality
  inlined; `\lean{stalkTensorIso_naturality_right}` is dangling (no decl).
- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_spec_tilde_iso`: `% NOTE:` — only the conditional
  `…_of_isLocalizedModule` built; unconditional pin dangling; sole residual `hloc`.
- No `\leanok` touched; no `\mathlibok` (all new decls are genuine constructions); no stale `\notready`.

## Carried to the next plan (see recommendations.md)
1. **Pivot the prover to the group law** (`exists_tensorObj_inverse` L695, `addCommGroup_via_tensorObj` L760) —
   the now-unblocked near-term objective; scope via the carrier-pivot witness route.
2. **CRITICAL blueprint fix:** the malformed `\uses{\leanok …}` in `Picard_TensorObjSubstrate.tex` (~L2227–2229)
   — plan agent collapses the `\uses{}` so `\leanok` lands after the brace (I left `\leanok` untouched).
3. **Pin hygiene:** add `\lean{}` for the route-iii FBC helpers + the stalkLinearMap quartet + converse
   stalk-bridges; reconcile the `lem:whisker_of_W` "not to be formalized" note against the now-built wrappers.
4. **Stale .lean docstrings** (auditor MAJOR ×5): a docstring-cleanup pass (review cannot edit .lean) — the
   `tensorObj_assoc_iso` docstring still describes the obsolete flatness route, actively contradicting the code.
5. **FlatBaseChange STUCK:** element-free `D(a)`-level `hloc` route or mathlib-analogist consult; no verbatim
   re-dispatch.
