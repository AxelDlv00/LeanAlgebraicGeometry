# Recommendations — for the iter-031 plan agent

## HIGH — blueprint↔Lean reconciliation (must precede the next FBC prover round)

1. **FBC: reconcile the 5 dangling effort-breaker link pins with the single fused Lean helper.**
   (lean-vs-blueprint-checker `fbc-iter030`, major ×2.) The iter-030 effort-breaker wrote 5
   `\uses`-linked link sub-lemma blocks into `Cohomology_FlatBaseChange.tex` with `\lean{}` pins
   `..._legs_link_{distribute,collapseComp,cancelEUnit,cancelPullbackComp,survivor}`. The prover
   instead built **one** fused helper `base_change_mate_fstar_reindex_legs_link_distributeCollapse`
   (covers L1+L2) and left L3–L5 unbuilt. Result: 5 dangling `\lean{}` pins + 1 unreferenced Lean
   decl. **Action:** dispatch a blueprint-writer to either (a) merge the L1/L2 blocks and re-pin them
   at `link_distributeCollapse`, or (b) keep the 5-block decomposition and instruct the next prover to
   match it. I added a `% NOTE:` on `lem:..._link_distribute` marking the situation. **Do this before
   the next FBC prover round** — otherwise the prover faces an incoherent blueprint and the leandag
   pin-resolution stays broken. (Note: blueprint-doctor reported 0 findings because it checks
   `\ref`/`\uses`/`\label` resolution, not `\lean{}`→Lean-decl existence; the dangling pins are a
   leandag/coverage issue, not a doctor-visible one.)

2. **QUOT: bridge C's proof sketch under-specified the IsCocontinuous prerequisite.**
   (lean-vs-blueprint-checker `quot-iter030`, major.) `lem:over_restrict_iso` described the endpoint
   (site equivalence → sheaf equivalence) but not the substance the prover actually had to build
   (cover-lifting for both functors of `Opens.overEquivalence U`). **Action:** dispatch a
   blueprint-writer to add blocks for the 6 new infra decls (esp. `overEquivalence_sheafCongr`) and
   wire them into `lem:over_restrict_iso`'s `\uses` chain, and to detail steps 2–4 of C
   (ring-sheaf identification → `pushforwardPushforwardEquivalence` → `restrictFunctorIsoPullback`).

## HIGH — GR stall (2nd consecutive no-output iter)

3. **GR has now no-output'd 2 consecutive iters** (iter-029 and iter-030) despite a sharpened
   "prove the cocycle ring identity `Φ=id` standalone first" directive. The iter-030 plan explicitly
   set the trigger "if R3 also no-outputs, escalate to STUCK." **Action:** run progress-critic on GR
   next plan phase (it will now have enough signal), and either (a) effort-break the cocycle ring
   identity into a pure-`CommRing` lemma with no scheme content, or (b) verify the GR dispatch is
   actually reaching a prover (two silent no-outputs may indicate a scheduling/dispatch issue, not a
   math wall). Do NOT re-dispatch the same GR directive a 3rd time unchanged.

## MEDIUM — continue the live fronts

4. **FBC `_legs`: continue the term-mode `congrArg`/`.trans` splice for the eCancel atoms.** The
   distribution wall is passed; the residual is the multi-layer cancellation of factors 2 & 4
   (`base_change_mate_inner_eCancel_eUnit` / `_pullbackComp`) against the **unfolded**
   `base_change_mate_codomain_read_legs` across the `gammaPushforwardIso ψ` / `MidColl` transport
   layer, then Seam-1 survivor identification (`base_change_mate_unit_value` → `inner_value`). Same
   validated mechanism (see memory `fbc-legs-termmode-splice-works`). **Do NOT re-try any keyed
   rewriting** (`rw`/`simp`/`erw`/`conv`/`set`/`dsimp`) — iter-029 AND iter-030 both proved it dead
   against the `X.Modules` diamond, even on freshly-stated clean factors. **OVER_BUDGET watch:** FBC-A
   entered iter-018; STRATEGY carries an iter-032 escalation trigger if `_legs`→`gstar_transpose` is
   not closed by then.

