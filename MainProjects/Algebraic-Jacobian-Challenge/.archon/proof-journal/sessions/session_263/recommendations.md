# Recommendations for the next plan iteration (post iter-263)

## CRITICAL / blueprint must-fixes that GATE prover dispatch (HARD GATE)

Both Picard lanes and the engine lane are covered by chapters that now carry
**must-fix blueprint-adequacy failures**. Per the HARD GATE, dispatch a
`blueprint-writer` for each BEFORE (or fast-path re-review then) re-dispatching the
corresponding prover lane.

1. **`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — DUAL `lem:slice_dual_transport`
   naturality sketch is WRONG (lvb-di263 must-fix).** The chapter claims naturality "holds by
   `Subsingleton.elim`, `Opens Y` being a thin poset." `Subsingleton.elim` discharges only the
   base morphisms in `(Over V.unop)ᵒᵖ`; the **module-map** equation additionally needs the
   **ε-naturality of `restrictScalars`** along the structure-ring iso (i.e. that `dualUnitRingSwap`
   is natural w.r.t. the target presheaf's restriction maps). A prover following the current sketch
   would get stuck on the naturality field. **Writer action:** correct the naturality paragraph;
   ALSO expand (major) the `invFun` description (name the Mathlib lemma for "every `W'' ≤ fV` is
   `f.opensFunctor(f⁻¹W'')`, give the component formula + the `Iso.inv_hom_id`/`hom_inv_id`
   round-trip recipe) and the `map_smul'` sketch (add the β-naturality ring identity
   `s = (β.app W').hom c` via `termRingMap_naturality` + `β.naturality`, and `restrictScalars.smul_def'`).

2. **`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — engine dependency claim is
   WRONG + functor laws have no blueprint block (lvb-cech263, TWO must-fix).** (a) §`sec:cech_three_part`
   paragraph (2) asserts `G`'s functor laws are a "consumer of the tensor–pullback substrate coherence"
   (i.e. coupled to project Sq1). The prover this iter **de-coupled** this: the laws are provable from
   **Mathlib's `pseudofunctor : Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` coherences ALONE**
   (`conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`,
   `pseudofunctor_{left,right}_unitality`, `pseudofunctor_associativity`). The chapter must drop the
   Sq1-coupling claim — otherwise the plan agent wrongly gates the engine behind D3′. (b) Add `\lean{}`
   hints + a lemma block + proof sketch for `pushPullMap_id` / `pushPullMap_comp` (currently a prover
   cannot formalize them from the chapter); also add `\lean{}` pins for the now-axiom-clean
   `pushPullObj`, `pushPullMap`, `coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve` (major).

3. **`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — D3′ Sq1 tail + Sq4 under-specified
   (lvb-tos263 major, recommended must-fix before the iter-264 D3′ fine-grain).** Add (a) the explicit
   goal form of `sheafificationCompPullback_comp_tail` (`B_{h≫f}.unit.app P` vs the RHS merged argument;
   the two-layer composite-adjunction structure `B_f = (PrPbPushAdj φ'_f).comp sheafAdj_Z`, similarly
   `B_h`; cite the `hinner`/`hcomp'` chain analog of `pullbackObjUnitToUnit_comp`); (b) an explicit
   statement of the Sq4 `pullbackValIso` composition-coherence sub-lemma (it must be built standalone).

## Route status & escalation triggers

### D3′ Sq1 (`TensorObjSubstrate.lean`) — STUCK trigger LIVE (was "one PARTIAL from STUCK")
- This is the **3rd PARTIAL on Sq1 with the R1/R5 blocker**. The main lemma
  `sheafificationCompPullback_comp` is now CLOSED (sorry-free), but the residual was **relocated** to
  `sheafificationCompPullback_comp_tail` (net residual unchanged; auditor confirms honest, not laundered).
- **Do NOT retry the transposition route** — the prover proved by hand it is circular
  (`homEquiv.injective`-equivalent to the original; re-opaquifies the comparison). Recorded as a Known
  Blocker.
- **Next action:** fine-grain `sheafificationCompPullback_comp_tail`'s mate calculus (keep LHS as
  concrete `B.unit`, ASSEMBLE the RHS via `homEquiv_leftAdjointUniq_hom_app` for both the `f` and `h`
  sub-comparisons + `pushforwardComp`/`pullbackComp` unit-naturality). ~50–80 LOC. **If that returns a
  4th PARTIAL with no close, dispatch the `mathlib-analogist` (cross-domain) on the bicategorical-cocycle
  / pseudofunctor-unit-composition shape** before any further inline attempt.

