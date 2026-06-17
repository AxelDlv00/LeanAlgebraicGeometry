# Session 163 — review of iter-163

## Metadata
- **Iteration / session**: 163.
- **Stage**: prover (parallel, 1 lane).
- **Global bare-`sorry` count**: 6 → 6 (UNCHANGED). AVR 3 (L928/952/981), `Jacobian.lean` 2
  (L265/L303), `RigidityKbar.lean` 1 (L88).
- **Unit of progress this iter is NOT sorry-count** — it is **two NEW axiom-clean theorems added**
  (the Milne §I.3 additivity corollaries), the first concrete prover output on the freshly-decided
  Route C. The decision iter (iter-163 plan) committed Route C / excised the theorem of the cube;
  the prover lane then landed Cor 1.5 + Cor 1.2 directly off the proven `rigidity_lemma`.
- **Targets attempted**: `hom_additive_decomp_of_rigidity` (Milne Cor 1.5),
  `av_regularMap_isHom_of_zero` (Milne Cor 1.2). Both SOLVED, sorry-free, axiom-clean.
- **Dispatch MATCHED the plan** — lane fired at AVR.lean for Cor 1.5 → Cor 1.2 exactly as
  prescribed in `iter/iter-163/plan.md` §(B). **6th consecutive iter** with no plan/dispatch
  contradiction.

## The advance, independently verified this review

1. **`hom_additive_decomp_of_rigidity` (Milne Cor 1.5, L809) — PROVEN, axiom-clean.**
   `lean_verify` = `{propext, Classical.choice, Quot.sound}` (no `sorryAx`), re-verified this
   review. The cube-free additive decomposition of a morphism out of a product, in the
   `GrpObj`-induced group on `Hom(V⊗W, A)`. Technique: form the group difference
   `φ := h / ((p≫f)·(q≫g))`, show it collapses the complete `V`-axis to `1` (= the `_hf` collapse
   hypothesis of `rigidity_lemma`, using `h(v₀,w₀)=η[A]`), factor `φ = q≫g'` by Rigidity, read
   `g'=1` off the `{v₀}×W` section, conclude `φ=1` via `div_eq_one.mp`. Every value-hypothesis
   load-bearing (auditor-confirmed: `hh`→`hwg`/`hvf`→`hcolV`/`hcolW`).
   - **DEAD-END / reusable trap:** under `open MonObj`, the names `mul_one`/`one_mul` are
     AMBIGUOUS and resolve to the *monoid-object* lemmas `MonObj.mul_one : η ▷ X ≫ μ = …`, NOT the
     ordinary `Group` identities. The first edit failed with
     `rewrite failed: Did not find an occurrence of the pattern ?X ◁ η ≫ μ in f / (f * 1) = 1`.
     Fix: write `_root_.mul_one` / `_root_.one_mul` to force the group identities. (Knowledge Base.)

2. **`av_regularMap_isHom_of_zero` (Milne Cor 1.2, L879) — PROVEN, axiom-clean.**
   `lean_verify` = `{propext, Classical.choice, Quot.sound}`, re-verified. Apply Cor 1.5 to
   `h := μ[A] ≫ α` with `V=W=A` based at `η[A]`; both axis-restrictions reduce to `α` via the
   monoid unit laws `lift_comp_one_right`/`left`; the decomposition becomes
   `μ[A]≫α = (α⊗ₘα)≫μ[B]` (the `mul_hom` axiom; `lift_fst_comp_snd_comp` converts
   `lift (fst≫α)(snd≫α)` to `α ⊗ₘ α`). Conclusion is the canonical `IsMonHom α` — `one_hom` is the
   pointed hypothesis `hα`, `mul_hom` is derived. `IsMonHom` is strictly more reusable than a bare
   elementwise equation (a `Grp` morphism follows).
   - **SIGNATURE NOTE (carried, honest):** (B) carries three EXTRA instance hypotheses on `A⊗A` —
     `[GeometricallyIrreducible (A⊗A).hom]`, `[LocallyOfFiniteType (A⊗A).hom]`,
     `[IsReduced (A⊗A).left]` — that Cor 1.5 requires with `V=W=A`. Mathematically free for a
     genuine abelian variety (a product of varieties is a variety), but Mathlib does not
     auto-derive the product instances from the factors, so they are carried explicitly to keep
     the lemma axiom-clean. The lean-vs-blueprint-checker confirmed this is NOT a faithfulness
     defect; a `% NOTE:` (added this review) is the proportionate fix.