5. **QUOT bridge C step 2 — the ring-sheaf identification** is the next concrete obstacle (geometric,
   not topos-theoretic): `(Spec R).ringCatSheaf.over U ≅ (transport of) U.toScheme.ringCatSheaf`.
   Lead documented in the task_result: `U.ι.opensFunctor = (Opens.overEquivalence U).inverse ⋙
   Over.forget U`, reducing it to `Scheme.restrict` / open-immersion structure-sheaf lemmas. Then
   step 3 (`pushforwardPushforwardEquivalence`, IsContinuous instances now in-file, possibly needs
   `set_option backward.isDefEq.respectTransparency false`) and step 4 (`restrictFunctorIsoPullback`).

## MEDIUM — coverage debt (`archon dag-query unmatched`, 7 nodes — author blueprint blocks)

All 7 are project-local helpers from this session with no blueprint entry (all `proved=true`, no sorry):

| Lean decl | File | Depends on (for the blueprint prose) |
|-----------|------|--------------------------------------|
| `base_change_mate_fstar_reindex_legs_link_distributeCollapse` | FlatBaseChange.lean | `..._gammaDistribute` + `..._unitExpand` + factor-3 collapse (`gammaMap_pushforwardComp_hom_eq_id`) — fold into the L1/L2 reconciliation (rec #1) |
| `overEquivalence_functor_isCocontinuous` | QuotScheme.lean | `GrothendieckTopology.mem_over_iff`, `Opens.grothendieckTopology` pointwise covering, `Subtype.val` open-embedding, `Sieve.downward_closed` |
| `overEquivalence_inverse_isCocontinuous` | QuotScheme.lean | same toolkit, preimage-opens direction |
| `overEquivalence_inverse_isDenseSubsite` | QuotScheme.lean | `Equivalence.isDenseSubsite_inverse_of_isCocontinuous` on the two cocontinuities |
| `overEquivalence_functor_isContinuous` | QuotScheme.lean | `Adjunction.isContinuous_of_isCocontinuous` on `e.symm` adjunction |
| `overEquivalence_inverse_isContinuous` | QuotScheme.lean | `Adjunction.isContinuous_of_isCocontinuous` on `e` adjunction |
| `overEquivalence_sheafCongr` | QuotScheme.lean | `Equivalence.sheafCongr`; **keystone** the C block should `\uses` |

Fold the 6 QUOT entries into rec #2's writer dispatch (they are precisely the infra C should `\uses`).

## LOW — documentation hygiene (no blocker)

6. **FBC docstring disclosure gap** (lean-auditor, 2 major but doc-only): `base_change_mate_fstar_reindex`
   (@1475) and `base_change_mate_inner_value_eq` (@1624) are transitively `sorry`-backed through
   `_fstar_reindex_legs` but their docstrings lack the explicit "transitively `sorry`-backed"
   disclaimer that `section_identity`/`cancelBaseChange` carry. A prover one-liner next time it edits
   the file. Review/plan cannot edit `.lean`.
7. **`thm:grassmannian_representable` `\lean{}` pin** points at an under-delivering skeleton (its own
   NOTE acknowledges this). A writer should split it: weaker skeleton-label block + stronger
   unformalized prose statement (no `\leanok`).
8. FBC `STATUS (iter-234/236)` comment block (@183–246) — accurate but accumulating opaque
   iter-number noise; optional prover cleanup.

## Do-NOT-retry list (blocked approaches)
- **Any keyed rewriting on the FBC `X.Modules`/`Functor.comp` diamond** (`rw`/`simp`/`erw`/`conv`/
  `set`/`dsimp`) — proven dead 2 iters running, even on `rfl`-true literal copies of the goal's own
  factor. Only composite-F-form + term-mode `congrArg`/`Functor.congr_map`/`.trans`/`exact` works.
- **Hand-rolling a modules restriction functor / site equivalence for QUOT** — `Opens.overEquivalence`
  + the (now-proved) continuity instances are the right primitives; do not rebuild from scratch.
- **A 3rd unchanged GR re-dispatch** — see rec #3.
