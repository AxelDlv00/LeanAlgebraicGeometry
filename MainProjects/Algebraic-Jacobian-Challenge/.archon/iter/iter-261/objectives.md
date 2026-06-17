# Iter-261 objectives (detail)

Two parallel A.1.c.sub prover lanes; both gated by `Picard_TensorObjSubstrate.tex` (consolidated chapter),
which RE-CLEARED the HARD GATE this iter via the bw-tos261 → bc-tos261 → br261b fast-path.

## Lane 1 (PRIMARY, critical path): `Picard/TensorObjSubstrate/DualInverse.lean` — ROUTE-2
**Close `sliceDualTransport` (L184) → `dual_restrict_iso` (L356) BY HAND.** [prover-mode: prove]

Route-1 (consume the shared root `overEquivalence`/`restrictOverIso`/`unitOverIso`) is DEAD — iter-260
proved it structurally insufficient (no internal-hom/dual content). Do NOT re-attempt it; do NOT add the
`SheafOverEquivalence` import.

### Route-2 (sanctioned this iter)
- `sliceDualTransport f M V` = the per-`V` `𝒪_Y(V)`-linear equivalence realizing **leg A** (slice-site Hom
  base-change / Beck–Chevalley across `f.opensFunctor`): forward/inverse = `eqToHom`-conjugation of the
  slice-Hom components along the down-set identity `image_preimage_of_le` (`ι(ι⁻¹V)=V`), naturality
  `Subsingleton.elim` on the thin poset `Opens Y` — the pattern proved axiom-clean for `homLocalSection`
  (L487) / `dualUnitIsoGen` (L121).
- **leg B** = `restrictScalarsRingIsoDualEquiv` along the ring iso `(f.appIso V).inv`. NB leg B does NOT
  type-apply standalone (different over-cat indexing) — leg A runs first; ONE intricate ~150–250 LOC build,
  not independently-compiling sub-pieces. `Module 𝒪_Y(V)` synthesizes automatically (iter-260 finding).
- Then `dual_restrict_iso`'s `isoMk` naturality (L386) = the thin-poset coherence of the now-concrete
  family. Keep `dual_unit_iso`/`dual_isLocallyTrivial` bodies untouched. Fix the in-file STATUS NOTE (L309).
- Blueprint: `lem:dual_restrict_iso` (route-2 sketch rewritten iter-261). Source: Stacks Modules
  `lemma-pullback-internal-hom` (tag 01CM).

### pc261 WATCH (ARMED) + reversing signal
- Route's sorry has been flat 4 iters; this is route-2's FIRST genuine dispatch. Make a real attempt at the
  body. If route-2 hits an UNEXPECTED structural wall (not tactic difficulty), leave a typed sorry + report
  the EXACT failing step — do NOT pivot to the stalkwise Plan-B unilaterally. No sorry reduction ⇒ STUCK
  iter-262.

### Bar
Close both axiom-clean ⇒ `dual_isLocallyTrivial` axiom-clean ⇒ unblocks `exists_tensorObj_inverse` (RPF
group inverse).

## Lane 2 (critical path): `Picard/TensorObjSubstrate.lean` — `pullbackTensorMap_restrict`
**Close `pullbackTensorMap_restrict` (L2521).** [prover-mode: prove]

D3′ Sq2/Sq2b CLOSED (iter-260). All four squares' sub-lemmas PROVED: Sq1
`sheafificationCompPullback_eq_leftAdjointUniq` (L1598), Sq2/Sq2b `pullbackComp_δ` (L2307), Sq3
`sheafifyTensorUnitIso(_hom_natural)` (L1071/1944), Sq4 `pullbackValIso(_hom_natural)` (L1196/1909).

### Route
- The composition-coherence paste: unfold `pullbackTensorMap` on both sides into `S₁ ; a.map δ ; S₃ ; S₄`,
  conjugate by `pullbackComp h f`, equate the (h∘f)-instance with the interleaved f-instance (transported by
  `h^*`) ∘ h-instance. Sq2 δ-core via `Functor.OplaxMonoidal.comp_δ` + `PresheafOfModules.pullbackComp` (the
  ring-map reconcile `toRingCatSheafHom_comp_hom_reconcile` is definitional); Sq1/Sq3/Sq4 assemble their
  proved comp-coherences. NOT a transpose (paste the squares directly).
- Blueprint: `lem:pullback_tensor_map_basechange` (4-square paste + open-immersion base-change Remark; Sq2b
  prose corrected iter-261).

### RACE MITIGATION (MANDATORY)
`DualInverse.lean` imports this file. KEEP IT COMPILABLE — commit only compiling states; if
`pullbackTensorMap_restrict` does not close, RETAIN its existing typed sorry. Do NOT touch
`exists_tensorObj_inverse` (L693).

### Bar
Close axiom-clean ⇒ its open-immersion base-change form feeds D4′ (the chart-chase), the last A.1.c.sub
comparison-iso piece. If stuck, typed sorry + report which square's paste blocked.

## Parallel non-prover prep (engine lane opening)
- `Cohomology_CechHigherDirectImage.tex` broken refs FIXED (bw-cech261). NEXT iter: file-skeleton scaffold
  `Cohomology/CechHigherDirectImage.lean` (race-free) then open the `Rⁱf_*` prover lane (strategy-critic #2).

## Held / not dispatched
- `LineBundleCoherence.lean` — DONE. RPF / FGA — gated. RR.*/Rigidity/Genus0 — Route C PAUSED (USER). A.3+ —
  not dispatched (USER #6).