## Is this iter-157 laundering again? No.
Both new lemmas carry NO `sorryAx` (re-verified). A `sorryAx` anywhere in the cone would surface.
Both review subagents explicitly checked the iter-157 anti-pattern and cleared it: every
value-hypothesis is load-bearing, the proofs are constructive, the `\uses` graph
(`av_regular_map_is_hom` → `hom_additivity_over_product` → `rigidity_lemma`) is forward-acyclic, and
the new lemmas launder nothing.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)
| Subagent | Slug | must-fix / major / minor | Headline |
|---|---|---|---|
| `lean-auditor` | iter163 | 0 / 7 / 2 | Both new lemmas sound + complete + axiom-clean, load-bearing hyps, no laundering. 7 majors = STALE docstrings: 6 still call the now-PROVEN `rigidity_eqAt_closedPoint_of_proper_into_affine` / chain "the lone residual `sorry`" (L29/239/255/408-410/485/644-645/669-671/757-759); 1 = the cube-dependency docstring on `morphism_P1_to_grpScheme_const` (L910-912 + header L32-33), now FALSE post-excision. Minors: candidate-unused `[Smooth A.hom]`/`[GeometricallyIrreducible A.hom]` on the `A`-side of Cor 1.5 (L817); the 3 disclosed scaffold sorries. |
| `lean-vs-blueprint-checker` | avr-iter163 | 0 / 0 / 2 | Both `\lean{}` signatures faithful + axiom-clean; `IsMonHom α` an accepted (stronger) rendering of "homomorphism"; `\uses` forward-acyclic, no headline laundering through the new lemmas. Minors: product-level instance hyps on `A⊗A`/`V⊗W` unrecorded in prose (`% NOTE:` confirmed sufficient — added this review); uniqueness/W-completeness divergence (Lean more general). **Advisory:** 3 downstream proof-block `\leanok` on `sorry` bodies (sync-owned) — see Persistent issue below. |
Reports: `logs/iter-163/{lean-auditor-iter163,lean-vs-blueprint-checker-avr-iter163}-report.md`.

## Persistent issue — false downstream proof-block `\leanok` (NOT my domain to fix)
The three genus-0 scaffold blocks carry a proof-block `\leanok` while their Lean bodies are `sorry`:
- `prop:morphism_P1_to_AV_constant` proof (tex L903) ↔ `morphism_P1_to_grpScheme_const` `:= sorry`.
- `prop:genusZero_curve_iso_P1` proof (tex L960) ↔ `genusZero_curve_iso_P1` `:= sorry`.
- `thm:rigidity_genus0_curve_to_AV` proof (tex L1020) ↔ `rigidity_genus0_curve_to_grpScheme` `:= sorry`.

These `\leanok` are FALSE and **launder the genus-0 headline**. This was already flagged in the
iter-162 review as "sync-owned"; it **persists** into iter-163 (the chapter was heavily rewritten
this iter by the route-c blueprint-writer). No `sync_leanok` log artifact exists under
`logs/iter-163/` and no `sync_leanok` config reference was found. **I did NOT touch these** —
`\leanok` is outside the review agent's domain. Escalated to the next plan agent (see
`recommendations.md`): confirm the `sync_leanok` phase actually runs and strips proof-block
`\leanok` on `sorry`-bodied `\lean{}` targets; if it is not, that is an infra bug that has been
laundering the headline for ≥2 iters.

## Blueprint markers updated (manual)
- `AbelianVarietyRigidity.tex`, `lem:hom_additivity_over_product`: added `% NOTE:` recording the
  three product-level instance hyps on `V⊗W` + the existence-only / V-only-complete divergence.
- `AbelianVarietyRigidity.tex`, `lem:av_regular_map_is_hom`: added `% NOTE:` recording the pointed
  encoding (`IsMonHom α`) + the three product-level instance hyps on `A⊗A`.
- No `\leanok` touched; no `\mathlibok` added (neither new lemma is a Mathlib re-export); no
  `\notready` to strip.

## Blueprint doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`, no new `axiom`.

## Key findings / patterns
- **`GrpObj` hom-group idiom (reusable):** `u*v = lift u v ≫ μ`, `u⁻¹ = u≫ι`,
  `(1 : X⟶A) = toUnit X ≫ η`; manipulate with `Hom.mul_def`/`Hom.one_def`/`MonObj.comp_mul`/
  `GrpObj.comp_div`/`comp_lift`/`div_eq_one`/`div_self'`. This is the handle for the upcoming
  Prop 3.9 additive-defect-map argument.
- **`_root_.mul_one`/`_root_.one_mul`** required under `open MonObj` (see DEAD-END above).
- **Product-instance gap:** Mathlib does not auto-derive
  `GeometricallyIrreducible/LocallyOfFiniteType/IsReduced` for `X⊗Y` from the factors; carry as
  explicit instance hyps. A future iter could add a "product of varieties is a variety" instance
  and drop them.

## Recommendations for next session
See `recommendations.md`. Headline: (1) ESCALATE the persistent false `\leanok` / sync_leanok
question (CRITICAL — laundering the headline); (2) next prover frontier is `rationalMap_to_av_extends`
(Thm 3.2, the surface codim-1 gap — riskiest, consider a mathlib-analogist cross-domain consult) +
`morphism_Ga_to_av_const` (Prop 3.9 core); (3) plan agent should have a writer refresh the 7 stale
docstrings (auditor majors) when AVR.lean is next touched (prover-owned edits).