### DUAL (`DualInverse.lean`) — STUCK-corrective WORKED; now a bounded multi-iter sub-hole grind
- The ma-ihom263 verified recipe closed `map_add'` (6→5 internal sub-sorries) as predicted, confirming
  the design is Mathlib-aligned (no refactor). This is the sanctioned STUCK corrective succeeding — NOT
  a re-stall.
- **Next action:** fine-grained on `map_smul'` ONLY. The crux `d.hom (s • u) = c • d.hom u` is exposed;
  all ingredients identified and individually verified to fire. The blocker is **tactic mechanics**
  (the `{app:=…}.app W` RHS projection is defeq-but-not-syntactic to `d.hom u`; the scalar carries the
  `{toFun:=…} m` MonoidWithZeroHom-coe form). Route: state `hring : s = (β.app W').hom c`
  (`termRingMap_naturality` + `β.naturality`), normalize the scalar form, then
  `← ModuleCat.restrictScalars.smul_def'` + `map_smul`, close with a projection-tolerant
  `exact hcrux` (defeq-tolerant). Then build `invFun` + `naturality` + 2 round-trips, then
  `dual_restrict_iso` isoMk naturality. **Watch:** if `map_smul'` does not close next iter with the
  named route, this lane has crossed from "tactic friction" to a genuine multi-iter grind — re-assess
  whether the `≃ₗ`-by-hand packaging is the right granularity vs. a categorical `.map`-only build.

### ENGINE (`CechHigherDirectImage.lean`) — DE-COUPLED from D3′; can run independently
- Major strategy update: the iter-262 "engine coupled to D3′ Sq1" belief is **refuted**. The functor
  laws `pushPullMap_id`/`pushPullMap_comp` need only Mathlib's pseudofunctor coherences. Once the
  chapter must-fix (#2 above) is fixed, this lane is a genuine independent parallel pole again.
- **Next action (after blueprint #2):** fine-grained pass on `pushPullMap_id`/`pushPullMap_comp` via
  the named Mathlib pseudofunctor lemmas (mate rewrite `conjugateEquiv_pullbackComp_inv` →
  `pseudofunctor_right_unitality` / `pseudofunctor_associativity`, discharging the `eqToHom`-through-
  `Over.w` transports under `set_option backward.isDefEq.respectTransparency false`). ~80–150 LOC.
  Then assemble `G` and proceed to `CechNerve`. Reusable gotcha: for `eqToHom`-glued composites write
  the **fully-applied forward term** with explicit `congrArg` proofs — `refine ?_ ≫ ?_` fails.

### `LineBundleCoherence.lean` — DONE (do not re-dispatch)
Re-verified axiom-clean. The A.2.c engine loc-triv coherence deliverable is complete.

## Stale in-file comments to fix (lean-auditor aud263, major — for the prover/plan, not me)
- `TensorObjSubstrate.lean:43` — module header slot (b) still names `sheafificationCompPullback_comp`
  as the sorry carrier (it is now closed; the sorry is in `sheafificationCompPullback_comp_tail`); also
  says "iter-262". Update the carrier name + iter marker (count THREE is still correct).
- `DualInverse.lean:36–38` — header lists `map_add'` as a remaining sorry with a stale blocker reason;
  open-field count is now 5 (naturality, map_smul', invFun, left_inv, right_inv), not 6.
- `DualInverse.lean:41` (minor) — `dual_restrict_iso` sorry is at L524, not "~L254".

## Reusable proof patterns discovered this iter (also in PROJECT_STATUS KB)
- `internalHomObjModule`-add = ambient `Preadditive` add → `map_add'` closes by `change` opener +
  `rw [show … from rfl, Functor.map_add, Preadditive.add_comp]` + trailing `rfl` (`add_app` does not fire).
- Transposition of an adjunction-unit coherence goal is a TRAP (re-opaquifies → `homEquiv.injective`-
  equivalent to the original). Keep LHS concrete; assemble RHS.
- `eqToHom`-glued composites: fully-applied forward term + explicit `congrArg` per `eqToHom`.
- Engine `G` functor laws need only Mathlib `pseudofunctor`, not project Sq1.
