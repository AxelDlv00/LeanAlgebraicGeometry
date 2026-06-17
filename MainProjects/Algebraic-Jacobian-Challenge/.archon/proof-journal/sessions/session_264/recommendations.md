# Recommendations for iter-265 (from session 264)

## Headline: 4th consecutive iter with ZERO file/decl sorries eliminated on the Picard critical path
Every lane produced genuine axiom-clean motion (engine `pushPullMap_id` landed; DUAL `map_smul'`
closed; D3′ recovery brick `leftAdjointUniqUnitEta_app` landed), but no declaration / file sorry was
eliminated. pc263's D3′-Sq1 STUCK escalation trigger (4th PARTIAL with the R1/R5-tail blocker) is now
**FIRED** and must be answered. The escalation is the single must-respond signal.

## CRITICAL / must-respond

1. **D3′ Sq1 — STUCK escalation FIRED (4th PARTIAL).** The recovery brick (`leftAdjointUniqUnitEta_app`)
   and the step-0 structural setup landed this iter; the open residual is the `hinner`/`hcomp'`
   mate-calculus assembly (Steps 2–5, ~50–80 LOC, the twin of `pullbackObjUnitToUnit_comp` L952–1001 one
   sheafification layer up). Two sanctioned responses — pick ONE, do NOT re-open the monolith inline a
   5th time:
   - **(a) One focused round consuming the new brick** for the hinner/hcomp' assembly. Justified because
     the ingredients (the P-general brick) just landed and the route is fully specified. **But arm: a
     5th PARTIAL with no close ⇒ mandatory pivot to (b).**
   - **(b) cross-domain `mathlib-analogist`** (mode `cross-domain-inspiration`) on the bicategorical
     mate-calculus cocycle shape (how does Mathlib close a "two composite-adjunction units agree after
     sliding a comparison 2-cell past them" obligation in any domain?).
   - **Blueprint contributor (tos264, major):** the chapter's D3′ Sq1 tail sketch (lines 4044–4113)
     names the route but omits the specific 5-step assembly + the `conv_rhs`-confined `Functor.map_comp`
     distribution + the role of `leftAdjointUniqUnitEta_app`. Dispatch a **blueprint-writer** on
     `Picard_TensorObjSubstrate.tex` to add the explicit assembly steps BEFORE/with the next prover
     round — blueprint thinness is a measurable contributor to the 4-iter stall.

2. **DUAL — close `invFun` (the linchpin), then the round-trips fall.** `sliceDualTransport` now has 4
   open `≃ₗ` fields (naturality, invFun, left_inv, right_inv); `map_smul'` closed this iter. The prover
   describes invFun as the mirror of `toFun` with `f.appIso.hom` (not `.inv`); `left_inv`/`right_inv`
   collapse via `Iso.inv_hom_id`/`hom_inv_id`. This lane is **converging mechanics** (decl-count flat
   only because the `≃ₗ` packaging is monolithic) — NOT stuck. Continue `fine-grained`. Closing all 4
   closes `sliceDualTransport` → `dual_restrict_iso` Step-4 → the whole dual inverse chain.
   - **Blueprint contributor (di264, major):** `sliceDualTransport.naturality` step (b) needs
     `PresheafOfModules.restrictScalarsLaxε` named in the proof sketch (the obligation is described
     mathematically but the project-local Lean helper is un-pinned → search burden). Fold into a
     `blueprint-writer` directive on `Picard_TensorObjSubstrate.tex`.

3. **Engine — build `pushPullMap_comp` (the pentagon).** The de-coupled parallel pole. `pushPullMap_id`
   landed axiom-clean this iter; `pushPullMap_comp` is the cheapest remaining REAL decl-close (route
   fully specified: `pseudofunctor_associativity` + `comp_unit_app` + `unit_naturality`, ~150-LOC, same
   `hpf`-style coercion collapse). This is the lane most likely to deliver an actual decl elimination —
   weight it accordingly when the plan agent allocates lanes.

## MEDIUM (housekeeping — fold into directives, not standalone iters)

- **Engine blueprint over-marking (cech264, my `% NOTE:` added this iter):** `lem:push_pull_functor`
  pins `\lean{pushPullMap_comp}` but that decl does not exist in Lean (only in a comment), so the
  statement-block `\leanok` over-states the lemma. Plan agent: either **split the block** into two
  (one `\lean{}` pin each, so `\leanok` tracks them independently) or have a `lemma pushPullMap_comp …
  := sorry` stub added. A `% NOTE:` is in place at `Cohomology_CechHigherDirectImage.tex:340`.
- **`leftAdjointUniqUnitEta_app` un-pinned (tos264, major):** the recovery brick landed this iter has no
  `\lean{...}` pin in `Picard_TensorObjSubstrate.tex`. Add a pin (fold into the same blueprint-writer
  directive as #1).
- **Stale in-file header (aud264, major):** `TensorObjSubstrate.lean:44` says "THREE tracked typed-sorry
  residuals (iter-262)" and mis-locates residual (b) — the Sq1 sorry now lives in the extracted helper
  `sheafificationCompPullback_comp_tail` (L2578), not in `sheafificationCompPullback_comp`. The prover
  on that file should refresh the header next time it is touched (not worth a standalone iter).

## LOW (notes, no action required)
- aud264 minors: stale iter refs (`DualInverse.lean:15` "held iter-258", `:466` "iter-260"),
  `maxHeartbeats` bumps to 3.2M (L1745/1787/1946/1983/2046) and
  `backward.isDefEq.respectTransparency false` scopes (L731/1708/2171/2186/2205/2222) — documented
  performance/fragility debt, no correctness issue.
- di264 minors: `presheafDualUnitIso` / `topSectionToHom` un-referenced (implementation helpers,
  acceptable); outer `isoMk` dependency-sequencing note would help.

## Reusable patterns discovered this iter (also in PROJECT_STATUS Knowledge Base)
- **Mate-calculus identity functor law** (`pushPullMap_id`): `unit_conjugateEquiv(Adjunction.id)` +
  `conjugateEquiv_pullbackId_hom` → `pseudofunctor_right_unitality` → coercion collapse via
  `hom_ext; intro U; rfl` → `erw` + `reassoc_of%` for the `(𝟭).obj` defeq wall. Omit `Category.id_comp`
  from the `star`-cleanup `simp` (it un-collapses the form `reassoc_of% star` needs).
- **Projection-tolerant smul reduction** (`map_smul'`): when `smul_def`/`smul_def'` BOTH fail because the
  action is the `compHom` instance (not `restrictScalars.obj`), use `conv_rhs => arg 2; change`; pull
  scalars through a `ModuleCat` hom with `d.hom.map_smul` as a TERM (bare `rw [← map_smul]` mis-resolves
  to the PresheafOfModules overload).
- **P-general recovery brick:** generalize a `𝟙_`-specialized mate lemma to all `P` by an object-generic
  copy of the body when nothing in the body used `𝟙_`.
- **`conv_rhs` confinement** for `Functor.map_comp` when the LHS carries an adjunction unit a whole-goal
  rewrite would unfold.

## Do NOT
- Do NOT re-open `sheafificationCompPullback_comp_tail` as an inline monolith a 5th time (pc263 + this
  iter). Consume the brick OR escalate.
- Do NOT pivot the DUAL to the stalkwise Plan-B: it is converging mechanics (invFun + round-trips), and
  the route-2 hard obstacles are all resolved.
