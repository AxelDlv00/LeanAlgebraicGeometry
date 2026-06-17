# Recommendations for iter-164 plan agent

## CRITICAL — persistent false `\leanok` laundering the genus-0 headline (infra)
Three downstream proof-block `\leanok` markers are present while their Lean bodies are `sorry`:
- `prop:morphism_P1_to_AV_constant` proof (AVR.tex L903) ↔ `morphism_P1_to_grpScheme_const` `:= sorry`
- `prop:genusZero_curve_iso_P1` proof (AVR.tex L960) ↔ `genusZero_curve_iso_P1` `:= sorry`
- `thm:rigidity_genus0_curve_to_AV` proof (AVR.tex L1020) ↔ `rigidity_genus0_curve_to_grpScheme` `:= sorry`

These were flagged "sync-owned" in the iter-162 review and **STILL persist** in iter-163. No
`sync_leanok` artifact exists under `logs/iter-163/`, and no `sync_leanok` config reference was
found. **Action:** confirm the deterministic `sync_leanok` phase actually runs between prover and
review, and that it strips proof-block `\leanok` on `sorry`-bodied `\lean{}` targets. If it does
not, this is an infra bug that has been falsely marking the genus-0 headline as proven for ≥2 iters.
The review agent cannot fix this (`\leanok` outside its domain). Until resolved, treat
`thm:rigidity_genus0_curve_to_AV` (and the two props) as OPEN regardless of the marker.

## Stale docstrings in AVR.lean (lean-auditor majors — prover-owned edits)
When AVR.lean is next assigned to a prover, ask the prover (in the objective) to refresh these — they
are NOT a separate lane, just include in the next AVR edit:
1. **6× now-FALSE "lone residual `sorry`" claims** (the chain is sorry-free since iter-162):
   header L29, L239, L255, L408-410, L485, L644-645, L669-671, L757-759. Especially L255 ("Status
   (iter-160): `sorry`") on `rigidity_eqAt_closedPoint_of_proper_into_affine`, which is now fully
   proven — the comment misrepresents the very declaration it annotates.
2. **Cube-dependency docstring** on `morphism_P1_to_grpScheme_const` (L910-912) + file header
   (L32-33): asserts the ℙ¹ base case "rests on the theorem of the cube" — FALSE after the iter-163
   cube-excision (Route C, Milne §I.3). Confirmed against the (now cube-free) blueprint. Refresh to
   the Route-C framing.

## Next prover frontier (Route C, in priority order)
1. **`morphism_Ga_to_av_const`** (`lem:hom_from_Ga_trivial`, Prop 3.9 core) — the
   additive-defect-map `ψ(x,y)=f(x+y)−f(x)−f(y)` killed by Rigidity; the `GrpObj` hom-group idiom
   established this iter (`Hom.mul_def`/`comp_div`/`div_eq_one`) is the direct handle. Likely the
   most tractable next step that reuses iter-163 infrastructure.
2. **`rationalMap_to_av_extends`** (`lem:rational_map_to_av_extends`, Milne Thm 3.2) — the surface
   codim-1 rational-map-extension gap; **the route's RISKIEST piece** (no Mathlib Weil divisors;
   see `rmk:thm32_codim1_mathlib_gap`). It IS on the genus-0 critical path (corrected plan-agent
   finding iter-163 — proving `f|_{𝔾_a}` additive needs extending ψ to the complete `ℙ¹×ℙ¹`).
   Before assigning, dispatch a **mathlib-analogist cross-domain consult**: "extend a rational map
   to a proper/group target across codim-1 on a smooth surface, no Weil divisors" (valuative
   criterion `IsProper.of_valuativeCriterion` is present per `analogies/route-support.md`).
3. The genus-0⟹ℙ¹ Riemann–Roch bridge (`genusZero_curve_iso_P1`) remains a parallel sub-build (no
   Mathlib RR) — not near-term.

## Minor (optional, low-priority)
- Cor 1.5 (`hom_additive_decomp_of_rigidity`, L817) carries `[Smooth A.hom]` /
  `[GeometricallyIrreducible A.hom]` on the `A`-side that the auditor flags as possibly unused (only
  `GrpObj A` + `IsProper A.hom` ⟹ `IsSeparated` are needed). A prover could try removing them to
  generalise; this would also lighten `av_regularMap_isHom_of_zero`'s `B`-side hyps. Not a soundness
  issue; defer unless touching the file anyway.
- A future "product of (geometrically-irreducible / reduced / lft) is so" instance would let both
  Cor 1.5 / Cor 1.2 drop their explicit `V⊗W` / `A⊗A` instance hypotheses.

## Trajectory note
Route C now has 1 iter of prover trajectory (2 axiom-clean corollaries landed). Re-dispatch
`progress-critic` next iter (it was correctly skipped iter-163 — route freshly decided, no
trajectory). Do NOT re-assign any of the 3 deferred genus-0 scaffolds as a primary lane until their
upstream inputs (Prop 3.9 / Thm 3.2 / RR) are themselves proven.
